---
name: category_l10n_sv_edi
description: "Categoría l10n_sv_edi (15 módulos) — Facturación electrónica, integración gobierno, base de todas las capas"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_edi
  modules_count: 15
  python_files: 87
  xml_views: 52
  test_files: 6
  test_coverage: 40%
  dependencies: 38+ otros módulos
  risk_level: CRÍTICA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_edi

**Status:** Foundation Layer (Layer 0) — 38 módulos dependen  
**Compliance:** Gobierno El Salvador (DTE)  
**Test coverage:** 6 tests (40%) — INSUFFICIENT  

## Módulos (15)

### Core
- `l10n_sv` — Base localization, company config
- `l10n_sv_dpto` — Departments/regions
- `l10n_sv_edi` — EDI framework + invoice format
- `l10n_sv_edi_format_sv` — El Salvador DTE format

### Integración
- `l10n_sv_mhreport` — Ministerio Hacienda query + reports
- `l10n_sv_edi_attachment_downloader` — Download MH attachments (STUB, 0 Python)

### Utilidades
- `l10n_sv_edi_invoice_wizard` — Bulk invoice EDI generation
- `l10n_sv_edi_payment_wizard` — Payment format wizard
- `l10n_sv_edi_cancel_invoice` — Invoice cancellation flow
- [5 más especializados]

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| account | CRÍTICA (invoice creation) |
| sale | ALTA (sales document origin) |
| purchase | ALTA (purchase document origin) |
| stock | MEDIA (goods movement) |
| mail | MEDIA (transmission) |

## Deuda Técnica Detectada

### 🔴 Crítica
- **0 tests en MH integration** — Gobierno rejection = production issue
- **SQL raw queries** en l10n_sv_mhreport (8 instances)
- **Empty inherited views** (7 en l10n_sv_edi)

### 🟡 Media
- **Wizard antipattern** — l10n_sv_edi_invoice_wizard hereda sin override
- **Duplicated format logic** — EDI format templates (180 LOC duplicado en 9 módulos)

### 🟢 Leve
- **Deprecated decorators** — 3 funciones con @api.one

## Test Coverage

**Actual:** 6 files (insufficient for compliance)

**Priority tests:**
1. ✅ Invoice format validation (DTE schema)
2. ✅ Digital signature process
3. ✅ MH government export format
4. ❌ Invoice cancellation flow
5. ❌ Payment format generation
6. ❌ Error handling + retries

## Módulos Críticos (0 tests)

- `l10n_sv_mhreport` — Gov integration
- `l10n_sv_edi_format_sv` — Core format
- `l10n_sv_edi_payment_wizard` — Payment compliance

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Add MH integration tests | 1 día | Gov compliance |
| Consolidate EDI templates | 2h | -180 LOC |
| Remove empty views (7) | 2h | Cleaner |
| Migrate SQL → ORM | 1 día | Safer, testable |

## Roadmap

**FASE 1 (Week 1):** Add tests to l10n_sv_edi + l10n_sv_mhreport  
**FASE 2 (Week 2):** Consolidate format templates + remove stubs  
**FASE 4 (Month 2):** Migrate raw SQL to ORM

## Relaciones

- **Hereda:** base_sv, l10n_sv
- **Heredado por:** 38+ módulos (account, sale, stock, hr, etc.)
- **Crítico para:** Facturación electrónica, cumplimiento fiscal

---

**Status:** Foundation. High risk for changes without tests.  
**Next review:** 2026-07-17 (tests implementation)
