---
name: Propinas no se procesaban en SO
description: Bug en cron_process_syncap_orders_line - dominio excluía is_tip y is_discount
type: bug
date: 2026-05-13
status: fixed
originSessionId: f436d718-538a-464d-ade2-aa61959c9b41
---
## El Bug
`cron_process_syncap_orders_line()` en syncap_order_line.py tenía un dominio incompleto:
- Solo buscaba por `ItemStatusId`
- Ignoraba líneas con `is_tip=True`
- Ignoraba líneas con `is_discount=True`
- Resultado: **propinas no se creaban en SO, causando descuadres**

## La Solución
Expandir dominio de 2 alternativas a 4:
```python
'|', '|', '|',  # 3 ORs = 4 alternativas
('ItemStatusId', 'in', ('1', '4')),  # líneas válidas
('ItemStatusId', '=', None),         # líneas sin status
('is_tip', '=', True),               # propinas ✅
('is_discount', '=', True),          # descuentos ✅
```

## Por Qué Pasó
El dominio original asumía que TODAS las líneas (propinas, descuentos) llegarían con un `ItemStatusId`. Pero las propinas se crean en `syncap.order.line` con `is_tip=True` y NO siempre llevan `ItemStatusId`.

## Impacto
- **Fase 1.5:** Ahora procesa correctamente propinas
- **Órdenes atascadas:** Se recuperan las propinas faltantes
- **Cuadratura:** Los SO ahora incluyen propinas → montos coinciden
