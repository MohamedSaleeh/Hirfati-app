<div align="center">

# Hirfati — حرفتي

### A two-sided marketplace connecting clients with skilled craftsmen

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/Firebase-Notifications-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## Overview

**Hirfati** (Arabic: حرفتي — "my craft") is a cross-platform mobile marketplace built with Flutter and Supabase. It connects clients who need skilled services — plumbing, electrical, cleaning, and more — with verified local craftsmen who offer those services.

The platform supports the full service lifecycle: discovery, booking, real-time chat, payment, and post-job review — all within a single bilingual (Arabic / English) application.

---

## Features

### For clients
- Browse and discover craftsmen by category, location, or live map
- View craftsman profiles — portfolio, services, reviews, and pricing
- Create detailed service requests with a 4-step guided order wizard
- Pay via credit card or ShamCash digital wallet
- Track order status in real time
- Chat directly with craftsmen
- Leave post-job reviews and ratings
- Manage saved addresses and payment methods

### For workers (craftsmen)
- Complete a professional profile with identity verification
- Set service categories, pricing, and availability
- Accept or reject incoming service requests
- Manage active jobs with live status updates
- Upload a work gallery to showcase past projects
- Track earnings, request withdrawals to ShamCash
- Receive push notifications for new orders and messages

### Platform
- Full Arabic / English localization with RTL layout support
- PIN-based security layer for ShamCash transactions
- Supabase Edge Functions for payment and notification processing
- Firebase Cloud Messaging for push notifications
- Offline-graceful error handling throughout

---

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State management | Riverpod |
| Backend & database | Supabase (PostgreSQL + Realtime) |
| Authentication | Supabase Auth |
| Push notifications | Firebase Cloud Messaging |
| Payments | Credit card gateway + ShamCash API |
| Localization | `easy_localization` — AR / EN |
| Code generation | `freezed`, `json_serializable` |
| Navigation | GoRouter |
| Maps | Flutter Maps (service area, order location) |

---

## Project structure

```
lib/
├── core/
│   ├── models/           # Shared domain models (Order, etc.)
│   ├── presentation/     # Shared screens, widgets, providers
│   ├── services/         # Notification service
│   └── utils/            # Formatting, image, distance utilities
│
├── features/
│   ├── auth/             # Login, sign-up, password reset
│   ├── Client/
│   │   ├── Home_client/         # Home feed, craftsman discovery
│   │   ├── create_order/        # 4-step order wizard
│   │   ├── orders/              # Order history & tracking
│   │   ├── worker_profile_details/
│   │   ├── map_discovery/       # Live map view
│   │   ├── Addresses/           # Address management
│   │   ├── profile/             # Client profile
│   │   ├── pyment_methods/      # Card & ShamCash management
│   │   └── client_navigation/
│   │
│   └── Worker/
│       ├── worker_home/         # Dashboard & active jobs
│       ├── incoming_orders/     # Order queue
│       ├── complete_profile/    # Professional profile setup
│       ├── identity_verification/
│       ├── categories_pricing/  # Service catalogue & pricing
│       ├── work_gallery/        # Portfolio management
│       ├── earnings/            # Earnings & withdrawals
│       ├── worker_profile/
│       └── account_settings/
│
├── chat/                 # Real-time messaging
├── review/               # Post-job reviews
├── payment/              # Payment processing
├── pin/                  # PIN setup & verification
├── notifications/        # Notification feed
├── sham_cash/            # ShamCash wallet
├── help_support/         # FAQ & contact
├── notification_settings/
│
├── main.dart
├── router.dart
└── theme.dart

assets/
├── translations/
│   ├── ar.json
│   └── en.json
├── images/
├── fonts/
└── animations/

supabase/
├── functions/
│   ├── send-notification/
│   └── shamcash-payment/
└── migrations/
```

Each feature follows a strict layered architecture:

```
feature/
├── data/
│   ├── datasources/    # Supabase queries
│   ├── repositories/   # Repository implementations
│   └── providers/      # Riverpod data providers
├── domain/
│   ├── models/         # Freezed data models
│   └── repositories/   # Abstract repository interfaces
└── presentation/
    ├── screens/        # UI screens
    ├── widgets/        # Feature-specific widgets
    └── providers/      # Riverpod UI state providers
```

---

## Getting started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- A [Supabase](https://supabase.com) project
- A [Firebase](https://firebase.google.com) project (for FCM)

### Setup

**1. Clone the repository**

```bash
git clone https://github.com/your-username/hirfati.git
cd hirfati
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Configure environment**

Create a `.env` file in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

**4. Add Firebase configuration**

Place your `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.

**5. Run database migrations**

Apply the SQL files in `supabase/migrations/` to your Supabase project via the dashboard or CLI:

```bash
supabase db push
```

**6. Deploy Edge Functions**

```bash
supabase functions deploy send-notification
supabase functions deploy shamcash-payment
```

**7. Run the app**

```bash
flutter run
```

---

## Localization

The app is fully bilingual. Translation strings live in `assets/translations/`:

```
assets/translations/
├── ar.json   # Arabic (primary)
└── en.json   # English
```

To add or update a translation key, edit both JSON files and rebuild. The app uses `easy_localization` — strings are accessed in code with `.tr()`.

---

## Architecture decisions

**Riverpod for state** — all business logic lives in providers, keeping widgets purely presentational and making logic independently testable.

**Freezed models** — all domain models are immutable value objects with generated `copyWith`, `fromJson`, and `toJson`. This eliminates an entire class of mutation bugs.

**Repository pattern** — Supabase datasources are hidden behind abstract repository interfaces. Swapping the backend requires changing only the datasource layer.

**Feature-first layout** — code is organised by feature, not by layer. Finding all code related to `earnings` means navigating to one folder, not hunting across `screens/`, `models/`, and `services/` separately.

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a pull request

Please follow the existing architecture conventions — new features should include datasource, repository, models, and providers layers.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Built with Flutter · Powered by Supabase

</div>
