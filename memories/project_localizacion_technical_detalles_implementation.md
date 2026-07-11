---
name: localizacion_technical_detalles_implementation
description: "Detalles técnicos implementación: antipatrones Odoo detectados, quick wins ROI alto, plan 4-fases refactoring, módulos críticos 0-tests"
metadata: 
  node_type: memory
  type: project
  date_captured: 2026-07-10
  antipatterns: 4
  quick_wins: 4
  critical_modules_zero_tests: 5
  phases: 4
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Localizacion — Technical Details & Implementation Plan

## 🔍 Antipatrones Odoo Detectados

### A. Empty Inheritance (AccountJournal Pattern)
**Patrón:** Hereda sin agregar lógica real, solo `selection_add`
```python
class AccountJournal(models.Model):
    _inherit = 'account.journal'
    # 0 campos, 0 métodos, solo decoración
```
**Problema:** Overhead herencia sin beneficio  
**Solución:** Composición + helpers en lugar de `_inherit`  
**Módulos:** 23+ minimal modules  

### B. Vistas Heredadas Vacías (390 casos)
**Patrón:** `inherit_id` sin `xpath` = redundante
```xml
<record model="ir.ui.view" id="view_account_move_form_inherited">
    <field name="inherit_id" ref="account.view_move_form"/>
    <!-- No xpath, no changes = empty inheritance -->
</record>
```
**Problema:** Overhead sin cambios visuales  
**Solución:** Remover herencia, explícito `depends` en `__manifest__.py`  
**Impacto:** `-300 LOC, -overhead`

### C. SQL Reinvention (406 cr.execute() instances)
**Patrón:** Manual query building vs ORM
```python
# ❌ ANTIPATTERN
cr.execute("SELECT id FROM account_move WHERE state = %s", ['posted'])
for row in cr.fetchall():
    cr.execute("UPDATE ... WHERE id = %s", [row[0]])

# ✅ PATTERN
moves = self.search([('state', '=', 'posted')])
moves.write({'field': value})
```
**Problema:** SQL injection risk, DB incompatibility, difícil testing  
**Instancias:** 406 total
- **HIGH RISK:** account_move_* (85), stock_* (60), payment_* (45)
- **MEDIUM:** hr_payroll_* (30), sale_* (25)

### D. Module Naming Inconsistency
**Patrón:** Prefijos unclear
- l10n_sv_check_printing (¿base o variant?)
- l10n_sv_operating_unit_account (naming unclear)
- sv_* o *_sv (incorrect)

**Solución:** Estandarizar `l10n_sv_*` + subsystem prefix  

---

## ⚡ Quick Wins (ROI Alto)

| # | Tarea | Esfuerzo | Impacto | Risk |
|---|-------|----------|--------|------|
| 1 | DELETE 5 stub modules | 1h | Dead code eliminated | Bajo |
| 2 | CONSOLIDATE check_printing (5→1) | 4h | -79 LOC duplicado | Bajo |
| 3 | REMOVE empty views (390) | 6h | -300 LOC, cleaner | Bajo |
| 4 | CREATE shared_helpers module | 3h | Deduplication foundation | Bajo |

**Total esfuerzo:** 14 horas ≈ 2 días  
**Impacto:** Immediate cleanup, foundation para Phase 2+

---

## 🔴 Módulos Críticos (0 tests, High-Risk)

### CRÍTICA — Compliance/Gov Integration
```
l10n_sv_edi/*          — Facturación electrónica, integración gobierno
  Coverage: 6 tests (insufficient)
  Risk: Gov rejection, invoice void
  Dependencies: 38+ módulos

l10n_sv_account/*      — Accounting core, 26+ variantes
  Coverage: 33 tests (insufficient)
  Risk: Financial statement misstatement
  Dependencies: 71+ módulos

l10n_sv_hr/*           — Payroll, deducción legal
  Coverage: 1 test (CRITICAL)
  Risk: Employee legal protection violations
  Dependencies: 21+ módulos

check_printing_*       — Formato banco (compliance)
  Coverage: 0 tests
  Risk: Payment rejection, fraud flags
  Modules affected: 5
```

### ALTA — Operacional
```
l10n_sv_stock/*        — FIFO/AVCO, landed cost
  Coverage: 2 tests
  Risk: Inventory value misstatement
  Modules affected: 25+

l10n_sv_sale/*         — Discount, reverse, EDI
  Coverage: 1 test
  Risk: Revenue recognition errors
  Modules affected: 15+

l10n_sv_utils/*        — Core helpers, auth
  Coverage: 2 tests
  Risk: Multi-tenancy isolation breach
  Modules affected: 26+

operating_unit_*       — Multi-tenancy framework
  Coverage: 0 tests
  Risk: Data leakage between companies
  Modules affected: 8+
```

---

## 📊 Métricas Detalladas

