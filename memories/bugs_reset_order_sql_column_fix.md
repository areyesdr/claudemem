---
name: bugs_reset_order_sql_column_fix
description: Fix para error de nombre de columna SQL en reset_order() - ticketid case sensitivity
metadata: 
  node_type: memory
  type: project
  date: 2026-05-14
  originSessionId: 28e2c4a6-a4dd-4101-bad7-c7bf739de1c5
---

## Reset Order - SQL Column Naming Fix

**Fecha**: 2026-05-14

### Error Original
```
ERROR: no existe la columna sp.TicketID
transacción abortada, las órdenes serán ignoradas hasta el fin de bloque de transacción
```

Ocurría en `reset_order()` al ejecutar SELECT sobre `syncap_payment sp` con WHERE clause erróneo.

### Causa
PostgreSQL es case-sensitive con nombres de columna. El SQL usaba `sp.TicketID` (mayúsculas) pero la columna en la tabla es `ticketid` (minúsculas).

Afectaba 3 sentencias SQL en syncap_order_cron.py:
- Línea 1351: SELECT de pagos
- Línea 1444: UPDATE syncap_order_line 
- Línea 1446: UPDATE syncap_payment

### Solución (v1 - Corregida 2026-05-14)
En `/home/axel/odoo/17/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order_cron.py`:

**Línea 1351** (antes → después):
```sql
WHERE sp.TicketID = %s
→
WHERE sp.ticketid = %s
```

**Línea 1444**:
```sql
WHERE TicketID = %s
→
WHERE ticketid = %s
```

**Línea 1446**:
```sql
WHERE TicketID = %s
→
WHERE ticketid = %s
```

### Comportamiento Resultante
- ✅ SQL queries no fallan por column name mismatch
- ✅ Transaction no aborta, permitiendo reset normal
- ✅ reset_order() puede procesar órdenes sin cascade de errores
- ✅ No rompe compatibilidad - solo corrige case sensitivity

### Archivos Afectados
- syncap_order_cron.py: reset_order() — 3 sentencias SQL corregidas
