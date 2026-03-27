import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/membership_provider.dart';

final selectedPlanTypeProvider = StateProvider<String>((ref) => 'OPEN');

class MembershipPurchaseModal extends ConsumerWidget {
  const MembershipPurchaseModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedPlanTypeProvider);
    final purchaseState = ref.watch(purchaseMembershipProvider);

    final plans = [
      {'type': 'OPEN', 'title': 'Karnet OPEN', 'price': '170 zł', 'desc': 'Całodobowy dostęp do klubu', 'highlight': true},
      {'type': 'NIGHT', 'title': 'Karnet NIGHT', 'price': '80 zł', 'desc': 'Dostęp w godzinach 22:00 - 06:00'},
      {'type': 'STUDENT', 'title': 'Karnet STUDENT', 'price': ' 100 zł', 'desc': 'Dla osób z ważną legitymacją'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const Text(
              'Wybierz Karnet',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
            const SizedBox(height: 8),
            const Text(
              'Uzyskaj pełny dostęp do klubu dopasowany do Twojego stylu życia.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.4),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 32),

            ...List.generate(plans.length, (index) {
              final plan = plans[index];
              final isSelected = selectedType == plan['type'];
              final isHighlighted = plan['highlight'] == true;

              return GestureDetector(
                onTap: () => ref.read(selectedPlanTypeProvider.notifier).state = plan['type'] as String,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.05),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))
                            : null,
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(plan['title'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                                if (isHighlighted) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('HIT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(plan['desc'] as String, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                          ],
                        ),
                      ),

                      // Cena
                      Text(
                        plan['price'] as String,
                        style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (200 + index * 100).ms).slideX(begin: 0.05);
            }),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: purchaseState.isLoading ? null : () async {
                  final success = await ref.read(purchaseMembershipProvider.notifier).purchase(selectedType);

                  if (!context.mounted) return;

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Karnet zakupiony pomyślnie! 🎉'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.read(purchaseMembershipProvider).error.toString()),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  shadowColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                child: purchaseState.isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Kupuję i płacę', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}