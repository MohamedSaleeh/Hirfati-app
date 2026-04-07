import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../translations.dart';
import '../../../client_navigation/presentation/providers/client_navigation_provider.dart';

class LiveMapCard extends ConsumerWidget {
  final int nearbyCount;
  final List<String?> avatarUrls;

  const LiveMapCard({
    super.key,
    this.nearbyCount = 12,
    this.avatarUrls = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        ref.read(clientNavigationProvider.notifier).state = 2;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.5),
                colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapPatternPainter(context: context),
                ),
              ),
              ..._buildMapDots(context),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'LIVE MAP'.i18n,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$nearbyCount ${'Craftsmen Nearby'.i18n}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (avatarUrls.isNotEmpty) _buildAvatarStack(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMapDots(BuildContext context) {
    final positions = [
      const Offset(0.55, 0.25),
      const Offset(0.75, 0.45),
      const Offset(0.40, 0.55),
    ];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return positions.asMap().entries.map((e) {
      final i = e.key;
      final pos = e.value;
      final url = i < avatarUrls.length ? avatarUrls[i] : null;
      return Positioned(
        left: pos.dx * 300,
        top: pos.dy * 160,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(color: colorScheme.surface, width: 2),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.2),
                blurRadius: 4,
              ),
            ],
            image: url != null
                ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                : null,
          ),
          child: url == null
              ? const Icon(Icons.person, size: 16, color: Colors.grey)
              : null,
        ),
      );
    }).toList();
  }

  Widget _buildAvatarStack(BuildContext context) {
    final show = avatarUrls.take(3).toList();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      width: (show.length * 20 + 22).toDouble(),
      height: 32,
      child: Stack(
        children: show.asMap().entries.map((e) {
          final url = e.value;
          return Positioned(
            left: e.key * 20.0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2),
                color: colorScheme.surfaceContainer,
                image: url != null
                    ? DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  final context;
  _MapPatternPainter({this.context});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MapPatternPainter oldDelegate) => false;
}
