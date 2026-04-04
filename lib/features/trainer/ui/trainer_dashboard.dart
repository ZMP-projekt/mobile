import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../../../core/ui/widgets/empty_state_view.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/ui/widgets/compact_class_card.dart';
import '../../dashboard/ui/widgets/dashboard_header.dart';
import 'widgets/trainer_summary.dart';
import 'widgets/add_class_modal.dart';

class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final trainerClassesAsync = ref.watch(trainerClassesProvider(today));

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
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(trainerClassesProvider(today));
              await ref.read(trainerClassesProvider(today).future);
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: DashboardHeader(),
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
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddClassModal(),
                      ),
                    ),
                  ),

                  trainerClassesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AppSkeleton(width: 260, height: 180, borderRadius: 24),
                    ),
                    error: (err, stack) => const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Błąd pobierania zajęć', style: TextStyle(color: AppColors.error)),
                    ),
                    data: (classes) {
                      final groupClasses = classes.where((c) => c.maxParticipants > 1 && c.isFuture).toList();

                      if (groupClasses.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.event_available_rounded,
                          title: 'Wszystko gotowe',
                          subtitle: 'Nie masz już dziś zaplanowanych zajęć grupowych.',
                        );
                      }

                      return SizedBox(
                        height: 180,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: groupClasses.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 15),
                          itemBuilder: (context, index) => CompactClassCard(
                              gymClass: groupClasses[index],
                              isTrainer: true
                          ),
                        ),
                      ).animate().fadeIn().slideX(begin: 0.1);
                    },
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildSectionHeader(title: 'Treningi personalne', action: '', onTap: () {}),
                  ),

                  trainerClassesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AppSkeleton(width: double.infinity, height: 80, borderRadius: 20),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (classes) {
                      final personalTrainings = classes.where((c) => c.maxParticipants == 1 && c.isFuture).toList();

                      if (personalTrainings.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.person_search_rounded,
                          title: 'Brak podopiecznych',
                          subtitle: 'Nie masz zaplanowanych treningów personalnych na dziś.',
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: personalTrainings.map((pt) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildPersonalTrainingCard(
                              pt.name,
                              pt.description ?? 'Trening personalny',
                              pt.startTimeFormatted,
                              isActive: pt.isOngoing,
                            ),
                          )).toList(),
                        ),
                      ).animate().fadeIn(delay: 400.ms);
                    },
                  ),
                  const SizedBox(height: 120),
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
          if (action.isNotEmpty)
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
        border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.3) : Colors.white10),
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
                Text(goal, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}