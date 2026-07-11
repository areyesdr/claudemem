---
name: Módulo l10n_sv_dte
description: Nuevo módulo de facturación electrónica DTE para El Salvador, arquitectura modular, independiente de l10n_sv_edi
type: project
---

Módulo `l10n_sv_dte` en desarrollo desde 2026-04-06.

**Ruta:** `/home/axel/odoo/17/l10n_sv_edi/l10n_sv_dte/`

**Why:** Reemplazar/mejorar `l10n_sv_edi` con arquitectura limpia: mixins separados, log de comunicaciones, validación por schema JSON, generación de QR propio, templates PDF por tipo de documento.

**How to apply:** Al trabajar en facturación electrónica SV, este módulo es la base. No modificar `l10n_sv_edi`; extender desde `l10n_sv_dte` o crear módulos que dependan de él.

Estado actual (2026-04-06): estructura base completa (7 modelos, 4 vistas, 5 templates QWeb, datos de 13 tipos DTE). Pendiente: wizard contingencia, acción invalidación, template correo, tests.

Schemas Hacienda en: `static/src/schemas/` (13 archivos JSON).
Documentación detallada en vault: `/home/axel/odoo/17/vault17/Modulos/l10n_sv_dte.md`
