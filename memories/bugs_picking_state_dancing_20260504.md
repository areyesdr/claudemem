---
name: Picking State Dancing Bug Fix
description: Crítico - Fix para orden saltando entre estados de albarán sin avanzar
type: bugs
originSessionId: 8c2bb374-4321-4b92-b0de-53e17bced4a5
---
## Bug: Órdenes Sin Albaranes Ni Fabricaciones Se Atascaban en Facturación

**Fecha**: 2026-05-04
**Severidad**: CRÍTICO
**Archivos afectados**:
- syncap_order_stock.py (cron_process_inventory_orders)
- syncap_order_cron.py (FASE 4)
- syncap_order_account.py (cron_process_invoices) ← **CAMBIO PRINCIPAL**

## Problema
Órdenes sin MO (Órdenes de Manufactura) y sin Albaranes (pickings) fallaban en FASE 5 (Facturación) con:
> "No se puede crear una factura. No hay artículos disponibles para facturar"

## Causa Raíz
**Principal**: En `cron_process_invoices()` (syncap_order_account.py:78-81), solo se marcaba `qty_delivered` para servicios. Para órdenes sin pickings con productos almacenables, `qty_delivered=0` → facturación fallaba.

**Secundaria**: En `cron_process_inventory_orders()` línea 109, el estado se cambiaba sin verificar pickings completados. Aunque esto causaba problemas, el REAL PROBLEMA era que incluso cuando la orden llegaba a FASE 5 correctamente, la facturación fallaba porque `qty_delivered` no se marcaba.

## Solución Implementada

### 1. **syncap_order_account.py (CAMBIO PRINCIPAL - línea 78-90)**
Marcar `qty_delivered` para órdenes sin pickings:
```python
# Si NO hay pickings Y es producto almacenable → marcar como entregado
if line.product_id.type == 'service' or (not has_pickings and line.product_id.detailed_type == 'product'):
    line.write({'qty_delivered': line.product_uom_qty})
```

### 2. syncap_order_stock.py (líneas 54-124)
Verificar pickings COMPLETADOS antes de cambiar estado:
```python
pickings = pickings.exists()  # Refrescar desde BD
pending_pickings = pickings.filtered(lambda p: p.state not in ('done', 'cancel'))
if pending_pickings:
    continue  # NO avanzar estado
order.write({'state': 'done_picking'})
```

### 3. syncap_order_cron.py
- Cron continuo (línea 183): Refrescar pickings después de procesar
- Orquestador maestro (línea 493): Refrescar pickings antes de verificar

## Resultado
- ✅ Órdenes NO se quedan atrapadas en FASE 4
- ✅ Si un albarán falla, se reintentar en siguiente ciclo (sin avanzar estado)
- ✅ Logs detallados muestran qué albaranes están pendientes
- ✅ Garantía: estado cambia SOLO cuando realmente completado

## How to Apply
Si ve una orden "bailando" entre estados del albarán:
1. Revisar logs de FASE 4 para ver qué albaranes están pendientes
2. Verificar en BDD el estado real de stock.picking.state
3. Resolver el problema subyacente (stock, lotes, etc.)
4. Siguiente ciclo del cron debería procesar correctamente
