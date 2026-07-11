---
name: libro_iva_count Fix
description: Campo computado queda amarrado en borrador, solucionado con filtro de estado + invalidación de cache
type: feedback
originSessionId: 64662c5d-1c56-4ce7-8d92-69ecc212ae7a
---
**Problema**: `libro_iva_count` en `account.move` no se actualiza cuando libro vuelve a borrador (draft).

**Causa raíz**: Campo computado `libro_iva_ids` depende solo de `is_tax_declare`, no se dispara cuando se eliminan líneas relacionadas. Además, incluía libros en estado `draft`/`cancel`.

**Solución implementada** (2026-05-07):
1. Filtrar búsquedas por `('libro_iva_id.state', '=', 'open')` en `_compute_libro_iva_ids` 
2. Invalidar cache explícitamente en `draft_button_compra/ccf/fcf` → `facturas.invalidate_recordset(['libro_iva_ids', 'libro_iva_count'])`
3. Para FCF, buscar facturas del periodo antes de eliminar líneas (relación virtual sin FK directa)

**Archivos**: 
- `l10n_sv_edi/reporte_impuestos_sv/models/account_move.py` (línea 94-117)
- `l10n_sv_edi/reporte_impuestos_sv/models/libro_iva.py` (línea 73-124)

**Why**: Los cambios en modelos relacionados no disparan recomputación automática de campos Many2many. El filtro por estado es la defensa principal; invalidación de cache es respaldo para garantizar recomputación inmediata.

**How to apply**: Aplicar mismo patrón cuando otros campos computados tengan problemas de invalidación con modelos relacionados.
