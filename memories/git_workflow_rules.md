---
name: Git Workflow Rules
description: Reglas estrictas sobre operaciones de git en el proyecto Odoo 17
type: feedback
originSessionId: 87e43e69-7bed-4c1d-a82d-a706dbecf86e
---
## Reglas de Git (CRÍTICAS)

**Git es SOLO LECTURA. Nunca hacer operaciones de escritura.**

### ✅ PERMITIDO (Lectura)
- `git log` — revisar historial
- `git show <commit>` — ver contenido de commits
- `git diff` — comparar cambios
- `git status` — ver estado del repo
- `git reflog` — revisar historial de operaciones

### ❌ PROHIBIDO (Escritura)
- ❌ `git commit` — NUNCA hacer commits automáticos
- ❌ `git push` — NUNCA hacer push a ramas
- ❌ `git add` — NUNCA stagear cambios
- ❌ `git reset` — NUNCA resetear commits
- ❌ `git branch` — NUNCA crear/eliminar ramas
- ❌ Cualquier operación de escritura en git

### Workflow Correcto

1. **Usuario edita archivos** → Cambios manuales en archivos (Edit, Write tools)
2. **Usuario decide cuándo committear** → `git add` y `git commit` manual
3. **Usuario decide cuándo pushear** → `git push` manual
4. **Yo solo leo información** → git log, show, diff, status

### Por Qué

El usuario tiene control total sobre cuándo/si hacer commits. Evita commits automáticos indeseados que creen historial sucio o confundan el flujo de trabajo.

**Vigencia:** Permanente en proyecto Odoo 17
**Actualizado:** 2026-04-29
