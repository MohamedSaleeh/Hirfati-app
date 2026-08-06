import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';
import '../theme/dashboard_colors.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.title,
    this.subtitle,
    this.trailing,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dashboardPanelDecoration(),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || trailing != null) ...[
              Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              color: DashboardColors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DashboardColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.badge,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.hasBoundedHeight && constraints.maxHeight < 158;
        final padding = isCompact ? 14.0 : 16.0;
        final iconSide = isCompact ? 40.0 : 44.0;
        final iconSize = isCompact ? 20.0 : 22.0;
        final titleFontSize = isCompact ? 12.0 : 13.0;
        final valueFontSize = isCompact ? 22.0 : 24.0;
        final subtitleFontSize = isCompact ? 10.5 : 11.0;
        final titleGap = isCompact ? 5.0 : 7.0;
        final subtitleGap = isCompact ? 5.0 : 7.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: dashboardPanelDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    height: iconSide,
                    width: iconSide,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  const Spacer(),
                  if (badge != null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 110),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 7 : 8,
                          vertical: isCompact ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: isCompact ? 10 : 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: DashboardColors.muted,
                  fontSize: titleFontSize,
                  height: 1.15,
                ),
              ),
              SizedBox(height: titleGap),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: TextStyle(
                      color: DashboardColors.text,
                      fontWeight: FontWeight.w900,
                      fontSize: valueFontSize,
                      height: 1.05,
                    ),
                  ),
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: subtitleGap),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: DashboardColors.muted,
                    fontSize: subtitleFontSize,
                    height: 1.15,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class DashboardBadge extends StatelessWidget {
  const DashboardBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSearchField extends StatelessWidget {
  const DashboardSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      style: const TextStyle(color: DashboardColors.text, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: DashboardColors.muted, fontSize: 12),
        prefixIcon: const Icon(
          Icons.search,
          color: DashboardColors.muted,
          size: 18,
        ),
        filled: true,
        fillColor: DashboardColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DashboardColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DashboardColors.primary),
        ),
      ),
    );
  }
}

class DashboardResponsiveBox extends StatelessWidget {
  const DashboardResponsiveBox({
    super.key,
    required this.preferredWidth,
    required this.child,
    this.minWidth = 180,
  });

  final double preferredWidth;
  final double minWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : preferredWidth;
        final width = maxWidth < minWidth
            ? maxWidth
            : maxWidth < preferredWidth
            ? maxWidth
            : preferredWidth;

        return SizedBox(width: width, child: child);
      },
    );
  }
}

class DashboardSelect<T> extends StatelessWidget {
  const DashboardSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
  });

  final T value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: DashboardColors.surfaceAlt,
        iconEnabledColor: DashboardColors.muted,
        style: const TextStyle(color: DashboardColors.text, fontSize: 12),
        decoration: InputDecoration(
          filled: true,
          fillColor: DashboardColors.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: DashboardColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: DashboardColors.primary),
          ),
        ),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = DashboardColors.primary,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final foreground = outlined ? color : Colors.white;
    final background = outlined ? Colors.transparent : color;

    return SizedBox(
      height: 42,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledForegroundColor: DashboardColors.muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(color: outlined ? DashboardColors.border : color),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }
}

class DashboardIconAction extends StatelessWidget {
  const DashboardIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = DashboardColors.muted,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 18),
        splashRadius: 18,
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        style: IconButton.styleFrom(
          backgroundColor: DashboardColors.surfaceAlt,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(color: DashboardColors.border),
          ),
        ),
      ),
    );
  }
}

class DashboardAvatar extends StatelessWidget {
  const DashboardAvatar({
    super.key,
    required this.label,
    this.imageUrl,
    this.color = DashboardColors.primary,
  });

  final String label;
  final String? imageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 17,
      backgroundColor: color.withValues(alpha: 0.22),
      backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
      child: imageUrl == null
          ? Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
    );
  }
}

class DashboardTableFrame extends StatelessWidget {
  const DashboardTableFrame({
    super.key,
    required this.child,
    this.minWidth = 760,
  });

  final Widget child;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: dashboardPanelDecoration(color: DashboardColors.surfaceAlt),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

class DashboardPagination extends StatelessWidget {
  const DashboardPagination({
    super.key,
    required this.summary,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPageChanged,
  });

