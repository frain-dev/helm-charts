#!/usr/bin/env bash
# This script verifies:
# - Redis Sentinel responds and reports a master; SET/GET on the master
# - PostgreSQL accepts a query on the convoy database
set -euo pipefail

NS="${1:-default}"
REDIS_SVC="${REDIS_SVC:-redis}"
REDIS_SENTINEL_PORT="${REDIS_SENTINEL_PORT:-26379}"
PG_SVC="${PG_SVC:-postgresql}"
PG_DB="${PG_DB:-convoy}"
PG_USER="${PG_USER:-postgres}"
MASTER_SET="${MASTER_SET:-mymaster}"
VERIFY_KEY="${VERIFY_KEY:-convoy_ci_verify}"

wait_terminal_phase() {
  local pod=$1
  local start now
  start=$(date +%s)
  while :; do
    now=$(date +%s)
    if [ $((now - start)) -ge 240 ]; then
      echo "Timeout"
      return 1
    fi
    local phase
    phase=$(kubectl get pod "$pod" -n "$NS" -o jsonpath='{.status.phase}' 2>/dev/null || echo Pending)
    if [ "$phase" = Succeeded ] || [ "$phase" = Failed ]; then
      echo "$phase"
      return 0
    fi
    sleep 2
  done
}

echo "Waiting for Redis Sentinel nodes (statefulset/redis-node)..."
kubectl rollout status "statefulset/redis-node" -n "$NS" --timeout=400s

echo "Waiting for PostgreSQL primary..."
kubectl rollout status "statefulset/postgresql" -n "$NS" --timeout=400s

REDIS_PASS=$(kubectl get secret redis -n "$NS" -o jsonpath='{.data.redis-password}' | base64 -d)
PG_PASS=$(kubectl get secret postgresql -n "$NS" -o jsonpath='{.data.postgres-password}' | base64 -d)

POD_REDIS="convoy-ci-redis-verify-$$"
POD_PG="convoy-ci-pg-verify-$$"

cleanup() {
  kubectl delete pod -n "$NS" "$POD_REDIS" --ignore-not-found=true --wait=false 2>/dev/null || true
  kubectl delete pod -n "$NS" "$POD_PG" --ignore-not-found=true --wait=false 2>/dev/null || true
}
trap cleanup EXIT

echo "Verifying Redis via Sentinel (${REDIS_SVC}:${REDIS_SENTINEL_PORT})..."
kubectl run "$POD_REDIS" -n "$NS" --restart=Never \
  --image=docker.io/library/redis:7-alpine \
  --env="REDISCLI_AUTH=${REDIS_PASS}" \
  --env="R_SVC=${REDIS_SVC}" \
  --env="R_SENT_PORT=${REDIS_SENTINEL_PORT}" \
  --env="R_MASTER_SET=${MASTER_SET}" \
  --env="R_KEY=${VERIFY_KEY}" \
  --command -- sh -ec '
set -euo pipefail
redis-cli -h "$R_SVC" -p "$R_SENT_PORT" --no-auth-warning PING | grep -qx PONG
OUT=$(redis-cli -h "$R_SVC" -p "$R_SENT_PORT" --no-auth-warning --raw SENTINEL get-master-addr-by-name "$R_MASTER_SET" || true)
if [ -z "$OUT" ]; then
  echo "SENTINEL get-master-addr-by-name failed or empty"
  exit 1
fi
MASTER_HOST=$(printf "%s\n" "$OUT" | sed -n "1p")
MASTER_PORT=$(printf "%s\n" "$OUT" | sed -n "2p")
if [ -z "$MASTER_HOST" ] || [ -z "$MASTER_PORT" ]; then
  MASTER_HOST=$(printf "%s\n" "$OUT" | awk "{print \$1}")
  MASTER_PORT=$(printf "%s\n" "$OUT" | awk "{print \$2}")
fi
if [ -z "$MASTER_HOST" ] || [ -z "$MASTER_PORT" ]; then
  echo "Could not parse master host/port from sentinel output: $OUT"
  exit 1
fi
redis-cli -h "$MASTER_HOST" -p "$MASTER_PORT" --no-auth-warning SET "$R_KEY" ok
test "$(redis-cli -h "$MASTER_HOST" -p "$MASTER_PORT" --no-auth-warning GET "$R_KEY")" = ok
echo "Redis Sentinel + master read/write OK"
'

phase_r=$(wait_terminal_phase "$POD_REDIS") || true
if [ "$phase_r" != Succeeded ]; then
  echo "--- Redis verify pod logs ---"
  kubectl logs "$POD_REDIS" -n "$NS" 2>/dev/null || true
  echo "Redis verify failed: phase=${phase_r}"
  exit 1
fi

echo "Verifying PostgreSQL (${PG_SVC}, db=${PG_DB})..."
kubectl run "$POD_PG" -n "$NS" --restart=Never \
  --image=docker.io/library/postgres:17-alpine \
  --env="PGPASS=${PG_PASS}" \
  --env="PG_SVC=${PG_SVC}" \
  --env="PG_DB=${PG_DB}" \
  --env="PG_USER=${PG_USER}" \
  --command -- sh -ec '
set -euo pipefail
export PGPASSWORD="$PGPASS"
psql -h "$PG_SVC" -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 -c "SELECT 1 AS ok;"
echo "PostgreSQL query OK"
'

phase_p=$(wait_terminal_phase "$POD_PG") || true
if [ "$phase_p" != Succeeded ]; then
  echo "--- Postgres verify pod logs ---"
  kubectl logs "$POD_PG" -n "$NS" 2>/dev/null || true
  echo "PostgreSQL verify failed: phase=${phase_p}"
  exit 1
fi

echo "Integration checks passed."
