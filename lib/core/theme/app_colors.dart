import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFF20D0D);
  static const Color primaryLight = Color(0xFFF20D0D);
  static const Color primaryWithOpacity10 = Color(0x1AF20D0D);
  static const Color primaryWithOpacity20 = Color(0x33F20D0D);
  static const Color primaryWithOpacity30 = Color(0x4DF20D0D);

  // Background
  static const Color backgroundLight = Color(0xFFF8F5F5);
  static const Color backgroundDark = Color(0xFF221010);

  // Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B); // slate-800

  // Text
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
  static const Color textSecondary = Color(0xFF475569); // slate-600
  static const Color textHint = Color(0xFF94A3B8); // slate-400
  static const Color textMuted = Color(0xFF64748B); // slate-500

  // Border
  static const Color border = Color(0xFFE2E8F0); // slate-200
  static const Color borderDark = Color(0xFF334155); // slate-700

  // Alert Colors
  static const Color critical = Color(0xFFF20D0D);
  static const Color important = Color(0xFFFFA726);
  static const Color general = Color(0xFF42A5F5);

  // SOS
  static const Color sosRed = Color(0xFFF20D0D);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF20D0D);
  static const Color info = Color(0xFF42A5F5);
}
