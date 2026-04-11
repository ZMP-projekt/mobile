import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class FullScreenEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;

  const FullScreenEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: iconColor == AppColors.primary ? AppColors.subtleGlow : null,
            ),
            child: Icon(icon, size: 70, color: iconColor),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 25),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.2
            ),
          ).animate().fadeIn(delay: 200.ms),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ).animate().fadeIn(delay: 300.ms),
          ]
        ],
      ),
    );
  }
}