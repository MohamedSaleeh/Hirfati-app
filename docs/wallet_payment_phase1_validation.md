# Wallet Payment Phase 1 Validation

This pass validates only the wallet-ledger and atomic wallet-payment foundation.
Refunds, withdrawals, dashboard expansion, verification, chat, and unrelated UI
features remain out of scope.

## Corrections Added

- `20260721000200_wallet_payment_phase1_validation.sql` replaces
  `public.settle_order_payment(...)` with a wallet-only Phase 1 implementation.
- The RPC now uses a transaction-scoped advisory lock on the idempotency key so a
  concurrent same-key retry waits and returns the completed idempotent result.
- Card and cash RPC paths return `payment_method_unavailable` until their real
  server-side flows exist.
- Guard triggers block direct wallet-balance changes, direct payment table
  writes, and direct order-paid updates outside the settlement RPC.
- Financial table grants are reset to authenticated read-only access.

## Validation Artifacts

- Preflight diagnostics:
  `supabase/diagnostics/wallet_payment_preflight_diagnostics.sql`
- Database tests:
  `supabase/tests/database/wallet_payment_settlement_test.sql`

The diagnostics script reports affected-row counts and detail rows without
deleting or mutating production data. Ambiguous financial records require a
separate audited data-fix migration.

## Expected Phase 1 Behavior

- Wallet payment settles only when the authenticated caller is the order client,
  the order is completed and unpaid, the price is positive, and the client wallet
  has enough balance.
- The amount, payer, and worker recipient are derived from database rows, not
  Flutter input.
- Client and worker balances, payment, payment event, order paid fields, ledger
  entries, and worker notification are written in the same transaction.
- Failed settlement attempts roll back all mutations.
- Repeating the same successful idempotency key returns the existing payment
  result without a second debit or credit.
- A new idempotency key for an already paid order returns `already_paid`.
