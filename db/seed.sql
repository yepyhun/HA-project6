-- Reset demo data
TRUNCATE ingest_raw, decision_audit RESTART IDENTITY;

-- Fail streak
INSERT INTO control_state(key,value) VALUES
  ('network_fail_streak', to_jsonb(0))
ON CONFLICT (key) DO UPDATE SET value=excluded.value, updated_at=now();

-- Cooldown until (ISO)
INSERT INTO control_state(key,value) VALUES
  ('cooldown_until', to_jsonb(NULL))
ON CONFLICT (key) DO UPDATE SET value=excluded.value, updated_at=now();

-- Daily budget spent (UTC date bucket)
INSERT INTO control_state(key,value) VALUES
  ('cost_spent_huf', jsonb_build_object('date', to_char(now() at time zone 'UTC','YYYY-MM-DD'), 'spent', 0))
ON CONFLICT (key) DO UPDATE SET value=excluded.value, updated_at=now();