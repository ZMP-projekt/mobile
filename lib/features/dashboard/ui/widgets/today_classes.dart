import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../../../core/ui/widgets/empty_state_view.dart';
import '../../../classes/providers/classes_provider.dart';
import '../../../classes/ui/widgets/compact_class_card.dart';
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

        if (classes.isEmpty) {
          return const EmptyStateView(
            icon: Icons.wb_sunny_rounded,
            title: 'Czas na odpoczynek',
            subtitle: 'Brak nadchodzących zajęć na dziś. Zregeneruj siły!',
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              return CompactClassCard(gymClass: classes[index]);
            },
          ),
        ).animate().fadeIn(duration: 400.ms);
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