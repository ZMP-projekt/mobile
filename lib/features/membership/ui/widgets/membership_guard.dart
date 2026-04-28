import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_gym_app/core/ui/widgets/no_connection_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../user/providers/user_provider.dart';
import '../../providers/membership_provider.dart';
import 'membership_purchase_modal.dart';

class MembershipGuard extends ConsumerWidget {
  final Widget child;

  const MembershipGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isTrainer = userAsync.valueOrNull?.isTrainer ?? false;

    if (isTrainer) return child;

    final membershipAsync = ref.watch(currentMembershipProvider);

    if (membershipAsync.hasValue) {
      final membership = membershipAsync.value!;
      if (membership.active && membership.daysRemaining > 0) {
        return child;
      }
      return _buildLockedScreen(context);
    }

    if (membershipAsync.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (membershipAsync.hasError) {
      return NoConnectionView(
        onRetry: () {
          ref.invalidate(currentUserProvider);
          ref.invalidate(currentMembershipProvider);
        },
      );
    }

    return _buildLockedScreen(context);
  }

  Widget _buildLockedScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                  boxShadow: AppColors.mediumGlow,
                ),
                child: const Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
              ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 32),

              Text(
                l10n.membershipLockedTitle,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: 16),

              Text(
                l10n.membershipLockedSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 48),

              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.primaryGlow,
                ),
                child: ElevatedButton(
                  onPressed: () => MembershipPurchaseModal.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(l10n.membershipBuyNow, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2)
            ],
          ),
        ),
      ),
    );
  }
}
