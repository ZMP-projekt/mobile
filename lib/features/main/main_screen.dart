import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final isTrainer = userAsync.valueOrNull?.isTrainer ?? false;

    final List<Widget> screens = isTrainer
        ? const [
      TrainerDashboardPage(),
      CalendarPage(),
      TrainerPersonalTrainingsPage(),
      ProfilePage(),
    ]
        : const [
      DashboardPage(),
      CalendarPage(),
      PersonalTrainingsPage(),
      ProfilePage(),
    ];

    final safeIndex = currentIndex >= screens.length ? 0 : currentIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          ref.read(mainNavigationProvider.notifier).state = index;
        },
        children: screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: _buildBottomNav(safeIndex, isTrainer),
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
          children: isTrainer
              ? [
            _buildNavItem(Icons.home_filled, 0, currentIndex),
            _buildNavItem(Icons.calendar_month_outlined, 1, currentIndex),
            const SizedBox(width: 40),
            _buildNavItem(Icons.people_alt_outlined, 2, currentIndex),
            _buildNavItem(Icons.person_outline, 3, currentIndex),
          ]
              : [
            _buildNavItem(Icons.home_filled, 0, currentIndex),
            _buildNavItem(Icons.calendar_today, 1, currentIndex),
            const SizedBox(width: 40),
            _buildNavItem(Icons.fitness_center_rounded, 2, currentIndex),
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
      onPressed: () {
        ref.read(mainNavigationProvider.notifier).state = index;
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.surface,
          width: 4,
        ),
      ),
      child: FloatingActionButton(
        onPressed: () => _showQRModal(context),
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
            child: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.3)),
    );
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
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.qr_code_2, size: 200, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              'Zeskanuj kod przy bramce',
              style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}