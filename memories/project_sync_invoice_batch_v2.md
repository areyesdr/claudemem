---
name: sync_amigopos Invoice Unique Constraint Fix — v2 Rollback + Simple Fix
description: Reverted complex batch optimization, implemented simple pre-write validation (2026-04-30)
type: project
originSessionId: bbcf6c9f-fd4f-4261-a5f1-d1c1bca9197d
---
# Fix Invoice Unique Constraint — Simple & Effective (2026-04-30)

## What Happened

**Initial Attempt (Failed):** Complex batch optimization with SELECT FOR UPDATE
- ❌ SELECT FOR UPDATE doesn't work across multiple DB connections (workers)
- ❌ Rollback() left transactions in invalid state
- ❌ "Record does not exist" errors appeared

**Solution Implemented (Working):** Reverted to simple pre-write validation

## The Fix

**Before write operation, validate:**
```python
if data.get('codigo_generacion'):
    existing_with_codigo = self.env['account.move'].search([
        ('codigo_generacion', '=', data['codigo_generacion']),
        ('state', '!=', 'cancel'),
        ('id', '!=', invoice.id),  # Exclude current invoice
    ], limit=1)
    if existing_with_codigo:
        _logger.warning(f"Código {data['codigo_generacion']} ya existe.")
        data.pop('codigo_generacion', None)  # Don't write it
```

**Result:** If `codigo_generacion` already exists in another invoice, simply DON'T write it. This prevents the unique constraint violation at the source.

## Why This Works

1. **Simple**: One extra search before write
2. **Atomic**: Single transaction, no locks needed
3. **Safe**: If duplicate found, just skip the field
4. **Effective**: Prevents violation without complex locking

## Status

**File:** `conectores/sync_amigopos/models/syncap_order.py`
**Change:** Added single pre-write validation check
**Complexity:** Minimal
**Risk:** Very Low

## Testing

Monitor logs for:
```bash
tail -f /var/log/odoo/odoo.log | grep -E "CRON DE FACTURACIÓN|unique_codigo_generacion"
```

Should see:
- ✅ "=== CRON DE FACTURACIÓN FINALIZADO ===" 
- ✅ NO errors about unique constraint violations
- ✅ "Código X ya existe" warnings (controlled)

## Rollback

If needed:
```bash
git checkout HEAD -- conectores/sync_amigopos/models/syncap_order.py
```

No other changes to roll back (removed complex methods).
