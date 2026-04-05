import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/success_overlay.dart';
import '../../../core/ui/widgets/no_connection_view.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/data/models/gym_class.dart';
import '../../classes/utils/gym_class_extension.dart';

class PersonalTrainingsPage extends ConsumerWidget {
  const PersonalTrainingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final classesAsync = ref.watch(classesForDateProvider(selectedDate));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Treningi Personalne',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  _buildHorizontalCalendar(ref, selectedDate),
                ],
              ),
            ),

            Expanded(
              child: classesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => NoConnectionView(onRetry: () => ref.invalidate(classesForDateProvider(selectedDate))),
                data: (dayClasses) {
                  final ptClasses = dayClasses.where((c) => c.personalTraining).toList();

                  if (ptClasses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 130),
                    itemCount: ptClasses.length,
                    itemBuilder: (context, index) {
                      final gymClass = ptClasses[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _UserPtCard(gymClass: gymClass)
                            .animate()
                            .fadeIn(delay: (index * 50).ms, duration: 300.ms)
                            .slideX(begin: 0.05, curve: Curves.easeOutQuad),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCalendar(WidgetRef ref, DateTime selectedDate) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final days = List.generate(14, (index) => normalizedToday.add(Duration(days: index)));

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = date.isAtSameMomentAs(selectedDate);
          final dayName = DateFormat('E', 'pl_PL').format(date).toLowerCase();

          return GestureDetector(
            onTap: () => ref.read(selectedDateProvider.notifier).state = date,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
              boxShadow: AppColors.subtleGlow,
            ),
            child: const Icon(Icons.person_search_rounded, size: 70, color: AppColors.primary),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 25),
          const Text(
            'Brak dostępnych\ntreningów w tym dniu',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 12),
          const Text(
            'Wybierz inną datę z kalendarza powyżej',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _UserPtCard extends ConsumerWidget {
  final GymClass gymClass;

  const _UserPtCard({required this.gymClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider).isLoading;

    return GestureDetector(
      onTap: () {
        context.push(
          '/class-details',
          extra: {'gymClass': gymClass, 'imageUrl': gymClass.displayImageUrl},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: gymClass.userEnrolled
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.background,
              backgroundImage: NetworkImage(gymClass.trainer.photoUrl ?? gymClass.trainer.displayAvatarUrl),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gymClass.trainer.fullName,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gymClass.description != null && gymClass.description!.isNotEmpty
                        ? gymClass.description!
                        : 'Trening personalny',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${gymClass.startTimeFormatted} (${gymClass.durationMinutes} min)',
                        style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            _buildActionArea(context, ref, isProcessing),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(BuildContext context, WidgetRef ref, bool isProcessing) {
    if (gymClass.userEnrolled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: const Text('ZAPISANO', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
      );
    }

    if (gymClass.isFull || gymClass.isPast) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
            gymClass.isPast ? 'ZAKOŃCZONE' : 'BRAK MIEJSC',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)
        ),
      );
    }

    return GestureDetector(
      onTap: isProcessing ? null : () async {
        try {
          await ref.read(bookingNotifierProvider.notifier).bookClass(gymClass.id);
          if (!context.mounted) return;
          await SuccessOverlay.show(context, "Zapisano na\ntrening!");
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Błąd: $e'), backgroundColor: AppColors.error)
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: isProcessing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Text('Zapisz', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}