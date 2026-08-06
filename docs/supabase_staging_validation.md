# Supabase Staging Validation

Use a dedicated Supabase staging project for destructive schema validation,
wallet-payment testing, and Flutter staging smoke tests. Do not link or push
these migrations to production while validating Phase 1.

## Link Staging

Confirm the intended project in the Supabase dashboard and CLI before any remote
database command:

```bash
supabase projects list
supabase link --project-ref <STAGING_PROJECT_REF>
cat supabase/.temp/project-ref
```

The linked ref must be the staging project ref, not the production project ref.
Do not paste database passwords, service-role keys, JWT secrets, Firebase
private keys, or access tokens into docs, commits, logs, or chat.

## Apply Schema

The staging database should start empty or be intentionally disposable. Apply
the repo migrations in timestamp order:

1. `20260712000100_hirfati_base_schema.sql`
2. `20260713000100_category_translations_search.sql`
3. `20260721000100_wallet_ledger_settlement_security.sql`
4. `20260721000200_wallet_payment_phase1_validation.sql`

Run the dry-run first:

```bash
supabase migration list
supabase db push --dry-run
```

If the dry-run targets staging and reports only the expected pending migrations,
apply them:

```bash
supabase db push
supabase migration list
```

## Test Wallet Payment

Run the Phase 1 pgTAP suite against staging after migrations are applied:

```bash
supabase test db --linked supabase/tests/database/wallet_payment_settlement_test.sql
```

The suite creates temporary auth users, profiles, workers, wallets, orders, and
payments inside a rolled-back transaction. It must pass before wallet payment is
considered validated on staging.

## Flutter Staging Smoke Test

Configure local environment values to point at staging, then run the app without
committing real environment files:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=APP_ENV=staging
```

Smoke-test signup/login, profile reads, category/search reads, wallet balance
read, successful wallet settlement, insufficient-balance failure, duplicate
idempotency retry, and rejected direct client writes to wallet/payment tables.

## Rollback

For disposable staging, reset the database from the Supabase dashboard or create
a fresh staging project and re-link the CLI. For a shared staging database, add
an audited forward-only migration instead of manually editing migration history.
