# Coding Standards

## Naming

- Dart files generally use `snake_case.dart`.
- Classes use `PascalCase`.
- Providers usually end with `Provider`.
- Controllers and notifiers often end with `Controller` or `Notifier`.
- Repository interfaces often end with `Repository`.
- Repository implementations often end with `RepositoryImpl`.
- Supabase datasources often end with `SupabaseDatasource`.
- Feature folder names are mixed: some are lowercase, some are `Client` or `Worker`, and some use names like `Home_client`, `completeProfile`, and `pyment_methods`. Preserve existing names when working in those areas.

## State Management

- Use Riverpod patterns already present in the target feature.
- Use `NotifierProvider` or `AsyncNotifierProvider` where the feature already uses Riverpod 3 notifiers.
- Use `StateNotifierProvider` where the feature already uses `StateNotifier`.
- Use `StateProvider` for small simple UI state when that matches the surrounding code.
- Use `FutureProvider` or `StreamProvider` for async or realtime reads when that matches the surrounding code.
- Keep provider files in the same layer used by the feature: many dependency providers are in `data/providers`, while UI state is in `presentation/providers`.

## Routing

- Add app routes in `lib/router.dart`.
- Use `context.go` for replacement navigation and `context.push` for pushed routes, following nearby usage.
- Pass route data through path parameters or `state.extra` following existing route patterns.
- Be careful with redirect logic because it controls auth, role, and profile setup flows.

## Dependency Injection

- Prefer existing Riverpod provider wiring for Supabase clients, datasources, and repositories.
- Keep datasource and repository wiring near the feature's existing provider files.
- Some controllers instantiate dependencies directly; do not refactor this unless the task asks for it.

## Forms

- Many forms use `reactive_forms` with `FormGroup`, `FormControl`, validators, and `ReactiveForm`.
- Keep forms near the related screen or provider, matching the surrounding feature.

## Models

- Many models use `freezed_annotation`, `part` files, and `fromJson`.
- Do not edit generated files manually.
- Run code generation only when a model change requires it.

## UI

- Use Material widgets and `Theme.of(context)` / `colorScheme` patterns already used by nearby screens.
- Use feature widgets from `presentation/widgets` to keep screens smaller.
- Use `.i18n` for visible user-facing strings where surrounding code does.
- Snackbars use `ScaffoldMessenger.of(context).showSnackBar`.
- Dialogs commonly use `showDialog` with `AlertDialog`.

## Error Handling

- Follow nearby feature behavior.
- Existing patterns include `try/catch`, `AsyncValue.error`, `errorMessage` in state, thrown `Exception`s, and SnackBars for user-visible errors.
- Do not silently swallow errors unless nearby code already does so for the same case.

## Imports And Formatting

- Follow Flutter lint defaults from `package:flutter_lints/flutter.yaml`.
- Keep imports organized in the style of the edited file.
- Remove unused imports.
- Run formatting on edited Dart files when application code changes.
