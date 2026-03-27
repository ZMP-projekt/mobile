import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../user/providers/user_provider.dart';
import '../../dashboard/ui/widgets/gym_location.dart';

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
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                          onPressed: () {},
                        ),
                        Positioned(
                          top: 10,
                          right: 12,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const SizedBox(),
              ),

              const SizedBox(height: 35),

              const Text(
                'Twój następny krok',
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
                          child: const Text('ZA 45 MIN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                        const Spacer(),
                        const Icon(Icons.fitness_center, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Trening Personalny', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    const SizedBox(height: 4),
                    const Text('z: Anna Nowak', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 35),

              const Text(
                'Twoje miejsce pracy',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              const SizedBox(height: 16),
              const GymLocationCard().animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}