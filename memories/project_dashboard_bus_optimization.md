---
name: Dashboard Bus Optimization
description: Log buffer en memoria (sin JSONL) + cards via bus con validación inteligente de rango
type: project
originSessionId: f18e8ffe-466b-4159-b118-600cab2632ee
---
## 2026-05-04: Optimización Completa Dashboard

### 1. Log Buffer → Solo Memoria

**Antes:** Leía logs del archivo JSONL físico (`syncap_monitor.jsonl`)
**Ahora:** Almacena en `deque(maxlen=1000)` en memoria

**Cambios:**
- `log_buffer.py`: Nuevo `MemoryBufferHandler` + `_LOG_BUFFER` deque
- Eliminado: `LOG_FILE_PATH`, `JSONFileFormatter`, `FileHandler`
- `get_logs()` lee del deque (no del archivo)
- `clear()` limpia el deque (no el archivo)

**Ventaja:** Frontend solo lee logs del bus de Odoo en tiempo real (RPC solo para refresh manual)

---

### 2. Cards: Bus Rápido + RPC con Filtros

**Antes:** Intentaba enviar cards calculadas en el write() = consultas pesadas que ralentizaban

**Ahora:** Notificación rápida en el bus → Frontend RPC con filtros aplicados

#### Backend (syncap_order.py)

**Simplificado:**
- `create()` → envía notificación simple: `{'message': 'new', 'count': X}`
- `write()` → envía notificación simple: `{'message': 'state_changed', 'count': X}`
- ❌ Eliminado: `_get_cards_for_bus()` (no necesario, frontend trae con filtros)
- ✅ Escrituras instantáneas: sin cálculos de cards

#### Frontend (sync_monitor_dashboard.js)

**onNotification():**
1. Recibe notificación simple del bus (casi instantáneo)
2. Hace RPC a `/sync_amigopos/get_sync_monitor_data` CON sus filtros:
   - dateFrom, dateTo (respeta rango)
   - branchIds (respeta sucursales)
3. Obtiene cards correctamente filtradas (50-200ms SQL)

**Ventaja:** 
- ✅ Tiempo real (bus instantáneo)
- ✅ RPC rápido (SQL ultra-optimizado)
- ✅ Respeta filtros de cada usuario
- ✅ Sin consistencias entre usuarios

---

### 3. Flujos Resultantes

**Logs:**
```
logger → MemoryBufferHandler → deque
         ↓ (bus broadcast)
frontend escucha → consola actualiza en tiempo real
```

**Cards:**
```
Orden cambia (write/create)
    ↓
Backend calcula cards globales
    ↓
Bus: {cards, changed_orders}
    ↓
Frontend: valida rango ✓
    ↓
Aplica cards (sin RPC)
```

---

### 4. Testing Pendiente

- [ ] Cambiar estado orden → aparece en dashboard sin RPC
- [ ] Cambiar rango → ignora órdenes fuera de rango
- [ ] Crear orden → actualiza cards automáticamente
- [ ] Limpiar logs → deque vacío, dashboard limpio
- [ ] Multi-usuario → cada uno aplica filtros independientemente
