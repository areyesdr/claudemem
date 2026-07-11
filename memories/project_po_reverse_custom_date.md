---
name: po_reverse_custom_date_implementation
description: Implementación completada de fecha personalizada en PO reverse workflow
metadata: 
  node_type: memory
  type: project
  originSessionId: 9870035e-7309-4d60-aa91-3cb4712715f9
---

## Fecha Personalizada en Compra Inversa (l10n_sv_purchase_order_reverse)

**Completado:** 2026-07-10

### Problema
Mercancía llega con fecha distinta a factura de proveedor → sistema forzaba fecha de factura a todos registros (PO/picking/SVL) → distorsión AVCO. 

**Por qué:** Promedio ponderado AVCO es sensible a orden cronológico de compras. Si insertas compra en fecha incorrecta, recalcula promedio de TODAS compras posteriores.

### Solución Implementada

**3 capas:**

1. **Vista & Validación (wizard_po.py)**
   - Campo `custom_date` siempre visible (no más lógica `invisible=`)
   - Método `_validate_custom_date()`: rechaza fecha futura + advierte si > 1 año antes de factura
   - Action confirma y pasa `custom_date` a `action_create_po_and_receive()`

2. **Propagación de Fecha (account_move.py)**
   - Prioridades claras: `custom_date` > `fecha_hora_emision` DTE > `invoice_date`
   - Contexto `po_reverse_force_date` inyectado en `safe_ctx` → propagado a PO/picking
   - Logging [CUSTOM_DATE], [DTE_DATE], [INVOICE_DATE] para auditoría

3. **Consumidores (purchase_order.py, stock_picking.py)**
   - Ya buscaban `po_reverse_force_date` en contexto (estaba no usado)
   - Ahora lo encuentran y lo aplican correctamente

### Cambios Puntuales

| Archivo | Qué | Por qué |
|---------|-----|--------|
| `wizard/wizard_po.py` | +imports timedelta, +`_validate_custom_date()` | Validar fecha realista sin break AVCO |
| `wizard/wizard_select_warehouse.xml` | Quitar `invisible="not confirm_albaran"` | Campo debe estar siempre visible |
| `models/account_move.py` | +contexto `po_reverse_force_date`, +logging de prioridad | Propagar fecha a PO/picking correctamente |

### Flujo de Usuario

1. Abrir wizard "Crear PO y Recibir" desde factura
2. En línea: llenar optional `custom_date` (si vacío → usa prioridades)
3. Confirmar → validación → crea PO/picking con fecha correcta
4. AVCO repair wizard ejecuta automáticamente post-backdating

### Casos Manejados

- ✅ Mercancía llega antes: `custom_date` = fecha real llegada
- ✅ Mercancía llega después: `custom_date` = fecha real llegada  
- ✅ DTE con hora: prioridad 2, automático si no hay custom_date
- ✅ Factura normal: prioridad 3, fallback siempre
- ✅ Fecha futura: rechazada (error de usuario)
- ✅ Fecha antigua: advertencia AVCO pero permitida (usuario decide)

### Auditoría

Log muestra qué fecha se usó en cada factura:
```
[CUSTOM_DATE] INV-2026-001 usa fecha personalizada: 2026-06-15 10:30:00
[DTE_DATE] INV-2026-002 usa fecha/hora de emisión DTE: 2026-06-16 15:45:00
[INVOICE_DATE] INV-2026-003 usa fecha de factura: 2026-06-17 23:59:00
```

Rastreable via BD: cada PO/picking/SVL tiene timestamps correctos.

### No Requiere

- Config empresa (automático)
- Cambios UI principales (solo vista wizard)
- Campos nuevos en modelos (usa parametro existente `custom_date`)
- Cambios instalación (deps no cambian)
