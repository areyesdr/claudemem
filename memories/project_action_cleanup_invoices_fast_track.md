---
name: action_cleanup_bad_invoices_only - Soporte Fast-Track
description: Función de limpieza de facturas ahora soporta órdenes sin SO y fast-track
type: project
originSessionId: f436d718-538a-464d-ade2-aa61959c9b41
---
## Fecha Implementación
2026-05-13

## Cambio Realizado
Actualización de función `action_cleanup_bad_invoices_only()` en:
**Archivo:** `/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order_account.py:663`

## Mejoras Implementadas

### Antes
- Solo funcionaba con órdenes que tenían `sale_order_id`
- Fallaba silenciosamente en órdenes fast-track

### Después
```python
if order.used_fast_track or not has_sale_order:
    # Buscar SOLO por syncap_order_id
    invoices = env['account.move'].search([('syncap_order_id', '=', order.id)])
else:
    # Buscar en SO + syncap_order_id
    invoices = sale_order.invoice_ids | env['account.move'].search(...)
```

## Estados Finales
- **Con SO:** regresa a `done_picking` (para re-facturación desde inventario)
- **Sin SO / Fast-Track:** regresa a `draft` (para reprocesamiento desde el inicio)

## SE USA EN
- Botón "Limpiar Facturas" en vistas de syncap.order
- Acción servidor para reparación manual
- Fast-Track invoicing workflow

## Casos de Uso
✅ Limpiar facturas corruptas de órdenes Fast-Track  
✅ Manejar órdenes normales que perdieron su SO  
✅ Reseteo correcto sin bloquear flujos
