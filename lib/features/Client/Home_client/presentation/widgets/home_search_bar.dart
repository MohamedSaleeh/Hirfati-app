import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class HomeSearchBar extends StatelessWidget {
  final FormControl<String> searchControl;

  const HomeSearchBar({super.key, required this.searchControl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ReactiveForm(
      formGroup: FormGroup({'search': searchControl}),
      child: ReactiveTextField<String>(
        formControl: searchControl,
        decoration: InputDecoration(
          hintText: 'Find plumbing, cleaning...'.i18n,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 22,
          ),
          suffixIcon:
              searchControl.value != null && searchControl.value!.isNotEmpty
              ? GestureDetector(
                  onTap: () => searchControl.reset(),
                  child: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
