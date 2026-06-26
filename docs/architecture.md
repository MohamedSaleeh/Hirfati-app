# Architecture

The app uses a feature-first layered structure.

## App Entry

- `lib/main.dart` initializes Flutter bindings, Arabic translations, Firebase, dotenv, Supabase, and notification services.
- The root widget wraps the app in `ProviderScope` and `I18n`.
- `MaterialApp.router` uses the `GoRouter` from `routerProvider`.
- Themes are defined in `lib/theme.dart`.
- Translations are defined in `lib/translations.dart` and loaded from `assets/translations/ar.json`.

## Routing

- Routing is centralized in `lib/router.dart`.
- `routerProvider` is a Riverpod `Provider<GoRouter>`.
- Redirect logic checks auth status, user role, and profile completion.
- Screens are imported directly into the router.

## Features

Most features are organized under `lib/features/<feature>` or under grouped folders such as `lib/features/Client` and `lib/features/Worker`.

Common feature layers:
- `data`: Supabase datasources, repository implementations, and data providers.
- `domain`: models and repository interfaces.
- `presentation`: screens, widgets, and UI state providers/controllers.

Some features also contain `application` folders, but their role is not clearly defined in the current project.

## State Management

State management uses Riverpod. Existing code uses:
- `Provider`
- `StateProvider`
- `NotifierProvider`
- `AsyncNotifierProvider`
- `StateNotifierProvider`
- `FutureProvider`
- `StreamProvider`

Some `StateNotifierProvider` usage imports `package:flutter_riverpod/legacy.dart`.

## Data Access

Data access is mostly implemented through Supabase datasource classes in `data/datasources`.
Repository interfaces are placed in `domain/repositories`, and implementations are placed in `data/repositories`.
Provider files often connect `Supabase.instance.client`, datasources, and repositories.

## Shared Code

Shared utilities, widgets, models, services, and core presentation providers live under `lib/core`.

## Error Handling

Error handling is local to features. Common patterns include `try/catch`, `AsyncValue`, `errorMessage` fields in state classes, thrown `Exception`s from repositories, `print` logging, `SnackBar`, and `AlertDialog`.

## Dependency Injection

Dependency injection is mainly done with Riverpod providers. Some controllers instantiate repositories or datasources directly inside `build()`.
