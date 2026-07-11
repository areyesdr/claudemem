---
name: category_l10n_sv_stock
description: "Categoría l10n_sv_stock (25 módulos) — Inventario, valuación AVCO/FIFO, landed costs, análisis"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_stock
  modules_count: 25
  python_files: 73
  xml_views: 37
  test_files: 2
  test_coverage: 8%
  dependencies: 28+ otros módulos
  risk_level: ALTA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_stock

**Status:** Operational Layer 2  
**Core function:** Inventory management + costing  
**Test coverage:** 2 files (8%) — INSUFFICIENT  

## Módulos (25)

### Inventory Core (5)
- `l10n_sv_stock` — Base inventory setup
- `l10n_sv_stock_move` — Stock movement
- `l10n_sv_stock_picking` — Picking management
- `l10n_sv_stock_location` — Location hierarchy
- `l10n_sv_stock_warehouse` — Warehouse config

### Valuation (6) — HUB-LIKE (circular deps)
- `l10n_sv_stock_valuation` (7 deps) — Valuation method
- `l10n_sv_stock_valuation_avco` — AVCO method
- `l10n_sv_stock_valuation_fifo` — FIFO method
- `l10n_sv_stock_valuation_lifo` — LIFO method
- `l10n_sv_stock_valuation_layer` — Cost layers
- `account_valuation_sv` — GL integration (circular with stock)

### Landed Costs (4)
- `l10n_sv_stock_landed_costs` — Landed cost base
- `l10n_sv_stock_landed_costs_customs` — Customs duties
- `l10n_sv_stock_landed_costs_freight` — Freight charges
- `l10n_sv_stock_landed_costs_insurance` — Insurance

### Analysis & Reports (7)
- `l10n_sv_stock_analysis` — Stock analysis
- `l10n_sv_stock_inventory_count` — Inventory counting
- `l10n_sv_stock_obsolescence` — Old stock detection
- `l10n_sv_stock_aging` — Product aging
- `l10n_sv_stock_forecasting` — Demand forecast
- `l10n_sv_stock_reorder` — Reorder point
- `l10n_sv_stock_rotation` — FIFO enforcement

### Utilities (3)
- `l10n_sv_stock_transfer` — Inter-warehouse transfer
- `l10n_sv_stock_barcode` — Barcode scanning
- `l10n_sv_stock_utils` — Helper functions

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| stock | CRÍTICA |
| account | CRÍTICA (valuation) |
| purchase | ALTA |
| sale | ALTA |
| product | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **Circular deps** — l10n_sv_stock_valuation ↔ account_valuation_sv
- **AVCO consistency** — Manual date forcing, no validation
- **Raw SQL** — 60+ instances en valuación/costing
- **Empty view** — 8 inherited views

### 🟡 Media
- **Duplicated valuation logic** — 120 LOC dup across AVCO/FIFO/LIFO
- **No tests** on valuation methods (8% coverage insufficient)
- **Circular date forcing** — PO reverse + inventory cost management dual overrides

### 🟢 Leve
- **Naming inconsistency** — sv_stock_* vs l10n_sv_stock_*

## Test Coverage

**Actual:** 2 files (insufficient for financial impact)

**MUST TEST:**
1. ✅ Valuation method accuracy (AVCO, FIFO)
2. ✅ Landed cost allocation
3. ❌ Date forcing (custom dates for AVCO protection)
4. ❌ GL integration (account moves creation)
5. ❌ Circular dep resolution

## Módulos Críticos (0 tests)

- `l10n_sv_stock_valuation` — Valuation hub
- `l10n_sv_stock_valuation_avco` — Primary method
- `account_valuation_sv` — GL integration

## Risk Assessment

**Failure scenarios:**
- Wrong valuation → inventory/GL mismatch
- Date forcing failure → AVCO distortion
- Landed cost miscalculation → cost margin errors
- GL entries wrong → financial statements incorrect

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Extract valuation utils | 1 día | -120 LOC dup |
| Add valuation tests | 2 días | Consistency |
| Migrate SQL → ORM | 1 día | -60 queries |
| Remove empty views (8) | 2h | Cleaner |

## Roadmap

**FASE 1 (Week 1):** Tests on valuation hub + AVCO  
**FASE 2 (Week 2):** Consolidate AVCO/FIFO/LIFO logic  
**FASE 3 (Week 3-4):** Break circular deps with GL  
**FASE 4 (Month 2):** Migrate SQL queries

## Críticos para

- Inventory valuation (financial accuracy)
- AVCO consistency (custom dates)
- GL reconciliation (accounting)
- Cost reporting (margins)

---

**Status:** Operational hub with circular deps. Risk: financial data corruption.  
**Next review:** 2026-07-17 (tests implementation)
