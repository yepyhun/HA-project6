-- Core tables
CREATE TABLE IF NOT EXISTS ingest_raw (
  id BIGSERIAL PRIMARY KEY,
  source TEXT NOT NULL,
  payload JSONB NOT NULL,
  received_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS listing_norm (
  id BIGSERIAL PRIMARY KEY,
  listing_id TEXT NOT NULL,
  idempotency_key TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  price_raw TEXT,
  price_huf INTEGER,
  currency TEXT,
  url TEXT NOT NULL,
  extracted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS decision_audit (
  id BIGSERIAL PRIMARY KEY,
  listing_id TEXT NOT NULL,
  decision TEXT NOT NULL,
  fit_score INTEGER,
  risk_score INTEGER,
  explanation TEXT,
  evidence JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS control_state (
  key TEXT PRIMARY KEY,
  value JSONB,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes (V0.4)
CREATE INDEX IF NOT EXISTS idx_ingest_raw_received_at ON ingest_raw(received_at DESC);
CREATE INDEX IF NOT EXISTS idx_decision_audit_listing_id ON decision_audit(listing_id);