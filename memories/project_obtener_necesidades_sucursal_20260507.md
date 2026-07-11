---
name: Necesidades de Producción Agrupadas por Sucursal
description: obtener_necesidades_del_dia() refactorizada para agrupar correctamente por sucursal+producto
type: project
originSessionId: 701975d6-e47a-4fa2-846f-8056926f1b2c
---
# Refactor: `obtener_necesidades_del_dia()` - Agrupación por Sucursal

**Fecha**: 2026-05-07  
**Archivos modificados**: 2
- `sync_amigopos/models/models_syncap/syncap_order_line.py:276`
- `sync_amigopos/models/models_syncap/syncap_order/sync_order_need.py:23`

## Problema Identificado

La función `obtener_necesidades_del_dia()` **no diferenciaba órdenes de diferentes sucursales**, mezclando ingredientes en un único diccionario.

**Escenario problemático**:
- Sucursal A: 10 hamburguesas
- Sucursal B: 5 hamburguesas
- **Función devolvía**: ingredientes para 15 hamburguesas (sin separación)
- **Debería devolver**: ingredientes para Sucursal A (10) + Sucursal B (5)

## Solución Implementada

### 1. Agrupamiento por `(config_id, product_id)`

```python
# ANTES: Solo product_id
demanda_productos[prod_id] += linea.Quantity

# AHORA: Tupla (config_id, product_id)
key = (config_id, prod_id)
demanda_por_sucursal[key] = {...}
```

### 2. Estructura de Retorno Mejorada

```python
# ANTES: Solo ingredientes planos
return ingredientes_totales

# AHORA: Estructura con contexto sucursal
return {
    'demanda_por_sucursal': {
        (config_id, product_id): {
            'config_id': ...,
            'config_name': 'Sucursal San Salvador',
            'product_id': ...,
            'product_name': 'Hamburguesa Clásica',
            'cantidad_total': 47
        }
    },
    'ingredientes_por_sucursal': {
        config_id: {
            'config_name': 'Sucursal San Salvador',
            'ingredientes': {
                product_id: {
                    'nombre': 'Carne Molida',
                    'cantidad': 47,
                    'unidad': 'kg'
                }
            }
        }
    }
}
```

### 3. Logs Claros por Sucursal

```
=== NECESIDADES DE PRODUCCIÓN DEL DÍA (POR SUCURSAL) ===
📍 SUCURSAL: Sucursal San Salvador
   Ingredientes: 5
   - Carne Molida: 47 kg
   - Pan para Hamburguesa: 47 pz
   ...
📍 SUCURSAL: Sucursal Santa Ana
   Ingredientes: 5
   - Carne Molida: 23 kg
   - Pan para Hamburguesa: 23 pz
   ...
```

## Cambios en `search_order_by_day()`

1. Ahora **retorna el resultado** (antes no devolvía nada)
2. Consume nuevo formato de retorno
3. Logs informativos sobre período, sucursales y órdenes encontradas

## Por Qué Es Importante

✅ **Para crear MOs**: Ahora se puede iterar `demanda_por_sucursal` y crear UNA MO por sucursal+producto  
✅ **Para sincronización**: Cada sucursal tendrá sus ingredientes correctamente calculados  
✅ **Para auditoría**: Logs claros permiten rastrear qué se preparó en cada sucursal  

## Próximas Fases (Futuras)

1. Crear `mrp.production` desde la estructura `demanda_por_sucursal`
2. Asignar una MO por sucursal+producto con cantidad diaria
3. Tests para validar no haya duplicados de MO

## Referencias

- Vault: `Bugs/obtener_necesidades_del_dia_validation.md`
- Skill: `odoo-sv-dev` para patrones MRP/BoM
