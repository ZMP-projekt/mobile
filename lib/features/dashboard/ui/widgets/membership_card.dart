import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../../../core/ui/widgets/async_value_widget.dart';
import '../../../membership/ui/widgets/membership_purchase_modal.dart';
import '../../../membership/providers/membership_provider.dart';

class MembershipCard extends ConsumerWidget {
  const MembershipCard({super.key});

  void _showPurchaseModal(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const MembershipPurchaseModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipAsync = ref.watch(currentMembershipProvider);

    return GestureDetector(
      onTap: () => _showPurchaseModal(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 15, spreadRadius: 1, offset: const Offset(0, 4))],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: AsyncValueWidget(
            value: membershipAsync,
            loading: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppSkeleton(width: 100, height: 16),
                SizedBox(height: 16),
                AppSkeleton(width: 180, height: 26),
                SizedBox(height: 20),
                AppSkeleton(width: double.infinity, height: 8),
              ],
            ),
            data: (membership) {
              if (!membership.active || membership.daysRemaining == 0) return _buildEmptyState();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Karnet ${membership.type}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
                      const Icon(Icons.workspace_premium, color: Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Aktywny: ${membership.daysRemaining} dni', style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(value: membership.progressValue, minHeight: 8, backgroundColor: Colors.white.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Brak aktywnego karnetu', style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.bold)),
            Icon(Icons.credit_card_off, color: AppColors.error),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Kup dostęp już dziś!', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: 0.0, minHeight: 8, backgroundColor: Colors.white.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary))),
      ],
    ).animate().fadeIn();
  }
}