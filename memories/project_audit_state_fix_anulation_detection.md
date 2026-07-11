---
name: audit_state_fix_anulation_detection
description: Detección de órdenes anuladas en action_audit_state_fix() - 2026-05-14
metadata: 
  node_type: memory
  type: project
  originSessionId: 28e2c4a6-a4dd-4101-bad7-c7bf739de1c5
---

## action_audit_state_fix() — Detección de Anulaciones

**Fecha**: 2026-05-14

### Problema Resuelto
La función `action_audit_state_fix()` en syncap_order_support.py no detectaba órdenes anuladas, permitiendo que se enviaran incorrectamente a "pedido de venta" en lugar de marcarse como `state='refund'`.

### Indicadores de Anulación Identificados
1. **Pagos anulados**: `syncap.payment.Void = 1`
2. **Orden hacienda anulada**: `syncap.ordenestomh.isAnul = True`

### Solución Implementada (v2 - con validación de facturación)
Modificada función `action_audit_state_fix()` (línea 1470) para:
- Ejecutar auditoría estándar (estados inconsistentes)
- Buscar órdenes con `Void=1` en syncap_payment_ids
- Buscar órdenes con `isAnul=True` en syncap_ordenestomh_id **SIN restricción de estado**
  - Esto permite corregir incluso órdenes ya facturadas/pagadas
- Verifica cada orden: solo corrige si NO está ya en `refund`
- Genera logs detallados (corrección y verificación)
- Reporta solo las órdenes realmente corregidas

### Archivos Modificados
- syncap_order_support.py:1470-1487 — action_audit_state_fix()

### Validación
- ✅ Detecta órdenes anuladas correctamente
- ✅ Las marca como refund en lugar de SO
- ✅ Limpia sync_error/sync_error_msg
- ✅ Logs detallados para trazabilidad

### Referencias Internas
- [[sync_amigopos_integridad_final_20260503]] — Integridad de anulación en órdenes
- [[audit_state_fix_anulation_detection]] — Documentación en vault
