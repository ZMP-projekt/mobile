import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../auth/providers/auth_provider.dart';
import '../../user/providers/user_provider.dart';
import '../../membership/providers/membership_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(context, ref)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.2),

                const SizedBox(height: 25),

                _buildMembershipCard(ref)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 300.ms)
                    .scale(alignment: Alignment.center),

                const SizedBox(height: 30),

                _buildSectionHeader('Twoja Siłownia', 'MAPA')
                    .animate()
                    .fadeIn(delay: 400.ms),

                _buildBigGymCard()
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 300.ms)
                    .slideX(begin: 0.1),

                const SizedBox(height: 30),

                _buildSectionHeader('Dzisiejsze zajęcia', 'ZOBACZ WSZYSTKIE')
                    .animate()
                    .fadeIn(delay: 600.ms),

                _buildWorkoutList()
                    .animate()
                    .fadeIn(delay: 700.ms)
                    .blurXY(begin: 10, end: 0),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(

      loading: () => const CircularProgressIndicator(),

      error: (err, stack) => AnimatedSwitcher(
        duration: 300.ms,
        child: FutureBuilder(
          future: Future.delayed(1000.ms),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text('Błąd: $err');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),

      data: (user) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 2
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=${user.email}'
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cześć, ${user.firstName}!',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Text(
                    'Gotowy na trening? 🔥',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14
                    ),
                  ),
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
      ),
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


  Widget _buildMembershipCard(WidgetRef ref) {
    final membershipAsync = ref.watch(currentMembershipProvider);

    return membershipAsync.when(
        loading: () => _buildMembershipCardSkeleton(),
        error: (err, stack) => _buildMembershipCardError(),
        data: (membership) => _withGlow(
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
            Text(
              '${membership.status == 'ACTIVE' ? 'Aktywny' : 'Nieaktywny'}: ${membership.daysRemaining} dni',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: membership.usagePercentage,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ],
        ),
      )
    )
    );
  }

  Widget _buildMembershipCardSkeleton() {
    return SizedBox(
      height: 150,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMembershipCardError() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text('Błąd pobierania karnetu', style: TextStyle(color: Colors.red)),
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
        boxShadow: AppColors.mediumGlow,
      ),
      child: child,
    );
  }
}