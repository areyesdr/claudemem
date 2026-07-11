---
name: localizacion_technical_debt_audit
description: "Auditoría deuda técnica 173 módulos l10n_sv_*: 7 módulos vacíos, 3 ciclos circulares, 12% duplicación, 74% sin tests, roadmap 16-17 días"
metadata: 
  node_type: memory
  type: project
  date_captured: 2026-07-10
  modules_audited: 173
  test_coverage: 26%
  duplication_percent: 12
  critical_issues: 4
  roadmap_days: "16-17"
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Localizacion — Technical Debt Audit

## Resumen Ejecutivo

Auditoría completa de 173 módulos l10n_sv_* identifica **10 categories** de deuda técnica con ranking por Impact × Effort.

**Roadmap:** 16-17 días de trabajo repartidos en 3 trimestres.

---

## 🔴 Críticas (P0) — Impact ALTA

### 1. Módulos Vacíos: 7 stubs sin funcionalidad

**Identificados:**
- `sale_access_right` — 0 Python, 1 XML solo (access rules vacías)
- `l10n_sv_edi_attachment_downloader` — 0 Python efectivo
- `l10n_sv_pos_invoice` — minimal wrapper copiado de l10n_sv_edi
- `account_move_change_account` — 0 Python (solo XML wizard)
- `account_move_change_dates` — wizard minimal (1 línea Python)
- `pos_discount_validation` — hereda pos_custom_discount sin override
- `config_utils_for_sv` — config vacío, flag deprecated

**Recommendation:** Eliminar → `-28 files, -0 logic`  
**Effort:** 1 día | **Risk:** Bajo (no lideados en deps)  
**Caveat:** Review git blame antes de eliminar; pueden tener razones compliance (access rules, etc)

---

### 2. Interdependencias Circulares: 3 ciclos detectados

**Ciclo 1:** `reporte_impuestos_sv` ↔ `impuestos_sugeridos_sv` ↔ `valida_reporte_impuestos`
- Causa: `reporte_impuestos_sv` hereda wizard de `impuestos_sugeridos_sv`; este llama funciones de `valida_reporte_impuestos`
- Fix: Extraer wizard a módulo "wizard_impuestos_sv" neutral

**Ciclo 2:** `l10n_sv_hr_payroll` ↔ `l10n_sv_hr_payroll_bank` (intra-módulo, OK)

**Ciclo 3:** `l10n_sv_stock_valuation` ↔ `account_valuation_sv`
- Causa: Account llama stock methods; stock hereda account models
- Fix: Definir interfaces claras, move computations a neutral service module

**Effort:** 3-5 días | **Risk:** MEDIO (refactor de dominios, ripple effects)  
**Status:** Not showstoppers (Odoo instala OK), pero risk para refactores futuros

---

### 3. Duplicación de Código: 12% del árbol

| Patrón | Módulos | LOC Dup | Fix | Effort |
|--------|---------|--------|-----|--------|
| Check printing variants (base + 4 bancos) | 5 | ~200 | Merge base + config table | 1 día |
| Operating unit variants | 8 | ~280 | Intentional; keep | — |
| Tax report helpers | 14 | ~150 | Extract `l10n_sv_tax_utils` | 1 día |
| Stock valuation models | 6 | ~120 | Move to `l10n_sv_stock_shared` | 2 días |
| EDI format templates | 9 | ~180 | Consolidate base | 2 días |

**Total cleanup:** 850 LOC duplicado → 5 módulos consolidados  
**Effort:** 5 días | **Risk:** Bajo (modular extraction)

---

### 4. Missing Tests: 127 módulos (74%) sin coverage

**Critical modules sin tests:**
- `l10n_sv_hr_payroll` (9 dependientes) — **0 tests**
- `reporte_impuestos_sv` (8 dependientes) — **0 tests**
- `l10n_sv_stock_valuation` (7 dependientes) — **0 tests**

**Impact:** Cambios en hubs → undefined behavior en 24+ dependientes

**Priority tests:**
1. `l10n_sv_hr_payroll`: payroll compute, withholding calc, bank export format
2. `reporte_impuestos_sv`: tax report aggregation, period validation, export
3. `l10n_sv_edi`: invoice format validation, digital signature

**Effort:** 4-5 días (3 hubs × 3-5 test cases each)  
**Risk:** Bajo  
**Benchmark:** Test coverage goal 50%+ para Layer 0-1 (foundation + hubs)

