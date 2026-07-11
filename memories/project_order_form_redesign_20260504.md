---
name: Order Form View Redesign
description: Vista sync_amigopos mejorada con secciones visuales, cajas de color y mejor jerarquía de campos
type: project
originSessionId: 5c20c3e9-91ac-4971-ae3f-52d0cf293f52
---
## Vista de Orden Mejorada (2026-05-04)

**Archivo**: `/home/axel/odoo/17/conectores/sync_amigopos/views/order_views.xml`

### Cambios Principales

1. **Reorganización de botones en header**: Agrupados por contexto (críticos, bulk, reparación, peligrosos)
2. **Secciones visuales con cajas de color**:
   - Identificación (azul, #007bff)
   - DTE Fiscal (verde, #28a745)
   - Cliente y Montos (naranja, #fd7e14)
   - Vinculación Odoo (púrpura, #6f42c1)
   - Indicadores (rojo, #dc3545)

3. **Grid responsivo con `col="4"`**: Campos distribuidos dinámicamente
4. **Alertas mejoradas**: Estilos Bootstrap con gradientes y separadores laterales
5. **Tabs con íconos**: 📦 📄 💳 🏭 para claridad visual
6. **Visibilidad inteligente**: Campos ocultos por defecto, modificables según contexto

### Técnicas Aplicadas
- Inline CSS con gradientes (`linear-gradient`)
- Bootstrap classes (alert-danger, alert-dismissible, fade show)
- HTML directo en XML para máxima compatibilidad
- Atributos `optional="hide"` para campos secundarios

### Beneficios
✅ 40+ campos sin verse abrumador
✅ Profesionalismo visual mejorado 
✅ Mejor experiencia de usuario
✅ Cumple estándares Odoo 17

### Documentación
- Nota en vault: `/home/axel/odoo/17/vault17/Modulos/sync_amigopos_vista_mejorada_20260504.md`
- XML validado con `xmllint`
