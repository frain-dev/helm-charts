#!/usr/bin/env bash
# Assert the rendered env var names and shapes are the ones Convoy actually reads.
#
# A name Convoy does not read is a silent no-op: the pod starts, the setting is
# ignored, and nothing in a normal install surfaces it. These names have drifted
# before, so they are pinned here against the umbrella chart.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "verify-env-contract-template: $*" >&2
  exit 1
}

# Value line after env_name in the Deployment with app.kubernetes.io/name: workload.
deployment_env_value_line() {
  local yaml=$1 workload=$2 env_name=$3
  echo "$yaml" | awk -v wl="$workload" -v en="$env_name" '
    /^kind: Deployment/ { in_dep=0 }
    $0 ~ ("app.kubernetes.io/name: " wl) { in_dep=1 }
    in_dep && $0 ~ ("name: " en "$") { getline; print; exit }
  '
}

PG_FLAGS=(
  --set global.convoy.queue_provider=postgres
  --set 'server.env.enable_feature_flag={postgres-queue}'
  --set 'agent.env.enable_feature_flag={postgres-queue}'
  --set redis.enabled=false
)

# --- Queue provider: redis is the default and keeps its Redis wiring ---
OUT_DEFAULT="$(helm template env-contract-default .)"
echo "$OUT_DEFAULT" | grep -q 'name: CONVOY_QUEUE_PROVIDER' || fail "default: missing CONVOY_QUEUE_PROVIDER"
echo "$OUT_DEFAULT" | grep -qE 'value: "?redis"?' || fail "default: CONVOY_QUEUE_PROVIDER should be redis"
echo "$OUT_DEFAULT" | grep -q 'name: CONVOY_REDIS_HOST' || fail "default: missing CONVOY_REDIS_HOST"

# --- Queue provider: postgres drops Redis and carries every tuning var ---
OUT_PG="$(helm template env-contract-pg . "${PG_FLAGS[@]}")"
echo "$OUT_PG" | grep -qE 'value: "?postgres"?' || fail "postgres: CONVOY_QUEUE_PROVIDER should be postgres"

n_redis="$(echo "$OUT_PG" | grep -c 'CONVOY_REDIS_' || true)"
[[ "${n_redis}" -eq 0 ]] || fail "postgres: Redis env must not render (got ${n_redis})"

for var in \
  CONVOY_POSTGRES_QUEUE_BATCH_SIZE \
  CONVOY_POSTGRES_QUEUE_BATCH_WAIT_MS \
  CONVOY_POSTGRES_QUEUE_WRITE_CONCURRENCY \
  CONVOY_POSTGRES_QUEUE_LEASE_TIMEOUT_SECONDS \
  CONVOY_POSTGRES_QUEUE_CLAIM_BATCH_SIZE \
  CONVOY_POSTGRES_QUEUE_POLL_IDLE_MS \
  CONVOY_POSTGRES_CACHE_LOCAL_READ_TTL_MS \
  CONVOY_POSTGRES_CACHE_LOCAL_READ_SIZE; do
  # Once per workload: server and agent both take the queue.
  n="$(echo "$OUT_PG" | grep -c "name: ${var}$" || true)"
  [[ "${n}" -eq 2 ]] || fail "postgres: expected ${var} on server and agent (got ${n})"
done

# --- Queue provider: postgres without the feature flag must fail closed ---
# Convoy refuses to boot without it, so rendering would only produce a crash loop.
if helm template env-contract-noflag . --set global.convoy.queue_provider=postgres >/dev/null 2>&1; then
  fail "postgres without postgres-queue in enable_feature_flag should fail to render"
fi

# --- Dispatcher: Convoy reads BLOCK_LIST; DENY_LIST is read by nothing ---
echo "$OUT_DEFAULT" | grep -q 'name: CONVOY_DISPATCHER_BLOCK_LIST' || fail "missing CONVOY_DISPATCHER_BLOCK_LIST"
if echo "$OUT_DEFAULT" | grep -q 'CONVOY_DISPATCHER_DENY_LIST'; then
  fail "CONVOY_DISPATCHER_DENY_LIST is not read by Convoy; use CONVOY_DISPATCHER_BLOCK_LIST"
