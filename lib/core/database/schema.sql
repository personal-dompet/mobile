-- =============================================================================
-- Dompet App - Full Database Schema (SQLite)
-- Generated from: lib/core/database/  (DbService, schemas, seeders, triggers, views)
-- DbService version: 1  |  PRAGMA foreign_keys = ON
-- Source files:
--   lib/core/database/db_service.dart:68-96         (_onCreate order)
--   lib/core/database/schemas/accounts.dart:6-21    (accountSchema)
--   lib/core/database/schemas/app_configuration.dart:5-11
--   lib/core/database/schemas/budget_plans.dart:6-23
--   lib/core/database/schemas/budgets.dart:6-34
--   lib/core/database/schemas/journal_entries.dart:7-25
--   lib/core/database/schemas/journal_lines.dart:7-30
--   lib/core/database/seeders/seed_app_configuration.dart:8-17
--   lib/core/database/seeders/seed_account.dart:6-44
--   lib/core/database/triggers/account_counter_trigger.dart:4-36
--   lib/core/database/views/account_balance.dart:7-25
--   lib/core/database/views/budget_tracker.dart:8-28
-- =============================================================================

-- Enable foreign keys (DbService:39-41 onConfigure)
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- =============================================================================
-- 1. TABLES
-- =============================================================================

-- -------------------------------------------------------------------------
-- Table: accounts
-- Source: lib/core/database/schemas/accounts.dart:6-21
-- Keys  : lib/core/constants/field_keys/account.dart:1-17
-- Enums : AccountType (ASSET, LIABILITY, EQUITY, INCOME, EXPENSE)
--         BalanceType (DEBIT, CREDIT)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS accounts (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  code            TEXT NOT NULL UNIQUE,
  name            TEXT NOT NULL,
  type            TEXT NOT NULL CHECK(type IN ('ASSET','LIABILITY','EQUITY','INCOME','EXPENSE')),
  normal_balance  TEXT NOT NULL CHECK(normal_balance IN ('DEBIT','CREDIT')),
  is_liquid       INTEGER DEFAULT 0,
  is_system       INTEGER DEFAULT 0,
  icon_code       INTEGER,
  is_deleted      INTEGER DEFAULT 0,
  counter         INTEGER DEFAULT 0,
  created_at      INTEGER DEFAULT (strftime('%s', 'now'))
);

-- -------------------------------------------------------------------------
-- Table: app_configurations
-- Source: lib/core/database/schemas/app_configuration.dart:5-11
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS app_configurations (
  id      INTEGER PRIMARY KEY AUTOINCREMENT,
  setting TEXT NOT NULL
);

