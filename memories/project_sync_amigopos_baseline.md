---
name: sync_amigopos Baseline (Frozen)
description: Estado congelado del módulo sync_amigopos v17.0.1.1 a 2026-04-29 — versión de referencia
type: project
originSessionId: 4bd1f21c-13e3-45b1-810f-96c79f8f9486
---
**Baseline de Código**: sync_amigopos v17.0.1.1  
**Congelado en**: 2026-04-29  
**Ubicación**: /home/axel/odoo/17/conectores/sync_amigopos/  
**Documentación**: [[sync_amigopos.md]] en vault

## Estado Actual
- 43 modelos Python (propios + herencias)
- 25 controladores API en AmigoOdoo/
- 3 wizards para operaciones especiales
- Sistema de logging circular (log_buffer.py) sin impact de memoria
- Dashboard OWL con componentes para sync monitor
- Indices SQL para optimización de queries

## Workflow Principal (Congelado)
Ticket AmigoPOS → syncap.order → sale.order → picking → factura → pago → reconciliado

## Qué Respetar
- Nombres de modelos Syncap no deben cambiar
- Estructura de herencias a modelos Odoo (account.move, stock.picking, etc.)
- Campos de control: `state`, `amount_subtotal`, `amount_total`, `amount_invoiced`, etc.
- Timezone handling: UTC-6 → UTC naive en DB
- Float precision: 18,2 para moneda, 18,6 para gratificación
- Sistema de logging via `log_buffer.py`

## Cambios Permitidos
- Extender modelos con nuevos campos (agregar campos, no renombrar)
- Crear nuevos controladores (no cambiar endpoints existentes)
- Mejorar queries con índices (respetar SQL_INDEXES.sql)
- Agregar tests sin afectar workflow existente
- Actualizar vistas XML (respetar XPATH)

## Cambios Prohibidos
- Renombrar modelos syncap_*
- Eliminar campos existentes (marcar como deprecated + ocultar)
- Cambiar lógica del workflow MO → Picking → Factura → Pago
- Modificar log_buffer.py sin justificación crítica
- Cambiar timezone handling sin auditoría

