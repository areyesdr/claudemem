---
name: changelog_modules
description: "Historial de cambios por categoría/módulo — qué se modificó, cuándo, por qué"
metadata: 
  node_type: memory
  type: reference
  version: 2026-07-11
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# 📋 CHANGELOG — Módulos Odoo 17

**Formato:** `YYYY-MM-DD | categoría | módulo | acción | descripción`

---

## 2026-07-10

### Análisis & Documentación (Sin cambios de código aún)

| Fecha | Categoría | Módulo | Acción | Descripción |
|-------|-----------|--------|--------|-------------|
| 2026-07-10 | l10n_sv_edi | (categoria) | ANALIZADO | 15 módulos, foundation layer, 6 tests |
| 2026-07-10 | l10n_sv_account | (categoria) | ANALIZADO | 58 módulos, hub central impuestos, 33 tests |
| 2026-07-10 | l10n_sv_hr | (categoria) | ANALIZADO | 21 módulos, payroll hub, 1 test — CRITICAL |
| 2026-07-10 | l10n_sv_stock | (categoria) | ANALIZADO | 25 módulos, valuación, circular deps, 2 tests |
| 2026-07-10 | l10n_sv_utils | (categoria) | ANALIZADO | 26 módulos, operating units (8 dup 200 LOC), 0 tests |
| 2026-07-10 | l10n_sv_sale | (categoria) | ANALIZADO | 15 módulos, CRM + sales, 1 test |
| 2026-07-10 | l10n_sv_purchase | (categoria) | ANALIZADO | 3 módulos, PO + custom dates, 0 tests |
| 2026-07-10 | l10n_sv_mrp | (categoria) | ANALIZADO | 3 módulos, MRP + BOM, 0 tests |
| 2026-07-10 | l10n_sv_point_of_sale | (categoria) | ANALIZADO | 4 módulos, POS, 0 tests |
| 2026-07-10 | l10n_sv_website | (categoria) | ANALIZADO | 2 módulos, website UI, 0 tests |
| 2026-07-10 | l10n_sv_school | (categoria) | ANALIZADO | 1 módulo, educación API, 0 tests |

### Deuda Técnica Identificada

| Fecha | Categoría | Módulo | Acción | Descripción |
|-------|-----------|--------|--------|-------------|
| 2026-07-10 | General | (multiple) | IDENTIFICADO | 7 módulos vacíos (stubs) — DELETE FASE 2 |
| 2026-07-10 | l10n_sv_account | (multiple) | IDENTIFICADO | 3 ciclos circulares en tax reporting |
| 2026-07-10 | General | (multiple) | IDENTIFICADO | 850 LOC duplicado (12% del árbol) |
| 2026-07-10 | General | (multiple) | IDENTIFICADO | 127 módulos sin tests (74%) |
| 2026-07-10 | l10n_sv_utils | (8 mods) | IDENTIFICADO | Operating units, 200+ LOC @api.model_create_multi dup |

### Plan de Acción

| Fecha | Categoría | Módulo | Acción | Descripción |
|-------|-----------|--------|--------|-------------|
| 2026-07-10 | General | (plan) | PROPUESTO | FASE 1 (Week 1): Tests críticos (l10n_sv_edi, l10n_sv_hr, l10n_sv_stock) |
| 2026-07-10 | General | (plan) | PROPUESTO | FASE 2 (Week 2): Delete stubs, consolidate checks, remove views |
| 2026-07-10 | General | (plan) | PROPUESTO | FASE 3 (Week 3-4): OperatingUnitMixin, break circular deps |
| 2026-07-10 | General | (plan) | PROPUESTO | FASE 4 (Month 2+): SQL → ORM migration (406 queries) |

---

## 2026-07-11

### Restructuración de Memoria

| Fecha | Categoría | Módulo | Acción | Descripción |
|-------|-----------|--------|--------|-------------|
| 2026-07-11 | Meta | DIARIO.md | CREADO | Diario de sesiones, control de cambios |
| 2026-07-11 | Meta | CHANGELOG.md | CREADO | Este archivo — historial por módulo |
| 2026-07-11 | Meta | DECISIONES.md | CREADO | Decisiones arquitectónicas y justificaciones |
| 2026-07-11 | Meta | TODO.md | CREADO | Próximos pasos con estado |
| 2026-07-11 | Meta | INDEX.md | ACTUALIZADO | Refocused en navegación histórica |
| 2026-07-11 | Meta | LANDING PAGE | CREADO | bootstrap con navbar, accordions, tables |

---

## Próximos cambios esperados

### FASE 1 (Week 1)

**l10n_sv_edi**
- [ ] Agregar tests MH integration
- [ ] Agregar tests invoice format validation
- [ ] Agregar tests digital signature

**l10n_sv_hr**
- [ ] Agregar tests payroll compute
- [ ] Agregar tests withholding validation
- [ ] Agregar tests bank export format

**l10n_sv_stock**
- [ ] Agregar tests valuation (AVCO, FIFO)
- [ ] Agregar tests landed costs
- [ ] Agregar tests date forcing (PO reverse)

### FASE 2 (Week 2)

**Deletions**
- [ ] sale_access_right — DELETE
- [ ] l10n_sv_edi_attachment_downloader — DELETE
- [ ] l10n_sv_pos_invoice — DELETE
- [ ] account_move_change_account — DELETE
- [ ] account_move_change_dates — DELETE
- [ ] pos_discount_validation — DELETE
- [ ] config_utils_for_sv — DELETE

**Consolidations**
- [ ] Check printing: 5 modules → 1 base + config
- [ ] Remove 390 empty inherited views
- [ ] Extract l10n_sv_helpers module

### FASE 3 (Week 3-4)

**Architecture Refactor**
- [ ] Extract OperatingUnitMixin
- [ ] Consolidate 8 operating_unit modules → 3 layers
- [ ] Break circular deps (tax reporting)
- [ ] Break circular deps (stock ↔ account)

### FASE 4 (Month 2+)

**SQL Migration**
- [ ] Audit 406 cr.execute() instances
- [ ] Migrate HIGH-RISK (account_move, stock) → ORM
- [ ] Migrate MEDIUM-RISK (payroll, sale) → ORM
- [ ] Migrate LOW-RISK → ORM

---

**Versión:** 1.0  
**Última actualización:** 2026-07-11  
**Próxima actualización:** Cuando se comience FASE 1
