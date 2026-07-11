#!/bin/bash
# restore-memories.sh - Restaurar memorias a Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEMORY_SOURCE="$SCRIPT_DIR/memories"
MEMORY_DEST="$HOME/.claude/projects/-home-axel-odoo-17/memory"

echo "═══════════════════════════════════════════════════════"
echo "  Claude Memory Restore ← GitHub"
echo "═══════════════════════════════════════════════════════"

# Verificar que directorio fuente existe
if [ ! -d "$MEMORY_SOURCE" ]; then
    echo "❌ Directorio de memorias no encontrado: $MEMORY_SOURCE"
    echo "   Clona primero: git clone https://github.com/areyesdr/claudemem.git"
    exit 1
fi

# Crear directorio destino si no existe
echo ""
echo "📂 Preparando directorio de Claude Code..."
mkdir -p "$MEMORY_DEST"
echo "   $MEMORY_DEST"

# Copiar archivos
echo ""
echo "📦 Restaurando memorias..."
cp -av "$MEMORY_SOURCE"/*.md "$MEMORY_DEST/"

# Contar archivos
file_count=$(find "$MEMORY_DEST" -maxdepth 1 -type f -name "*.md" | wc -l)

echo ""
echo "✅ RESTAURACIÓN COMPLETADA"
echo "   Memorias restauradas: $file_count"
echo "   Ubicación: $MEMORY_DEST"

# Mostrar MEMORY.md como referencia
echo ""
echo "📋 Índice de Memorias (MEMORY.md):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -20 "$MEMORY_DEST/MEMORY.md" | tail -15

echo ""
echo "✨ Próximo paso: Iniciar Claude Code"
echo "   Prueba: /claude-mem how-it-works"
echo ""
echo "═══════════════════════════════════════════════════════"
