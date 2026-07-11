---
name: Orquestador Maestro - Secuencia Estricta
description: Reescritura de cron_process_syncap_orders con garantía de precedencias
type: project
originSessionId: 5078f515-2d1a-4ef4-b311-9324268706b7
---
## Cambio Crítico: 2026-04-30

### Problema Resuelto

El orquestador anterior procesaba **todas las fases en un lote**, permitiendo que órdenes saltaran fases:

```
ANTES (❌ PROBLEMA):
for loop in range(5):
    orders = self.search(...)
    
    # FASE 1
    draft = orders.filtered(state='draft')
    procesar_fase_1(draft)
    
    # FASE 3
    to_mo = orders.filtered(state='done_sale')  # ❌ Sin verificar sale.order.state
    procesar_fase_3(to_mo)
    
    # FASE 4
    to_pick = orders.filtered(state='done_mo')  # ❌ Sin verificar MO.state
    procesar_fase_4(to_pick)
```

**Impacto**: Con 4000 órdenes, caos completo. Órdenes avanzaban sin completar fases.

### Solución: Loops Secuenciales

```python
# DESPUÉS (✅ GARANTIZADO):

# FASE 1: Completa ANTES de pasar a FASE 2
while True:
    draft = self.search([('state', '=', 'draft'), ('sale_order_id', '=', False)])
    if not draft: break
    procesar_fase_1(draft)

# FASE 2: Completa ANTES de pasar a FASE 3
while True:
    to_validate = self.search([('state', 'in', ['done_sale_created', 'done_sale_sent'])])
    if not to_validate: break
    procesar_fase_2(to_validate)

# FASE 3: GARANTÍA - Solo procesa si sale.order.state == 'sale'
while True:
    to_mo = self.search([
        ('state', '=', 'done_sale'),
        ('sale_order_id.state', '=', 'sale')  # ← CLAVE
    ])
    if not to_mo: break
    procesar_fase_3(to_mo)
```

### Eliminación de Cuarentena

**Campos Removidos:**
- `sync_error` (Boolean)
- `sync_error_msg` (Char)
- `sync_retries` (Integer)
- Función `_rescue_quarantine_orders()`

**Razón:**
- Mecanismo escribía `sync_error=True` en excepciones
- Pero nunca se usaba en 4000 órdenes
- Rescate era lento: 20 órdenes/ciclo, solo si `retries < 3`
- Órdenes quedaban atrapadas invisiblemente

**Nueva Estrategia:**
- Si falla en FASE 3 → reintentos exponenciales en mismo ciclo
- Si sobrevive a reintentos → queda en estado intermedio pero visible en logs
- No hay "cuarentena invisible"

### Cambios en Código

```python
# ANTES (línea ~914-918):
order.write({
    'sync_error': True,
    'sync_error_msg': str(e)[:250],
    'sync_retries': order.sync_retries + 1
})

# DESPUÉS:
# Solo log, sin escribir campos de cuarentena
```

### Verificaciones de Precedencia Agregadas

**FASE 3 → MO:**
```python
to_mo = self.search([
    ('state', '=', 'done_sale'),
    ('sale_order_id.state', '=', 'sale'),  # ← Verificación
])
```

**Garantía:** Una orden NO puede pasar a MO si su sale.order no está confirmado.

## Logging Mejorado

### Antes
```
[SYNC] Lote 1/5 | Procesando 50 órdenes en PIPELINE BATCH.
```

### Después
```
[FASE-1] Procesando 50 órdenes → sale.order
[FASE-1] Procesando 30 órdenes → sale.order
[FASE-2] Confirmando 50 sale.orders hasta state='sale'
[FASE-3] Procesando 50 fabricaciones → MO.done
[FASE-4] Validando 50 albaranes → picking.done
[FASE-5] Facturando 50 órdenes → invoice.posted
[FASE-6] Procesando pagos para 50 órdenes
[FASE-7] Conciliando 50 órdenes
[SYNC] ✅ Pipeline completo: todas las fases ejecutadas en secuencia estricta
```

## Garantías Implementadas

✅ FASE 1 completa → sale.order existe
✅ FASE 2 completa → sale.order.state = 'sale'
✅ FASE 3 completa → MO.state = 'done'
✅ FASE 4 completa → picking.state = 'done'
✅ FASE 5 completa → invoice.state = 'posted'
✅ FASE 6 completa → payment existe
✅ FASE 7 completa → reconciliation done

## Impacto Esperado

| Métrica | Antes | Después |
|---------|-------|---------|
| Órdenes sin completar FASE 1 | Posible | ❌ Imposible |
| Órdenes avanzando sin precedencias | Común | ❌ Imposible |
| Órdenes atrapadas en cuarentena | Invisible | ❌ No existen |
| Tiempo para completar 4000 órdenes | Variable | Predecible |
| Debugging difficultad | Alta | Baja |

## Testing Recomendado

```bash
# Con 20-30 órdenes simultáneas:
- Buscar logs [FASE-X] en orden
- Verificar que se completan las fases en secuencia
- Monitorear que no hay órdenes atrapadas
- Validar conteos de len() en cada fase

# Red flags:
- Órdenes saltando fases (ej: done_sale sin pasar por FASE 2)
- Estado de sale.order != 'sale' cuando order.state='done_sale'
- MO en estado 'confirmed' cuando order.state='done_mo'
```

## Status
✅ **IMPLEMENTADO** 2026-04-30
- 7 loops while secuenciales
- Verificaciones de precedencia
- Cuarentena eliminada
- Logging por fase
