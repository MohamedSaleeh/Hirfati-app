import 'package:flutter/material.dart';

abstract final class DashboardColors {
  static const Color background = Color(0xFF0B111C);
  static const Color sidebar = Color(0xFF111827);
  static const Color surface = Color(0xFF151E2D);
  static const Color surfaceAlt = Color(0xFF1A2535);
  static const Color border = Color(0xFF263447);
  static const Color primary = Color(0xFF1469E8);
  static const Color primarySoft = Color(0xFF16345F);
  static const Color text = Color(0xFFF7FAFC);
  static const Color muted = Color(0xFF8EA0B8);
  static const Color success = Color(0xFF20C56B);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color teal = Color(0xFF14B8A6);
}

BoxDecoration dashboardPanelDecoration({Color? color}) {
  return BoxDecoration(
    color: color ?? DashboardColors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: DashboardColors.border),
  );
}
