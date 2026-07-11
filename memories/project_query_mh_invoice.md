---
name: Query MH from Invoice
description: Funciones para consultar sello de Hacienda desde account.move con botón
type: project
originSessionId: 560a6ff4-4325-4576-9ce2-34c5dd888842
---
# Query Hacienda desde Invoice — 2026-04-30

**Implementación**: Funciones `_fetch_mh_seal()` y `action_query_mh()` en `l10n_sv_edi/models/account_move.py` + botón "Consultar Hacienda" en vista XML.

## Qué hace
Permite a usuarios consultarla API pública de Hacienda directamente desde una factura (`account.move`) para obtener el sello digital si no está registrado, y generar los links de consulta (QR y link directo).

## Archivos modificados
1. `/home/axel/odoo/17/l10n_sv_edi/l10n_sv_edi/models/account_move.py`
   - Línea 4134: `_fetch_mh_seal()` — GET a `/prod/consultas/publica/simple/1`
   - Línea 4220: `action_query_mh()` — Handler del botón

2. `/home/axel/odoo/17/l10n_sv_edi/l10n_sv_edi/views/account_move.xml`
   - Línea 51: Botón en xpath de acciones DTE
   - Línea 59: Campo `codigo_generacion` agregado a DOM oculto

## Detalles técnicos
- **Endpoint**: `https://admin.factura.gob.sv/[prod|dev]/consultas/publica/simple/1`
- **Parámetros**: `codigoGeneracion`, `fechaEmi` (YYYY-MM-DD), `ambiente` (00=pruebas, 01=prod)
- **Respuesta esperada**: JSON con campos como `selloRecibido`, `sello` o `selloMH`
- **Timeout**: 15 segundos
- **Campos llenados**: `sello_digital`, `invoice_code_link_mh`, `invoice_qr_code`, `portal_url`

## Visibilidad del botón
- Solo si: `state='posted'` AND `codigo_generacion` AND `invoice_date` AND `is_edi_company=True`
- Clase: `btn-info` (azul informativo)

## Auditoría
- Ambos casos (éxito/error) dejan una nota en el chatter para trazabilidad
- Nota incluye: código de generación, fecha, sello obtenido (primeros 50 caracteres)
- Maneja errores: timeout, conexión, JSON inválido, respuesta HTTP ≠ 200

## Reutilización
- Usa `_build_mh_url()` (línea 1541) para generar URLs de consulta
- Usa `_generate_portal_url()` (línea 542) para URL del portal
- Usa `_requests_session` (línea 35) — sesión HTTP reutilizable
