import 'package:flutter/material.dart';

class AppColors {

  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);

  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF8B5CF6);


  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.7),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.5),
      blurRadius: 35,
      spreadRadius: 4,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      blurRadius: 80,
      spreadRadius: 8,
      offset: const Offset(0, 10),
    ),
  ];
}