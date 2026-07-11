# Claude Memory Vault - Odoo 17 Project

Repositorio de memorias persistentes (claude-mem) para proyecto Odoo 17 de Mecaconsultores.

**Mantiene histórico de decisiones, bugs resueltos, arquitectura y documentación técnica** — accesible desde cualquier máquina.

## 📋 Contenido

- `memories/` — Archivos de memoria (.md) del proyecto
  - `MEMORY.md` — Índice maestro
  - `project_*.md` — Decisiones de arquitectura
  - `bugs_*.md` — Bugs resueltos + soluciones
  - `feedback_*.md` — Guías de desarrollo
  - `reference_*.md` — Referencias técnicas
  - `workflow_*.md` — Procesos establecidos

- `scripts/` — Herramientas de sincronización
  - `sync-memories.sh` — Sincronizar desde máquina local a GitHub
  - `restore-memories.sh` — Restaurar en máquina nueva

- `docs/` — Documentación de setup

## 🚀 Instalación en Máquina Nueva

### 1. Clonar repositorio

```bash
git clone https://github.com/areyesdr/claudemem.git
cd claudemem
```

### 2. Restaurar memorias a Claude Code

```bash
bash scripts/restore-memories.sh
```

Esto copia automáticamente archivos a:
```
~/.claude/projects/-home-axel-odoo-17/memory/
```

### 3. Verificar instalación

```bash
# En Claude Code:
/claude-mem how-it-works  # verifica que plugin está viendo archivos
```

## 🔄 Sincronización Automática

### Desde máquina actual (desarrollo)

Después de cada sesión de trabajo con Claude Code:

```bash
bash scripts/sync-memories.sh
```

O configurar para auto-sync en settings.json:

```json
{
  "hooks": {
    "postToolUse": ["bash scripts/sync-memories.sh"]
  }
}
```

### Desde máquina nueva

Después de restaurar (paso 2 arriba):

```bash
# Sincronizar cambios remotos
git pull origin main

# Restaurar a Claude Code
bash scripts/restore-memories.sh
```

## 📝 Workflow

### Después de terminar desarrollo en odoo/17:

1. **Guardar memoria en Claude Code** (automático con auto-memory)
   ```
   Archivo creado: ~/.claude/projects/-home-axel-odoo-17/memory/project_xyz.md
   ```

2. **Sincronizar a GitHub**
   ```bash
   cd /path/to/claudemem
   bash scripts/sync-memories.sh
   # o commit manual:
   git add memories/
   git commit -m "feat: memoria de XYZ"
   git push origin main
   ```

3. **En máquina nueva**
   ```bash
   git pull origin main
   bash scripts/restore-memories.sh
   ```

## 🛠️ Archivos Importantes

| Archivo | Contenido |
|---------|-----------|
| `MEMORY.md` | Índice maestro — siempre leer primero |
| `workflow_commit_documentation.md` | Obligatorio: estructura de commits y docs |
| `git_workflow_rules.md` | CRÍTICO: git es read-only, no auto-commit |
| `feedback_vault_as_memory.md` | Consultar vault Obsidian para contexto |

## 🔐 Credenciales

Para hacer push a GitHub, necesitas:

```bash
# Opción 1: SSH (recomendado)
ssh-keygen -t ed25519 -C "areyesdr@github.com"
# Agregar clave pública a GitHub: https://github.com/settings/keys

# Opción 2: Personal Access Token
# Generar en https://github.com/settings/tokens
# Guardar en ~/.git-credentials (no en repo)
git config --global credential.helper store
```

## 📊 Estadísticas

```
Total memorias: 38+
Tipos: proyectos, bugs, feedback, referencias, workflows
Última sincronización: (ver último commit)
Tamaño: ~200KB
```

## 🔗 Enlaces Útiles

- **Vault Obsidian**: `/home/axel/odoo/17/vault17/`
- **Proyecto Claude Code**: `~/.claude/projects/-home-axel-odoo-17/`
- **Configuración Claude Code**: `~/.claude/settings.json`

## ⚠️ Notas Importantes

1. **NUNCA modificar MEMORY.md manualmente** — actualizar a través de Claude Code
2. **Memorias son READ en cada sesión** — contexto para decisiones
3. **Git es READ-ONLY** — no hacer commits automáticos desde scripts
4. **Sincronización es MANUAL** después de cambios importantes
5. **Vault Obsidian** es el histórico visual — memorias son índices

## 📞 Soporte

Preguntas sobre memorias:
- `/claude-mem how-it-works` — Cómo funciona el sistema
- `/claude-mem mem-search "palabra"` — Buscar en memorias
- `/claude-mem standup` — Resumen de trabajo reciente

Preguntas sobre setup:
- Ver `docs/` en este repositorio
- Revisar últimos commits para cambios recientes

---

**Última actualización:** 2026-07-10  
**Rama:** main  
**Autor:** Claude Code + Axel Reyes