### Distribución por Tamaño
```
Total: 173 módulos
  Stub (0 Python):       5 (3%)          ← DELETE
  Minimal (1-4 files):  23+ (13%)        ← CONSOLIDATE
  Medium (50-300 LOC):  ~80 (46%)        ← REFACTOR
  Large (>300 LOC):     ~65 (38%)        ← MAINTAIN

Duplication:           ~900 LOC
  Check printing:      79 LOC (5 modules)
  Operating unit:      200 LOC (8 modules)
  Tax helpers:         150 LOC (14 modules)
  Stock valuation:     120 LOC (6 modules)
  EDI templates:       180 LOC (9 modules)

Test Coverage:         8% (14/173 modules)
  Target: 50%+ for Layer 0-1

Raw SQL instances:     406 (ANTIPATTERN)
  HIGH-RISK: 190/406
  MEDIUM: 100/406
  LOW: 116/406

Empty view inherit:    390 (REDUNDANT)
  Removable: ~250
  Some critical: ~140

Internal deps:         0 in 159 modules (96% = excellent modularity)
  159 módulos: zero interdependencies
  7 hub modules: 38 dependientes
  7 circular dependencies: [datos anteriores]
```

---

## 🎯 Plan 4-Fases Refactoring

### FASE 1 — Tests Foundation (Week 1)
**Goal:** Stabilize critical paths

**Tareas:**
- [ ] Crear test suite l10n_sv_edi: invoice format, digital signature, gov export
- [ ] Crear test suite operating_unit: domain building, multi-tenancy isolation
- [ ] Crear test suite check_printing: bank format validation, payment compliance
- [ ] Integration tests: edi → account → bank export flow

**Effort:** 5 días  
**Modules touched:** 3 + 10 dependientes  
**Success metric:** Coverage ≥ 20% on these modules

---

### FASE 2 — Low-Risk Cleanup (Week 2)
**Goal:** Remove dead code, establish shared helpers

**Tareas:**
- [ ] DELETE 5 stub modules: l10n_sv_pos_invoice, sale_access_right, etc.
  - Review git blame para compliance reasons
  - Create deprecation stubs si necesario
  
- [ ] REMOVE 390 empty inherited views
  - Audit: cuáles son críticas para backward compat
  - Remove: ~250 redundant
  - Keep: ~140 con comentario "critical for backward compat"
  
- [ ] CONSOLIDATE check_printing: 5 módulos → 1 base + config
  - Extract fields: `print_format`, `bank_account_digits`, `page_breaks`, etc.
  - Move a `res.partner.bank` config table
  
- [ ] CREATE `l10n_sv_helpers` module
  - Move common domain builders (from operating_unit, account, stock)
  - Move common formatters (payment, tax, invoice)
  - Establece foundation para deduplication

**Effort:** 2 días  
**Impact:** -400 LOC, -4 modules, cleaner codebase  
**Success metric:** No functionality changed, all tests pass

---

### FASE 3 — Operating Unit Consolidation (Week 3-4)
**Goal:** Extract mixin, consolidate 8 → 1 architecture

**Tareas:**
- [ ] Extract `OperatingUnitMixin`
  - Common methods: `_get_operating_unit_domain()`, `_force_company_id()`
  - Move 200+ LOC duplicated code
  
- [ ] Refactor 8 operating_unit_* modules
  - operating_unit (base)
  - operating_unit_account (hereda base, adds mixin a `account.move`)
  - operating_unit_stock (hereda base, adds mixin a `stock.move`)
  - [etc. para sale, purchase, analytic, product_variants]
  
- [ ] Consolidation result: 8 modules → 3 layers
  - Layer 1: base + mixin
  - Layer 2: domain-specific models (account, stock, sale)
  - Layer 3: config + feature flags
  
- [ ] Testing: Add integration tests for multi-company isolation

**Effort:** 3-5 días  
**Risk:** MEDIUM (refactor architecture, ripple effects)  
**Success metric:** 0 duplicated domain-building code, tests pass

---

### FASE 4 — SQL Audit & Gradual Migration (Month 2+)
**Goal:** Reduce raw SQL to <50 instances

**Tareas (Phased):**
- [ ] Audit 406 cr.execute() instances
  - Categorize: HIGH-RISK (190), MEDIUM (100), LOW (116)
  - Document: why SQL needed, what ORM replacement would look like
  
- [ ] HIGH-RISK migration (account_move_*, stock_*)
  - account_move_*: bulk operations, date forcing, state changes
  - stock_*: picking validation, cost computation, location updates
  - Effort: 5-7 días
  
- [ ] MEDIUM-RISK migration (hr_payroll_*, sale_*)
  - hr_payroll: salary computation, withholding calc
  - sale: discount validation, reverse order cleanup
  - Effort: 3-5 días
  
- [ ] LOW-RISK migration + cleanup
  - Effort: 2-3 días

**Total Phase 4:** 10-15 días  
**Success metric:** Raw SQL instances < 50, all queries via ORM with ORM tests

---

## 🔗 Integración con Memoria Existente

**Relacionado:**
- [[project_localizacion_structure_complete]] — Mapeo estructura base
- [[project_localizacion_technical_debt_audit]] — Resumen deuda técnica
- [[workflow_commit_documentation]] — Protocolo commits con docs
- [[Git Workflow Rules]] — Git es SOLO lectura

**Síguiente sesión:**
- Comenzar FASE 1 con l10n_sv_edi tests
- Preparar PR con FASE 2 quick wins
- Comunicar roadmap a equipo técnico

---

**Generated by:** odoo-project-lead (iteración 2)  
**Last updated:** 2026-07-10  
**Next review:** 2026-07-24 (2 semanas, al terminar FASE 1)
