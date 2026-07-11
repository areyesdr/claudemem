#!/bin/bash
# sync-memories.sh - Sincronizar memorias locales a GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEMORY_SOURCE="$HOME/.claude/projects/-home-axel-odoo-17/memory"
MEMORY_DEST="$SCRIPT_DIR/memories"

echo "═══════════════════════════════════════════════════════"
echo "  Claude Memory Sync → GitHub (areyesdr/claudemem)"
echo "═══════════════════════════════════════════════════════"

# Verificar que directorio fuente existe
if [ ! -d "$MEMORY_SOURCE" ]; then
    echo "❌ Directorio de memorias no encontrado: $MEMORY_SOURCE"
    echo "   Asegúrate de que Claude Code está configurado con auto-memory"
    exit 1
fi

echo ""
echo "📦 Copiando memorias..."
echo "   Desde: $MEMORY_SOURCE"
echo "   Hacia: $MEMORY_DEST"

# Copiar archivos (preservar timestamps)
cp -av "$MEMORY_SOURCE"/*.md "$MEMORY_DEST/" 2>/dev/null || true

# Contar archivos
file_count=$(find "$MEMORY_DEST" -maxdepth 1 -type f -name "*.md" | wc -l)
echo ""
echo "✅ Copiadas $file_count memorias"

# Ir a directorio repo
cd "$SCRIPT_DIR"

# Asegurar que remoto usa SSH (no HTTPS)
if git remote -v | grep -q "https://github.com"; then
    echo ""
    echo "🔧 Actualizando remoto a SSH..."
    git remote set-url origin git@github.com:areyesdr/claudemem.git
fi

# Verificar estado git
echo ""
echo "🔍 Estado git..."
if git status --porcelain | grep -q .; then
    echo "   Cambios detectados"

    # Mostrar archivos modificados
    echo ""
    echo "📝 Archivos modificados:"
    git status --short

    # Agregar cambios
    echo ""
    echo "⬆️  Haciendo commit..."
    git add memories/

    # Crear mensaje de commit con fecha
    timestamp=$(date '+%Y-%m-%d %H:%M')
    git commit -m "sync: actualización de memorias ($timestamp)"

    # Push a origin
    echo ""
    echo "🚀 Enviando a GitHub..."
    git push origin main

    echo ""
    echo "✅ SYNC COMPLETADO"
    echo "   Commit: $(git rev-parse --short HEAD)"
    echo "   URL: https://github.com/areyesdr/claudemem"
else
    echo "   ✓ Sin cambios pendientes"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
