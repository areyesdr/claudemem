---
name: Fast-Track Taxes Company Validation (Multicompany Fix)
description: Filtrado de impuestos con fallback automático para evitar error de validación nativa
type: bug
originSessionId: d39efe1e-d529-4566-87f9-50574051d266
---
## Error Original
```
[FAST-TRACK] ❌ ERROR: Empresas incompatibles con los registros:
- '[CVIP3]...' pertenece a 'AIRPORT...' y 'Taxes' (tax_ids: ...) pertenece a otra compañía.
```

## Root Cause
- Sistema es **multicompany**: productos compartidos, taxes asignados a compañías específicas
- Odoo nativo valida en `_check_company_consistency()` (models.py:4100+)
- Los `tax_ids` asignados desde productos no coincidían con company_id de factura

## Solución Implementada (2026-05-05)
**Estrategia**: Filtrado con fallback automático

**Archivo 1**: `syncap_order_cron.py` líneas 709-758
- Función `get_valid_taxes()`: filtra taxes por compañía, usa fallback si no hay válidos
- 3 fallbacks inteligentes:
  - Consumo → `account_tax_iva_id`
  - Descuento → `account_tax_id` (exento)
  - Propina → `account_tax_iva_id`

**Archivo 2**: `syncap_config.py` líneas 34-41
- Dominios en campos product_*_id para filtrar por compañía en UI
- Previene selección de productos de otras compañías

## Status
✅ Implementado - Doble validación: filtrado en código + dominios en UI
