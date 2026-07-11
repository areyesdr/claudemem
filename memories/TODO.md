---
name: todo_project
description: Lista de tareas pendientes por FASE — con estado de avance
metadata: 
  node_type: memory
  type: reference
  version: 2026-07-11
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# 📝 TODO — Roadmap FASE 1-4

**Proyecto:** Odoo 17 Localizacion — 173 módulos  
**Estado general:** 🔄 Planificación → Implementación  
**Estimado total:** 16-17 días

---

## 📌 FASE 1 — TESTS CRÍTICOS (Semana 1, 5 días)

**Objetivo:** Agregar tests en hubs críticos para mitigar riesgo legal/compliance  
**Prioridad:** 🔴 CRÍTICA  
**Dependencias:** Ninguna  
**Riesgo:** BAJO (tests no cambian código existente)

### l10n_sv_edi (15 módulos, 6/15 tests)

**Contexto:** Facturación electrónica, cumplimiento gubernamental

#### MH (Manual Handling) Integration Tests
- [ ] Test fetch MH seal from API
  - Caso: Valid invoice → get seal
  - Caso: Invalid credentials → error handling
  - Caso: Network timeout → retry logic
- [ ] Test MH seal validation
  - Caso: Valid seal → accepted
  - Caso: Invalid seal → rejected
  - Caso: Expired seal → rejected
- [ ] Test MH seal storage
  - Caso: Seal stored in invoice attachment
  - Caso: Multiple seals (if supported)

#### Invoice Format Validation Tests
- [ ] Test 3-digit classification code
  - Caso: Valid code (001-099) → accepted
  - Caso: Invalid code → error
  - Caso: Empty code → error
- [ ] Test electronic format validation
  - Caso: Valid XML structure → pass
  - Caso: Invalid XML → error
  - Caso: Missing required fields → error

#### Digital Signature Tests
- [ ] Test signature generation
  - Caso: Valid certificate → sign
  - Caso: Expired certificate → error
  - Caso: Invalid key → error
- [ ] Test signature verification
  - Caso: Valid signature → verified
  - Caso: Tampered invoice → rejected
  - Caso: Missing signature → error

**Archivos a modificar:**
- `l10n_sv_edi/tests/test_edi_mh_seal.py` (crear si no existe)
- `l10n_sv_edi/tests/test_edi_invoice_format.py` (crear)
- `l10n_sv_edi/tests/test_edi_digital_signature.py` (crear)

**Métricas:**
- Target: +12 tests
- Coverage delta: 40% → 50%
- Esfuerzo estimado: 8 horas

---

### l10n_sv_hr (21 módulos, 1/21 tests)

**Contexto:** Nómina, retenciones legales (CRITICAL legal risk)

#### Payroll Computation Tests
- [ ] Test salary computation
  - Caso: Base salary + bonuses → correct total
  - Caso: Deductions applied → correct net
  - Caso: Edge case: Zero hours → zero pay
- [ ] Test ISSS withholding (seguridad social)
  - Caso: Valid salary range → correct withholding %
  - Caso: Out of range → error
  - Caso: Multiple affiliations → handled correctly
- [ ] Test IMP (pensión) withholding
  - Caso: Valid computation → correct %
  - Caso: Minimum/maximum bounds → respected

#### Bank Export Format Tests
- [ ] Test CSV export format
  - Caso: Valid structure → export succeeds
  - Caso: Missing required fields → error
  - Caso: Special chars in names → handled
- [ ] Test ACH file format (if used)
  - Caso: Valid ACH structure → correct
  - Caso: Invalid routing number → error
  - Caso: Batch size limits → respected

#### Compliance & Audit Tests
- [ ] Test wage stability fund (FSV) deduction
  - Caso: Correct rate applied → valid deduction
  - Caso: Out of valid wage range → error
- [ ] Test legal retention registers
  - Caso: Withholding logged → audit trail exists
  - Caso: Employee summary → accurate totals
  - Caso: Government submission format → valid

**Archivos a modificar:**
- `l10n_sv_hr/tests/test_hr_payroll_compute.py` (crear)
- `l10n_sv_hr/tests/test_hr_bank_export.py` (crear)
- `l10n_sv_hr/tests/test_hr_compliance.py` (crear)

**Métricas:**
- Target: +15 tests
- Coverage delta: 5% → 25%
- Esfuerzo estimado: 12 horas (complexity de nómina)
- ⚠️ BLOCKEADO hasta que l10n_sv_account stabilized (tax dependencies)

