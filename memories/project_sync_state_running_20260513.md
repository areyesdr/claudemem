---
name: sync_state_running_integration_20260513
description: Integración de estado syncap_sync_running en los 4 crons de sync_amigopos
metadata: 
  node_type: memory
  type: project
  date: 2026-05-13
  status: completado
  originSessionId: 19c0a134-7772-4929-8702-c45e60b4ab5a
---

# Integración: syncap_sync_running en todos los crons

## Cambios Realizados (2026-05-13)

### syncap_order_cron.py

Agregada lógica de estado a los 4 crons:

#### 1. cron_continuous_flow_syncap_orders (Flujo Continuo)
- **Inicio del loop**: `company.syncap_sync_running = True`
- **Finally**: Calcula `final_total = CompanyModel.search_count(base_domain)`
  - `final_total == 0` → `syncap_sync_running = False` ✅ COMPLETADO
  - `final_total > 0` → Mantiene `True` ⏳ CONTINÚA

#### 2. cron_process_syncap_orders (Orquestador de Fases)
- **Inicio del loop**: `company.syncap_sync_running = True`
- **Finally**: Usa `final_pending` (ya calculado al final del try)
  - `final_pending == 0` → `syncap_sync_running = False` ✅ COMPLETADO
  - `final_pending > 0` → Mantiene `True` ⏳ CONTINÚA

#### 3. cron_fast_track_invoices (Fast Track)
- **Inicio del loop**: `company.syncap_sync_running = True`
- **Finally**: Calcula dinámicamente órdenes pendientes:
  ```python
  remaining_domain = [
      ('company_id', '=', company.id),
      ('invoice_ids', '!=', False),
      ('used_fast_track', '!=', True),
      ('state', 'not in', ['done_reconciled', 'refund']),
  ]
  # + filtro por sync_no_dte
  ```
  - `remaining_count == 0` → `syncap_sync_running = False` ✅ COMPLETADO
  - `remaining_count > 0` → Mantiene `True` ⏳ CONTINÚA

#### 4. cron_reset_orders_masivo (Reseteador)
- **Inicio del loop**: `company.syncap_sync_running = True`
- **Finally**: Siempre `syncap_sync_running = False` (procesa sin batch = termina todo)

### controllers/main.py

Correcciones a métodos que sobrescribían el estado:

1. **run_sync()** (línea 479)
   - Antes: `company.syncap_sync_running = False` (sobrescribía)
   - Ahora: `pass` (permite que el cron decida)

2. **resume_sync()** (línea 427)
   - Antes: `company.syncap_sync_running = False`
   - Ahora: Solo limpia `company.syncap_stop_requested = False`

3. **activate_continuous_sync()** (línea 441)
   - Antes: `company.syncap_sync_running = False` (sobrescribía)
   - Ahora: `pass` (permite que el cron decida)

## Integración con Dashboard

El dashboard (`get_sync_info()`) ya lee:
```python
running = company.syncap_sync_running
```

Y aún tiene fallback inteligente:
- Si `pending_count > 0` → `running = True`
- Si `last_activity < 5 min` → `running = True`

## Testing Manual

Para verificar que funciona:

1. Activa un cron manualmente desde el dashboard
2. Verifica que `company.syncap_sync_running` = True
3. Cuando el cron termina:
   - Si `final_pending > 0` → `running = True` (ícono sigue parpadeando)
   - Si `final_pending == 0` → `running = False` (ícono desaparece)

```bash
# En Odoo shell:
env['res.company'].browse(1).syncap_sync_running
```

## Campos Relacionados

- `syncap_sync_running`: Flag que indica si hay sincronización activa
- `syncap_pending_orders_count`: Contador de órdenes pendientes (actualizado internamente)
- `syncap_last_sync_activity`: Timestamp de última actividad (Datetime.now() al finalizar)
- `syncap_stop_requested`: Flag para solicitar parada (limpiado por resume)

