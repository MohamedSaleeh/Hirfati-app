import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const PinKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildRow(['1', '2', '3'], context),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6'], context),
        const SizedBox(height: 12),
        _buildRow(['7', '8', '9'], context),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDeleteButton(context),
            _buildKey('0', theme),
            _buildSubmitButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> keys, BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildKey(key, theme);
      }).toList(),
    );
  }

  Widget _buildKey(String digit, ThemeData theme) {
    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: () => onKeyPressed(digit),
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: onDelete,
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.errorContainer,
          foregroundColor: theme.colorScheme.onErrorContainer,
        ),
        child: Icon(Icons.backspace, size: 28, color: theme.colorScheme.error),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: onSubmit,
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Icon(Icons.check, size: 28, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