---

### l10n_sv_stock (25 módulos, 2/25 tests)

**Contexto:** Valuación de inventario, circular deps con account

#### Valuation Method Tests (AVCO, FIFO)
- [ ] Test AVCO valuation
  - Caso: Purchase creates AVCO cost → stored
  - Caso: Receipt actualiza AVCO average → correct
  - Caso: Multiple purchases → cumulative average
  - Caso: Inventory adjustment → AVCO recalc
- [ ] Test FIFO valuation
  - Caso: First in first out → correct cost layers
  - Caso: Layer depletion → moves to next layer
  - Caso: Inventory adjustment → layer affected

#### Landed Costs Tests
- [ ] Test landed cost computation
  - Caso: Distribution by weight/volume → correct
  - Caso: Multiple landed cost lines → all allocated
  - Caso: Rounding → no cents lost

#### Custom Date Forcing (PO Reverse)
- [ ] Test PO reverse with custom date
  - Caso: Custom date < receipt date → AVCO forced to custom
  - Caso: Custom date >= receipt date → normal AVCO
  - Caso: Multiple receives, mixed dates → correct precedence
- [ ] Test date forcing validation
  - Caso: Future date → error
  - Caso: Date locked in period → warning or error

**Archivos a modificar:**
- `l10n_sv_stock/tests/test_stock_valuation.py` (expandir existente)
- `l10n_sv_stock/tests/test_stock_landed_costs.py` (crear)
- `l10n_sv_stock/tests/test_stock_date_forcing.py` (crear)

**Métricas:**
- Target: +10 tests
- Coverage delta: 8% → 20%
- Esfuerzo estimado: 10 horas

---

## 🎯 FASE 2 — QUICK WINS (Semana 2, 2 días)

**Objetivo:** Eliminar deuda fácil, consolidar patrones repetidos  
**Prioridad:** 🟡 MEDIA  
**Dependencias:** FASE 1 completa (para confianza en cambios)  
**Riesgo:** BAJO (eliminaciones de módulos vacíos)

### Deletions: Módulos Stub

| Módulo | Razón | Confirmación |
|--------|-------|-------------|
| `sale_access_right` | Funcionalidad built-in en Odoo | [ ] Revisar si hay custom usage |
| `l10n_sv_edi_attachment_downloader` | Stub, no implementado | [ ] Grep por imports |
| `l10n_sv_pos_invoice` | Redundante con POS estándar | [ ] Check POS dependencies |
| `account_move_change_account` | Cambio manual de cuenta en draft (dangerous) | [ ] Verificar si alguien lo usa |
| `account_move_change_dates` | Cambio de fecha (deuda técnica, usar reverse) | [ ] Check usage before delete |
| `pos_discount_validation` | Lógica débil, sin tests | [ ] Consolidate con POS discount stándar |
| `config_utils_for_sv` | Configuración dispersa | [ ] Audit references |

**Tareas:**
- [ ] Audit cada módulo: grep imports, check dependencias
- [ ] Crear migration script (si data migration needed)
- [ ] Delete 7 módulos stubs
- [ ] Update `__manifest__.py` en módulos dependientes (remover depends)
- [ ] Run full test suite post-deletion
- [ ] Document deprecation en CHANGELOG

**Esfuerzo:** 4 horas

---

### Consolidations: Check Printing

**Contexto:** 5 variantes de check printing (SV, payment method variants), código duplicado

**Módulos:**
- `l10n_sv_check_printing_base`
- `l10n_sv_check_printing_variant_1`
- `l10n_sv_check_printing_variant_2`
- `l10n_sv_check_printing_variant_3`
- `l10n_sv_check_printing_variant_4`

**Estrategia:**
- [ ] Extract `CheckPrintingMixin` (template rendering, format, security)
- [ ] Keep base module with mixin
- [ ] Variants = configuration only (payment method → template mapping)
- [ ] Remove duplicate `generate_check_pdf()` (5 copies → 1)
- [ ] Add config wizard: payment method → check template selection

**Archivos:**
- Crear: `l10n_sv_check_printing_base/models/check_printing_mixin.py`
- Modificar: 5 variants para heredar del mixin
- Remover: 1500+ LOC duplicado

**Esfuerzo:** 6 horas

---

### View Cleanup: Empty Inherited Views

**Contexto:** 390 inherited views con 0 cambios (legacy)

