---
name: SQL Multiple Queries Fix
description: PostgreSQL no permite múltiples sentencias SQL en un único execute()
type: project
originSessionId: 5078f515-2d1a-4ef4-b311-9324268706b7
---
## Problema Detectado
Error en logs del cron (Ticket 7136):
```
ERROR: error de sintaxis en o cerca de «]»
LÍNEA 4: ]                              create_date='2026-01-16T02:57...
```

## Causa Raíz
Función `_force_picking_dates_sql_massive()` en `syncap_order.py` (línea 2922-2946) intentaba ejecutar **4 sentencias UPDATE en un único `self.env.cr.execute()`**:

```python
self.env.cr.execute("""
    UPDATE stock_picking ...;
    UPDATE stock_move ...;
    UPDATE stock_move_line ...;
    UPDATE stock_valuation_layer ...;
    """, (hist_date, ...))  # ❌ PostgreSQL NO lo permite
```

PostgreSQL a través de **psycopg2 rechaza múltiples sentencias** en una sola llamada `execute()`. El `;` cierra la primera query y PostgreSQL intenta parsear `] UPDATE ...` como SQL, causando error.

## Solución Implementada
Separar cada sentencia SQL en su propio `execute()`:

```python
# ✅ Ejecutar cada query por SEPARADO
self.env.cr.execute("""UPDATE stock_picking SET ... WHERE id IN %s""", (hist_date, picking_tuple))
self.env.cr.execute("""UPDATE stock_move SET ... WHERE picking_id IN %s""", (hist_date, picking_tuple))
self.env.cr.execute("""UPDATE stock_move_line SET ... WHERE picking_id IN %s""", (hist_date, picking_tuple))
self.env.cr.execute("""UPDATE stock_valuation_layer SET ... WHERE ...""", (hist_date, picking_tuple))
```

## Status
✅ **ARREGLADO** en `/home/axel/odoo/17/conectores/sync_amigopos/models/syncap_order.py` (2026-04-30)

## Regla para Futuro
**NUNCA** integrar múltiples sentencias SQL en un único `execute()`:
- ❌ Prohibido: `execute("UPDATE ... ; UPDATE ...")`
- ✅ Permitido: Múltiples `execute()` secuenciales
- ✅ Permitido: `execute()` envuelto en savepoint para atomicidad

## Implicaciones
- No hay cambios en comportamiento funcional
- Las 4 queries se ejecutan secuencialmente (casi tan rápido como antes)
- Los `invalidate_model()` aplican igual después

## Referencias
- Función afectada: `_force_picking_dates_sql_massive()` (línea 2912)
- Llamadas desde:
  - `action_fix_bom_and_reprocess_stock()` (línea 3021, 3051)
  - `action_return_picking()` (línea 3263)
- Nota en vault: `/home/axel/odoo/17/vault17/Bugs/sql_syntax_error_multiples_sentencias.md`

**Why:** PostgreSQL + psycopg2 limitación de seguridad (prevent SQL injection)
**How to apply:** Patrón: 1 execute() = 1 sentencia SQL
