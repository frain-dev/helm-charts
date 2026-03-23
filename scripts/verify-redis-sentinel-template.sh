#!/usr/bin/env bash
# Render agent and server subcharts with Sentinel values; assert expected env vars.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OVERLAY="${ROOT}/ci/redis-sentinel-values.yaml"

fail() {
  echo "verify-redis-sentinel-template: $*" >&2
  exit 1
}

assert_sentinel_env() {
  local name="$1"
  local out="$2"

  local n_scheme
  n_scheme="$(echo "$out" | grep -cE 'value: "?redis-sentinel"?' || true)"
  [[ "${n_scheme}" -ge 1 ]] || fail "${name}: expected CONVOY_REDIS_SCHEME=redis-sentinel (got ${n_scheme})"

  echo "$out" | grep -q 'name: CONVOY_REDIS_SENTINEL_MASTER_NAME' || fail "${name}: missing CONVOY_REDIS_SENTINEL_MASTER_NAME"
  echo "$out" | grep -qE 'value: "?mymaster"?' || fail "${name}: missing sentinel master name mymaster"

  echo "$out" | grep -qE 'name[[:space:]]*:[[:space:]]*CONVOY_REDIS_PORT' || fail "${name}: missing CONVOY_REDIS_PORT"
  echo "$out" | grep -qE 'value: "?26379"?$' || fail "${name}: missing CONVOY_REDIS_PORT 26379"

  echo "$out" | grep -q 'name: CONVOY_REDIS_TYPE' || fail "${name}: missing CONVOY_REDIS_TYPE"
  echo "$out" | grep -qE 'value: "?EXTERNAL"?' || fail "${name}: missing CONVOY_REDIS_TYPE EXTERNAL"

  echo "$out" | grep -q 'name: CONVOY_REDIS_SENTINEL_PASSWORD' || fail "${name}: missing CONVOY_REDIS_SENTINEL_PASSWORD"
}

OUT_AGENT="$(helm template sentinel-agent-test ./charts/agent -f charts/agent/values.yaml -f "${OVERLAY}")"
assert_sentinel_env "charts/agent" "${OUT_AGENT}"

OUT_SERVER="$(helm template sentinel-server-test ./charts/server -f charts/server/values.yaml -f "${OVERLAY}")"
assert_sentinel_env "charts/server" "${OUT_SERVER}"

echo "verify-redis-sentinel-template: OK (agent + server)"
