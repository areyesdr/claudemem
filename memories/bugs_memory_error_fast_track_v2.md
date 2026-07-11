---
name: memory_error_fast_track_v2_optimization
description: Optimizaciones v2 para MemoryError en cron_fast_track_invoices - Pre-carga SQL + limpieza agresiva
metadata: 
  node_type: memory
  type: bug
  date: 2026-05-19
  status: optimization_completed
  related: fast_track_memory_error_fix
  originSessionId: 132c983f-424b-4140-bff2-53fcd63dda56
---

## Optimizaciones Implementadas (2026-05-19)

### Root Cause Analysis
El MemoryError no era solo saturación de cache pasivo, sino **búsquedas repetitivas en ORM dentro del loop**:
- Cada orden hacía `.search()` para verificar facturas existentes (línea 1001-1005)
- Con 230 órdenes = 160+ búsquedas que cargaban account.move completo en cache
- Cada búsqueda cargaba: relaciones, validadores, campos computados, etc.

### Cambios Implementados

1. **Pre-carga SQL (Línea ~890)**
   - Recolectar todos `codigo_generacion` de órdenes
   - 1 query SQL para obtener todas facturas existentes
   - Almacenar en diccionario para O(1) lookup
   - Impacto: 160+ búsquedas ORM → 1 query SQL

2. **Uso de Diccionario (Línea ~1010-1015)**
   - Cambiar de `CompanyModel.env['account.move'].search([...])` 
   - A: `existing_invoices_by_codigo.get(codigo_key)`
   - Impacto: O(n) búsqueda → O(1) lookup, sin cargar cache

3. **Limpieza Más Agresiva (Línea ~1062-1065)**
   - De `idx % 10 == 0` → `idx % 5 == 0`
   - Limpieza cada 5 órdenes en lugar de 10
   - Agregada limpieza adicional en rescate idempotencia

4. **prefetch_fields=False en Search (Línea ~876-877)**
   - `.with_context(prefetch_fields=False)` en búsqueda de órdenes
   - Evita cargar campos computados innecesarios

5. **Batch Size Reducido (Línea ~837)**
   - De `default=100` → `default=50`
   - Procesa 50 órdenes por ejecución (más manejable)

### Archivo Modificado
- `/home/axel/odoo/17/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order_cron.py`

### Testing Necesario
1. Ejecutar cron con 500+ órdenes
2. Monitorear memoria (RSS)
3. Verificar contador completando sin MemoryError
4. Si aún hay issues, investigar `_fetch_sello_from_mh()` o validators de account.move

## Critical Discovery: Inverse Fields (v3)

**Root Cause**: No era solo N+1 queries, sino **campos inversos en account.move.partner_id**:
1. Durante `account.move.create()`, Odoo procesa `determine_inverse` para relaciones
2. El campo `partner_id` dispara un campo inverso que escribe en `res.partner`
3. Eso carga: mail, followers, activities, web_map, snailmail, etc.
4. Con 230+ órdenes en loop, cache se satura de mail data

**Solución v3**: Diferir `partner_id` a post-creación
- Crear factura SIN partner_id → evita campo inverso en creación
- Asignar partner_id con `write()` después → cache ya limpio
- **Impacto**: Evita saturación de 230+ campos inversos en loop

## Why This Works
- **Bulk Load**: Cargar datos ANTES del loop evita saturación incremental
- **SQL vs ORM**: SQL queries directas no cargan relaciones complejas en cache
- **Frequent Cleanup**: Cada 5 órdenes garantiza que cache nunca crece demasiado
- **Reduced Batch**: 50 órdenes es mucho más manejable que 100/500
- **Deferred Fields**: No disparar campos inversos problemáticos durante creación
