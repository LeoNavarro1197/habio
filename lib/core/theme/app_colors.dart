import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Color.fromARGB(255, 0, 3, 10);
  static const surface = Color(0xFF141720);
  static const surfaceElevated = Color(0xFF1C1F2E);
  static const card = Color.fromARGB(255, 28, 31, 42);

  static const primary = Color(0xFF4F8CFF);
  static const primaryDim = Color(0xFF3B6FD9);
  static const secondary = Color(0xFF6366F1);
  static const success = Color(0xFF22C55E);
  static const successDim = Color(0xFF16A34A);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);

  static const border = Color(0xFF3A3F52);
  static const borderFocused = Color(0xFF4F8CFF);
  static const divider = Color(0xFF1E2332);

  static const shimmerBase = Color(0xFF1A1D2B);
  static const shimmerHighlight = Color(0xFF232740);

  static Color categoryColor(String id) {
    return switch (id) {
      'study' => const Color(0xFFFFB300),
      'work' => const Color(0xFF26C6DA),
      'health' => const Color(0xFF66BB6A),
      'personal' => const Color(0xFFF06292),
      _ => primary,
    };
  }
}
