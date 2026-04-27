-- ══════════════════════════════════════════════════════════
--  OPERATIONS TEAM REGISTER — SUPABASE SCHEMA
--  BizProspex · 2025
--  
--  HOW TO USE:
--  1. Go to your Supabase Dashboard → SQL Editor
--  2. Paste this ENTIRE file and click "Run"
--  3. All tables, policies, and employees will be created
-- ══════════════════════════════════════════════════════════

-- ────────────────────────────────────
--  TABLE: employees
-- ────────────────────────────────────
CREATE TABLE IF NOT EXISTS employees (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE,
  desig       TEXT NOT NULL DEFAULT 'L3',
  joined      DATE NOT NULL DEFAULT CURRENT_DATE,
  team        TEXT NOT NULL DEFAULT 'Impact Ops',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ────────────────────────────────────
--  TABLE: entries
-- ────────────────────────────────────
CREATE TABLE IF NOT EXISTS entries (
  id              TEXT PRIMARY KEY,
  employee_name   TEXT NOT NULL REFERENCES employees(name) ON DELETE CASCADE,
  type            TEXT NOT NULL DEFAULT 'note',
  date            DATE NOT NULL DEFAULT CURRENT_DATE,
  title           TEXT,
  "desc"          TEXT,
  mail_subject    TEXT,
  action          TEXT,
  severity        TEXT DEFAULT 'medium',
  ref_id          TEXT,
  ts              BIGINT NOT NULL DEFAULT (EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for fast lookups by employee
CREATE INDEX IF NOT EXISTS idx_entries_employee ON entries(employee_name);
CREATE INDEX IF NOT EXISTS idx_entries_type ON entries(type);
CREATE INDEX IF NOT EXISTS idx_entries_date ON entries(date);

-- ────────────────────────────────────
--  ROW LEVEL SECURITY (RLS)
--  Enable public read/write with anon key
-- ────────────────────────────────────
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE entries   ENABLE ROW LEVEL SECURITY;

-- Allow all operations for anon users (internal tool, no auth needed)
CREATE POLICY "Allow all on employees" ON employees
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all on entries" ON entries
  FOR ALL USING (true) WITH CHECK (true);

-- ────────────────────────────────────
--  SEED DATA: ALL EMPLOYEES
--  Impact Ops (23 members) + Pinnacle Team (10 members)
-- ────────────────────────────────────

INSERT INTO employees (id, name, desig, joined, team) VALUES
  -- ═══ IMPACT OPS ═══
  ('IO-001', 'Payal Dulhani',       'L1', '2025-01-01', 'Impact Ops'),
  ('IO-002', 'Nafees Ansari',       'L1', '2025-01-01', 'Impact Ops'),
  ('IO-003', 'Konica Dalal',        'L1', '2025-01-01', 'Impact Ops'),
  ('IO-004', 'Rukhsar Ansari',      'L2', '2025-01-01', 'Impact Ops'),
  ('IO-005', 'Zubair Ansari',       'L2', '2025-01-01', 'Impact Ops'),
  ('IO-006', 'Priyanshi Konduwala', 'L2', '2025-01-01', 'Impact Ops'),
  ('IO-007', 'Mohtashim Bux',       'L2', '2025-01-01', 'Impact Ops'),
  ('IO-008', 'Bismillah Mohammad',  'L2', '2025-01-01', 'Impact Ops'),
  ('IO-009', 'Zulfhekhar Khan',     'L2', '2025-01-01', 'Impact Ops'),
  ('IO-010', 'Tausif Ansari',       'L2', '2025-01-01', 'Impact Ops'),
  ('IO-011', 'Yunus Khan',          'L3', '2025-01-01', 'Impact Ops'),
  ('IO-012', 'Himanshu Soni',       'L3', '2025-01-01', 'Impact Ops'),
  ('IO-013', 'Unnati Yawar',        'L3', '2025-01-01', 'Impact Ops'),
  ('IO-014', 'Haris Bilal',         'L3', '2025-01-01', 'Impact Ops'),
  ('IO-015', 'Imtiyaz Hanif',       'L3', '2025-01-01', 'Impact Ops'),
  ('IO-016', 'Mubeen Syed',         'L3', '2025-01-01', 'Impact Ops'),
  ('IO-017', 'Naba Naaz',           'L3', '2025-01-01', 'Impact Ops'),
  ('IO-018', 'Sameer Ahmed',        'L3', '2025-01-01', 'Impact Ops'),
  ('IO-019', 'Tushar Choudhary',    'L3', '2025-01-01', 'Impact Ops'),
  ('IO-020', 'Zeeshan Husain',      'L3', '2025-01-01', 'Impact Ops'),
  ('IO-021', 'Sheetal Padme',       'L4', '2025-01-01', 'Impact Ops'),
  ('IO-022', 'Izhar Ashraf',        'L4', '2025-01-01', 'Impact Ops'),
  ('IO-023', 'Hrushikesh Joshi',    'L4', '2025-01-01', 'Impact Ops'),

  -- ═══ PINNACLE TEAM ═══
  ('PT-001', 'Vikar Ali',           'TL', '2025-01-01', 'Pinnacle Team'),
  ('PT-002', 'Ahtesham Shaikh',     'L2', '2025-01-01', 'Pinnacle Team'),
  ('PT-003', 'Tausif Khan',         'L3', '2025-01-01', 'Pinnacle Team'),
  ('PT-004', 'Aamir Khan',          'L3', '2025-01-01', 'Pinnacle Team'),
  ('PT-005', 'Amaan Khan',          'L3', '2025-01-01', 'Pinnacle Team'),
  ('PT-006', 'Farhana Kausar',      'L4', '2025-01-01', 'Pinnacle Team'),
  ('PT-007', 'Sohail Ansari',       'L4', '2025-01-01', 'Pinnacle Team'),
  ('PT-008', 'Shoaib Ansari',       'L4', '2025-01-01', 'Pinnacle Team'),
  ('PT-009', 'Gunjan Choudhary',    'L4', '2025-01-01', 'Pinnacle Team'),
  ('PT-010', 'Asif Mohammad',       'L2', '2025-01-01', 'Pinnacle Team')
ON CONFLICT (id) DO NOTHING;

-- ════════════════════════════════════
--  DONE! Your database is ready.
--  Total: 33 employees seeded.
-- ════════════════════════════════════
