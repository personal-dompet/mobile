# Dompet — Roadmap & Product Spec Mirror

> Versioned plan and product-decision mirror for the Dompet app.
> `DOCUMENT.md` (repo root) is the **unversioned** source of truth for product vision and decisions (kept gitignored by decision D2). All decisions made after this document exists are mirrored here so they are versioned.

---

## 1. Project Goal & Release Scope

**Goal:** Dompet is an offline-first personal finance app for Indonesian non-accountant users. A silent double-entry accounting engine (journal_entries / journal_lines) runs behind a simple wallet-based UX ("Dompet" = Account of type Asset). Principles: fast, lightweight, minimal onboarding friction, non-judgmental, Indonesian-first.

**Definition of DONE (user-confirmed):**
- Core app (dashboard, aktivitas, dompet/wallets, transfer, kategori, onboarding, accounting engine)
- Budget
- Plan Tracker (Target Keuangan)
- Reports
- **All well-tested**: unit tests for accounting engine/repositories + integration tests per flow.

**Deferred (post-release):** backup & sync, export/import, attachment, multi-currency.

**Explicitly out of scope:** Play Store release/packaging (user decision — no release to Play Store).

---

## 2. Verified Current State (2026-08-08, verified by reviewer + oracle agents)

| Area | Reality |
|---|---|
| Runtime `dompet.db` (repo root) | Tables: `accounts`, `app_configurations`, `journal_entries`, `journal_lines`; view: `account_balances`. **No budget tables.** |
| Budget schemas | `budget_plans` + `budget_periods` schemas exist in `lib/core/database/schemas/` but are **code-only**: `db_service.dart` executes only `budgetPlanSchema`; `budgetPeriodSchema` is never executed. Zero non-schema references — feature is greenfield. |
| View name | **Truth = `v_account_balances`** (live code, referenced by 3 repositories). Dev DB snapshot and all 3 agent docs say `account_balances` → three-way drift; freeze on the code name, regenerate the snapshot. |
| `TransactionType` | `enum TransactionType { income, expense }` only. Transfers = `JournalSource.transfer` + `TransferRepository`; adjustments = `JournalSource.adjustment`. |
| Feature stubs | `lib/features/budgets/pages/budget_page.dart` and `lib/features/savings/pages/saving_page.dart` are 12-line `Placeholder` pages. `savings/` has only `pages/`. |
| Tests | Only `integration_test/app_test.dart` (smoke). No `test/` dir. Test harness **broken**: `initDependency(dbTestPath:)` exists but is commented out; `DbService._testPath` commented out; integration test claims in-memory but hits the real app DB. |
| **Core gap** | **Edit Transaction Effective Balance NOT implemented** (DOCUMENT.md lists it under "Sudah Matang / Final" — false). Form only displays `assetBalance`; validation must use *Effective Balance* = balance after the old transaction is reversed. Silent wallet-balance corruption risk. |
| DB lifecycle | `db_service.dart` unconditionally deletes/recreates the app DB on every launch (dev hack). **KEPT by decision D1.** |
| Versioning | `.pi/`, `*.db`, `DOCUMENT.md` are gitignored. `ROADMAP.md` is versioned. |
| Environment | 16GB RAM → codegen via `/gen` only, **never** `build_runner --watch`. Windows host (flutter/dart are `.bat` shims). `query_db` tool is read-only. |

---

## 3. Decisions Log

| ID | Decision | Status |
|---|---|---|
| D1 | Keep the delete-on-launch DB reset behavior **for now** (no `RESET_DB` gate yet). **Revisit before Phase 3** — Reports needs multi-session data; the wipe makes manual budget/report development painful. | Decided 2026-08-08 |
| D2 | `DOCUMENT.md` stays gitignored. All product/spec decisions (incl. spec-lock gate outputs) are mirrored into this ROADMAP.md (versioned). | Decided 2026-08-08 |
| D3 | No Play Store packaging/release work. | Decided 2026-08-08 |
| D4 | Testing is mandatory: unit tests (accounting/repositories, real ffi in-memory SQLite — no mocked DBs for money math) + integration tests per flow. | Decided 2026-08-08 |
| D5 | Product semantics that are undecided (budget carry/rollover, target mechanics, reports scope) must be **spec-locked before implementation**. The writer agent stops and asks — it does not invent semantics. | Decided 2026-08-08 |

---

## 4. Working Agreements (enforced across all agents)