**Tareas:**
- [ ] Scan: `grep -r "inherit_id" models/views.xml` → count empty inherits
- [ ] Audit: Verify each view does nothing
- [ ] Delete: Remove empty `<record inherit_id=...>` blocks
- [ ] Test: Run full UI suite (verificar que nada se rompa)

**Archivos:**
- Modificar: 15+ archivos de vistas (l10n_sv_account, l10n_sv_sale, etc.)

**Esfuerzo:** 3 horas

---

### Extract Helpers: l10n_sv_helpers

**Contexto:** Helper functions duplicados en varios módulos (domain builders, formatting, date utils)

**Tareas:**
- [ ] Audit: Find duplicated utility functions
- [ ] Extract: Crear `l10n_sv_helpers/models/helpers.py`
  - `_get_operating_unit_domain()` (en prep para FASE 3)
  - `_format_dte_date()`
  - `_compute_tax_base()`
  - [otros]
- [ ] Refactor: Update 8+ módulos para usar helpers
- [ ] Tests: Crear tests para cada helper

**Esfuerzo:** 5 horas

**Total FASE 2:** 2 días (18 horas)

---

## 🏗️ FASE 3 — REFACTORING ARQUITECTURA (Semana 3-4, 5 días)

**Objetivo:** Eliminar deuda técnica estructural, romper ciclos, consolidar patrones  
**Prioridad:** 🟡 MEDIA  
**Dependencias:** FASE 1 + FASE 2  
**Riesgo:** MEDIO (cambios estructurales, refactor extenso)

### Task 1: Extract OperatingUnitMixin

**Problema:** 8 módulos reimplementan `_get_operating_unit_domain()` (200+ LOC)

**Módulos afectados:**
- l10n_sv_account_operating_unit
- l10n_sv_sale_operating_unit
- l10n_sv_stock_operating_unit
- [5 más]

**Solución:**

1. [ ] Create `l10n_sv_utils/models/operating_unit_mixin.py`
   ```python
   class OperatingUnitMixin(models.AbstractModel):
       _name = 'operating.unit.mixin'
       
       def _get_operating_unit_domain(self, force_ou=None):
           # Shared logic from 8 modules
   ```

2. [ ] Consolidate 8 modules → 3 layers:
   - Base: `operating_unit_base` (mixin + core)
   - Domain-specific: `account_operating_unit`, `sale_operating_unit`, `stock_operating_unit`
   - Config: Config selectors per module

3. [ ] Add multi-tenancy tests
   - [ ] Test domain filtering works per tenant
   - [ ] Test data isolation (cross-OU leak prevention)
   - [ ] Test permission checks

4. [ ] Update dependencies
   - Modules using single OU: keep current
   - Modules needing multi-OU: migrate to base + mixin

**Esfuerzo:** 12 horas

---

### Task 2: Break Circular Dependency #1 — Tax Reporting

**Problem:** Ciclo: `reporte_impuestos ↔ impuestos_sugeridos ↔ valida_reporte`

**Root cause:** Bidirectional validation (reporter needs validator, validator needs reporter)

**Solution:**

1. [ ] Extract neutral wizard module: `l10n_sv_tax_wizard_common`
   - Move shared models here
   - Remove circular imports

2. [ ] Restructure depends:
   - `reporte_impuestos` depends on `l10n_sv_tax_wizard_common`
   - `impuestos_sugeridos` depends on `l10n_sv_tax_wizard_common`
   - `valida_reporte` depends on `l10n_sv_tax_wizard_common`
   - No direct cross-module depends

3. [ ] Add cycle-detection test
   - [ ] Verify no circular imports with `sys.modules`
   - [ ] Audit `__manifest__.py` for reversed depends

**Esfuerzo:** 6 horas

---

### Task 3: Break Circular Dependency #2 — Stock ↔ Account

**Problem:** Ciclo: `l10n_sv_stock_valuation ↔ account_valuation_sv`

**Root cause:** Stock needs account chart, account needs stock methods

**Solution:**

1. [ ] Define interfaces (abstract models)
   - `valuation_interface.py`: Shared signatures

2. [ ] Move computations:
   - Account-side: AVCO computation logic
   - Stock-side: Receiving, cost layer tracking
   - Separate concerns, call via hook

3. [ ] Add integration tests
   - [ ] Full receive → account entry pipeline
   - [ ] Valuation consistency across OU

**Esfuerzo:** 8 horas

---

### Task 4: Consolidate Tax Methods

**Problem:** Tax computation duplicated across account variants

**Solution:**

1. [ ] Audit existing tax computation methods
   - [ ] Find all `_compute_*_tax()` functions

