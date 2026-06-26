# Project Structure

## Root `lib` Files

- `lib/main.dart`: app startup and service initialization.
- `lib/router.dart`: centralized GoRouter routes and redirects.
- `lib/theme.dart`: light and dark theme configuration.
- `lib/translations.dart`: string localization extension and Arabic JSON loading.

## Core

- `lib/core/models`: shared models.
- `lib/core/presentation/providers`: shared UI providers such as theme state.
- `lib/core/presentation/screens`: shared or legacy app screens.
- `lib/core/presentation/widgets`: shared UI widgets.
- `lib/core/services`: app-wide services.
- `lib/core/utils`: shared utilities and formatters.
- `lib/core/widgets`: shared widgets.

## Features

Features live under `lib/features`.

Top-level feature groups include:
- `auth`
- `chat`
- `Client`
- `Worker`
- `help_support`
- `notifications`
- `notification_settings`
- `payment`
- `review`
- `costom_arch`

Many feature folders follow this shape:
- `data/datasources`
- `data/providers`
- `data/repositories`
- `domain/models`
- `domain/repositories`
- `presentation/providers`
- `presentation/screens`
- `presentation/widgets`

## Where To Add Code

- New screens: add under the related feature's `presentation/screens`.
- New widgets: add under the related feature's `presentation/widgets`; use `lib/core` only for shared widgets.
- UI state/controllers: add under the related feature's `presentation/providers`.
- Datasources: add under the related feature's `data/datasources`.
- Repository interfaces: add under the related feature's `domain/repositories`.
- Repository implementations: add under the related feature's `data/repositories`.
- Data wiring providers: add under the related feature's `data/providers`.
- Models: add under `domain/models` when they represent feature/domain state; follow existing generated model patterns when present.
- Shared services: add under `lib/core/services`, unless the existing feature already has `data/services`.
- Shared helpers: add under `lib/core/utils`.
- Routes: add to `lib/router.dart`.

## Generated Files

Files ending in `.freezed.dart` and `.g.dart` are generated and should not be edited manually.

## Unclear Areas

- The exact role of `application` folders: Not clearly defined in the current project.
- The purpose of `features/costom_arch`: Not clearly defined in the current project.
- A single global naming convention for feature folders: Not clearly defined in the current project.