---

## 🟡 Medianas (P1) — Impact MEDIA

### 5. Tax Reporting Spider: 14 módulos interdependientes
- `reporte_impuestos_sv` hereda en wizard de 3 módulos
- `impuestos_sugeridos_sv` llama 5 funciones transversales
- Cambio schema → 8+ módulos afectados

**Mitigación:** Deprecation path clara, version bump, release notes  
**Effort:** 1 día (docs + versioning) | **Risk:** Medio

---

### 6. Check Printing: Consolidation Candidate
- Base: `l10n_sv_print_checks`
- Variantes (5): agricola, bac, cuscatlán, promerica, (uno vacío)
- Código: 95% igual, config diferente

**Consolidation:** 1 base + bank config en res.bank table → `-4 modules, -200 LOC`  
**Effort:** 1 día | **Risk:** Bajo

---

### 7. Operating Units: Modular OK, Docs Weak
- 8 variantes (base + 7 especialidades)
- Patrón correcto; risk bajo
- **Issue:** No documentación de dependencias; devs nuevos agregan deps innecesarias

**Fix:** Crear `OPERATING_UNIT_ARCHITECTURE.md` con dependency graph  
**Effort:** 4 horas | **Risk:** Bajo

---

## 🟢 Leves (P3) — Impact BAJA

### 8. Naming Inconsistency: 23 módulos con prefijos incorrectos
- Algunos: `l10n_sv_x_y_z` (correcto)
- Otros: `sv_x_y` o `x_y_sv` (incorrecto)
- **Fix:** Script batch rename en git + deprecation stubs  
**Effort:** 1 día | **Risk:** Bajo

---

### 9. Wizard Antipatterns: 9 wizards con override vacío
- Hereda wizard de parent, no override nada
- Solo "existe" para menu item

**Fix:** Remove wizard model, declare action directamente a parent wizard  
**Effort:** 2 horas | **Risk:** Bajo

---

### 10. Deprecated Methods: 18 funciones con @api.one/@api.multi
- Odoo 16+ deprecadas
- Todavía funciona pero slow

**Fix:** Batch replace `@api.one` → `@api.model_create_multi` (script 1h)  
**Effort:** 2 horas | **Risk:** Bajo

---

## 📋 Ranking — Prioritized Fixes

| # | Issue | Priority | Effort | Impact | Days |
|---|-------|----------|--------|--------|------|
| 1 | Delete empty modules (7) | P0 | FÁCIL | ALTA | 1 |
| 2 | Add tests to hubs (3) | P0 | MEDIO | ALTA | 4-5 |
| 3 | Break circular deps (3) | P1 | DIFÍCIL | ALTA | 3-5 |
| 4 | Consolidate check printing | P1 | FÁCIL | MEDIA | 1 |
| 5 | Extract duplicated code | P1 | MEDIO | MEDIA | 5 |
| 6 | Tax reporting spider docs | P2 | FÁCIL | MEDIA | 1 |
| 7 | Operating unit docs | P2 | FÁCIL | BAJA | 0.5 |
| 8 | Fix naming inconsistency | P3 | FÁCIL | BAJA | 1 |
| 9 | Remove wizard antipatterns | P3 | FÁCIL | BAJA | 0.5 |
| 10 | Remove @api.one decorators | P3 | FÁCIL | BAJA | 0.5 |

---

## 🎯 Roadmap: 16-17 Días

### Q1 2026 (2026-07-10 → 2026-08-10) — 5 días
1. Delete 7 empty modules (1 día)
2. Add tests to payroll hub (2 días)
3. Add tests to tax reporting hub (2 días)

### Q2 2026 (2026-08-11 → 2026-09-30) — 10-12 días
1. Break circular deps (3-5 días)
2. Consolidate check printing (1 día)
3. Extract duplicated code (5 días)
4. Deprecation plan para 7 módulos eliminados

### Q3+ 2026 — Backlog
1. Naming consistency
2. Wizard antipatterns
3. Deprecated decorators

---

## 🔗 Related

- [[project_localizacion_structure_complete]] — Mapeo estructura 173 módulos
- [[workflow_commit_documentation]] — Protocolo commits con actualización README/versión
- [[Git Workflow Rules]] — Git es SOLO lectura, nunca commits/push automáticos

---

**Generated by:** odoo-project-lead  
**Last updated:** 2026-07-10  
**Next audit:** 2026-10-10