1. **Money correctness**: money = INTEGER minor units (IDR), never float. Every journal entry balances (SUM(debit) == SUM(credit)); no line with both sides > 0. Only `status='posted'` affects balances.
2. **Spec-lock before code**: any feature whose semantics are not decided (see §6 OPEN items) requires a decision recorded in this file first.
3. **Test-first evidence**: every task ships with unit + integration tests and a green `/check` (flutter analyze + flutter test) before phase sign-off.
4. **Post-write audit gate**: any change touching journals/balances/repositories → writer implements → `accounting-auditor` verifies ledger invariants + test coverage → main agent reviews. (Oracle RISK 7.)
5. **Verify against reality**: never trust agent docs or the dev DB snapshot for schema — cross-check `lib/core/database/schemas/`, `views.dart`, and `query_db` output; report divergence instead of assuming. `dompet.db` is a **frozen read-only snapshot**, not ground truth.
6. **View name is `v_account_balances`** (code truth); the snapshot is regenerated to match, not vice versa.
7. **Codegen**: run `/gen` (build_runner without `--watch`). **Never** `dart run build_runner watch`.
8. **UI strings are Indonesian**, plain language, non-technical (product tone per DOCUMENT.md).

---

## 5. Phases

> Ordering validated by oracle: test/harness foundation first (it is broken), then dependency-correct feature order (Reports needs budget data). Each feature phase opens with a **spec-lock gate**.

### Phase 0 — DB lifecycle & test harness repair + Core-Gap (BLOCKERs 1–2)

**Goal:** make the foundation honest: tests actually use a real isolated DB, the schema code matches what gets created, and the effective-balance correctness gap is closed.

| # | Task | Acceptance criteria |
|---|---|---|
| 0.1 | Wire the test DB path: honor `initDependency(dbTestPath:)` and `DbService` test path so tests use a real isolated DB (`sqflite_common_ffi` in-memory on host). | Unit tests run against in-memory ffi SQLite; no test touches the real app DB. Delete-on-launch behavior **unchanged** (D1). |
| 0.2 | `db_service.dart` `_onCreate`: execute `budgetPeriodSchema` (currently never created). | Fresh DB contains `budget_plans` + `budget_periods`. |
| 0.3 | Add `mocktail` + `clock` to dev_dependencies; `flutter pub get`; run `/gen` if models changed. | Deps resolve on Windows; `/check` still green. |
| 0.4 | Create `test/` harness + first unit tests: repository test harness (real ffi in-memory DB); balance-math tests (posted-only accounting, normal_balance signs: assets DEBIT-normal, income CREDIT-normal, etc.); port the integration smoke test to the isolated test path. | `flutter test` green; `flutter test integration_test` green without polluting real data. |
| 0.5 | **Core-Gap — Edit Transaction Effective Balance** per DOCUMENT.md: UI shows current balance, validation uses *Effective Balance* = balance after the old transaction is reversed. | Unit test proves reverse-then-validate math (edit that would overdraw is rejected on effective balance, accepted on naive current balance). |
| 0.6 | Freeze view name `v_account_balances` (no rename in code); regenerate repo-root `dompet.db` snapshot for schema parity (all tables incl. budget, view, seeds). | `query_db` shows same tables/columns as `schemas/` + `views/`; snapshot keeps seed data (accounts, app config, opening journal). |
| 0.7 | Phase verification. | `flutter analyze` clean; `flutter test` green; `flutter test integration_test` green; snapshot regenerated. |

**Phase 0 exit gate:** D1–D5 recorded above; harness proven by green tests; effective-balance fix shipped with test; snapshot in parity.

### Phase 1 — Budget (spec-lock gate first)

**Gate (OPEN items — need user decisions, mirrored here before code):**
- Carry/rollover semantics per `BudgetCarryPolicy` (unused budget: carry to next period? expire? zero-out?).
- Period timing (`BudgetFrequency`: weekly/monthly/…; period boundary = calendar or first-use?).
- Overrun UX (blocking, warning, badge?) and budget-vs-actual display language (Indonesian, non-technical).
- Whether multi-category transactions split budget usage proportionally or by primary category.

**Then:** schema (exists) → repository (CRUD + usage calc from journal_lines, posted-only) → cubit → form → page (Rencana area) → unit tests (repository budget-usage math incl. carry policy) + integration test (create budget → record expense → progress updates).

### Phase 2 — Plan Tracker / Target Keuangan (spec-lock gate first)

