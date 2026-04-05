import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../../../core/ui/widgets/empty_state_view.dart';
import '../../../../core/ui/success_overlay.dart';
import '../../../classes/data/models/gym_class.dart';
import '../../../classes/providers/classes_provider.dart';
import '../../../classes/ui/widgets/compact_class_card.dart';
import '../../../classes/utils/gym_class_extension.dart';
import '../../../membership/providers/membership_provider.dart';
import '../../../membership/ui/widgets/membership_purchase_modal.dart';

class TodayClassesCarousel extends ConsumerWidget {
  const TodayClassesCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayClassesAsync = ref.watch(todayClassesProvider);

    final membershipAsync = ref.watch(currentMembershipProvider);
    final hasActiveMembership = membershipAsync.valueOrNull?.active == true &&
        (membershipAsync.valueOrNull?.daysRemaining ?? 0) > 0;

    return todayClassesAsync.when(
      loading: () => _buildSkeleton(),
      error: (err, stack) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text('Nie udało się pobrać dzisiejszych zajęć.', style: TextStyle(color: AppColors.error, fontSize: 14)),
      ),
      data: (classes) {
        if (!hasActiveMembership && membershipAsync.hasValue) {
          return GestureDetector(
            onTap: () => MembershipPurchaseModal.show(context),
            child: const EmptyStateView(
              icon: Icons.lock_outline,
              title: 'Dzisiejsze zajęcia',
              subtitle: 'Kup karnet, aby zobaczyć grafik na dziś i zapisać się na trening! ⚡',
            ).animate().fadeIn(),
          );
        }

        // Filtrowanie na dwie kategorie
        // Jeśli w modelu masz isPersonalTraining zamiast personalTraining, zmień to tutaj!
        final groupClasses = classes.where((c) => !c.personalTraining).toList();
        final ptClasses = classes.where((c) => c.personalTraining).toList();

        // Brak jakichkolwiek zajęć w dniu dzisiejszym
        if (classes.isEmpty) {
          return const EmptyStateView(
            icon: Icons.wb_sunny_rounded,
            title: 'Czas na odpoczynek',
            subtitle: 'Brak nadchodzących zajęć na dziś. Zregeneruj siły!',
          ).animate().fadeIn();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEKCJA ZAJĘĆ GRUPOWYCH (Karuzela) ---
            if (groupClasses.isNotEmpty)
              SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: groupClasses.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    return CompactClassCard(gymClass: groupClasses[index]);
                  },
                ),
              ).animate().fadeIn(duration: 400.ms)
            else
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: EmptyStateView(
                  icon: Icons.event_busy_rounded,
                  title: 'Brak zajęć grupowych',
                  subtitle: 'Nie ma już dzisiaj zaplanowanych zajęć grupowych.',
                ),
              ).animate().fadeIn(),

            // --- SEKCJA TRENINGÓW PERSONALNYCH (Pionowa lista) ---
            if (ptClasses.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Dostępne Treningi 1 na 1',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: ptClasses.map((pt) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DashboardUserPtCard(gymClass: pt),
                  )).toList(),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ]
          ],
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) => const AppSkeleton(width: 260, height: 180, borderRadius: 24),
      ),
    );
  }
}

// ---------------------------------------------------------
// Dedykowana karta dla Treningu Personalnego na Dashboardzie
// ---------------------------------------------------------
class _DashboardUserPtCard extends ConsumerWidget {
  final GymClass gymClass;

  const _DashboardUserPtCard({required this.gymClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider).isLoading;

    return GestureDetector(
      onTap: () {
        context.push('/class-details', extra: {'gymClass': gymClass, 'imageUrl': gymClass.displayImageUrl});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gymClass.userEnrolled
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Avatar trenera
            CircleAvatar(
              radius: 26,
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
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gymClass.description != null && gymClass.description!.isNotEmpty
                        ? gymClass.description!
                        : 'Trening personalny',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
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

  // Przycisk zapisu na trening wbudowany w kartę
  Widget _buildActionArea(BuildContext context, WidgetRef ref, bool isProcessing) {
    if (gymClass.userEnrolled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: const Text('ZAPISANO', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
      );
    }

    if (gymClass.isFull || gymClass.isPast) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
        child: Text(
          gymClass.isPast ? 'ZAKOŃCZONE' : 'BRAK MIEJSC',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e'), backgroundColor: AppColors.error));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
        child: isProcessing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Text('Zapisz', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}