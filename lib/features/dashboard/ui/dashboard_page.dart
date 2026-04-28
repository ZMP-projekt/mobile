import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../notifications/providers/notification_provider.dart';
import '../../user/providers/user_provider.dart';
import '../../main/main_screen.dart';
import '../../classes/providers/classes_provider.dart';
import '../../membership/providers/membership_provider.dart';
import 'widgets/membership_card.dart';
import 'widgets/gym_location.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/today_classes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsProvider);
    final hasError = ref.watch(currentUserProvider).hasError ||
        ref.watch(todayClassesProvider).hasError ||
        ref.watch(currentMembershipProvider).hasError;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Container(
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
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(classesForDateProvider);
              await Future.wait([
                ref.refresh(currentUserProvider.future),
                ref.read(todayClassesProvider.future),
                ref.read(currentMembershipProvider.future),
              ]);
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  if (hasError)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(l10n.dashboardNoConnection, style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.invalidate(currentUserProvider);
                              ref.invalidate(todayClassesProvider);
                              ref.invalidate(currentMembershipProvider);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.error.withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            child: Text(l10n.commonRefresh.toUpperCase(), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: DashboardHeader(),
                  ),

                  const SizedBox(height: 25),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: MembershipCard(),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildSectionHeader(
                        title: l10n.dashboardSectionGym,
                        action: l10n.dashboardMapAction,
                        onTap: () {}
                    ).animate().fadeIn(delay: 200.ms),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const GymLocationCard()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(begin: 0.05, curve: Curves.easeOutQuad),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildSectionHeader(
                      title: l10n.dashboardSectionTodayClasses,
                      action: l10n.dashboardSeeAll,
                      onTap: () => ref.read(mainNavigationProvider.notifier).state = 1,
                    ).animate().fadeIn(delay: 400.ms),
                  ),

                  const TodayClassesCarousel(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String action, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }
}