2. [ ] Extract to base model: `l10n_sv_account_tax_base`
   - ISC (sales tax)
   - IVA (VAT)
   - Withholding rates (IMP, ISSS, FSV)

3. [ ] Config-based rate selectors (not hardcoded)

**Esfuerzo:** 5 horas

**Total FASE 3:** 5 días (40 horas)

---

## 🔄 FASE 4 — SQL → ORM MIGRATION (Mes 2+, 7 días)

**Objetivo:** Migrar 406 cr.execute() queries a ORM equivalents  
**Prioridad:** 🟡 MEDIA  
**Dependencias:** FASE 1-3 completadas  
**Risk:** MEDIO-ALTO (data mutation queries)

### Strategy

**HIGH-RISK (Semana 1, 190 queries):**
- [ ] Account move: Financial data core
- [ ] Stock: Inventory valuation
- [ ] Payment: Journal entries

**MEDIUM-RISK (Semana 2, 100 queries):**
- [ ] Payroll: Salary computation
- [ ] Sale: Order processing

**LOW-RISK (Semana 3+, 116 queries):**
- [ ] Reports: Read-only queries
- [ ] Utils: Helper functions

### Process per Query

1. [ ] Audit: What does this query do?
2. [ ] Test: Add test case (if missing)
3. [ ] Rewrite: Use ORM equivalent
4. [ ] Verify: Query returns same results
5. [ ] Benchmark: No regression on performance
6. [ ] Commit: One commit per module

### HIGH-RISK: account_move

**Queries:** 95 in l10n_sv_account

- [ ] Invoice line taxes: `cr.execute("SELECT sum(amount) FROM ...")` → `self.env['account.move.line'].read_group(...)`
- [ ] Withholding computation: SQL → `@api.depends` + field computation
- [ ] Journal entry validation: SQL checks → ORM domain filters
- [ ] Multi-currency balances: SQL conversions → Odoo rate engine

**Esfuerzo:** 10 horas per module × 3 = 30 horas

### HIGH-RISK: stock

**Queries:** 65 in l10n_sv_stock

- [ ] Valuation updates: `cr.execute("UPDATE ...")` → `self.write()`
- [ ] Cost layer tracking: SQL joins → ORM related fields
- [ ] Landed cost allocation: SQL → compute

**Esfuerzo:** 15 horas

### HIGH-RISK: payment

**Queries:** 30 in payment modules

- [ ] Journal entries: SQL generation → `create()`
- [ ] Payment reconciliation: SQL matching → `reconcile()`

**Esfuerzo:** 8 horas

### MEDIUM-RISK: payroll

**Queries:** 60 in l10n_sv_hr

- [ ] Salary computation: SQL → models
- [ ] Withholding summary: SQL aggregation → read_group

**Esfuerzo:** 12 horas

### MEDIUM-RISK: sale

**Queries:** 40 in l10n_sv_sale

- [ ] Order line totals: SQL → compute
- [ ] Discount validation: SQL → domain

**Esfuerzo:** 8 horas

### LOW-RISK: reports + utils

**Queries:** 116

- [ ] Read-only reports: `cr.execute("SELECT...")` → `search()` + loop
- [ ] Helper lookups: SQL → `search_count()`, `mapped()`

**Esfuerzo:** 12 horas

**Total FASE 4:** 7 días (85 horas)

---

## 📊 RESUMEN

| FASE | Objetivo | Duración | Riesgo | Prioridad | Estado |
|------|----------|----------|--------|-----------|--------|
| 1 | Tests críticos | 5 días | BAJO | 🔴 | 🔄 Planificación |
| 2 | Quick wins | 2 días | BAJO | 🟡 | 📋 Backlog |
| 3 | Refactor arquitectura | 5 días | MEDIO | 🟡 | 📋 Backlog |
| 4 | SQL → ORM | 7 días | MEDIO-ALTO | 🟡 | 📋 Backlog |

**Total:** 19 días

**Arranque FASE 1:** Cuando esté listo

---

## 🚀 PRÓXIMOS PASOS

1. [ ] Revisar este TODO con equipo
2. [ ] Priorizar entre FASEs (legal risk first → FASE 1)
3. [ ] Asignar propietarios de tarea (si equipo disponible)
4. [ ] Setup CI/CD para tests (pre-commit hooks)
5. [ ] Begin FASE 1 Week 1

**Versión:** 1.0  
**Última actualización:** 2026-07-11  
**Próxima revisión:** FASE 1 kickoff

