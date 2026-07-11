---
name: Fast-Track Taxes Company Validation
description: Filtrado de impuestos por compañía para evitar error de validación nativa
type: bug
originSessionId: d39efe1e-d529-4566-87f9-50574051d266
---
## Error Original
```
[FAST-TRACK] ❌ ERROR: Empresas incompatibles con los registros:
- '[CVIP3]...' pertenece a 'AIRPORT...' y 'Taxes' (tax_ids: ...) pertenece a otra compañía.
```

## Root Cause
- Odoo nativo valida en `_check_company_consistency()` (models.py:4100+)
- Los `tax_ids` asignados desde productos podían pertenecen a compañías diferentes
- Cuando se creaba factura con `company_id: config.branch_id.id`, los taxes no coincidían

## Solución Implementada (2026-05-05)
**Archivo**: `/home/axel/odoo/17/conectores/sync_amigopos/models/models_syncap/syncap_order/syncap_order_cron.py:709-755`

Agregado función `filter_taxes_by_company()` que retorna solo taxes de la compañía:
```python
def filter_taxes_by_company(product, company_id):
    if not product.taxes_id:
        return []
    return product.taxes_id.filtered(
        lambda t: not t.company_id or t.company_id.id == company_id
    ).ids
```

Se aplica a 3 líneas de factura:
1. Consumo (product_misc_id)
2. Descuento (product_desc_id)
3. Propina (product_tip_id)

## Status
✅ Código aplicado - Pendiente prueba en cron
