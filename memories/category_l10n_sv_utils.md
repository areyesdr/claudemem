---
name: category_l10n_sv_utils
description: "Categoría l10n_sv_utils (26 módulos) — Infraestructura, operating units, shared utilities"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_utils
  modules_count: 26
  python_files: 110
  xml_views: 74
  test_files: 2
  test_coverage: 8%
  dependencies: 26+ otros módulos
  risk_level: MEDIA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_utils

**Status:** Foundation + Infrastructure Layer  
**Core function:** Operating units, multi-tenancy, shared helpers  
**Test coverage:** 2 files (8%) — CRITICAL for multi-tenancy  

## Módulos (26)

### Operating Unit Suite (8) — CONSOLIDATION CANDIDATE
- `l10n_sv_operating_unit` (base)
- `l10n_sv_operating_unit_account` (hereda base)
- `l10n_sv_operating_unit_stock` (hereda base)
- `l10n_sv_operating_unit_purchase` (hereda base)
- `l10n_sv_operating_unit_sale` (hereda base)
- `l10n_sv_operating_unit_analytic` (hereda base)
- `l10n_sv_operating_unit_product_variants` (hereda base)
- `l10n_sv_operating_unit_partner` (hereda base)
- **Status:** 200+ LOC duplicated `_get_operating_unit_domain()`, mixin-based consolidation needed

### Utilities & Helpers (10)
- `l10n_sv_helpers` — Common functions
- `l10n_sv_formatters` — Formatters (payment, tax, invoice)
- `l10n_sv_validators` — Validators
- `l10n_sv_constants` — Shared constants
- `l10n_sv_cron_utils` — Cron job helpers
- `l10n_sv_export_utils` — Export utilities
- `l10n_sv_api_utils` — API wrappers
- `l10n_sv_report_utils` — Report helpers
- `l10n_sv_cache_utils` — Caching
- `l10n_sv_batch_utils` — Batch operations

### Company & Access (5)
- `l10n_sv_company` — Company setup SV
- `l10n_sv_partner` — Partner data SV
- `l10n_sv_access_rules` — Access control
- `l10n_sv_ir_rule` — Access rules
- `l10n_sv_security` — Security policies

### Configuration (3)
- `l10n_sv_config` — Settings
- `l10n_sv_settings_company` — Company settings
- `l10n_sv_settings_user` — User settings

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| base | CRÍTICA |
| account | ALTA |
| sale | ALTA |
| stock | ALTA |
| purchase | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **Operating unit duplication** — 200+ LOC `_get_operating_unit_domain()` en 8 módulos
  - Fix: Extract `OperatingUnitMixin` + consolidate a 3 layers (base, domain-specific, config)
- **ZERO tests** on multi-tenancy framework (data leakage risk)
- **Access rule complexity** — Manual domain building error-prone

### 🟡 Media
- **Duplicated helpers** — 150+ LOC formatters, validators spread across modules
- **Raw SQL** — 25+ instances en access rule queries
- **Empty modules** — `config_utils_for_sv` (deprecated flag)

### 🟢 Leve
- **Naming inconsistency** — sv_* vs l10n_sv_* prefixes

## Test Coverage

**Actual:** 2 files (EMERGENCY for multi-tenancy)

**MUST TEST:**
1. ✅ Operating unit domain isolation
2. ✅ Company filtering in searches
3. ✅ Access rule enforcement
4. ❌ Multi-company transactions
5. ❌ Cross-OU security breach scenarios

## Módulos Críticos (0 tests)

- `l10n_sv_operating_unit` — Multi-tenancy framework
- `l10n_sv_access_rules` — Access control enforcement
- `l10n_sv_operating_unit_account` — Financial isolation

## Risk Assessment

**Failure scenarios:**
- Data leakage between companies
- OU isolation bypass
- Access rule bypass → unauthorized data access
- Duplicated domain logic → inconsistent filtering

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Extract OperatingUnitMixin | 1 día | -200 LOC dup |
| Extract helpers module | 1 día | -150 LOC dup |
| Remove stubs | 2h | Cleaner |
| Add multi-tenancy tests | 2 días | Data security |

## Roadmap

**FASE 1 (Week 1):** Tests on operating_unit + access_rules  
**FASE 2 (Week 2):** Extract OperatingUnitMixin, helpers consolidation  
**FASE 3 (Week 3-4):** Refactor 8 OU modules → 3 layers  
**FASE 4 (Month 2):** Migrate SQL queries, document architecture

## Críticos para

- Multi-company isolation (security)
- Access control (permissions)
- Data integrity (cross-OU)
- Configuration management (settings)

---

**Status:** Infrastructure hub with multi-tenancy risk (0 tests). Consolidation needed.  
**PRIORITY:** Tests + OperatingUnitMixin extraction.  
**Next review:** 2026-07-17 (tests implementation)
