---
name: category_l10n_sv_sale
description: "Categoría l10n_sv_sale (15 módulos) — Sales, CRM, discounts, reverse orders, EDI integration"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_sale
  modules_count: 15
  python_files: 30
  xml_views: 13
  test_files: 1
  test_coverage: 7%
  dependencies: 21+ otros módulos
  risk_level: MEDIA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_sale

**Status:** Domain Layer 2  
**Core function:** Sales management + CRM  
**Test coverage:** 1 file (7%) — INSUFFICIENT  

## Módulos (15)

### Core Sales (5)
- `l10n_sv_sale` — Base sales module
- `l10n_sv_sale_order` — Sales order SV
- `l10n_sv_sale_advance` — Advance payments
- `l10n_sv_sale_return` — Return orders
- `l10n_sv_sale_quote` — Quotation management

### CRM & Customers (4)
- `l10n_sv_crm` — CRM integration
- `l10n_sv_crm_lead` — Lead management
- `l10n_sv_crm_opportunity` — Opportunity tracking
- `l10n_sv_partner_contact` — Contact mgmt

### Discount & Special (3)
- `l10n_sv_sale_discount` — Discount validation
- `l10n_sv_sale_promotion` — Promotions
- `l10n_sv_sale_tips` — Tip management

### EDI & Reporting (3)
- `l10n_sv_sale_edi` — EDI integration
- `l10n_sv_sale_reports` — Sales reports
- `l10n_sv_sale_analysis` — Analysis

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| sale | CRÍTICA |
| account | ALTA |
| stock | ALTA |
| crm | MEDIA |
| l10n_sv_edi | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **0 tests** on core sales module
- **Discount validation** — No tests, manual SQL (25 instances)
- **Reverse order logic** — Circular with account_move logic

### 🟡 Media
- **Duplicated domain builders** — Search domains repeated (40 LOC dup)
- **Empty views** (5 inherited, no xpath)
- **Wizard antipatterns** (2 wizards)

### 🟢 Leve
- **Deprecated decorators** (1 @api.one)

## Test Coverage

**Actual:** 1 file (insufficient)

**MUST TEST:**
1. ✅ Sales order creation
2. ✅ Discount validation (business rules)
3. ❌ Reverse order workflow
4. ❌ EDI transmission
5. ❌ Return processing

## Módulos Críticos (0 tests)

- `l10n_sv_sale` — Core module
- `l10n_sv_sale_discount` — Business logic
- `l10n_sv_sale_edi` — External integration

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Add sales tests | 1 día | Coverage |
| Migrate SQL → ORM | 1 día | -25 queries |
| Remove empty views (5) | 2h | Cleaner |
| Extract domain builders | 4h | -40 LOC dup |

## Roadmap

**FASE 1 (Week 1):** Tests on sales core + discount  
**FASE 2 (Week 2):** Remove empty views, migrate SQL  
**FASE 3 (Week 3-4):** Resolve reverse order circular deps  
**FASE 4 (Month 2):** Documentation

## Críticos para

- Sales processing (order creation)
- Discount enforcement (business logic)
- EDI transmission (gov compliance)
- Reporting (analytics)

---

**Status:** Medium priority. Low test coverage but operational.  
**Next review:** 2026-07-17 (tests implementation)
