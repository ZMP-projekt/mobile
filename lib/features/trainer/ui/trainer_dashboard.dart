import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gym_app/features/trainer/ui/widgets/add_class_modal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/app_skeleton.dart';
import '../../classes/utils/gym_class_extension.dart';
import '../../membership/ui/widgets/membership_purchase_modal.dart';
import '../../user/providers/user_provider.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/data/models/gym_class.dart';
import '../../dashboard/ui/widgets/dashboard_header.dart';
import 'widgets/trainer_summary.dart';

class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final trainerClassesAsync = ref.watch(trainerClassesProvider(today));

    final hasError = userAsync.hasError || trainerClassesAsync.hasError;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
            ref.invalidate(trainerClassesProvider(today));
            await ref.read(currentUserProvider.future);
            await ref.read(trainerClassesProvider(today).future);
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                if (hasError) _buildErrorBanner(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const DashboardHeader()
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2),
                ),

                const SizedBox(height: 25),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TrainerSummaryCard(),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildSectionHeader(
                    title: 'Twoje zajęcia grupowe',
                    action: 'DODAJ',
                    onTap: () {
                      MembershipPurchaseModal.show(context);
                    },
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                ),

                _buildTrainerCarousel(trainerClassesAsync),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildSectionHeader(
                    title: 'Treningi personalne',
                    action: '',
                    onTap: () {},
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      _buildPersonalTrainingCard('Michał Kowalski', 'Redukcja', '12:30', isActive: true),
                      const SizedBox(height: 12),
                      _buildPersonalTrainingCard('Anna Nowak', 'Budowa siły', '15:00'),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainerCarousel(AsyncValue<List<GymClass>> classesAsync) {
    return classesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: AppSkeleton(width: 260, height: 180, borderRadius: 24),
      ),
      error: (err, stack) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('Błąd pobierania zajęć', style: TextStyle(color: AppColors.error)),
      ),
      data: (classes) {
        if (classes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Nie masz dziś zaplanowanych zajęć 🧘', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final gymClass = classes[index];
              return _buildTrainerClassCard(context, gymClass);
            },
          ),
        ).animate().fadeIn().slideX(begin: 0.1);
      },
    );
  }

  Widget _buildTrainerClassCard(BuildContext context, GymClass gymClass) {
    return GestureDetector(
        onTap: () {
          context.push('/class-details', extra: {
            'gymClass': gymClass,
            'imageUrl': gymClass.displayImageUrl,
          });
        },
        child: Container(
          width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(gymClass.displayImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black12, Colors.black87],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    color: Colors.white.withValues(alpha: 0.2),
                    child: Text(gymClass.startTimeFormatted, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gymClass.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Uczestnicy: ${gymClass.currentParticipants}/${gymClass.maxParticipants}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
        ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 18),
          SizedBox(width: 8),
          Text('Problemy z połączeniem', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        ],
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
            child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTrainingCard(String clientName, String goal, String time, {bool isActive = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface : AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isActive ? AppColors.primary : AppColors.background, shape: BoxShape.circle),
            child: Icon(Icons.person_rounded, color: isActive ? Colors.white : AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Cel: $goal', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}