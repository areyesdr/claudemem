---
name: bugs_refund_codigo_generacion_duplicate
description: Fix para codigo_generacion duplicado en creación de refund desde orden anulada - 2026-05-14
metadata: 
  node_type: memory
  type: project
  originSessionId: 28e2c4a6-a4dd-4101-bad7-c7bf739de1c5
---

## Refund codigo_generacion Duplicado

**Fecha**: 2026-05-14

### Error Original
```
ERROR: llave duplicada viola restricción de unicidad «account_move_unique_codigo_generacion»
DETALLE:  Ya existe la llave (codigo_generacion)=(D9C27FA0-287A-44E1-A946-C4104E464645).
```

Ocurría en `refund_from_amigopos_order()` al crear nota de crédito para orden anulada.

### Causa
Función usaba `codigo_anulacion` (de `syncap_ordenestomh_id.codGeneracionAnul`) sin validar que fuera diferente del código original, causando violación de unicidad.

### Solución (v2 - Robusta con UUID)
En `/home/axel/odoo/17/conectores/sync_amigopos/models/account_move.py` línea 86:

```python
import uuid

codigo_anulacion = move.syncap_ordenestomh_id.codGeneracionAnul

# Si está vacío o es igual al original → generar UUID único
if not codigo_anulacion or codigo_anulacion == move.codigo_generacion:
    codigo_anulacion = str(uuid.uuid4()).upper()
    _logger.warning(f"[REFUND] generando UUID: {codigo_anulacion}")

refund_vals = {
    'codigo_generacion': codigo_anulacion,  # Garantizado único
}
```

### Comportamiento Resultante
- Si `codGeneracionAnul` válido → úsalo
- Si está vacío → generar UUID
- Si es igual al original → generar UUID
- **GARANTIZA unicidad** evitando violación de constraint
- Compatible con l10n_sv_edi
- Logs detallados de casos donde se generó UUID de emergencia

### Archivos Afectados
- account_move.py: refund_from_amigopos_order() — validación de codigo_anulacion
