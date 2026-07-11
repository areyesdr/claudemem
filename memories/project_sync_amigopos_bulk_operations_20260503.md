---
name: Bulk Operations Integradas en sync_amigopos (20260503)
description: Integración de lógica bulk (confirmar SO/MO/pickings) desde l10n_sv_bulk_confirm_orders
type: project
originSessionId: dcf1e574-1a4a-497c-93a6-425f54609c3f
---
# Bulk Operations Integradas en sync_amigopos

**Fecha:** 2026-05-03  
**Estado:** ✅ COMPLETO  
**Decisión del usuario:** "Traer la lógica del módulo bulk a sync_amigopos, mantener la estructura, pero SIN wizard"

## Resumen de cambios

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `syncap_bulk_operations.py` | NUEVO | 3 métodos bulk (SO/MO/pickings) |
| `syncap_order.py` | MODIFICADO | 3 métodos de acción (wrappers) |
| `order_views.xml` | MODIFICADO | 3 botones en header |
| `__init__.py` (syncap_order/) | MODIFICADO | Importar syncap_bulk_operations |

## Métodos públicos (reutilizables)

```python
# Confirmar múltiples SO
bulk_confirm_sales_orders(order_ids, force_confirm=True, historical_date=False)

# Finalizar múltiples MO
bulk_confirm_manufacturing_orders(mo_ids, force_done=True, historical_date=False)

# Validar múltiples pickings
bulk_validate_pickings(picking_ids, force_validate=True, historical_date=False)
```

Cada método:
- ✅ Valida que no haya lotes/series (FAIL-FAST)
- ✅ Maneja fechas históricas con inyección SQL
- ✅ Propaga contextos especializados
- ✅ Log de operaciones

## Métodos de acción (UI)

```python
action_bulk_confirm_sales_orders()      # Botón "Confirmar SO (Bulk)"
action_bulk_confirm_manufacturing_orders()  # Botón "Finalizar MO (Bulk)"
action_bulk_validate_pickings()         # Botón "Validar Pickings (Bulk)"
```

Cada método de acción:
- Prepara datos desde la selección actual
- Llama al método bulk correspondiente
- Retorna notificación (éxito/error) al usuario

## Botones agregados

- "Confirmar SO (Bulk)" - visible en estados done_sale_created/done_sale_sent/done_sale
- "Finalizar MO (Bulk)" - visible en estados done_mo_created/done_mo_confirmed
- "Validar Pickings (Bulk)" - visible en estados done_picking_created/done_assigned

Todos con:
- Icono: fa-bolt (rayo = operación rápida)
- Permisos: group_syncap_manager / mrp_user / stock_user
- Clase: btn-info (azul)

## Comparativa: Módulo separado vs Integrado

**Antes (l10n_sv_bulk_confirm_orders):**
- Módulo separado en `/conectores/l10n_sv_bulk_confirm_orders/`
- Acceso vía wizard (l10n_sv_bulk_confirm_orders.bulk_wizard)
- Dependencia externa

**Después (sync_amigopos):**
- Integrado en sync_amigopos
- Acceso vía botones directos (sin wizard)
- Métodos públicos reutilizables
- Una sola fuente de verdad

## Validaciones integradas

### FAIL-FAST para lotes/series
Si intenta forzar finalización de MO o validar picking con productos que exigen lote/serie:

```
❌ UserError:
"No se puede forzar la finalización masiva porque las siguientes 
Órdenes de Producción contienen productos que exigen seguimiento 
por Lote o Número de Serie:

• MO-0001 (Productos: Producto A, Producto B)

Por favor, procese estas órdenes manualmente asignando sus lotes."
```

## Inyección SQL para históricos

Si `historical_date` se proporciona:
- Convierte a fecha contable de El Salvador (UTC-6)
- Inyecta fecha en SO/MO/pickings
- Inyecta fecha en stock moves y move lines
- Inyecta fecha en asientos contables (accounting_date)
- Invalida cache de Odoo para refrescar valores

Garantiza integridad de trazabilidad histórica.

## Casos de uso documentados

1. **Sincronización masiva de órdenes antiguas** → Confirmar SO batch
2. **Retroactivos históricos** → Finalizar MO con fecha inyectada
3. **Validación masiva sin stock** → Force-validate pickings

## Why: Contexto de decisión

El usuario quería:
- ✅ Traer lógica del módulo bulk a sync_amigopos
- ✅ Mantener la misma estructura (3 métodos reutilizables)
- ❌ SIN wizard (simplificar acceso)
- ✅ NO borrar módulo original (dejar disponible)

## How: Cómo usar

### Desde UI
- Seleccionar órdenes syncap
- Hacer clic en botón "Confirmar SO (Bulk)" / "Finalizar MO (Bulk)" / "Validar Pickings (Bulk)"
- Sistema ejecuta y muestra notificación

### Desde código
```python
# En un cron o método
orders = self.env['syncap.order'].search([...])
self.bulk_confirm_sales_orders(
    orders.mapped('sale_order_id').ids,
    force_confirm=True,
    historical_date=False
)
```

## Referencias

- Vault: `/vault17/Modulos/sync_amigopos_bulk_operations_20260503.md`
- Código: 
  - `/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_bulk_operations.py`
  - `/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order.py` (línea ~885)
  - `/conectores/sync_amigopos/views/order_views.xml` (línea ~152)
- Módulo original: `/conectores/l10n_sv_bulk_confirm_orders/` (sin cambios)

---
*Decisión de usuario: "Traer la lógica del módulo bulk a sync_amigopos sin wizard" — Completado 2026-05-03*
