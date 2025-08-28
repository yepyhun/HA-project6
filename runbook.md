# Runbook (V0.4)

## DB init
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f db/schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f db/seed.sql

## n8n
1. Importáld a két flow-t a `flows/` mappából.
2. Állítsd be az ENV-eket (lásd `.env.example`), illetve az `ENV_PG` Postgres credentialt.
3. Futtasd először az `ingest_raw_v0_4_domparser_alerts_cooldown`-t, majd a `normalize_and_decide_v0_4_schema_budget_daily`-t.

## ENV minimum
- `HARDVERAPRO_SEARCH_URL`, `SEARCH_QUERY`
- `PG*` paraméterek
- Opcionális: Slack/Telegram (riasztás), TOKENIZER_URL

## V0.4 változások (quick wins)
- **JSON Schema**: fájl-alapú validáció (`listing_norm.schema.json`, required/type/format).
- **Kill-switch cooldown**: küszöb elérésekor **10 perc** kötelező „lehűlés”.
- **Napi költségkeret**: `cost_spent_huf = { date, spent }` (UTC), éjfélkor nullázódik automatikusan.
- **Indexek**: két riport gyorsító index a sémában.


## v0.5 – Breaking change jegyzet: `cost_spent_huf` objektummá vált

**Mi változott?**  
A `control_state.cost_spent_huf` típusa korábban *number* volt, mostantól **object**:  
`{"date": "YYYY-MM-DD", "spent": <nonnegative number>}` (UTC dátum).

**Miért?**  
Napi költségablak bevezetése (date + spent), kompatibilis a kill-switch/budget logikával.

**Migráció futtatása:**
```bash
psql "host=$PGHOST port=$PGPORT user=$PGUSER dbname=$PGDATABASE password=$PGPASSWORD"   -f db/migrations/003_cost_spent_huf_migrate.sql
```

**Gyors ellenőrzés (smoke):**
```bash
bash scripts/smoke_v05.sh
# elvárt kimenet: SMOKE_V05_PASS
```

**Megjegyzés:** A változás **idempotens**; a migráció többször is futtatható, meglévő objektum mezőit nem írja felül.
