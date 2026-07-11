---
name: category_l10n_sv_purchase
description: "Categoría l10n_sv_purchase (3 módulos) — Purchase orders, EDI formats, receipt"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_purchase
  modules_count: 3
  python_files: 15
  xml_views: 9
  test_files: 0
  test_coverage: 0%
  dependencies: 12+ otros módulos
  risk_level: MEDIA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_purchase

**Status:** Domain Layer 2  
**Size:** Small (3 módulos)  
**Test coverage:** 0% — NO TESTS  

## Módulos (3)

### Core Purchase (2)
- `l10n_sv_purchase` — Base purchase module
- `l10n_sv_purchase_order` — PO management SV

### EDI & Receiving (1)
- `l10n_sv_purchase_receipt` — Goods receipt + EDI

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| purchase | CRÍTICA |
| account | ALTA |
| stock | ALTA |
| l10n_sv_edi | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **ZERO tests** (3/3 módulos untested)
- **Custom date handling** in reverse PO workflow (circular logic with account_move)
- **Raw SQL** (8 instances)

### 🟡 Media
- **Reverse PO logic** — Date forcing for AVCO (custom dates, 3 priorities, validation)
- **EDI format validation** — No tests

### 🟢 Leve
- None identified

## Test Coverage

**Actual:** 0 files

**MUST TEST:**
1. ✅ PO creation + submission
2. ✅ Receipt validation
3. ✅ Custom date handling (reverse PO)
4. ✅ EDI format generation
5. ✅ Circular dep (PO reverse ↔ account moves)

## Módulos Críticos

- `l10n_sv_purchase` — Core (0 tests)
- `l10n_sv_purchase_receipt` — Custom dates + AVCO (0 tests)

## Risk Assessment

**Failure scenarios:**
- PO mismatch with receipt
- Custom date causing AVCO distortion
- EDI format rejection
- Circular dep resolution failure

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Add PO tests | 1 día | Coverage |
| Migrate SQL → ORM | 4h | -8 queries |
| Document custom date logic | 2h | Knowledge |

## Roadmap

**FASE 1 (Week 1):** Tests on purchase + receipt  
**FASE 2 (Week 2):** Migrate SQL  
**FASE 3:** Verify PO reverse custom date interaction with account  

## Críticos para

- Purchase processing (order creation)
- Inventory receipt (stock updates)
- Custom date handling (AVCO protection)
- EDI transmission (vendor integration)

---

**Status:** Small, 0 tests. Custom date logic links to PO reverse features (v17.10).  
**Priority:** Add tests before production release.  
**Next review:** 2026-07-17 (tests implementation)
