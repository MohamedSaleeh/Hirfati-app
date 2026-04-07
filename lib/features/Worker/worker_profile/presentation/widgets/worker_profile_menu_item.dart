import 'package:flutter/material.dart';

class WorkerProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDisabled;

  const WorkerProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDisabled ? Colors.grey.shade400 : null;

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color ?? Theme.of(context).colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: color ?? Colors.grey.shade600,
              ),
            )
          : null,
      trailing:
          trailing ??
          (isDisabled
              ? const Icon(Icons.lock, size: 16, color: Colors.grey)
              : const Icon(Icons.chevron_right, color: Colors.grey)),
      onTap: onTap,
    );
  }
}