fi

# --- Pool size: one value per process, and blank defers to Convoy's default ---
n_pool="$(echo "$OUT_DEFAULT" | grep -c 'name: CONVOY_DB_MAX_OPEN_CONN' || true)"
[[ "${n_pool}" -eq 2 ]] || fail "expected CONVOY_DB_MAX_OPEN_CONN on server and agent (got ${n_pool})"

OUT_NOPOOL="$(helm template env-contract-nopool . --set global.convoy.db_max_open_conn="")"
if echo "$OUT_NOPOOL" | grep -q 'CONVOY_DB_MAX_OPEN_CONN'; then
  fail "a blank db_max_open_conn must not render, so Convoy applies its own default"
fi

# --- Read replicas: a JSON array of database objects, and only ever one value ---
OUT_DSN="$(helm template env-contract-dsn . \
  --set global.convoy.read_replica_dsn='postgres://u:p@replica:5432/convoy')"
echo "$OUT_DSN" | grep -q 'name: CONVOY_DB_READ_REPLICAS' || fail "dsn: missing CONVOY_DB_READ_REPLICAS"
echo "$OUT_DSN" | grep -q 'dsn.*postgres://u:p@replica:5432/convoy' || fail "dsn: expected a JSON array carrying the dsn key"
if echo "$OUT_DSN" | grep -q 'CONVOY_READ_REPLICA_DSN'; then
  fail "CONVOY_READ_REPLICA_DSN is not read by Convoy; use CONVOY_DB_READ_REPLICAS"
fi

# Both inputs set: the full-shape list wins and the variable is set once per pod,
# because a container may only carry one value for a given name.
OUT_BOTH="$(helm template env-contract-both . \
  --set global.convoy.read_replica_dsn='postgres://u:p@dsnreplica:5432/convoy' \
  --set global.externalDatabase.enabled=true \
  --set global.externalDatabase.host=pg.example.com \
  --set 'global.externalDatabase.readReplicas[0].scheme=postgres' \
  --set 'global.externalDatabase.readReplicas[0].host=listreplica')"
n_rr="$(echo "$OUT_BOTH" | grep -c 'name: CONVOY_DB_READ_REPLICAS' || true)"
[[ "${n_rr}" -eq 2 ]] || fail "both inputs: expected CONVOY_DB_READ_REPLICAS once per workload (got ${n_rr})"
echo "$OUT_BOTH" | grep -q 'listreplica' || fail "both inputs: externalDatabase.readReplicas should win"
if echo "$OUT_BOTH" | grep -q 'dsnreplica'; then
  fail "both inputs: read_replica_dsn must not also render"
fi

# --- Argo Rollout templates carry the same contract as the Deployments ---
# rollout.yaml is a second copy of the container spec, so it is where these names
# drift out of step without anything failing.
OUT_RO="$(helm template env-contract-rollout . \
  --set server.rollout.enabled=true \
  --set agent.rollout.enabled=true \
  --set global.convoy.read_replica_dsn='postgres://u:p@replica:5432/convoy' \
  "${PG_FLAGS[@]}")"

n_ro="$(echo "$OUT_RO" | grep -c 'kind: Rollout' || true)"
[[ "${n_ro}" -eq 2 ]] || fail "rollout: expected a Rollout for server and agent (got ${n_ro})"

echo "$OUT_RO" | grep -qE 'value: "?postgres"?' || fail "rollout: CONVOY_QUEUE_PROVIDER should be postgres"
echo "$OUT_RO" | grep -q 'name: CONVOY_POSTGRES_QUEUE_BATCH_SIZE' || fail "rollout: missing Postgres queue tuning env"
echo "$OUT_RO" | grep -q 'name: CONVOY_DISPATCHER_BLOCK_LIST' || fail "rollout: missing CONVOY_DISPATCHER_BLOCK_LIST"
echo "$OUT_RO" | grep -q 'name: CONVOY_DB_READ_REPLICAS' || fail "rollout: missing CONVOY_DB_READ_REPLICAS"
echo "$OUT_RO" | grep -q 'name: CONVOY_DB_MAX_OPEN_CONN' || fail "rollout: missing CONVOY_DB_MAX_OPEN_CONN"

