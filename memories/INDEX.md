---
name: index_master
description: Índice maestro y buscador rápido de todas las memorias del proyecto Odoo 17
metadata: 
  node_type: memory
  type: reference
  version: 2026-07-11
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# 📑 ÍNDICE MAESTRO — Memorias Odoo 17

**Última actualización:** 2026-07-11  
**Total memorias:** 54 archivos  
**Repositorio:** https://github.com/areyesdr/claudemem

---

## 🎯 BÚSQUEDA RÁPIDA

### ¿Qué busco?

| Necesidad | Archivo | Descripción |
|-----------|---------|-------------|
| **Entender estructura 173 mods** | [[project_localizacion_structure_complete]] | Mapeo 4 capas, 11 categorías |
| **Deuda técnica general** | [[project_localizacion_technical_debt_audit]] | 10 issues críticas, roadmap |
| **Cómo arreglarlo** | [[project_localizacion_technical_detalles_implementation]] | Antipatrones, quick wins, plan 4-fases |
| **Módulos por categoría** | Ver ⬇️ CATEGORÍAS | 11 archivos (uno por categoría) |
| **Flujo de trabajo** | [[workflow_commit_documentation]] | Commits con docs obligatorios |
| **Reglas git** | [[Git Workflow Rules]] | Git SOLO lectura, NO commits automáticos |

---

## 📂 CATEGORÍAS (11 archivos)

### 🔴 CRÍTICAS — Actuar primero

| Categoría | Módulos | Tests | Riesgo | Archivo |
|-----------|---------|-------|--------|---------|
| **l10n_sv_edi** | 15 | 6 (40%) | CRÍTICA — Gov compliance | [[category_l10n_sv_edi]] |
| **l10n_sv_account** | 58 | 33 (57%) | CRÍTICA — Financial core | [[category_l10n_sv_account]] |
| **l10n_sv_hr** | 21 | 1 (5%) | 🚨 **CRITICAL** — Payroll, legal | [[category_l10n_sv_hr]] |
| **l10n_sv_stock** | 25 | 2 (8%) | ALTA — Valuation, circular deps | [[category_l10n_sv_stock]] |
| **l10n_sv_utils** | 26 | 0 (0%) | ALTA — Multi-tenancy, 200 LOC dup | [[category_l10n_sv_utils]] |

### 🟡 MEDIANAS — Plan después

| Categoría | Módulos | Tests | Riesgo | Archivo |
|-----------|---------|-------|--------|---------|
| **l10n_sv_sale** | 15 | 1 (7%) | MEDIA — Sales ops | [[category_l10n_sv_sale]] |
| **l10n_sv_purchase** | 3 | 0 (0%) | MEDIA — Custom dates | [[category_l10n_sv_purchase]] |

### 🟢 LEVES — Backlog

| Categoría | Módulos | Tests | Riesgo | Archivo |
|-----------|---------|-------|--------|---------|
| **l10n_sv_mrp** | 3 | 0 (0%) | BAJA | [[category_l10n_sv_mrp]] |
| **l10n_sv_point_of_sale** | 4 | 0 (0%) | BAJA | [[category_l10n_sv_point_of_sale]] |
| **l10n_sv_website** | 2 | 0 (0%) | BAJA | [[category_l10n_sv_website]] |
| **l10n_sv_school** | 1 | 0 (0%) | BAJA | [[category_l10n_sv_school]] |

---

## 📊 RESUMEN EJECUTIVO

### Números Clave
- **173 módulos** en 11 categorías
- **56%** tienen interdependencias internas
- **26%** tienen tests (45/173)
- **12%** código duplicado (850 LOC)
- **16-17 días** roadmap implementación

### Problemas Top 5
1. 🚨 **l10n_sv_hr:** 1 test en hub de payroll (9 deps) — LEGAL RISK
2. 🔴 **Tax reporting:** 14 módulos interdependientes, ciclos circulares
3. 🔴 **Operating units:** 8 módulos, 200+ LOC duplicado (mixin needed)
4. 🟡 **Check printing:** 5 variantes, consolidation candidate (1 día)
5. 🟡 **Empty modules:** 7 stubs sin funcionalidad (DELETE)

### Roadmap (Q1-Q3)
- **FASE 1 (Week 1):** 5 días — Tests críticos (edi, payroll, stock)
- **FASE 2 (Week 2):** 2 días — Quick wins (stubs, check consolidation)
- **FASE 3 (Week 3-4):** 5 días — Operating unit mixin + circular deps
- **FASE 4 (Month 2):** 5-7 días — SQL → ORM migration

---

## 🔍 BÚSQUEDA POR PROBLEMA

### Problema: "No sé por dónde empezar"
→ Leer: [[project_localizacion_technical_detalles_implementation]]  
→ Quick wins: 14 horas, bajo riesgo  
→ Depois roadmap 4-fases

