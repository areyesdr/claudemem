---
name: commit_documentation_workflow
description: Flujo obligatorio de documentación antes de cada commit en módulos Odoo 17
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 61be9c07-71e9-4e21-ab67-c26a2dc0d0d8
---

## 🔴 INSTRUCCIÓN BASE PARA TODOS LOS DEVS

**Esta instrucción debe aplicarse ANTES de cada commit al repo.**

### Pasos Obligatorios

1. **Actualizar README del Módulo** (`localizacion/<modulo>/README.md`)
   - Crear archivo si no existe
   - Agregar sección "Cambios Recientes (vX.Y)"
   - Documentar:
     - Problema resuelto
     - Solución implementada
     - Campos modificados/nuevos
     - Comportamiento nuevo
     - Configuración si aplica

2. **Actualizar README del Repo** (`/home/axel/odoo/17/README.md`)
   - Agregar entrada en sección "Cambios Recientes"
   - Formato:
     ```markdown
     #### <módulo> (vX.Y)
     **<Título Descriptivo>**
     
     - Cambio 1
     - Cambio 2
     
     **Archivos Modificados:**
     - ruta/archivo.py (+X líneas, descripción)
     ```
   - Incluir fecha (YYYY-MM-DD)
   - Listar todos los archivos tocados

3. **Subir Versión del Módulo** (`__manifest__.py`)
   - Versión base: 17.X
   - Incrementar X por cambio/commit
   - Ejemplo: 17.8 → 17.9 → 17.10
   - Actualizar también tabla de versionado en README del repo

### Plantilla Mínima

```python
# En __manifest__.py
'version': '17.X',  # incrementar X

# En README.md del módulo
## Cambios Recientes (vX.Y)

### Descripción del Cambio
**Problema:** ...
**Solución:** ...
**Archivos Modificados:**
- models/file.py
- views/file.xml
```

### Why

- **Trazabilidad**: Git history sin commits frecuentes no es suficiente, README es el source of truth
- **Onboarding**: Nuevos devs entienden rápido qué hace cada módulo
- **Auditoría**: Cambios contables/fiscales deben estar documentados
- **Rollback**: Si es necesario deshacer, README + versión facilita identificar qué revertir

### How to Apply

Antes de hacer `git commit`:
1. Abre el README del módulo
2. Agrega tu cambio con fecha y versión
3. Actualiza README del repo
4. Incrementa versión en __manifest__.py
5. Luego sí, commit

### No Skip

Esta es una regla **NON-NEGOTIABLE** para todos los commits. No es opcional.

Relacionado: [[git_workflow_rules]] (git es solo lectura, solo documentar cambios aquí)