n_ro_redis="$(echo "$OUT_RO" | grep -c 'CONVOY_REDIS_' || true)"
[[ "${n_ro_redis}" -eq 0 ]] || fail "rollout: Redis env must not render on the Postgres queue (got ${n_ro_redis})"

for stale in CONVOY_DISPATCHER_DENY_LIST CONVOY_READ_REPLICA_DSN; do
  if echo "$OUT_RO" | grep -q "${stale}"; then
    fail "rollout: ${stale} is not read by Convoy"
  fi
done

# --- Retention: global defaults apply to server and agent unless env overrides ---
OUT_RET_GLOBAL="$(helm template env-contract-ret-global . \
  --set global.convoy.retention_period=48h \
  --set global.convoy.webhook_archiving_enabled=false)"
n_period="$(echo "$OUT_RET_GLOBAL" | grep -c 'name: CONVOY_RETENTION_PERIOD' || true)"
[[ "${n_period}" -eq 2 ]] || fail "global retention_period: expected on server and agent (got ${n_period})"
echo "$OUT_RET_GLOBAL" | grep -qE 'value: "?48h"?' || fail "global retention_period: expected 48h"
n_arch="$(echo "$OUT_RET_GLOBAL" | grep -c 'name: CONVOY_WEBHOOK_ARCHIVING_ENABLED' || true)"
[[ "${n_arch}" -eq 2 ]] || fail "global webhook_archiving_enabled: expected on server and agent (got ${n_arch})"
echo "$OUT_RET_GLOBAL" | grep -qE 'value: "?false"?' || fail "global webhook_archiving_enabled: expected false"

RET_OVERRIDE_VALUES="$(mktemp "${TMPDIR:-/tmp}/convoy-ret-override.XXXXXX")"
trap 'rm -f "${RET_OVERRIDE_VALUES}"' EXIT
cat > "${RET_OVERRIDE_VALUES}" <<'EOF'
global:
  convoy:
    retention_period: 48h
server:
  env:
    retention:
      period: 720h
EOF
OUT_RET_OVERRIDE="$(helm template env-contract-ret-override . -f "${RET_OVERRIDE_VALUES}")"
srv_period_line="$(deployment_env_value_line "$OUT_RET_OVERRIDE" convoy-server CONVOY_RETENTION_PERIOD)"
ag_period_line="$(deployment_env_value_line "$OUT_RET_OVERRIDE" convoy-agent CONVOY_RETENTION_PERIOD)"
[[ -n "${srv_period_line}" ]] || fail "retention override: server missing CONVOY_RETENTION_PERIOD"
[[ -n "${ag_period_line}" ]] || fail "retention override: agent missing CONVOY_RETENTION_PERIOD"
echo "${srv_period_line}" | grep -qE '720h' || fail "retention override: server expected 720h (got ${srv_period_line})"
echo "${ag_period_line}" | grep -qE '48h' || fail "retention override: agent expected 48h (got ${ag_period_line})"

OUT_RET_LEGACY="$(helm template env-contract-ret-legacy . \
  --set 'server.extraEnvs[0].name=CONVOY_RETENTION_POLICY' \
  --set 'server.extraEnvs[0].value=48h' \
  --set global.convoy.retention_period=48h)"
if echo "$OUT_RET_LEGACY" | awk '/^kind: Deployment/{d=0} /app.kubernetes.io\/name: convoy-server/{d=1} d' | grep -q 'name: CONVOY_RETENTION_PERIOD'; then
  fail "legacy extraEnvs CONVOY_RETENTION_POLICY on server must suppress chart-rendered CONVOY_RETENTION_PERIOD"
fi

echo "verify-env-contract-template: OK (queue provider, dispatcher, read replicas, rollouts, retention globals)"
