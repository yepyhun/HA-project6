#!/usr/bin/env bash
set -euo pipefail

# --- Preflight: szükséges PG ENV kulcsok ---
req=(PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE)
for k in "${req[@]}"; do
  if [[ -z "${!k:-}" ]]; then
    echo "FAIL: missing env $k"; exit 2
  fi
done

psql_cmd() { psql "host=$PGHOST port=$PGPORT user=$PGUSER dbname=$PGDATABASE password=$PGPASSWORD" -t -A -q "$@"; }

echo "[1/3] Migráció futtatása..."
psql_cmd -f db/migrations/003_cost_spent_huf_migrate.sql

echo "[2/3] Információs számlálók (nem kapuk, csak infó)..."
listing_norm_count=$(psql_cmd -c "SELECT COUNT(*) FROM listing_norm;" || echo 0)
decision_audit_count=$(psql_cmd -c "SELECT COUNT(*) FROM decision_audit;" || echo 0)
echo "INFO: listing_norm=${listing_norm_count} decision_audit=${decision_audit_count}"

echo "[3/3] Kapuk a control_state alapján..."
date_str=$(psql_cmd -c "SELECT value->>'date' FROM control_state WHERE key='cost_spent_huf';")
spent_huf=$(psql_cmd -c "SELECT COALESCE((value->>'spent')::numeric,0) FROM control_state WHERE key='cost_spent_huf';")
today=$(date -u +%F)

fail=0
if [[ "${date_str}" != "${today}" ]]; then
  echo "FAIL: cost_spent_huf.date != ${today} (=${date_str})"; fail=1
fi
awk "BEGIN {exit !(${spent_huf:-0} >= 0)}" || { echo "FAIL: cost_spent_huf.spent < 0 (=${spent_huf:-0})"; fail=1; }

if [[ $fail -ne 0 ]]; then
  echo "SMOKE_V05_FAIL"; exit 1
fi

echo "SMOKE_V05_PASS"
