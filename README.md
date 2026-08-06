# Hirfati

Hirfati is a Flutter marketplace app for clients and workers. It uses Supabase
for authentication, database access, storage, and Edge Functions, plus Firebase
Cloud Messaging for push notifications.

## Stack

- Flutter and Dart
- Riverpod
- GoRouter
- Supabase Auth, Database, Storage, and Edge Functions
- Firebase Cloud Messaging
- Freezed and json_serializable
- i18n_extension with Arabic JSON translations
- flex_color_scheme

## Project Structure

- `lib/router.dart`: app routes and auth/role redirects.
- `lib/main.dart`: public runtime configuration, Firebase, Supabase, localization, and notification startup.
- `lib/core`: shared services, models, utilities, providers, and widgets.
- `lib/features`: feature-first client, worker, auth, chat, payment, wallet, review, support, and notification code.
- `lib/DashBoard`: current admin dashboard screens, providers, services, and widgets.
- `supabase/migrations`: incremental database migrations.
- `supabase/functions`: Supabase Edge Functions.

## Configuration

Do not bundle `.env` as a Flutter asset and do not place server secrets in the
Flutter app. Provide public client configuration with `--dart-define` or a local
development environment file:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=FIREBASE_API_KEY=your-firebase-api-key \
  --dart-define=FIREBASE_APP_ID=your-firebase-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_PROJECT_ID=your-firebase-project-id
```

Privileged Supabase and Firebase server credentials belong only in Supabase
Edge Function secrets.

## Database And Payments

The app uses `wallets.balance` as the available balance and
`wallet_transactions` as the immutable wallet ledger. Payment settlement is
performed by the protected `settle_order_payment` PostgreSQL RPC.

Current Phase 1 payment behavior:

- Wallet: debits the client wallet and credits the worker wallet atomically.
- Card/external provider: disabled until a real server-side provider verification and capture flow exists.
- Cash: disabled until a real worker-confirmation flow exists.
- Refunds: require a separate idempotent reversal flow before being enabled.

Before applying wallet-payment constraints to a database with existing data, run:

```bash
psql "$SUPABASE_DB_URL" -f supabase/diagnostics/wallet_payment_preflight_diagnostics.sql
```

## Deployment

Apply migrations in order, then deploy Edge Functions:

```bash
supabase db push
supabase functions deploy send-notification
```

After any leaked credential is removed from the app, rotate it in the provider
dashboard. At minimum rotate the Supabase Service Role key and Firebase service
account key if they were ever committed, copied, or bundled.

## Checks

Use the standard project checks after code changes:

```bash
dart format .
flutter pub get
flutter analyze
flutter test
flutter build web
```
