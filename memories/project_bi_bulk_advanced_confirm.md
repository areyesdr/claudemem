---
name: bi_bulk_advanced_confirm Module Implementation
description: Módulo avanzado para bulk operations con auto-fill y force-validate
type: project
originSessionId: 497637e1-dccc-4906-bac5-0eaf11f733bf
---
# Proyecto: bi_bulk_advanced_confirm Module

**Fecha**: 2026-05-03
**Actualizado**: 2026-05-03 (rediseño con 3 wizards modales)

## Implementado (v17.0.1.0)

Módulo en `/home/axel/odoo/17/utility/bi_bulk_advanced_confirm/` con **3 wizards modales independientes**

### 3 Wizards modales

1. **BulkSalemWizard** (bulk.sale.wizard)
   - Modal para confirmar SOs en bulk
   - Campo: `force_confirm` (bool, default=True)
   - Método: `action_bulk_force_confirm()`
   - Auto-popup con active_ids, tags view
   - Contexto: skip_sale_order_warning, disable_cancel_warning

2. **BulkMrpWizard** (bulk.mrp.wizard)
   - Modal para confirmar + finalizar MOs
   - Campo: `force_done` (bool, default=True)
   - Método: `action_bulk_force_done()`
   - Auto-consumir: `move.quantity = move.product_uom_qty`
   - Contexto: skip_consumption, skip_backorder, skip_sms

3. **BulkPickingWizard** (bulk.picking.wizard)
   - Modal para validar pickings con force-reserve
   - Campo: `force_validate` (bool, default=True)
   - Método: `action_bulk_force_validate()`
   - Force-reserve en moves + move_lines
   - Contexto: skip_backorder, skip_immediate, skip_sms, cancel_backorder

### UI Features
- Modal puro (target="new")
- Tags view (no tree view)
- Auto-populate desde active_ids
- Botones: Confirmar / Cancelar

## Arquitectura

**Flujo**:
1. Usuario selecciona registros en lista
2. Menú ⋯ → abre wizard modal
3. Wizard auto-rellena selected_ids como tags
4. Usuario activa/desactiva force flag
5. Click botón → ejecuta acción en modelo
6. Modal se cierra

**Independencia**: Cada wizard puede ejecutarse sin necesidad del otro

## Verificación manual

Ver plan: `/home/axel/.claude/plans/iterative-watching-moon.md` sección "Verificación"

**Why**: Módulo complementario a `bi_bulk_confirm_and_cancel_orders` que ES de verdad: genera MOs/pickings automáticamente, auto-fill componentes, fuerza cantidades sin stock.
