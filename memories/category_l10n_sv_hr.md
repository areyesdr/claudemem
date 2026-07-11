---
name: category_l10n_sv_hr
description: "Categoría l10n_sv_hr (21 módulos) — Payroll, deducción legal, asistencia, cumplimiento laboral"
metadata: 
  node_type: memory
  type: project
  category: l10n_sv_hr
  modules_count: 21
  python_files: 105
  xml_views: 77
  test_files: 1
  test_coverage: 5%
  dependencies: 21+ otros módulos
  risk_level: CRÍTICA
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Categoría l10n_sv_hr

**Status:** Domain Hub Layer 1 — 21 módulos dependientes  
**Compliance:** Labor law El Salvador  
**Test coverage:** 1 file (5%) — CRITICAL GAP  

## Módulos (21)

### Core Payroll (7) — HUB CENTRAL
- `l10n_sv_hr_payroll` (9 deps) — Main payroll engine
- `l10n_sv_hr_payroll_bonus` — Bonus calculation
- `l10n_sv_hr_payroll_bank` — Bank export format
- `l10n_sv_hr_payroll_deductions` — Wage garnishment
- `l10n_sv_hr_payroll_employee_benefits` — Benefits mgmt
- `l10n_sv_hr_payroll_loans` — Employee loans
- `l10n_sv_hr_payroll_withholding` — Tax withholding

### Attendance & Hours (6)
- `l10n_sv_hr_attendance` — Clock in/out
- `l10n_sv_hr_attendance_analytics` — Analytics
- `l10n_sv_hr_extra_hours` — Overtime tracking
- `l10n_sv_hr_leaves` — Leave types SV
- `l10n_sv_hr_shift_management` — Shift scheduling
- `l10n_sv_hr_work_entry` — Work entry SV

### Administrative (5)
- `l10n_sv_hr_contract` — Employment contracts
- `l10n_sv_hr_employee` — Employee data
- `l10n_sv_hr_reports` — HR reports
- `l10n_sv_hr_org_chart` — Org structure
- `l10n_sv_hr_policies` — HR policies

### Utilities (3)
- `l10n_sv_hr_employee_documents` — Document mgmt
- `l10n_sv_hr_access_rights` — Permissions
- `l10n_sv_hr_nominative_reports` — Export forms

## Dependencias Externas

| Módulo | Impacto |
|--------|---------|
| hr_payroll | CRÍTICA |
| account | ALTA |
| hr | ALTA |
| mail | MEDIA |
| base | MEDIA |

## Deuda Técnica Detectada

### 🔴 Crítica
- **ZERO tests on payroll hub** — Employee legal protection violations risk
- **Withholding calculation** — No validation, manual SQL
- **Bank export format** — Payment rejection risk
- **Minimal wizard** — l10n_sv_hr_payroll_wizard (0 logic)

### 🟡 Media
- **Raw SQL** — 30+ instances en payroll computations
- **Duplicated domain builders** — Payroll filters reused (50 LOC dup)
- **Circular logic** — payroll → bonus → bank export

### 🟢 Leve
- **Deprecated decorators** — 2 @api.one methods

## Test Coverage

**Actual:** 1 file (EMERGENCY)

**MUST TEST FIRST:**
1. Salary computation (base, deductions, withholding)
2. Legal withholding validation (employee rights)
3. Bank export format (payment compliance)
4. Bonus calculation (calculation accuracy)
5. Leave accrual (legal requirement)

## Módulos Críticos (0 tests)

- `l10n_sv_hr_payroll` — Hub, 9 deps, salary engine
- `l10n_sv_hr_payroll_withholding` — Legal compliance
- `l10n_sv_hr_payroll_bank` — Payment execution

## Risk Assessment

**Failure scenarios:**
- Incorrect salary calculation → employee lawsuit
- Wrong withholding → tax agency fine
- Bank rejection → payment delay
- Leave accrual error → legal claim

## Quick Wins

| Tarea | Effort | Impact |
|-------|--------|--------|
| Add payroll tests | 3 días | Legal protection |
| Migrate SQL → ORM | 1 día | Safer, auditable |
| Remove wizard stubs | 2h | Cleaner |
| Extract domain helpers | 1 día | -50 LOC dup |

## Roadmap

**FASE 1 (Week 1):** Tests l10n_sv_hr_payroll (HUB) — URGENT  
- Salary computation
- Withholding validation
- Bank export

**FASE 2 (Week 2):** Tests attendance + benefits  
**FASE 3 (Week 3-4):** Migrate SQL, extract helpers  
**FASE 4 (Month 2):** Deprecation paths, documentation

## Críticos para

- Employee salary (payroll engine)
- Legal compliance (withholding)
- Bank integration (payments)
- Audit trail (all transactions)

---

**Status:** CRITICAL — 0 tests on hub with 9 dependientes. Legal risk.  
**PRIORITY:** Start FASE 1 immediately.  
**Next review:** 2026-07-14 (1 week)
