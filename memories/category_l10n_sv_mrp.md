---
name: category_l10n_sv_mrp
description: "Categoría l10n_sv_mrp (3 módulos) — Manufacturing, BOM, costing"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_mrp
  modules_count: 3
  python_files: 7
  xml_views: 3
  test_files: 0
  test_coverage: 0%
  dependencies: 11+ otros módulos
  risk_level: BAJA-MEDIA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_mrp

**Status:** Domain Layer 2 — Small  
**Size:** Minimal (3 módulos)  
**Test coverage:** 0% — NO TESTS  

## Módulos (3)

- `l10n_sv_mrp` — Base manufacturing SV
- `l10n_sv_mrp_bom` — BOM management
- `l10n_sv_mrp_costing` — Cost calculation (BOM costing)

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| mrp | CRÍTICA |
| stock | ALTA |
| account | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **ZERO tests** (3/3 untested)

### 🟡 Media
- **BOM costing logic** — Manual calculation, no validation
- **Minimal Python** (7 files total, mostly views)

### 🟢 Leve
- Simple structure

## Test Coverage

**Actual:** 0 files

**MUST TEST:**
1. ✅ BOM creation + validation
2. ✅ Cost calculation accuracy
3. ✅ Routing integration

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Add MRP tests | 1 día | Coverage |

## Roadmap

**FASE 1:** Add basic tests  
**FASE 2:** Validate costing logic  

## Críticos para

- Manufacturing orders (production)
- BOM costing (financial accuracy)
- Routing (production planning)

---

**Status:** Small, low complexity. Add tests before production.  
**Priority:** LOW (low code volume, standalone module).  
**Next review:** 2026-08-01 (after critical modules)
