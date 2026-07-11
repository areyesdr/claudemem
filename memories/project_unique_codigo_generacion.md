---
name: Unique Codigo Generación - Fix
description: Solución al error de duplicate unique constraint en codigo_generacion de facturas DTE
type: project
originSessionId: 2e413636-9661-4220-9f5b-4253b1a71eb9
---
## Problema Identificado

**Error:** `llave duplicada viola restricción de unicidad «account_move_unique_codigo_generacion»`

El cron `cron_process_invoices()` intentaba crear facturas nuevas sin validar si ya existían con el mismo `codigo_generacion` (UUID del DTE).

**Tickets afectados:** 13147-13183 (30+ errores por cron run)

## Causa Raíz

El código en `conectores/sync_amigopos/models/syncap_order.py` línea ~1705:
1. Creaba factura NUEVA vía `sale.advance.payment.inv` wizard
2. Escribía `codigo_generacion` sin verificar si ya existía
3. PostgreSQL rechazaba por unique constraint

## Solución Implementada

**Archivo:** `conectores/sync_amigopos/models/syncap_order.py`
**Función:** `cron_process_invoices()` (línea 1650+)

### 3 Cambios Clave:

1. **Búsqueda previa por `codigo_generacion`** (antes de crear factura)
   - Si existe: Reutilizar
   - Si no existe: Crear nueva

2. **Validación antes de write()** 
   - Si `codigo_generacion` ya está en factura, no intentar sobrescribir
   - Evita write innecesarios que podrían fallar

3. **Try-catch robusto en `action_post()`**
   - Si factura ya posted, no fallar
   - Log info en lugar de error

## Versión

- **Implementado:** 2026-04-29
- **Línea inicio:** 1685
- **Línea fin:** 1820
- **Cambios:** +45 líneas (búsqueda + validaciones)

## Testing Pendiente

- [ ] Ejecutar cron con tickets DTE
- [ ] Verificar que NO hay error unique constraint
- [ ] Verificar logs INFO sobre reutilización
- [ ] Verificar que `syncap_order_id` está correctamente vinculado
- [ ] Verificar que facturas se cierren con estado 'done_invoice'

## Documentación

- Bug report: `/vault17/Bugs/bug_unique_codigo_generacion_duplicado.md`
- Solution doc: `/vault17/Bugs/bug_solucion_unique_codigo_generacion.md`

## Backward Compatibility

✓ Totalmente compatible - no hay cambios en modelos ni constraintss
✓ Flujos FÍSICO y NINGUNO sin cambios
✓ Solo optimiza flujo DTE evitando duplicados