**Gate (OPEN items):**
- Internal mechanics per DOCUMENT.md: "internal implementation may use a special account, concept not shown to user" — decide: dedicated account per target? type/normal_balance? funding & withdrawal journal flows (e.g., transfer from wallet to target account).
- Progress calc: current balance vs target amount; percentage display; what happens on withdrawal (progress decreases? locked?).
- Whether targets link to a wallet or a category.

**Then:** repository → cubit → form → page (Rencana area) → unit + integration tests (fund → progress %, withdraw → balance math).

### Phase 3 — Reports (spec-lock gate first)

**Gate (OPEN items):**
- **Entry point**: DOCUMENT.md's bottom nav has NO Reports tab — decide placement (inside Menu? Beranda section? Rencana?).
- Date-window semantics (calendar month in local id timezone; this-month vs last-month; custom ranges?).
- Default content: monthly income/expense summary, spending by category, budget vs actual. What else (top categories, trend chart?) — common-sense defaults, adjustable.

**Precondition:** D1 must be revisited (multi-session data needed for meaningful reports) — dev seed fixture spanning ≥3 months.
**Then:** repository (aggregation SQL over journal_lines, posted-only, date-windowed) → UI → deterministic tests via `clock` (no wall-clock dependence) → integration test.

### Phase 4 — Test hardening & polish

Coverage gaps in core (dashboard repository, transfer/balance-adjustment math, category CRUD, archive semantics), edge cases (voided/draft entries never counted, empty states, Indonesian formatting), full `/check` green across `test/` + `integration_test/`. No Play Store work (D3).

---

## 6. Product Spec Mirror (versioned decisions)

Source of truth for semantics decided **after** ROADMAP creation. `DOCUMENT.md` remains the unversioned master for the stable product vision.

### Feature status
| Feature | DOCUMENT.md status | Code reality (2026-08-08) | Versioned decisions here? |
|---|---|---|---|
| Dashboard / Total Uang | Final | Implemented | — |
| Aktivitas (list/filter/detail) | Final | Implemented | — |
| Dompet management (grid/detail/archive/sort) | Final | Implemented | — |
| Transfer | Final | Implemented | — |
| Balance adjustment | Final | Implemented | — |
| Edit transaction validation | Final | **NOT implemented** (Core-Gap, Phase 0.5) | — |
| Budget Kategori | Belum dibahas | Stub page; schemas code-only | Gate in Phase 1 → decisions land here |
| Target Keuangan | Belum dibahas | Stub page | Gate in Phase 2 → decisions land here |
| Laporan & Analytics | Belum dibahas | Nothing | Gate in Phase 3 → decisions land here |
| Tagihan berulang, Backup & sync, Export/Import, Attachment, Multi-currency | Belum dibahas | Nothing | Deferred (post-release) |

### OPEN spec-lock questions (record answers here as they are decided)
1. **Budget**: carry policy, period timing, overrun UX, multi-category usage split. *(Phase 1 gate)*
2. **Plan Tracker**: internal account mechanics, funding/withdrawal journal flows, progress calc behavior on withdrawal. *(Phase 2 gate)*
3. **Reports**: entry point (no Reports tab exists in nav), date-window semantics, content defaults. *(Phase 3 gate)*
4. **D1 revisit**: DB reset policy before Phase 3.

---

## 7. Agent Operating Model (.pi/agents — Plan B)

| Agent | Role | Key corrections applied |
|---|---|---|
| `accounting-bookkeeper` | Writer (single writer thread) | `TransactionType` = income/expense (transfer/adjustment via `JournalSource`); release scope = Budget/Plan Tracker/Reports; **mandatory** unit + integration tests per change; spec-lock rule: stop and ask, never invent semantics; verify-against-reality; view name `v_account_balances`. |
| `accounting-analyst` | Read-only data analyst | Budget tables are **code-only** — run `sqlite_master` existence check, report "table not found" instead of inventing data; `dompet.db` = frozen snapshot, not schema truth; view name `v_account_balances`; DOCUMENT.md terminology, Indonesian plain-language output. |
| `accounting-auditor` | Read-only ledger/code auditor | Add test-coverage checklist item; DB-vs-code schema drift check; Indonesian terminology; runs the **post-write audit gate** (Working Agreement 4). |

Process: main agent → (worker/bookkeeper) implements → auditor verifies → main agent reviews. All three agents share the Working Agreements in §4.
