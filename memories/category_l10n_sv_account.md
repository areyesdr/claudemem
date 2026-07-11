---
name: category_l10n_sv_account
description: "Categoría l10n_sv_account (58 módulos) — Accounting core, 26 variantes, reports, taxes, check printing"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_account
  modules_count: 58
  python_files: 225
  xml_views: 137
  test_files: 33
  test_coverage: 57%
  dependencies: 71+ otros módulos
  risk_level: CRÍTICA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_account

**Status:** Domain Hub Layer 1 — 71 módulos dependen  
**Size:** Largest category (58 módulos)  
**Test coverage:** 33 tests (57%) — BETTER but still gaps  

## Módulos Principales (58)

### Core Accounting (8)
- `l10n_sv_account` — Base accounting setup
- `account_analytic_accounts_sv` — Analytic accounts
- `l10n_sv_chart_template` — Chart of accounts
- [5 más]

### Tax & Fiscal Reporting (14) — HUB CENTRAL
- `reporte_impuestos_sv` (8 dependientes) — Tax aggregation, export
- `impuestos_sugeridos_sv` — Tax suggestions
- `valida_reporte_impuestos` — Validation
- `l10n_sv_mhreport` — Gov queries
- [10 más especialidades]

### Check Printing (5) — CONSOLIDATION CANDIDATE
- `l10n_sv_print_checks` (base)
- `l10n_sv_print_checks_agricola` (variant)
- `l10n_sv_print_checks_bac` (variant)
- `l10n_sv_print_checks_cuscatlan` (variant)
- `l10n_sv_print_checks_promerica` (variant)
- **Status:** 95% duplicated code, 5% config → Merge to 1 + bank table

### Reports (20+)
- `account_reports_sv` (26 tests — best)
- Specialized reports (tax, expense, balance, etc.)

### Utilities (11+)
- `account_move_change_account` (STUB, 0 Python)
- `account_move_change_dates` (minimal, 1 line)
- Helper modules

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| account | CRÍTICA |
| sale | ALTA |
| purchase | ALTA |
| stock | MEDIA |
| hr | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **2 módulos stub** (account_move_change_account, account_move_change_dates)
- **Tax reporting spider** (14 módulos interdependientes, tight coupling)
- **Circular deps** — reporte_impuestos ↔ impuestos_sugeridos ↔ valida
- **Empty inherited views** (15 casos)

### 🟡 Media
- **Check printing consolidation** — 5 módulos casi idénticos (79 LOC dup)
- **Raw SQL** — 85 instances en account_move_*
- **Wizard antipatterns** — 4 wizards con override vacío

### 🟢 Leve
- **Deprecated decorators** — 6 funciones @api.one

## Test Coverage Analysis

**Actual:** 33 files

**Well-tested:**
- ✅ account_reports_sv (26 tests)

**Gaps:**
- ❌ reporte_impuestos_sv (0 tests) — 8 dependientes
- ❌ Tax report spider logic
- ❌ Check printing validation
- ❌ Circular dep resolution

## Módulos Críticos (0 tests)

- `reporte_impuestos_sv` — Hub, 8 deps
- `impuestos_sugeridos_sv` — Core tax logic
- `l10n_sv_print_checks` — Payment compliance

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Delete 2 stub modules | 2h | Dead code |
| Consolidate check printing | 1 día | -79 LOC, -4 mods |
| Remove 15 empty views | 3h | Cleaner |
| Add tax reporting tests | 2 días | 8+ mods safer |
| Migrate SQL → ORM | 2 días | -85 queries |

## Roadmap

**FASE 1 (Week 1):** Tests reporte_impuestos_sv (hub)  
**FASE 2 (Week 2):** Delete stubs, consolidate checks, remove views  
**FASE 3 (Week 3-4):** Break circular deps (tax spider)  
**FASE 4 (Month 2):** Migrate SQL queries

## Críticos para

- Financial statements (reportes)
- Tax compliance (impuestos)
- Bank integration (checks)
- GL analysis (analytics)

---

**Status:** Large, complex hub. Changes ripple to 71+ dependientes.  
**Next review:** 2026-07-17 (tests implementation)