  final String summary;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final firstPage = totalPages <= 5
        ? 1
        : (currentPage - 2).clamp(1, totalPages - 4);
    final pages = List<int>.generate(
      totalPages.clamp(1, 5),
      (index) => firstPage + index,
    );
    return Row(
      children: [
        Expanded(
          child: Text(
            summary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: DashboardColors.muted, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        DashboardIconAction(
          icon: Icons.chevron_right,
          tooltip: 'السابق',
          onPressed: currentPage <= 1 || onPageChanged == null
              ? null
              : () => onPageChanged!(currentPage - 1),
        ),
        const SizedBox(width: 6),
        ...pages.map(
          (page) => Container(
            height: 32,
            width: 32,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: page == currentPage
                  ? DashboardColors.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: page == currentPage
                    ? DashboardColors.primary
                    : DashboardColors.border,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: page == currentPage || onPageChanged == null
                  ? null
                  : () => onPageChanged!(page),
              child: Center(
                child: Text(
                  '$page',
                  style: const TextStyle(
                    color: DashboardColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        DashboardIconAction(
          icon: Icons.chevron_left,
          tooltip: 'التالي',
          onPressed: currentPage >= totalPages || onPageChanged == null
              ? null
              : () => onPageChanged!(currentPage + 1),
        ),
      ],
    );
  }
}

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inbox_outlined,
            color: DashboardColors.muted,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DashboardColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: DashboardColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Color userRoleColor(UserDashboardRole role) {
  return switch (role) {
    UserDashboardRole.client => DashboardColors.muted,
    UserDashboardRole.craftsman => DashboardColors.purple,
    UserDashboardRole.admin => DashboardColors.info,
  };
}

String userRoleLabel(UserDashboardRole role) {
  return switch (role) {
    UserDashboardRole.client => 'عميل',
    UserDashboardRole.craftsman => 'حرفي',
    UserDashboardRole.admin => 'مدير',
  };
}

Color userStatusColor(UserDashboardStatus status) {
  return switch (status) {
    UserDashboardStatus.active => DashboardColors.success,
    UserDashboardStatus.pendingReview => DashboardColors.warning,
    UserDashboardStatus.suspended => DashboardColors.danger,
  };
}

String userStatusLabel(UserDashboardStatus status) {
  return switch (status) {
    UserDashboardStatus.active => 'نشط',
    UserDashboardStatus.pendingReview => 'قيد المراجعة',
    UserDashboardStatus.suspended => 'غير نشط',
  };
}

Color verificationColor(VerificationDashboardStatus status) {
  return switch (status) {
    VerificationDashboardStatus.pending => DashboardColors.warning,
    VerificationDashboardStatus.approved => DashboardColors.success,
    VerificationDashboardStatus.rejected => DashboardColors.danger,
  };
}

String verificationLabel(VerificationDashboardStatus status) {
  return switch (status) {
    VerificationDashboardStatus.pending => 'قيد المراجعة',
    VerificationDashboardStatus.approved => 'مقبول',
    VerificationDashboardStatus.rejected => 'مرفوض',
  };
}

Color complaintPriorityColor(ComplaintPriority priority) {
  return switch (priority) {
    ComplaintPriority.low => DashboardColors.muted,
    ComplaintPriority.medium => DashboardColors.warning,
    ComplaintPriority.high => DashboardColors.danger,
  };
}

String complaintPriorityLabel(ComplaintPriority priority) {
  return switch (priority) {
    ComplaintPriority.low => 'منخفضة',
    ComplaintPriority.medium => 'متوسطة',
    ComplaintPriority.high => 'عالية',
  };
}

Color complaintStatusColor(ComplaintDashboardStatus status) {
  return switch (status) {
    ComplaintDashboardStatus.open => DashboardColors.primary,
    ComplaintDashboardStatus.inReview => DashboardColors.warning,
    ComplaintDashboardStatus.archived => DashboardColors.success,
  };
}

String complaintStatusLabel(ComplaintDashboardStatus status) {
  return switch (status) {
    ComplaintDashboardStatus.open => 'مفتوحة',
    ComplaintDashboardStatus.inReview => 'قيد المراجعة',
    ComplaintDashboardStatus.archived => 'تم الحل',
  };
}

Color activityToneColor(ActivityTone tone) {
  return switch (tone) {
    ActivityTone.neutral => DashboardColors.primary,
    ActivityTone.success => DashboardColors.success,
    ActivityTone.warning => DashboardColors.warning,
    ActivityTone.danger => DashboardColors.danger,
  };
}

String dashboardNumber(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String dashboardAmount(double value) {
  final whole = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return '\$$whole USD';
}

String dashboardDate(DateTime? date) {
  if (date == null) return 'غير محدد';
  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String dashboardTimeAgo(DateTime date) {
  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return 'الآن';
  if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
  if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
  return 'منذ ${difference.inDays} أيام';
}
