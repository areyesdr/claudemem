---
name: Unificación _fetch_mh_seal_syncap + action_query_mh_syncap
description: Fusión de funciones de consulta MH + integración en flujo de creación de facturas
type: project
originSessionId: 3a8e5078-8805-4a13-a7a7-e2e9b9b46df6
---
## Cambios realizados (2026-05-05)

**Archivos modificados:**
1. `sync_amigopos/models/models_syncap/syncap_order/syncap_order_cron.py`
2. `sync_amigopos/models/models_syncap/syncap_order/syncap_order_account.py`

### En syncap_order_cron.py

**Agregué:**
- `import re` (faltaba)
- Nuevo método `_fetch_sello_from_mh(self, codigo_gen, fecha_emi)`: 
  - Helper ligero que consulta MH y retorna sello limpio o None
  - Reutilizable tanto desde `action_query_mh_syncap` como desde cron de creación de facturas
  - Retorna sólo el sello (sin dict), facilitando su uso como fallback

**Eliminé:**
- `_fetch_mh_seal_syncap()` (obsoleta, su lógica está ahora en `_fetch_sello_from_mh`)

**Reescribí:**
- `action_query_mh_syncap()`: ahora una sola función que incorpora toda la lógica:
  - **Paso 0 (Nuevo):** Resuelve datos desde `orderstomh.codigoGeneracion/fecha` → fallback a `move.codigo_generacion/invoice_date`
  - Si no hay ninguno → ticket (no DTE) → log silencioso, continúa
  - **Paso 1-4:** Consulta HTTP a MH, extrae sello, escribe en factura
  - Cuando MH retorna sello:
    - Escribe `sello_digital`, `invoice_code_link_mh`, `invoice_qr_code`, `portal_url`
    - Popula `codigo_generacion` si estaba vacío
    - Limpia `no_sello_mh` en la orden (si estaba activado)
  - Cuando MH NO retorna sello:
    - Activa `no_sello_mh = True` en la orden
    - Muestra mensaje en chatter con enlace manual a MH

### En syncap_order_account.py

**Modificó:** Bloque `if order.syncap_ordenestomh_id` (línea 109):
- **Antes:** Asignación directa sin fallback: `'sello_digital': tomh.selloAuth or False`
- **Ahora:** Resolución de sello en variable `sello_a_usar`:
  1. Intenta `tomh.selloAuth`
  2. Si está vacío → intenta `order._fetch_sello_from_mh(tomh.codigoGeneracion, tomh.fecha)`
  3. Si ambos fallan → marca `no_sello_mh = True` y continúa
  4. Si hay sello → asigna limpiamente en `data.update()` con `'sello_digital': sello_a_usar`

**Ventaja:** Lógica de consulta MH ANTES de `data.update()`, variable única, código sin duplicación

## Lógica de flujo mejorada

Antes: Orden sin `selloAuth` → ❌ refund (saltar)
Después: Orden sin `selloAuth` → 🔍 Consultar MH → ✅ si hay sello: factura normal → ❌ si no: refund

## Ventajas

1. **Una sola función:** `action_query_mh_syncap` maneja todo (antes eran dos: `_fetch` + `action`)
2. **Código reutilizable:** `_fetch_sello_from_mh` usado tanto en creación como en botón de recuperación
3. **Mejor cobertura:** Órdenes que pierden sello en `orderstomh` ahora pueden recuperarse desde MH
4. **Booleano semántico:** `no_sello_mh` se activa solo después de agotar opciones (no sólo por ausencia en `orderstomh`)
5. **Menos tickets sin sello:** Consulta MH automáticamente antes de rendirse
