#!/usr/bin/env python3
"""
Generator claudemem-web: Lee .md de múltiples proyectos → genera índice JSON + HTML estático.
Auto-descubre: ~/.claude/projects/*/memory/*.md
Lazy: sin frameworks, sin compilación, puro HTML/CSS.
"""

import os
import json
import re
from pathlib import Path
from datetime import datetime

WEB_ROOT = Path(__file__).parent.parent
OUTPUT_DIR = WEB_ROOT / "docs"
TEMPLATES_DIR = WEB_ROOT / "_templates"

# Auto-descubre directorios de memoria
def find_memory_dirs():
    """Busca automáticamente directorios .claude/projects/*/memory/"""
    claude_projects = Path.home() / ".claude" / "projects"
    if not claude_projects.exists():
        return []

    dirs = []
    for proj_dir in claude_projects.iterdir():
        memory_dir = proj_dir / "memory"
        if memory_dir.is_dir():
            dirs.append((proj_dir.name, memory_dir))

    return dirs

def parse_frontmatter(content):
    """Extrae frontmatter YAML básico (sin librería, regex simple)."""
    match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not match:
        return {}, content

    fm = {}
    for line in match.group(1).split('\n'):
        if ':' in line:
            key, val = line.split(':', 1)
            fm[key.strip()] = val.strip().strip('"\'')

    body = content[match.end():]
    return fm, body

def extract_type(fm):
    """Mapea tipo metadata → etiqueta visual."""
    type_map = {
        'project': '◆ Proyecto',
        'bug': '● Bug',
        'feedback': '⚖ Feedback',
        'reference': '📋 Referencia',
        'workflow': '↻ Workflow'
    }
    meta = fm.get('metadata', {})
    if isinstance(meta, str):
        # parsear tipo de string "type: project"
        type_str = fm.get('metadata', '').split('type:')[-1].strip()
    else:
        type_str = fm.get('type', 'project')

    return type_map.get(type_str, '◆ Otros')

def generate_index():
    """Lee memorias de TODOS los proyectos → retorna lista JSON."""
    memories = []
    memory_dirs = find_memory_dirs()

    for proj_name, memory_dir in memory_dirs:
        for mfile in sorted(memory_dir.glob("*.md")):
            if mfile.name == 'MEMORY.md':
                continue

            content = mfile.read_text(encoding='utf-8')
            fm, body = parse_frontmatter(content)

            slug = fm.get('name', mfile.stem)
            memories.append({
                'id': slug,
                'file': mfile.name,
                'project': proj_name.replace('-home-axel-', '').replace('/', '_'),
                'title': fm.get('name', mfile.stem),
                'desc': fm.get('description', 'Sin descripción'),
                'type': extract_type(fm),
                'date': fm.get('date', 'sin fecha'),
            })

    # Ordenar por fecha descendente
    memories.sort(key=lambda x: x['date'], reverse=True)
    return memories

def read_template(name):
    """Lee y retorna contenido template."""
    return (TEMPLATES_DIR / f"{name}.html").read_text(encoding='utf-8')

def render_card(memory):
    """Renderiza 1 card de memoria (componente reutilizable)."""
    template = read_template('card')
    return template.format(
        id=memory['id'],
        title=memory['title'],
        type_badge=memory['type'],
        desc=memory['desc'],
        date=memory['date'],
    )


def main():
    OUTPUT_DIR.mkdir(exist_ok=True)

    # Generar índice dinámico
    memories = generate_index()
    print(f"✓ Descubierto {len(memories)} memorias")

    # Guardar JSON (única verdad → cliente carga vía fetch)
    (OUTPUT_DIR / "memories.json").write_text(
        json.dumps(memories, indent=2, ensure_ascii=False),
        encoding='utf-8'
    )
    print(f"✓ Generado memories.json")

    # Copiar templates estáticos (100% dinámicos vía JS)
    for fname in ["index.html", "style.css"]:
        src = WEB_ROOT / ("_templates" if fname.endswith(".html") else "_assets") / fname
        if src.exists():
            (OUTPUT_DIR / fname).write_text(src.read_text(), encoding='utf-8')
            print(f"✓ Copiado {fname}")

    # Crear .nojekyll para GitHub Pages
    (OUTPUT_DIR / ".nojekyll").touch()
    print(f"✓ GitHub Pages configurado")

if __name__ == '__main__':
    main()