### Problema: "Payroll está roto"
→ Leer: [[category_l10n_sv_hr]]  
→ Riesgo: CRITICAL (0 tests, legal)  
→ Acción: Agregar tests FASE 1

### Problema: "Valuación de inventario inconsistente"
→ Leer: [[category_l10n_sv_stock]]  
→ Problema: Circular deps con account, 0 tests  
→ Ver también: [[project_po_reverse_custom_date]] (custom dates AVCO)

### Problema: "Facturación electrónica falla"
→ Leer: [[category_l10n_sv_edi]]  
→ Riesgo: Gov compliance (6 tests insufficient)  
→ Acción: Agregar MH integration tests

### Problema: "Multi-tenancy data leakage"
→ Leer: [[category_l10n_sv_utils]]  
→ Problema: 8 operating_unit modules, 0 tests  
→ Solución: OperatingUnitMixin (FASE 3)

### Problema: "Deuda técnica general"
→ Leer: [[project_localizacion_technical_debt_audit]]  
→ Contiene: 10 issues categorizadas, prioridades

---

## 🗂️ ESTRUCTURA DE MEMORIA

```
/home/axel/.claude/projects/-home-axel-odoo-17/memory/

PROJECT LEVEL (ESTRUCTURA GENERAL)
├── project_localizacion_structure_complete.md ← Mapeo 173 mods
├── project_localizacion_technical_debt_audit.md ← Issues críticas
├── project_localizacion_technical_detalles_implementation.md ← Plan 4-fases
└── INDEX.md ← TÚ ESTÁS AQUÍ

CATEGORY LEVEL (11 CATEGORÍAS)
├── category_l10n_sv_edi.md
├── category_l10n_sv_account.md
├── category_l10n_sv_hr.md
├── category_l10n_sv_stock.md
├── category_l10n_sv_utils.md
├── category_l10n_sv_sale.md
├── category_l10n_sv_purchase.md
├── category_l10n_sv_mrp.md
├── category_l10n_sv_point_of_sale.md
├── category_l10n_sv_website.md
└── category_l10n_sv_school.md

WORKFLOW & RULES (CÓMO TRABAJAR)
├── workflow_commit_documentation.md
├── feedback_vault_as_memory.md
└── git_workflow_rules.md

HISTORICAL (PROYECTOS ANTERIORES)
├── project_sync_amigopos_*.md (4 archivos)
├── project_po_reverse_custom_date.md
├── bugs_*.md (9 archivos)
└── [otros proyectos]
```

---

## 💡 CÓMO USAR

### Nivel 1: "Necesito entender TODO"
1. Lee: [[project_localizacion_structure_complete]] (10 min)
2. Lee: [[project_localizacion_technical_debt_audit]] (15 min)
3. Lee: [[project_localizacion_technical_detalles_implementation]] (10 min)
4. Total: 35 minutos

### Nivel 2: "Necesito arreglarlo"
1. Abre: [[project_localizacion_technical_detalles_implementation]]
2. Sección: "Plan 4-Fases" → elige FASE
3. Sigue: Tareas checklist

### Nivel 3: "Necesito detalles de una categoría"
1. Secciona tabla de CATEGORÍAS arriba ↑
2. Haz click en archivo `[[category_l10n_sv_*]]`
3. Dentro: deuda técnica específica, quick wins, roadmap

### Nivel 4: "Necesito buscar algo específico"
Usa: Sección "BÚSQUEDA POR PROBLEMA" ↑

---

## 🔗 ENLACES EXTERNOS

- **GitHub claudemem:** https://github.com/areyesdr/claudemem
- **Último commit:** c18617a
- **Memorias sincronizadas:** Sí (automático)

---

## 📌 QUICK REFERENCE

**Módulos críticos 0 tests:**
- l10n_sv_hr_payroll (9 deps) — LEGAL RISK
- l10n_sv_stock_valuation (7 deps)
- l10n_sv_utils (operating_unit)

**Módulos stubs a eliminar:**
- sale_access_right
- l10n_sv_edi_attachment_downloader
- l10n_sv_pos_invoice
- account_move_change_account
- account_move_change_dates
- pos_discount_validation
- config_utils_for_sv

**Consolidation candidates:**
- Check printing (5 → 1, 1 día)
- Operating unit (8 → mixin, 3-5 días)

**Circular deps a romper:**
1. reporte_impuestos ↔ impuestos_sugeridos ↔ valida
2. l10n_sv_stock_valuation ↔ account_valuation_sv
3. [otros 1]

---

**Versión:** 2026-07-11  
**Próxima actualización:** 2026-07-24 (FASE 1 complete)  
**Mantenedor:** Claude Code + odoo-project-lead
