import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../user/providers/user_provider.dart';

class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userAsync.when(
                data: (user) => Row(
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
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.surface,
                            backgroundImage: NetworkImage(user?.avatarUrl ?? ''),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cześć, ${user?.firstName}!', style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                            const Text('Tryb Trenera Aktywny ⚡', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const SizedBox(),
              ),

              const SizedBox(height: 35),

              const Text(
                'Zaraz zaczynasz',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text('ZA 15 MIN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                        const Spacer(),
                        const Icon(Icons.fitness_center, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Trening Personalny', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    const SizedBox(height: 4),
                    const Text('z: Michał Kowalski', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 40),

              const Text(
                'Twój plan na dziś',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

              const SizedBox(height: 20),

              _buildTimelineItem('10:00', 'Trening Personalny', 'Anna Nowak', isPast: true),
              _buildTimelineItem('12:30', 'Trening Personalny', 'Michał Kowalski', isActive: true),
              _buildTimelineItem('15:00', 'Zajęcia Grupowe', 'Crossfit (Sala A)'),
              _buildTimelineItem('17:00', 'Konsultacja', 'Nowy klient: Jan'),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String time, String title, String subtitle, {bool isPast = false, bool isActive = false}) {
    final color = isPast ? AppColors.textSecondary.withValues(alpha: 0.3) : (isActive ? AppColors.primary : AppColors.textPrimary);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(time, style: TextStyle(color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                const SizedBox(height: 4),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isPast ? AppColors.surface : (isActive ? AppColors.primary.withValues(alpha: 0.5) : AppColors.surface),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 2),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold, decoration: isPast ? TextDecoration.lineThrough : null)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: isPast ? color : AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}