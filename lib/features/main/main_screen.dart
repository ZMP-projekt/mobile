import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_gym_app/features/main/ui/widgets/main_action_button.dart';

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
import '../user/ui/widgets/qr_entry_modal_content.dart';

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
    return MainActionButton(
      onPressed: () => _handleQRAction(context, isTrainer),
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
      MembershipPurchaseModal.show(context);
    }
  }

  void _showQRModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const QrEntryModalContent(),
    );
  }
}