-- -------------------------------------------------------------------------
-- Table: budget_plans
-- Source: lib/core/database/schemas/budget_plans.dart:6-17
-- FK    : account_id -> accounts(id)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS budget_plans (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id  INTEGER UNIQUE NOT NULL,
  amount      INTEGER NOT NULL CHECK(amount > 0),
  note        TEXT,
  is_deleted  INTEGER DEFAULT 0,
  created_at  INTEGER DEFAULT (strftime('%s', 'now')),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- -------------------------------------------------------------------------
-- Table: budgets
-- Source: lib/core/database/schemas/budgets.dart:6-22
-- FK    : account_id -> accounts(id)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS budgets (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id       INTEGER NOT NULL,
  period_start     INTEGER NOT NULL,
  period_end       INTEGER NOT NULL,
  budgeted_amount  INTEGER NOT NULL CHECK(budgeted_amount > 0),
  carry_amount     INTEGER NOT NULL DEFAULT 0,
  leftover         INTEGER NOT NULL DEFAULT 0,
  closed_at        INTEGER,
  created_at       INTEGER DEFAULT (strftime('%s', 'now')),
  UNIQUE(account_id, period_start),
  CHECK(period_start < period_end),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- -------------------------------------------------------------------------
-- Table: saving_plans
-- Source: lib/core/database/schemas/saving_plans.dart
-- FK    : account_id -> accounts(id)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS saving_plans (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id    INTEGER UNIQUE NOT NULL,
  target_amount INTEGER CHECK(target_amount IS NULL OR target_amount > 0),
  target_date   INTEGER,
  note          TEXT,
  status        TEXT NOT NULL DEFAULT 'ACTIVE' CHECK(status IN ('ACTIVE','COMPLETED')),
  is_deleted    INTEGER DEFAULT 0,
  created_at    INTEGER DEFAULT (strftime('%s', 'now')),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- -------------------------------------------------------------------------
-- Table: journal_entries
-- Source: lib/core/database/schemas/journal_entries.dart:7-20
-- Enums : JournalSource (setup, transfer, transaction, bill_generated,
--                        bill_payment, adjustment, saving)
--         JournalStatus (draft, posted, voided)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_entries (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  entry_date  INTEGER NOT NULL,
  description TEXT,
  reference   TEXT,
  source      TEXT NOT NULL CHECK(source IN ('setup','transfer','transaction','bill_generated','bill_payment','adjustment','saving')),
  status      TEXT NOT NULL CHECK(status IN ('draft','posted','voided')),
  metadata    TEXT,
  source_id   INTEGER,
  created_at  INTEGER DEFAULT (strftime('%s', 'now'))
);

-- -------------------------------------------------------------------------
-- Table: journal_lines
-- Source: lib/core/database/schemas/journal_lines.dart:7-20
-- FK    : journal_entry_id -> journal_entries(id)
--         account_id       -> accounts(id)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_lines (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  journal_entry_id  INTEGER NOT NULL,
  account_id        INTEGER NOT NULL,
  debit_amount      INTEGER DEFAULT 0 CHECK(debit_amount >= 0),
  credit_amount     INTEGER DEFAULT 0 CHECK(credit_amount >= 0),
  note              TEXT,
  line_order        INTEGER,
  FOREIGN KEY (journal_entry_id) REFERENCES journal_entries(id),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- =============================================================================
-- 2. INDEXES
-- =============================================================================

-- Active indexes created in DbService._onCreate (db_service.dart:81-83)
CREATE INDEX IF NOT EXISTS idx_journal_lines_journal_entry_id ON journal_lines (journal_entry_id);
CREATE INDEX IF NOT EXISTS idx_journal_lines_account_id       ON journal_lines (account_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_status_entry_date ON journal_entries (status, entry_date);

-- Defined but NOT executed in current _onCreate (kept for completeness) --
-- lib/core/database/schemas/budget_plans.dart:19-23
CREATE INDEX IF NOT EXISTS idx_budget_plan_status ON budget_plans (is_deleted);

-- lib/core/database/schemas/budgets.dart:24-34
CREATE INDEX IF NOT EXISTS idx_budget_period ON budgets (period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_budget_status ON budgets (account_id, closed_at);

-- lib/core/database/schemas/saving_plans.dart
CREATE INDEX IF NOT EXISTS idx_saving_plan_account ON saving_plans (account_id);
CREATE INDEX IF NOT EXISTS idx_saving_plan_status ON saving_plans (status, is_deleted);

-- =============================================================================
-- 3. VIEWS
-- =============================================================================

-- -------------------------------------------------------------------------
-- View: v_account_balances
-- Source: lib/core/database/views/account_balance.dart:7-25
-- Logic: balance = SUM(posted debits) - SUM(posted credits)  if DEBIT
--               or SUM(posted credits) - SUM(posted debits)  if CREDIT
-- -------------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_account_balances AS
  SELECT
    accounts.*,
    CASE
      WHEN accounts.normal_balance = 'DEBIT' THEN
        SUM(CASE WHEN journal_entries.status = 'posted' THEN journal_lines.debit_amount ELSE 0 END) -
        SUM(CASE WHEN journal_entries.status = 'posted' THEN journal_lines.credit_amount ELSE 0 END)
      ELSE
        SUM(CASE WHEN journal_entries.status = 'posted' THEN journal_lines.credit_amount ELSE 0 END) -
        SUM(CASE WHEN journal_entries.status = 'posted' THEN journal_lines.debit_amount ELSE 0 END)
    END AS balance
  FROM accounts
  LEFT JOIN journal_lines ON journal_lines.account_id = accounts.id
  LEFT JOIN journal_entries ON journal_entries.id = journal_lines.journal_entry_id
    AND journal_entries.status = 'posted'
  GROUP BY accounts.id;

-- -------------------------------------------------------------------------
-- View: v_budget_tracker
-- Source: lib/core/database/views/budget_tracker.dart:8-28
-- Logic: actual_spend = SUM(debit_amount if DEBIT else credit_amount)
--        filtered by entry_date BETWEEN period_start AND period_end
--        and status = 'posted', grouped by budgets.id
-- -------------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_budget_tracker AS
  SELECT
    budgets.*,
    accounts.name AS account_name,
    COALESCE(SUM(CASE
      WHEN accounts.normal_balance = 'DEBIT'  THEN journal_lines.debit_amount
      WHEN accounts.normal_balance = 'CREDIT' THEN journal_lines.credit_amount
      ELSE 0
    END), 0) AS actual_spend
  FROM budgets
  LEFT JOIN accounts ON accounts.id = budgets.account_id
  LEFT JOIN journal_entries
    ON journal_entries.entry_date BETWEEN budgets.period_start AND budgets.period_end
    AND journal_entries.status = 'posted'
  LEFT JOIN journal_lines
    ON journal_lines.journal_entry_id = journal_entries.id
    AND journal_lines.account_id = accounts.id
  GROUP BY budgets.id, budgets.account_id;

-- -------------------------------------------------------------------------
-- View: v_saving_tracker
-- Source: lib/core/database/views/saving_tracker.dart
-- Logic: progress = balance / target_amount (NULL jika tanpa target)
-- -------------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_saving_tracker AS
  SELECT
    saving_plans.*,
    accounts.code AS account_code,
    accounts.name AS account_name,
    accounts.icon_code AS icon_code,
    v_account_balances.balance AS balance,
    CASE
      WHEN saving_plans.target_amount IS NULL THEN NULL
      ELSE v_account_balances.balance * 1.0 / saving_plans.target_amount
    END AS progress
  FROM saving_plans
  INNER JOIN accounts ON accounts.id = saving_plans.account_id
  LEFT JOIN v_account_balances ON v_account_balances.id = saving_plans.account_id
  WHERE saving_plans.is_deleted = 0
    AND accounts.is_deleted = 0;

-- =============================================================================
-- 4. TRIGGERS
-- =============================================================================

-- -------------------------------------------------------------------------
-- Trigger: increase_account_counter
-- Source: lib/core/database/triggers/account_counter_trigger.dart:4-19
-- Fires: AFTER UPDATE ON journal_entries WHEN draft -> posted
-- Effect: counter = counter + 1 for all accounts in that journal
-- -------------------------------------------------------------------------
CREATE TRIGGER IF NOT EXISTS increase_account_counter
  AFTER UPDATE ON journal_entries
  WHEN NEW.status = 'posted'
    AND OLD.status = 'draft'
BEGIN
  UPDATE accounts
  SET counter = counter + 1
  WHERE id IN (
    SELECT account_id
    FROM journal_lines
    WHERE journal_entry_id = NEW.id
  );
END;

-- -------------------------------------------------------------------------
-- Trigger: decrease_account_counter
-- Source: lib/core/database/triggers/account_counter_trigger.dart:21-36
-- Fires: AFTER UPDATE ON journal_entries WHEN any -> voided (except already voided)
-- Effect: counter = MAX(counter - 1, 0)
-- -------------------------------------------------------------------------
CREATE TRIGGER IF NOT EXISTS decrease_account_counter
  AFTER UPDATE ON journal_entries
  WHEN NEW.status = 'voided'
    AND OLD.status != 'voided'
BEGIN
  UPDATE accounts
  SET counter = MAX(counter - 1, 0)
  WHERE id IN (
    SELECT account_id
    FROM journal_lines
    WHERE journal_entry_id = NEW.id
  );
END;

-- =============================================================================
-- 5. SEEDERS
-- =============================================================================

-- -------------------------------------------------------------------------
-- Seeder: app_configurations
-- Source: lib/core/database/seeders/seed_app_configuration.dart:8-17
--         lib/core/models/app_configuration.dart:6-27
-- Note : AppConfiguration(hint: AppHint(categorySwipeHint: false),
--                         themeMode: AppThemeMode.system)
--        JSON is inserted via batch.rawInsert in _onCreate (db_service.dart:79)
-- -------------------------------------------------------------------------
INSERT INTO app_configurations (setting) VALUES ('{"hint":{"category_swipe":false},"themeMode":"system"}');

-- -------------------------------------------------------------------------
-- Seeder: accounts (28 presets)
-- Source: lib/core/database/seeders/seed_account.dart:6-44
--         lib/core/enums/account_preset.dart:5-77
--         lib/core/enums/account_type.dart:4-25  -> type + balanceType
-- Logic: is_liquid = 1 for cash, bank, eWallet else 0
--        is_system = 1
--        icon_code = AccountPreset.icon.codePoint (MaterialIcons rounded)
--        ON CONFLICT DO NOTHING (code UNIQUE)
-- Executed inside transaction after batch.commit (db_service.dart:93-95)
-- -------------------------------------------------------------------------

-- ASSET (101) - normal_balance DEBIT
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0001', 'Tunai', 'ASSET', 'DEBIT', 1, 983128, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.cash / Icons.payments_rounded (0xf0058)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0002', 'Rekening Bank', 'ASSET', 'DEBIT', 1, 62751, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.bank / Icons.account_balance_rounded (0xf51f)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0003', 'E-Wallet', 'ASSET', 'DEBIT', 1, 983160, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.eWallet / Icons.phone_android_rounded (0xf0078)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0004', 'Piutang', 'ASSET', 'DEBIT', 0, 62983, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.receivable / Icons.call_received_rounded (0xf607)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0005', 'Investasi', 'ASSET', 'DEBIT', 0, 983636, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.investment / Icons.trending_up_rounded (0xf0254)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('101.0006', 'Kantong Tabungan', 'ASSET', 'DEBIT', 0, 983336, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.savingPocket / Icons.savings_rounded (0xf0128)

-- LIABILITY (201) - normal_balance CREDIT
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('201.0001', 'Tagihan Tertunda', 'LIABILITY', 'CREDIT', 0, 983130, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.delayedBill / Icons.pending_actions_rounded (0xf005a)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('201.0002', 'Kartu Kredit', 'LIABILITY', 'CREDIT', 0, 63100, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.creditCard / Icons.credit_card_rounded (0xf67c)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('201.0003', 'Hutang', 'LIABILITY', 'CREDIT', 0, 62979, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.debt / Icons.call_made_rounded (0xf603)

-- EQUITY (301) - normal_balance CREDIT
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('301.0001', 'Saldo Awal', 'EQUITY', 'CREDIT', 0, 63333, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.intialBalance / Icons.first_page_rounded (0xf765)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('301.0002', 'Penyesuaian Saldo', 'EQUITY', 'CREDIT', 0, 983546, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.balanceAdjustment / Icons.swap_horiz_rounded (0xf01fa)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('301.0003', 'Tabungan', 'EQUITY', 'CREDIT', 0, 983336, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.saving / Icons.savings_rounded (0xf0128)

-- INCOME (401) - normal_balance CREDIT
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0001', 'Gaji / Pendapatan Tetap', 'INCOME', 'CREDIT', 0, 983751, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.salary / Icons.work_rounded (0xf02c7)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0002', 'Usaha / Freelance', 'INCOME', 'CREDIT', 0, 983521, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.freelance / Icons.storefront_rounded (0xf01e1)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0003', 'Bonus', 'INCOME', 'CREDIT', 0, 63695, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.bonus / Icons.monetization_on_rounded (0xf8cf)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0004', 'Hadiah', 'INCOME', 'CREDIT', 0, 63002, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.reward / Icons.card_giftcard_rounded (0xf61a)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0005', 'Penjualan', 'INCOME', 'CREDIT', 0, 983407, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.sale / Icons.shopping_bag_rounded (0xf016f)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('401.0006', 'Lain-lain', 'INCOME', 'CREDIT', 0, 63705, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.otherIncome / Icons.more_horiz_rounded (0xf8d9)

-- EXPENSE (501) - normal_balance DEBIT
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0001', 'Makan / Minum', 'EXPENSE', 'DEBIT', 0, 983304, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.food / Icons.restaurant_rounded (0xf0108)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0002', 'Belanja Harian', 'EXPENSE', 'DEBIT', 0, 983409, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.dailyPurchase / Icons.shopping_cart_rounded (0xf0171)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0003', 'Transportasi', 'EXPENSE', 'DEBIT', 0, 63155, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.transport / Icons.directions_car_rounded (0xf6b3)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0004', 'Tagihan', 'EXPENSE', 'DEBIT', 0, 983265, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.bill / Icons.receipt_long_rounded (0xf00e1)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0005', 'Hiburan', 'EXPENSE', 'DEBIT', 0, 63074, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.entertainment / Icons.confirmation_number_rounded (0xf662)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0006', 'Langganan', 'EXPENSE', 'DEBIT', 0, 983533, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.subscription / Icons.subscriptions_rounded (0xf01ed)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0007', 'Kesehatan', 'EXPENSE', 'DEBIT', 0, 63664, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.healthcare / Icons.medical_services_rounded (0xf8b0)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0008', 'Pendidikan', 'EXPENSE', 'DEBIT', 0, 983342, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.education / Icons.school_rounded (0xf012e)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0009', 'Donasi & Sosial', 'EXPENSE', 'DEBIT', 0, 983707, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.social / Icons.volunteer_activism_rounded (0xf029b)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0010', 'Pajak', 'EXPENSE', 'DEBIT', 0, 63405, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.tax / Icons.gavel_rounded (0xf7ad)
INSERT INTO accounts (code, name, type, normal_balance, is_liquid, icon_code, is_system) VALUES ('501.0011', 'Lain-lain', 'EXPENSE', 'DEBIT', 0, 63705, 1) ON CONFLICT(code) DO NOTHING; -- AccountPreset.otherExpense / Icons.more_horiz_rounded (0xf8d9)

-- =============================================================================
-- 6. NOTES & EXECUTION ORDER (from DbService._onCreate)
-- =============================================================================
-- DbService._onCreate (lib/core/database/db_service.dart:68-96) executes:
--   batch.execute(accountSchema)
--   batch.execute(appConfigurationSchema)
--   batch.execute(budgetPlanSchema)
--   batch.execute(budgetSchema)
--   batch.execute(journalEntrySchema)
--   batch.execute(journalLineSchema)
--   seedAppConfiguration(batch)            -- INSERT app_configurations
--   batch.execute(journalLineEntryIdx)
--   batch.execute(journalLineAccountIdIdx)
--   batch.execute(journalEntryStatusDateIdx)
--   batch.execute(accountBalanceViewDefinition)
--   batch.execute(budgetTrackerViewDefinition)
--   batch.execute(increaseAccountCounter)
--   batch.execute(decreaseAccountCounter)
--   await batch.commit()
--   await db.transaction((txn) async { await seedAccount(txn); })
--
-- To replicate in SQLite CLI: sqlite3 dompet.db < schema.sql
-- =============================================================================
