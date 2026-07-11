---
name: localizacion_structure_complete
description: "Mapeo completo de 173 módulos l10n_sv_* en /home/axel/odoo/17/localizacion/ con estructura de capas, clústeres, dependencias y deuda técnica"
metadata: 
  node_type: memory
  type: project
  date_captured: 2026-07-10
  modules_total: 173
  test_coverage: 26%
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# Localizacion Structure — Complete Inventory

## Resumen Ejecutivo

**173 módulos** organizados en **11 categorías** con **4 capas arquitectónicas**. 
- **56%** tienen interdependencias internas (97 modules)
- **26%** tienen tests (45 archivos / 173 módulos)
- **Capas:** Foundation (Layer 0), Domain Hubs (Layer 1), Features (Layer 2), Standalone (Layer 3)

---

## Categorías Principales

| Categoría | Módulos | Python | Vistas | Tests | Patrón |
|-----------|---------|--------|--------|-------|--------|
| l10n_sv_account | 58 | 225 | 137 | 33 | Maior: impuestos/fiscal/reports |
| l10n_sv_edi | 15 | 87 | 52 | 6 | Foundation (todas dependen) |
| l10n_sv_hr | 21 | 105 | 77 | 1 | Payroll + asistencia |
| l10n_sv_stock | 25 | 73 | 37 | 2 | Inventario + costing |
| l10n_sv_utils | 26 | 110 | 74 | 2 | Infraestructura + operating_unit |
| l10n_sv_sale | 15 | 30 | 13 | 1 | Ventas + CRM |
| l10n_sv_purchase | 3 | 15 | 9 | — | PO + formatos EDI |
| l10n_sv_mrp | 3 | 7 | 3 | — | BOM costing |
| l10n_sv_point_of_sale | 4 | 11 | 5 | — | POS |
| l10n_sv_website | 2 | 5 | 4 | — | Website UI |
| l10n_sv_school | 1 | 4 | 1 | — | Education API |

---

## Arquitectura en Capas

### Layer 0 — Foundation (38 módulos dependen)
- `base_sv`, `l10n_sv_edi`, `l10n_sv`, `l10n_sv_dpto`
- Todas las capas: accounting, EDI, HR construidas sobre estas

### Layer 1 — Domain Hubs
- `l10n_sv_hr_payroll` (9 dependientes)
- `reporte_impuestos_sv` (8 dependientes)
- Núcleos de funcionalidad con múltiples especializaciones

### Layer 2 — Features (97 módulos con deps internas)
- Reportes especializados, formatos, validadores
- Heredan de hubs, no dependen entre sí directamente

### Layer 3 — Standalone (76 módulos sin deps internas)
- Utilidades de un propósito, análisis, exportes
- Completamente independientes de otros l10n_sv_*

---

## Clústeres Clave & Consolidación

### 1. **Tax & Fiscal (14 módulos)** — l10n_sv_account
- Hub central: `reporte_impuestos_sv`
- Módulos: `impuestos_sugeridos_sv`, `valida_reporte_impuestos`, `l10n_sv_mhreport`, etc.
- **Risk:** Interdependencias tight; cambios en hub afectan 8+ módulos

### 2. **Operating Unit Suite (8 módulos)** — l10n_sv_utils
- Base + variantes: account, stock, purchase, sale, analytic, product variants
- **Patrón:** Diseño modular deliberado, mínima duplicación
- **Risk:** Bajo; variantes son thin wrappers

### 3. **Check Printing (5 módulos)** — l10n_sv_account
- Base: `l10n_sv_print_checks`
- Variantes por banco: agricola, bac, cuscatlán, promerica
- **Consolidation candidate:** Mergeable a 1 + configuración de banco

### 4. **Payroll Processing (7 módulos)** — l10n_sv_hr
- Main → bank exports, bonus, attendance, hours tracking
- **Integración:** Sequential, uno depende del anterior

---

## Análisis de Duplicación & Deuda Técnica

| Patrón | Cantidad | Riesgo | Nota |
|--------|----------|--------|------|
| Check printing variants | 5 | Bajo | Heredan base, código minimal |
| Operating unit modules | 8 | Bajo | Diseño modular, intencional |
| Report modules (inherit account.report) | 30+ | Bajo | Patrón estándar Odoo |
| Módulos vacíos/stub | 7 | **Alto** | `sale_access_right`, `l10n_sv_edi_attachment_downloader` |
| Tax reporting interdeps | 14 | **Medio** | `reporte_impuestos_sv` es hub central |

### Módulos Vacíos Identificados
- `sale_access_right` — sin Python, 1 vista
- `l10n_sv_edi_attachment_downloader` — sin Python efectivo
- `l10n_sv_pos_invoice` — minimal
- [7 totales]

---

## Dependencias Externas (Top 10)

| Dependencia | Módulos | Tipo |
|------------|---------|------|
| `base` | 76 | Core |
| `account` | 71 | Core |
| `stock` | 28 | Operaciones |
| `sale` | 21 | Ventas |
| `product` | 16 | Catálogo |
| `purchase` | 12 | Procura |
| `mail` | 11 | Comunicación |
| `mrp` | 11 | Manufactura |
| `hr` | 11 | RRHH |
| `hr_payroll` | 9 | Nómina |

---

## Coverage & Calidad

- **Test files:** 45 / 173 módulos = **26%**
- **Best tested:** `account_reports_sv` (26 tests), `l10n_sv_edi` (4 tests)
- **Módulo promedio:** 3.7 archivos Python, 2.0 archivos XML
- **Interdependencias internas:** 97 módulos (56%) dependen de otros l10n_sv_*

---

## Consolidation Candidates (No edits, observación)

1. **Check printing (5 mod)** → Merge a 1 base + bank config table
2. **Módulos vacíos (7 mod)** → Revisar si realmente necesarios
3. **Minimal wizards** → `account_move_change_account` (0 Python, solo XML)

---

## Próximos Pasos

- [[ponytail:ponytail-audit]] aplicar auditoría de deuda técnica
- Sync con [[project_claudemem_github_setup]]
- Vault: crear nota en /Modulos/ con este análisis
