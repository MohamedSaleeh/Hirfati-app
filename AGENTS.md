# Project Guidance

Read this file before making any project change.

## Project Summary

This is a Flutter app named `hirfati`.

The app uses:

- `flutter_riverpod` for state management and dependency wiring.
- `go_router` for routing in `lib/router.dart`.
- `supabase_flutter` for backend data access.
- Firebase initialization and messaging-related services.
- `reactive_forms` for many forms.
- `freezed` and `json_serializable` for generated models.
- `i18n_extension` with JSON-loaded Arabic translations.
- `flex_color_scheme` for app themes in `lib/theme.dart`.

The project is organized mainly by feature under `lib/features`, usually with `data`, `domain`, and `presentation` folders. Shared code lives under `lib/core`.

## Required Workflow

- Read `AGENTS.md` first before making changes.
- Read only the files related to the requested task.
- Do not scan the whole project unless the task explicitly requires it.
- Make the smallest possible diff.
- Do not modify unrelated files.
- Do not change business logic unless explicitly requested.
- Do not add, remove, or upgrade dependencies unless explicitly requested.
- Follow existing project conventions, even when naming is inconsistent.
- Do not manually edit generated `*.freezed.dart` or `*.g.dart` files.
- Keep changes inside the requested scope.
- After every change, summarize changed files and checks performed.

## Reference Docs

Use these files for more detail:

- `docs/architecture.md`
- `docs/project_structure.md`
- `docs/coding_standards.md`
- `docs/code_review.md`
