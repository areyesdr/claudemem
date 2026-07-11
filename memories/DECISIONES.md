---
name: decisiones_project
description: "Decisiones arquitectónicas tomadas — por qué, cuándo, alternativas consideradas"
metadata: 
  node_type: memory
  type: reference
  version: 2026-07-11
  originSessionId: da414162-bff1-4f2d-95e8-c795c5decf0a
---

# 🎯 DECISIONES ARQUITECTÓNICAS

**Proyecto:** Análisis y restructuración Odoo 17 Localizacion  
**Período:** 2026-07-10 a presente

---

## D1 — Estructura de Memoria: De Auditoría → Diario

**Decisión:** Cambiar modelo de memoria de "análisis crítico de deuda técnica" a "diario de control y historial"

**Fecha:** 2026-07-11  
**Tomado por:** User feedback

**Contexto:**
- Memoria inicial enfocada en "qué está mal" (clasificación de issues, severidades, riesgos)
- User requería historial de cambios y control, no auditoría

**Alternativas consideradas:**
1. ❌ Mantener análisis crítico + agregar diario (duplicación)
2. ✅ Restructurar completo como diario (decisión elegida)
3. ❌ Dos memorias separadas (complejidad excesiva)

**Implementación:**
- DIARIO.md: sesiones con fecha/hora y qué se hizo
- CHANGELOG.md: por módulo/categoría, cambios realizados
- DECISIONES.md: este archivo
- TODO.md: próximos pasos con estado

**Impacto:**
- Mejor trazabilidad
- Control claro de progreso
- Historial para auditoría de cambios

**Estado:** ✅ Completado

---

## D2 — Organización de Memoria: Por Categoría vs. Por Módulo

**Decisión:** Crear 11 archivos por categoría en lugar de 173 por módulo

**Fecha:** 2026-07-10  
**Tomado por:** Practicidad + usabilidad

**Contexto:**
- 173 módulos requeriría 173 archivos (excesivo, difícil navegar)
- Categorías (11) son unidades lógicas naturales

**Alternativas consideradas:**
1. ✅ 11 categorías (decisión elegida)
2. ❌ 173 módulos individuales (ruido excesivo)
3. ❌ 4 capas (Foundation, Hub, Features, Standalone) — demasiado abstracto
4. ❌ Mega archivo único (inmanejable)

**Implementación:**
- category_l10n_sv_*.md para cada una de 11 categorías
- Cada categoría contiene: módulos, deuda técnica, tests, roadmap

**Impacto:**
- Fácil de navegar
- Granularidad correcta
- Escalable

**Estado:** ✅ Completado

---

## D3 — Landing Page: Bootstrap vs. Alternativas

**Decisión:** Crear landing page HTML con Bootstrap 5

**Fecha:** 2026-07-10  
**Tomado por:** Visualización accesible para todo el equipo

**Contexto:**
- Memoria es text-based (archivos .md)
- Equipo técnico + no-técnico necesita vista accesible
- GitHub Pages disponible

**Alternativas consideradas:**
1. ✅ HTML + Bootstrap 5 (decisión elegida)
2. ❌ Wiki (excesivo, overhead)
3. ❌ React app (excesivo, no necesario)
4. ❌ Confluence/Notion (externo, no integrated)

**Implementación:**
- index.html con navbar, hero, stats, tabs, accordions, tables
- Bootstrap CDN, sin dependencias
- Publicada en GitHub Pages: https://areyesdr.github.io/claudemem/

**Impacto:**
- Acceso público
- Fácil compartir con equipo
- UX clara para búsqueda

**Estado:** ✅ Completado

---

## D4 — Sync a GitHub: Memoria Persistente

**Decisión:** Sincronizar memoria local a GitHub repo (areyesdr/claudemem)

**Fecha:** 2026-07-10  
**Tomado por:** Persistencia cross-machine + backup

**Contexto:**
- Memoria local en `/home/axel/.claude/projects/-home-axel-odoo-17/memory/`
- Necesidad: acceso desde otra máquina
- Necesidad: backup permanente

**Alternativas consideradas:**
1. ✅ GitHub repo (decisión elegida)
2. ❌ Google Drive (sharing, versionado débil)
3. ❌ Obsidian Sync (pago, overkill)
4. ❌ Solo local (pérdida de datos)

**Implementación:**
- Script `/home/axel/projects/claudemem/scripts/sync-memories.sh`
- Post-tool hook en settings.json (automático)
- Commits regulares con timestamp

**Impacto:**
- Memoria disponible en nueva máquina
- Auditoría de cambios en git
- Backup permanente

**Estado:** ✅ Completado

---

## D5 — Priorización FASE 1: Tests vs. Quick Wins

**Decisión:** FASE 1 = Tests en hubs críticos, NO quick wins

**Fecha:** 2026-07-10  
**Tomado por:** Riesgo legal + compliance

**Contexto:**
- l10n_sv_hr: 1 test en hub de payroll (9 dependientes) — legal risk
- l10n_sv_edi: 6 tests en facturación (gov compliance) — insufficient
- l10n_sv_stock: 2 tests en valuación — financial risk

**Alternativas consideradas:**
1. ✅ FASE 1 = Tests (decisión elegida)
2. ❌ FASE 1 = Quick wins (delete stubs, consolidate checks)
   - Motivo rechazo: Quick wins no mitiguen legal risk
3. ❌ Paralelo tests + quick wins (5 días cada = 10 días total)
   - Motivo rechazo: Impacto menor < impacto legal

**Implementación:**
- FASE 1 (Week 1): 5 días en tests
- FASE 2 (Week 2): 2 días en quick wins
- FASE 3+ (Week 3-4): Refactoring arquitectura

