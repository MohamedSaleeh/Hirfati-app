import 'package:flutter/material.dart';

class PinInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;

  const PinInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        hintText: hint ?? '****',
        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        errorText: errorText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock, color: theme.colorScheme.primary),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface),
      keyboardType: TextInputType.number,
      obscureText: obscureText,
      maxLength: 4,
    );
  }
}
