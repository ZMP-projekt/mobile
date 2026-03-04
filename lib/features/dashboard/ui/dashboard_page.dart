import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../auth/providers/auth_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withValues(alpha: 0.08),
              AppColors.background,
              AppColors.primary.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(context, ref)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2),

                const SizedBox(height: 25),

                _buildMembershipCard()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .scale(alignment: Alignment.center),

                const SizedBox(height: 30),

                _buildSectionHeader('Twoja Siłownia', 'MAPA')
                    .animate()
                    .fadeIn(delay: 400.ms),

                _buildBigGymCard()
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideX(begin: 0.1),

                const SizedBox(height: 30),

                _buildSectionHeader('Dzisiejsze zajęcia', 'ZOBACZ WSZYSTKIE')
                    .animate()
                    .fadeIn(delay: 700.ms),

                _buildWorkoutList()
                    .animate()
                    .fadeIn(delay: 800.ms)
                    .blurXY(begin: 10, end: 0),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 1200.ms),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showQRModal(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Center(
              child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 32
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.2)),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Czesc, Alex!',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Gotowy na trening? 🔥',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 28),
          onPressed: () {
            ref.read(authStateProvider.notifier).logout();
          },
        ),
      ],
    );
  }

  Widget _buildBigGymCard() {
    return _withGlow(
      color: AppColors.secondary,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Siłownia Centrum',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('ul. Marszałkowska 12, Warszawa',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGymStat('850m', 'Dystans'),
                _buildGymStat('42 os.', 'Obłożenie'),
                _buildGymStat('Czynne', 'Status'),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.7,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGymStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
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
            IconButton(icon: const Icon(Icons.home_filled, color: AppColors.primary), onPressed: () {}),
            IconButton(icon: const Icon(Icons.calendar_today, color: Colors.white38), onPressed: () {}),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.bar_chart, color: Colors.white38), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_outline, color: Colors.white38), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipCard() {
    return _withGlow(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status karnetu', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                Icon(Icons.workspace_premium, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Aktywny: 12 dni',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.4,
                minHeight: 8,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildWorkoutList() {
    return Column(
      children: [
        _buildWorkoutItem('Yoga', '18:00', '45 min', Icons.fitness_center),
        const SizedBox(height: 12),
        _buildWorkoutItem('Crossfit', '19:30', '60 min', Icons.bolt),
      ],
    );
  }

  Widget _buildWorkoutItem(String title, String time, String duration, IconData icon) {
    return _withGlow(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  Text('$time • $duration', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _withGlow({required Widget child, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.primary).withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  void _showQRModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Twój kod wejścia', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.qr_code_2, size: 200, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text('Zeskanuj kod przy bramce', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}