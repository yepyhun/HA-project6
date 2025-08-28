# V0.4 PoC Report

- Visszakerült a **fájl-alapú JSON Schema enforcement** a normalizáció végére.
- A **kill-switch** 10 perces **cooldown**-t vezet be; cooldown aktív esetén a rendszer offline mintára vált.
- A **budget guard** napi költségkeretet figyel, nem kumulatív összeget.
- Új **indexek**: `idx_ingest_raw_received_at`, `idx_decision_audit_listing_id`.

A PoC továbbra is minimális, de üzemszerű: auditálható döntések, idempotencia, fallback, riasztás, költség-transzparencia.
