import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/success_overlay.dart';
import '../../../core/ui/widgets/full_screen_empty_state.dart';
import '../../../core/ui/widgets/horizontal_calendar.dart';
import '../../../core/ui/widgets/no_connection_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/data/models/gym_class.dart';
import '../../classes/utils/gym_class_extension.dart';

class PersonalTrainingsPage extends ConsumerWidget {
  const PersonalTrainingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final classesAsync = ref.watch(classesForDateProvider(selectedDate));
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                    l10n.trainerDashboardPersonalTrainings,
                    style: const TextStyle(color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0),
                  ).animate().fadeIn(duration: 400.ms).slideY(
                      begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  HorizontalCalendar(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      ref
                          .read(selectedDateProvider.notifier)
                          .state = date;
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: classesAsync.when(
                loading: () =>
                const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) =>
                    NoConnectionView(onRetry: () =>
                        ref.invalidate(classesForDateProvider(selectedDate))),
                data: (dayClasses) {
                  final ptClasses = dayClasses
                      .where((c) => c.personalTraining)
                      .toList();

                  if (ptClasses.isEmpty) {
                    return FullScreenEmptyState(
                      icon: Icons.person_search_rounded,
                      title: l10n.classesNoTrainingsDateTitle,
                      subtitle: l10n.classesChooseAnotherDate,
                      iconColor: AppColors.primary,
                    );
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
}

class _UserPtCard extends ConsumerWidget {
  final GymClass gymClass;

  const _UserPtCard({required this.gymClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider).isLoading;
    final l10n = AppLocalizations.of(context)!;

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
                        : l10n.trainerPersonalTraining,
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

            _buildActionArea(context, ref, isProcessing, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(BuildContext context, WidgetRef ref, bool isProcessing, AppLocalizations l10n) {
    if (gymClass.userEnrolled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: Text(l10n.classesBooked, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
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
            gymClass.isPast ? l10n.classesFinished.toUpperCase() : l10n.classesFull,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)
        ),
      );
    }

    return GestureDetector(
      onTap: isProcessing ? null : () async {
        try {
          await ref.read(bookingNotifierProvider.notifier).bookClass(gymClass.id);
          if (!context.mounted) return;
          await SuccessOverlay.show(context, l10n.classesBookingSuccess);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.classesGenericError(e)), backgroundColor: AppColors.error)
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
            : Text(l10n.classesBook, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}
