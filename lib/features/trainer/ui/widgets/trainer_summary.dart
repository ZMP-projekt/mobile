import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../../classes/providers/classes_provider.dart';

class TrainerSummaryCard extends ConsumerWidget {
  const TrainerSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final trainerClassesAsync = ref.watch(trainerClassesProvider(today));

    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: trainerClassesAsync.when(
          loading: () => _buildSkeleton(),
          error: (error, stack) => _buildErrorState(),
          data: (classes) {
            if (classes.isEmpty) return _buildEmptyState();

            final classCount = classes.length;
            final isBusy = classCount > 2;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DZISIAJ',
                      style: TextStyle(
                          color: isBusy ? AppColors.success : AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                  ],
                ),
                const Text(
                  'Harmonogram gotowy',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Wszystkie zajęcia są zaplanowane.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms);
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSkeleton(width: 100, height: 16),
            Icon(Icons.check_circle_outline_rounded, color: Colors.white10),
          ],
        ),
        const SizedBox(height: 16),
        const AppSkeleton(width: 180, height: 32),
        const Spacer(),
        const AppSkeleton(width: double.infinity, height: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
                'DZISIAJ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)
            ),
            Icon(Icons.event_available_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          ],
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text(
                'Brak zaplanowanych zajęć',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
              value: 0,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1)
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildErrorState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 28),
        const SizedBox(height: 8),
        const Text('Błąd ładowania', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Nie udało się pobrać grafiku.', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 13)),
      ],
    ).animate().fadeIn();
  }
}