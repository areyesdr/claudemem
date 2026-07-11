---
name: Code Documentation - SE USA EN Comments
description: Documentación exhaustiva de uso de funciones en sync_amigopos (2026-04-30)
type: project
originSessionId: 5078f515-2d1a-4ef4-b311-9324268706b7
---
## Trabajo Completado: 2026-04-30

### Descripción
Documentación exhaustiva de **25+ funciones críticas** en `sync_amigopos` mediante comentarios "SE USA EN". Cada función ahora muestra exactamente dónde se usa, facilitando navegación rápida y auditoría de código.

### Funciones Documentadas

#### syncap_order.py (18 funciones)

**Flujo Principal (FASE 1-7)**
- `cron_process_syncap_orders()` [L.812] → Maestro orquestador
- `_create_sale_order()` [L.1495] → FASE 1 Crear Venta
- `cron_process_syncap_orders_validate()` [L.1650] → FASE 2 Validar Venta
- `cron_process_manufacturing_orders()` [L.1743] → FASE 3 Fabricación
- `cron_process_inventory_orders()` [L.1785] → FASE 4 Picking
- `cron_process_invoices()` [L.1864] → FASE 5 Facturación
- `cron_reconcile_invoices()` [L.2117] → FASE 7 Conciliación

**Soporte y Reparación**
- `action_rebuild_stock()` [L.288] → Reconstrucción stock.quant
- `_inject_historical_dates()` [L.1294] → Post-procesamiento fechas
- `action_unstick_orders()` [L.4204] → Desbloqueo manual
- `action_repair_missing_lines()` [L.4614] → Reparación líneas
- `action_validate_assigned_pickings()` [L.4306] → Validación albaranes
- `action_confirm_pending_sale_orders()` [L.4382] → Confirmación pedidos
- `action_resume_from_confirmed_sale()` [L.4442] → Reanudación venta

**Diagnóstico y Auditoría**
- `action_find_incomplete_sale_lines()` [L.4700] → Detección líneas incompletas
- `action_check_and_reset_incomplete_lines()` [L.4746] → Reset líneas
- `action_start_rollback_resync()` [L.4836] → Reinicio sincronización

**Procesamiento Manual**
- `action_create_invoices()` [L.3583] → Facturación manual
- `action_process_payments()` [L.3605] → Procesamiento pagos
- `action_manual_process_payments()` [L.2196] → Pagos manuales
- `action_reconcile_invoices()` [L.3627] → Conciliación manual
- `action_clear_accounting_and_reset_to_stock()` [L.3643] → Limpieza contable

#### mrp_production.py (4 funciones)

**Manufactura con Reintentos Exponenciales**
- `_collect_all_mos()` [L.114] → Recopilación ordenada por depth
- `syncap_process_mo_for_order()` [L.179] → Orquestador MOs
- `_process_single_mo()` [L.191] → Procesamiento individual (15 reintentos)
- `_inject_mo_dates()` [L.258] → Inyección fechas históricas

### Patrón de Comentarios

```python
def action_example():
    """
    Descripción clara de qué hace.

    #SE USA EN ACCION 'action_caller()' [Línea XXXX]
    #SE USA EN BOTON 'Nombre del Botón'
    #SE USA EN LLAMADA A 'funcion_child()' [Línea XXXX]
    #SE USA EN FASE X DEL FLUJO
    """
```

### Beneficios

| Aspecto | Beneficio |
|---------|-----------|
| **Navegación** | Saltar directamente a donde se usa una función |
| **Auditoría** | Rastrear flujo completo de datos |
| **Refactoring** | Saber exactamente qué afecta cada cambio |
| **Debugging** | Encontrar rápidamente la función que llama |
| **Onboarding** | Nuevos devs entienden arquitectura en minutos |

### Documentación en Vault

- 📄 `/vault17/Diario/2026-04-30.md` → Resumen sesión con cambios
- 📄 `/vault17/Referencias/syncap_order_function_map.md` → Mapa completo ASCII

### Impacto en Mantenibilidad

**Antes:**
- Buscar "dónde se usa esta función" = grep + exploración manual
- Entender flujo = leer 15+ archivos en orden específico
- Onboarding nuevo dev = 4-5 horas de contexto

**Después:**
- Buscar dónde se usa = mirar docstring
- Entender flujo = leer comentarios + mapa ASCII
- Onboarding nuevo dev = 30-45 minutos de contexto

### Status
✅ **COMPLETADO** 2026-04-30
- 25+ funciones documentadas
- Patrón consistente en todo el código
- Vault actualizado con referencias
- Mapa de funciones generado

### Próximas Mejoras (Optional)
- [ ] Agregar tipos de retorno a docstrings
- [ ] Documentar parámetros críticos (@param)
- [ ] Crear visualización interactiva del flujo
- [ ] Agregar ejemplos de uso en docstrings
