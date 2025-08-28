# CHANGELOG

## v0.5
- Added migration: `db/migrations/003_cost_spent_huf_migrate.sql` (idempotens).
- Added smoke test: `scripts/smoke_v05.sh`.
- Updated `runbook.md` a breaking change jegyzettel.
- QA: Secrets – PASS; License – PASS; Back-compat – **PENDING** (futtasd a smoke tesztet).

**Artifact hashes (SHA-256, zip):**
- v0_4: 677ac4bc9281ebc52aea4c52c63224ca04b86b2e1a83fb8ab643991ffb8436c1
- v0_5: 53e8cac065a3a9b2eb60d4847da9e622aeeeb5bfd656704d9924480195e27e72

> Megjegyzés: Git commit SHA-k jelen környezetben nem rögzíthetők; merge után kérlek egészítsd ki a fenti bejegyzést a tényleges `v0_4` és `v0_5` commit SHA-kkal.