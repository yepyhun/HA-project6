BEGIN;

-- 1) Ha nincs kulcs: hozd létre objektumként (UTC dátummal, 0 költéssel)
INSERT INTO control_state (key, value)
SELECT 'cost_spent_huf',
       jsonb_build_object(
         'date', to_char((now() at time zone 'UTC')::date, 'YYYY-MM-DD'),
         'spent', 0
       )
WHERE NOT EXISTS (SELECT 1 FROM control_state WHERE key = 'cost_spent_huf');

-- 2) Csak a numerikus régi értéket konvertáld objektummá (UTC dátummal)
UPDATE control_state
SET value = jsonb_build_object(
  'date',  to_char((now() at time zone 'UTC')::date, 'YYYY-MM-DD'),
  'spent', (value)::text::numeric
)
WHERE key = 'cost_spent_huf'
  AND jsonb_typeof(value) = 'number';

-- 3) Ha már objektum, NE írd felül — csak pótold a hiányzó mezőket
UPDATE control_state
SET value = jsonb_set(
  value, '{spent}',
  to_jsonb(COALESCE( (value->>'spent')::numeric, 0 ))
)
WHERE key = 'cost_spent_huf'
  AND jsonb_typeof(value) = 'object'
  AND NOT (value ? 'spent');

UPDATE control_state
SET value = jsonb_set(
  value, '{date}',
  to_jsonb( to_char((now() at time zone 'UTC')::date, 'YYYY-MM-DD') )
)
WHERE key = 'cost_spent_huf'
  AND jsonb_typeof(value) = 'object'
  AND NOT (value ? 'date');

COMMIT;
