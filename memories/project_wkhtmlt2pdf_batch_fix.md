---
name: wkhtmlt2pdf_batch_fix
description: Corrección de integración del módulo wkhtmlt2pdf_batch con account_reports
metadata: 
  node_type: memory
  type: project
  originSessionId: 095cf739-853c-4561-b2a7-983352d4e6e1
---

# wkhtmlt2pdf_batch - Corrección Final v3 (2026-05-19)

## Problema
PDFs grandes (especialmente Libro Mayor) tardaban **5+ minutos** o fallaban con errores de file descriptors. El módulo original solo soportaba reportes QWeb, no account_reports.

**Why:** El HTML se generaba correctamente pero wkhtmltopdf tardaba muchísimo procesando HTMLs > 5MB.

## Solución v3 (Estrategia Robusta)

**Cambio clave:** Interceptar `_run_wkhtmltopdf()` - el método que REALMENTE convierte HTML a PDF

### Arquitectura
```
ir.actions.report._run_wkhtmltopdf()
  ├─ Si HTML > 5MB: divide + PDF chunks + fusiona
  └─ Sino: wkhtmltopdf directo
```

### Ventajas v3
- ✅ Funciona con **CUALQUIER reporte** (QWeb, account_reports, custom)
- ✅ Divide donde se gasta tiempo (HTML→PDF)
- ✅ Sin overhead para reportes pequeños
- ✅ Compatible PyPDF2 v1 y v2+

## Archivos Finales
- ✅ `models/ir_action_report.py` — Intercepta `_run_wkhtmltopdf()` + `_split_html_by_size()`
- ✅ `models/account_report.py` — Vacío (no necesita override)
- ✅ `models/__init__.py` — Imports

## Parámetros
- `base.wkhtmltopdf_max_files` = 20 (docs por chunk en QWeb)
- `base.wkhtmltopdf_max_html_size` = 5MB (HTML antes de dividir)

**How to apply:** Instalar/actualizar. Ya funciona.

Documentación: [[wkhtmlt2pdf_batch_fix]]
