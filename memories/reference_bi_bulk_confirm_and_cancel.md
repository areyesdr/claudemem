---
name: bi_bulk_confirm_and_cancel Module Reference
description: Módulo BrowseInfo de utilidad para confirmar y cancelar órdenes en bulk
type: reference
originSessionId: 497637e1-dccc-4906-bac5-0eaf11f733bf
---
# Referencia: bi_bulk_confirm_and_cancel_orders

**Ubicación**: `/home/axel/odoo/17/utility/bi_bulk_confirm_and_cancel_orders/`

**Documentación completa**: Ver `/home/axel/odoo/17/vault17/Modulos/bi_bulk_confirm_and_cancel_orders.md`

## Resumen Ejecutivo

Módulo de BrowseInfo (v17.0.0.0) que agrega acciones de servidor para:
- ✅ Confirmar órdenes en bulk (SO, PO, MO)
- ✅ Cancelar órdenes en bulk (SO, PO, MO)
- ⚠️ Tiene 4 bugs conocidos detectados

## Quick Reference de Métodos

| Modelo | Método Confirm | Método Cancel |
|--------|---|---|
| `sale.order` | `action_confirm_sale()` | `action_cancel_sale()` |
| `purchase.order` | `action_confirm_po()` | `action_cancel_po()` |
| `mrp.production` | `action_confirm_mo()` | `action_cancel_mo()` |

## Restricciones por Tipo de Orden

**Sales**: Can confirm draft/sent/sale → Can cancel draft/sent/sale (con wizard si hay picking done)
**Purchase**: Cannot confirm if done/cancel → Can cancel any state
**MRP**: Cannot confirm if progress/done/cancel → Can cancel draft/confirmed/progress (no done)

## Bugs Críticos

1. **Validación después de acción** (PO y MO): Confirma y LUEGO valida
2. **Lógica de picking invertida** (SO): Cancela si picking NO está done
3. **Sin transaccionalidad**: Falla en orden #50 = primeras 49 ya procesadas
4. **Inconsistencia de contexto**: Usa `self` vs `active_ids` inconsistentemente

Ver documentación completa para detalles y impacto.
