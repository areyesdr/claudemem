---
name: claudemem_github_setup
description: Setup de repositorio GitHub para memorias persistentes - areyesdr/claudemem
metadata: 
  node_type: memory
  type: project
  originSessionId: 9870035e-7309-4d60-aa91-3cb4712715f9
---

## Repositorio GitHub claudemem - Setup 2026-07-10

**Status:** Repo local listo, pendiente first push a GitHub

### Problema Resuelto
Memorias de Claude Code vivían solo en máquina local → pérdida si cambias de PC. Solución: repositorio GitHub sincronizado.

### Implementación

**Repo local:** `/tmp/claudemem-repo/`
- 38 memorias (.md) de Odoo 17 proyecto
- 2 scripts de sync/restore
- Documentación completa (README, QUICKSTART, instrucciones)
- Primer commit: f96438d (42 archivos)

**Estructura:**
```
claudemem/
├── memories/          # 38 archivos .md (índices + bugs + proyectos)
├── scripts/
│   ├── sync-memories.sh       # Copiar local → repo → push a GitHub
│   └── restore-memories.sh    # Copiar repo → ~/.claude/projects/
├── docs/              # (vacío, para docs futuras)
├── README.md          # Guía completa
├── QUICKSTART.md      # Instrucciones rápidas
└── PUSH_TO_GITHUB.md  # Step-by-step para first push
```

### Workflow

**Máquina actual (desarrollo):**
```bash
# Después de trabajar con Claude Code:
~/projects/claudemem/scripts/sync-memories.sh
# → Copia memorias locales
# → Git add + commit
# → Git push a GitHub
```

**Máquina nueva:**
```bash
git clone https://github.com/areyesdr/claudemem.git
cd claudemem
bash scripts/restore-memories.sh
# → Copia memorias a ~/.claude/projects/-home-axel-odoo-17/memory/
```

### ✅ Setup Completado (2026-07-10 23:26)

**Status:** Repo en GitHub LIVE, sync scripts operacionales, aliases configurados

### Setup Realizado

1. **✅ Repo en GitHub:**
   - https://github.com/new
   - Nombre: `claudemem`
   - Usuario: `areyesdr`
   - Privado/público: elegir
   - SIN inicializar (local existe)

2. **Agregar remoto:**
   ```bash
   cd /tmp/claudemem-repo
   git remote add origin https://github.com/areyesdr/claudemem.git
   git branch -M main
   git push -u origin main
   ```

3. **Copiar scripts a ubicación permanente:**
   ```bash
   mkdir -p ~/projects/claudemem
   cd ~/projects/claudemem
   git clone https://github.com/areyesdr/claudemem.git .
   ```

4. **Luego para sync automático:** (opcional en settings.json)
   ```json
   {
     "hooks": {
       "postToolUse": ["bash ~/projects/claudemem/scripts/sync-memories.sh"]
     }
   }
   ```

### Scripts Detalles

**sync-memories.sh:**
- Copia memorias de `~/.claude/projects/-home-axel-odoo-17/memory/`
- `git add memories/`
- `git commit -m "sync: actualización de memorias (fecha)"`
- `git push origin main`

**restore-memories.sh:**
- Verifica clonación
- Copia `memories/*.md` a `~/.claude/projects/-home-axel-odoo-17/memory/`
- Muestra resumen de archivos restaurados

### Autenticación GitHub

**Opción SSH (recomendado):**
```bash
ssh-keygen -t ed25519 -C "areyesdr@github.com"
# Agregar a https://github.com/settings/keys
git remote set-url origin git@github.com:areyesdr/claudemem.git
```

**Opción HTTPS:**
```bash
# Generar token en https://github.com/settings/tokens
git config --global credential.helper store
# Se pedirá token en primer push
```

### Notas

- Memorias se syncan MANUALMENTE (no auto-commit de git por política)
- Vault Obsidian sigue siendo histórico visual
- Repo es backup + acceso desde cualquier máquina
- Auto-sync via hooks es OPCIONAL (tarea futura)

### Recursos

- `PUSH_TO_GITHUB.md` — instrucciones completas step-by-step
- `README.md` — documentación completa
- `QUICKSTART.md` — inicio rápido

### Deployment Final

**Repo GitHub:** https://github.com/areyesdr/claudemem (LIVE ✅)
- Branch: main
- 44 archivos
- SSH remoto: git@github.com:areyesdr/claudemem.git

**Scripts locales:** `~/projects/claudemem/`
- Clone del repo GitHub
- Listos para usar sync-memories.sh diariamente

**Setup script:** `/home/axel/odoo/17/scripts/setup-claudemem.sh`
- Bash one-liner para máquina nueva
- Clona repo + restaura memorias automáticas

**Aliases en ~/.bash_aliases:**
- `cm-sync` → `~/projects/claudemem/scripts/sync-memories.sh`
- `cm-restore` → `~/projects/claudemem/scripts/restore-memories.sh`
- `cm-setup` → setup automático en máquina nueva

### Archivos Clave

- GitHub: https://github.com/areyesdr/claudemem
- Local: ~/projects/claudemem/
- Setup rápido: /home/axel/odoo/17/scripts/setup-claudemem.sh
- Aliases: ~/.bash_aliases (cm-sync, cm-restore, cm-setup)
