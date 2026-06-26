# Code Review Checklist

Use this checklist after every change.

- Did the change stay inside the requested scope?
- Were unrelated files left untouched?
- Is the diff the smallest practical diff?
- Was business logic preserved unless the task required changing it?
- Were dependencies left unchanged unless explicitly requested?
- Are imports used and organized consistently with nearby files?
- Are Dart files formatted?
- Were generated `*.freezed.dart` and `*.g.dart` files avoided unless generated intentionally?
- Does state management match the target feature's existing Riverpod pattern?
- Are provider locations consistent with nearby files?
- Are routes added or changed only in `lib/router.dart`?
- Could router redirect behavior be affected?
- Is dependency wiring consistent with nearby datasource/repository providers?
- Are errors handled consistently with the feature?
- Are user-visible errors shown with the existing SnackBar/dialog style when needed?
- Are visible strings localized with `.i18n` where nearby code does that?
- Are new files placed in the correct feature layer?
- Are UI patterns consistent with nearby screens and widgets?
- Were checks run or intentionally skipped with a clear reason?
