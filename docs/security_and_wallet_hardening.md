# Security And Wallet Hardening

## Active Supabase Tables

Current active payment and wallet flows use:

- `orders`
- `payments`
- `payment_events`
- `profiles`
- `workers`
- `wallets`
- `wallet_transactions`
- `notifications`
- `device_tokens`

`wallet_transactions` is the immutable ledger. `payments.payer_id` and
`payments.payee_id` identify the payment participants; worker earnings still
come from ledger credits, not payment rows alone.

## Migration Order

Apply migrations in timestamp order. A fresh staging database needs the baseline
schema before the wallet hardening migrations:

1. `20260712000100_hirfati_base_schema.sql`
2. `20260713000100_category_translations_search.sql`
3. `20260721000100_wallet_ledger_settlement_security.sql`
4. `20260721000200_wallet_payment_phase1_validation.sql`
5. `20260724000100_wallet_ledger_architecture.sql`

The wallet/security migration intentionally stops if duplicate completed
payments, reversed duplicate conversations, duplicate worker records, duplicate
notification settings, or duplicate pending verification requests already exist.
Resolve those rows with an audited data-fix migration before re-running.

## RPC Functions

- `public.is_admin()`: checks the caller role from `profiles` using `auth.uid()`.
- `public.ensure_wallet_for_current_user()`: idempotently creates a zero-balance wallet for the authenticated user.
- `public.settle_order_payment(...)`: settles wallet order payments atomically.

## Payment Behavior

- Wallet payments require an existing client wallet with enough balance. The RPC
  locks the idempotency key, order row, worker row, and wallet rows; creates one
  completed payment; debits the client wallet; credits the worker wallet; inserts
  paired ledger rows; writes a payment event; marks the order paid; creates the
  worker notification; and returns safe settlement metadata.
- Card payments are disabled in Phase 1. They must stay unavailable until a real
  provider verification/capture flow is implemented server-side.
- Cash payments are disabled in Phase 1. They must stay unavailable until a real
  worker-confirmation flow is implemented server-side.
- Refunds are not enabled by this pass. They must be implemented as idempotent
  reversal ledger transactions linked to the original payment.

## Authorization

Financial table writes are revoked from normal Flutter clients. Guard triggers
also reject direct payment inserts/updates, wallet balance changes, and direct
order-paid updates unless the protected settlement RPC is executing. RLS allows
users to read only their own wallet rows, ledger rows, and payment/event rows
connected to their own orders or worker account. Admin access uses
`public.is_admin()` and is enforced in PostgreSQL, not only in Flutter routes.

Run preflight diagnostics before applying constraints to a database that already
has production-like data:

```bash
psql "$SUPABASE_DB_URL" -f supabase/diagnostics/wallet_payment_preflight_diagnostics.sql
```

Run the wallet-payment pgTAP tests against local or staging after migrations:

```bash
supabase test db supabase/tests/database/wallet_payment_settlement_test.sql
```

The `send-notification` Edge Function now validates the authenticated caller.
Order notifications require the caller to be the order client or assigned
worker. Message notifications require the caller and target user to be
conversation participants.

## Secret Rotation

The Flutter app must never include:

- Supabase Service Role keys
- Firebase service account JSON
- Firebase private keys
- card data, PIN values, JWTs, or raw provider payloads in logs

Rotate any credential that was previously committed, copied, or bundled:

1. Supabase Service Role key.
2. Firebase service account key.
3. Any unrestricted Google Maps or Firebase client key that was exposed.

Store server-only values with Supabase secrets, for example:

```bash
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=...
supabase secrets set FIREBASE_CLIENT_EMAIL=...
supabase secrets set FIREBASE_PRIVATE_KEY=...
supabase secrets set FIREBASE_PROJECT_ID=...
```

## Postponed Cleanup

- A full refund RPC is still required before refunds can be enabled.
- A real card provider capture flow is still required before card payment UI is enabled.
- A worker-confirmed cash flow is still required before cash payment UI is enabled.
- Historical paid orders are not backfilled into the ledger by this migration.
- Legacy payment PIN columns are dropped by the wallet ledger architecture
  migration.
