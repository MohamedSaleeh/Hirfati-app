import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_setup_controller.dart';

class ProfileAvatarPicker extends ConsumerWidget {
  const ProfileAvatarPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileState = ref.watch(profileSetupProvider);
    final controller = ref.read(profileSetupProvider.notifier);

    final localPath = profileState.asData?.value.avatarLocalPath;
    final hasImage = localPath != null && localPath.isNotEmpty;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _DashedCirclePainter(
                  color: colorScheme.outlineVariant,
                  strokeWidth: 2,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage: hasImage
                        ? FileImage(File(localPath))
                        : null,
                    child: hasImage
                        ? null
                        : Icon(
                            Icons.person,
                            size: 56,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: -4,
              child: GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                    border: Border.all(color: colorScheme.surface, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: colorScheme.onPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Add a photo so craftsmen can recognize you\nand for easier communication',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 8,
    this.gapLength = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    final circumference = 2 * 3.14159265358979 * radius;

    final dashCount = (circumference / (dashLength + gapLength)).floor();
    final actualGap = (circumference - dashCount * dashLength) / dashCount;

    double startAngle = -1.5707963267948966;
    for (int i = 0; i < dashCount; i++) {
      final sweepAngle = (dashLength / circumference) * 6.283185307179586;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle +=
          sweepAngle + ((actualGap / circumference) * 6.283185307179586);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
