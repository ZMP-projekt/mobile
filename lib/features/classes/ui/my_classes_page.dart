import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class MyClassesPage extends ConsumerWidget {
  const MyClassesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.8,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.secondary.withValues(alpha: 0.08),
            AppColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Moje Zajęcia',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.2, end: 0),
              const SizedBox(height: 8),
              Text(
                'Twoje zapisane treningi',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: -0.2, end: 0),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 80,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 600.ms)
                          .scale(begin: Offset(0.8, 0.8))
                          .then()
                          .shimmer(duration: 2.seconds, color: AppColors.primary.withValues(alpha: 0.1)),
                      const SizedBox(height: 20),
                      const Text(
                        'Moje zajęcia - TODO',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 18,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms),
                      const SizedBox(height: 8),
                      const Text(
                        'Zajęcia na które jesteś zapisany',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}