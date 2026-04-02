import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ui/widgets/async_value_widget.dart';
import '../../core/ui/widgets/no_connection_view.dart';
import '../../core/ui/widgets/offline_access_modal.dart';
import '../membership/ui/widgets/membership_guard.dart';
import '../membership/ui/widgets/membership_purchase_modal.dart';
import '../membership/providers/membership_provider.dart';

import '../dashboard/ui/dashboard_page.dart';
import '../trainings/ui/personal_trainings_page.dart';
import '../classes/ui/calendar_page.dart';
import '../profile/ui/profile_page.dart';

import '../trainer/ui/trainer_dashboard.dart';
import '../trainer/ui/personal_trainings.dart';
import '../user/providers/user_provider.dart';

import '../../core/theme/app_colors.dart';

final mainNavigationProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: ref.read(mainNavigationProvider));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _getScreens(bool isTrainer) {
    if (isTrainer) {
      return const [
        TrainerDashboardPage(),
        CalendarPage(),
        TrainerPersonalTrainingsPage(),
        ProfilePage(),
      ];
    }
    return const [
      DashboardPage(),
      MembershipGuard(child: CalendarPage()),
      MembershipGuard(child: PersonalTrainingsPage()),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(mainNavigationProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    final currentIndex = ref.watch(mainNavigationProvider);
    final userAsync = ref.watch(currentUserProvider);

    if (!_pageController.hasClients && _pageController.initialPage != currentIndex) {
      _pageController.dispose();
      _pageController = PageController(initialPage: currentIndex);
    }

    return AsyncValueWidget(
      value: userAsync,
      data: (user) {
        if (user == null) {
          return const Scaffold(backgroundColor: AppColors.background);
        }

        final isTrainer = user.isTrainer;
        final screens = _getScreens(isTrainer);
        final safeIndex = currentIndex >= screens.length ? 0 : currentIndex;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: screens,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFAB(context, isTrainer),
          bottomNavigationBar: _buildBottomNav(safeIndex, isTrainer),
        );
      },
      error: (err, stack) => NoConnectionView(
        onRetry: () => ref.invalidate(currentUserProvider),
        message: 'Nie udało się zweryfikować uprawnień konta. Sprawdź sieć.',
      ),
    );
  }

  Widget _buildBottomNav(int currentIndex, bool isTrainer) {
    return BottomAppBar(
      color: AppColors.surface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      elevation: 0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, 0, currentIndex),
            _buildNavItem(isTrainer ? Icons.calendar_month_outlined : Icons.calendar_today, 1, currentIndex),
            const SizedBox(width: 40),
            _buildNavItem(isTrainer ? Icons.people_alt_outlined : Icons.fitness_center_rounded, 2, currentIndex),
            _buildNavItem(Icons.person_outline, 3, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int currentIndex) {
    final isSelected = currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.white38,
        size: isSelected ? 28 : 24,
      ),
      onPressed: () => ref.read(mainNavigationProvider.notifier).state = index,
    );
  }

  Widget _buildFAB(BuildContext context, bool isTrainer) {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.surface, width: 4),
      ),
      child: FloatingActionButton(
        onPressed: () => _handleQRAction(context, isTrainer),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.3)),
    );
  }

  void _handleQRAction(BuildContext context, bool isTrainer) {
    if (isTrainer) {
      _showQRModal(context);
      return;
    }

    final membershipAsync = ref.read(currentMembershipProvider);
    final membership = membershipAsync.valueOrNull;
    final hasActiveMembership = membership != null && membership.active && membership.daysRemaining > 0;

    if (hasActiveMembership) {
      _showQRModal(context);
    } else if (membershipAsync.hasError || membershipAsync.isLoading) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const OfflineAccessModal(),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const MembershipPurchaseModal(),
      );
    }
  }

  void _showQRModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Twój kod wejścia',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.qr_code_2, size: 200, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text('Zeskanuj kod przy bramce', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}