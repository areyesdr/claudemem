# Instrucciones para Hacer Push a GitHub

Repo local está en `/tmp/claudemem-repo/` listo para subir a tu cuenta.

## Paso 1: Crear repositorio vacío en GitHub

1. Ve a https://github.com/new
2. Nombre: **claudemem**
3. Descripción: "Claude Memory Vault - Memorias persistentes Odoo 17"
4. Privado o Público (tu elección)
5. NO inicializar con README/license (repo local ya existe)
6. Click **Create repository**

Verás URL como: `https://github.com/areyesdr/claudemem.git`

## Paso 2: Agregar remoto

```bash
cd /tmp/claudemem-repo

# Agregar remoto origin (usa tu URL)
git remote add origin https://github.com/areyesdr/claudemem.git

# Verificar
git remote -v
# output:
# origin  https://github.com/areyesdr/claudemem.git (fetch)
# origin  https://github.com/areyesdr/claudemem.git (push)
```

## Paso 3: Cambiar rama a 'main' (opcional pero recomendado)

```bash
git branch -M main
```

## Paso 4: Hacer push

```bash
# Primera vez (establece upstream)
git push -u origin main

# En el futuro, solo:
git push
```

Si te pide autenticación:
- **SSH**: Agregar clave pública a GitHub
- **HTTPS**: Usar token personal (generar en https://github.com/settings/tokens)

## Paso 5: Verificar

```bash
# Ver en GitHub
open https://github.com/areyesdr/claudemem

# O desde terminal:
git remote -v
git log --oneline
```

## Paso 6: Sincronizar scripts locales

Después del primer push, copia scripts a un lugar permanente:

```bash
# Opción 1: Dentro de proyecto Odoo
mkdir -p ~/odoo/17/scripts/claudemem
cp /tmp/claudemem-repo/scripts/*.sh ~/odoo/17/scripts/claudemem/

# Opción 2: Usar symlink
mkdir -p ~/projects
ln -s /tmp/claudemem-repo ~/projects/claudemem
```

Luego en scripts:
```bash
~/projects/claudemem/scripts/sync-memories.sh
# o
~/odoo/17/scripts/claudemem/sync-memories.sh
```

## Paso 7: Verificar sync automático (Futuro)

Después de trabajar:
```bash
# Sincronizar cambios
~/projects/claudemem/scripts/sync-memories.sh
```

## ⚠️ Notas

- Primer push puede pedir contraseña/token si usas HTTPS
- SSH es más fácil: configura clave en https://github.com/settings/keys
- Memorias se sincronizan MANUALMENTE con `sync-memories.sh`
- Auto-sync vía hooks de Claude Code (ver README.md)

## Troubleshooting

```bash
# Si falla por certificado SSL
git config --global http.sslVerify false

# Si falla por autenticación
git config --global user.name "Axel Reyes"
git config --global user.email "axel.reyes@mecaconsultores.net"

# Ver lo que se va a pushear
git diff origin/main..HEAD --stat
```

---

**URL repo:** https://github.com/areyesdr/claudemem (después de crear)  
**Scripts:** `/tmp/claudemem-repo/scripts/`
