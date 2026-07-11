# Quickstart - Claudemem

## En máquina actual

Después de trabajar con Claude Code:

```bash
cd ~/projects/claudemem  # o donde clonaste
bash scripts/sync-memories.sh
```

## En máquina nueva

```bash
# 1. Clonar
git clone https://github.com/areyesdr/claudemem.git
cd claudemem

# 2. Restaurar a Claude Code
bash scripts/restore-memories.sh

# 3. Verificar
/claude-mem how-it-works
```

## Auto-sync (opcional)

Agregar a `~/.claude/settings.json`:

```json
{
  "hooks": {
    "postToolUse": [
      "test -d ~/projects/claudemem && bash ~/projects/claudemem/scripts/sync-memories.sh"
    ]
  }
}
```

Esto hace sync automático después de cada herramienta usada en Claude Code.

---

Ver README.md para detalles completos.
