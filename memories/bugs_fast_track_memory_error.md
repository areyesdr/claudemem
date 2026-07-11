---
name: fast_track_memory_error_fix
description: "MemoryError en cron_fast_track_invoices después de ~230 órdenes, solucionado con limpieza periódica de cache"
metadata: 
  node_type: memory
  type: bug
  resolved: 2026-05-19
  originSessionId: 132c983f-424b-4140-bff2-53fcd63dda56
---

## Problema
El cron `cron_fast_track_invoices` en sync_amigopos fallaba con `MemoryError` después de procesar ~230 órdenes de un lote de 500. El error ocurría en la creación de factura:

```
File "/opt/odoo/17/addons/odoo/odoo/api.py", line 1135, in insert_missing
    field_cache.setdefault(id_, val)
MemoryError
```

## Causa
El **cache en memoria de Odoo se saturaba**. Cada `invoice.create()` cargaba referencias en caché (partners, companies, productos, movimientos). Después de 230 iteraciones sin limpiar, agotaba memoria.

## Solución Implementada (2026-05-19)

**Archivo**: `/home/axel/odoo/17/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order_cron.py`

### 1. Limpieza cada 50 órdenes (pre-create)
```python
if idx % 50 == 0:
    CompanyModel.env.cache.clear()
    CompanyModel.env.cr.commit()
```
Inserto justo antes de crear la factura (línea ~1062).

### 2. Limpieza post-commit
```python
CompanyModel.env.cache.clear()  # AGREGADO
CompanyModel.env.invalidate_all()
```
Agregado en línea ~1206 después del commit que ya existía.

### 3. Contexto mejorado en create()
```python
invoice = CompanyModel.env['account.move'].with_context(
    mail_create_nosubscribe=True,
    tracking_disable=True,
    mail_notrack=True,
    prefetch_fields=False  # AGREGADO
).create(invoice_vals)
```

## Por Qué Funciona

- `cache.clear()`: Descarta toda la caché en memoria
- `cr.commit()`: Guarda cambios y permite reset de transacción
- `prefetch_fields=False`: Evita cargar campos relacionados automáticamente
- Frecuencia de 50 órdenes: Balance entre limpieza y overhead

## Testing

Ejecutar cron con 500+ órdenes para verificar que procesa sin MemoryError.

## Referencias Técnicas

- [[Loop Consolidation]] — Patrón de optimización de crons en sync_amigopos
- [[Orquestador Secuencial]] — Arquitectura del cron maestro