**Impacto:**
- Protección legal/compliance
- Confianza en hubs antes de refactor
- Estabilidad

**Estado:** 🔄 Pendiente implementación

---

## D6 — OperatingUnitMixin: Consolidación vs. Status Quo

**Decisión:** Crear OperatingUnitMixin para consolidar 8 módulos (FASE 3)

**Fecha:** 2026-07-10  
**Tomado por:** DRY principle + 200 LOC duplicado

**Contexto:**
- 8 operating_unit_* modules reimplementan `_get_operating_unit_domain()` (200+ LOC)
- Duplicación causa:
  - Inconsistencia en dominio logic
  - Riesgo multi-tenancy data leakage
  - Mantenimiento difícil

**Alternativas consideradas:**
1. ✅ Mixin-based consolidation (decisión elegida)
2. ❌ Status quo (sin consolidación)
   - Motivo rechazo: Deuda técnica perpetua
3. ❌ Abstract base class (similar a mixin, más rígido)
4. ❌ Funciones helper en utils (menos estructura)

**Implementación:**
- Extract `OperatingUnitMixin` → shared domain builder
- Consolidate 8 → 3 layers (base, domain-specific, config)
- Add multi-tenancy tests

**Impacto:**
- -200 LOC duplicado
- Consistencia garantizada
- Seguridad multi-tenancy

**State:** 🔄 Planificado FASE 3

---

## D7 — Circular Deps: Break vs. Accept

**Decisión:** Romper 3 ciclos circulares en FASE 3

**Fecha:** 2026-07-10  
**Tomado por:** Arquitectura limpia + refactor safety

**Contexto:**
- 3 ciclos detectados:
  1. reporte_impuestos ↔ impuestos_sugeridos ↔ valida_reporte
  2. l10n_sv_stock_valuation ↔ account_valuation_sv
  3. [otros]
- Ciclos no causan crash (Odoo instala OK)
- Pero riesgo para refactors futuros

**Alternativas consideradas:**
1. ✅ Break cycles (decisión elegida)
2. ❌ Accept as-is (técnica deuda perpetua)
3. ❌ Document only (no soluciona problema)

**Implementación:**
- Tax reporting: extract wizard_impuestos_sv neutral
- Stock ↔ Account: define interfaces, move computations
- Tests para garantizar no regression

**Impacto:**
- Refactorability future-proof
- Claridad arquitectura

**State:** 🔄 Planificado FASE 3

---

## D8 — SQL Migration Strategy: Cuál primero?

**Decisión:** HIGH-RISK (account_move, stock) antes que LOW-RISK

**Fecha:** 2026-07-10  
**Tomado por:** Risk mitigation + financial accuracy

**Contexto:**
- 406 cr.execute() instances
- Categorías:
  - HIGH-RISK: 190 (account_move, stock, payment)
  - MEDIUM: 100 (payroll, sale)
  - LOW: 116 (reports, utils)

**Alternativas consideradas:**
1. ✅ HIGH→MEDIUM→LOW (decisión elegida)
2. ❌ LOW→HIGH (bajo impacto primero)
   - Motivo rechazo: Financial data corruption > low-risk cleanup
3. ❌ Paralelo por categoría (5 días c/u)
   - Motivo rechazo: No hay recursos para paralelo

**Implementación:**
- FASE 4 Week 1: account_move SQL → ORM
- FASE 4 Week 2: stock SQL → ORM
- FASE 4 Week 3: payment SQL → ORM
- FASE 4 Week 4+: MEDIUM + LOW

**Impacto:**
- Financial integrity first
- Testability improves as we go
- Reduces manual SQL bugs

**State:** 🔄 Planificado FASE 4

---

## D9 — Diarios vs. Vault Obsidian

**Decisión:** Usar DIARIO.md en memoria + notas en Vault como secondary

**Fecha:** 2026-07-11  
**Tomado por:** Consolidación de fuentes

**Contexto:**
- Vault Obsidian: `/home/axel/odoo/17/vault17/`
- Memoria local: `/home/axel/.claude/projects/-home-axel-odoo-17/memory/`
- Duplicación: ESTRUCTURA_LOCALIZACION en ambos

**Alternativas consideradas:**
1. ✅ Primary memory, secondary Vault (decisión elegida)
2. ❌ Vault como primary (perdería sync cross-machine)
3. ❌ Ambas en paralelo (duplicación confusa)
4. ❌ Solo Vault (sin sync automático a GitHub)

**Implementación:**
- DIARIO.md es fuente principal
- Vault tiene snapshot para referencia rápida
- Sync automático a GitHub para backup

**Impacto:**
- Single source of truth
- Cross-machine access
- Permanent backup

**State:** ✅ Completado

---

## D10 — Índice de Memoria: Hub Central

**Decisión:** INDEX.md como hub con búsqueda rápida

**Fecha:** 2026-07-11  
**Tomado por:** Usabilidad (usuario feedback)

**Contexto:**
- 11 categorías + otros archivos → fácil perderse
- User: "memorias confusas, no sé cómo buscarlas"

**Alternativas consideradas:**
1. ✅ INDEX.md hub (decisión elegida)
2. ❌ Tree structure (git, pero CLI-only)
3. ❌ Wiki (overkill)
4. ❌ Mega MEMORY.md (inmanejable)

**Implementación:**
- INDEX.md: Búsqueda rápida por necesidad
- Tabla de categorías con prioridades
- "Búsqueda por problema" (6 scenarios comunes)
- Estructura visual en memoria

**Impacto:**
- Fácil onboarding
- Rápida búsqueda
- Reducción confusion

**State:** ✅ Completado

---

**Última actualización:** 2026-07-11  
**Próxima decisión esperada:** FASE 1 test suite design
