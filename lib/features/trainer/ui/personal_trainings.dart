import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/app_skeleton.dart';
import '../../../core/ui/widgets/no_connection_view.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/data/models/gym_class.dart';

class TrainerPersonalTrainingsPage extends ConsumerWidget {
  const TrainerPersonalTrainingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final classesAsync = ref.watch(trainerClassesProvider(selectedDate));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Podopieczni', style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0))
                      .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  const Text('Zarządzaj swoimi treningami 1 na 1.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.4))
                      .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 20),

                  _buildHorizontalCalendar(ref, selectedDate),
                ],
              ),
            ),

            Expanded(
              child: classesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => NoConnectionView(onRetry: () => ref.invalidate(trainerClassesProvider(selectedDate))),
                data: (dayClasses) {
                  final ptClasses = dayClasses.where((c) => c.personalTraining).toList();

                  if (ptClasses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 130),
                    itemCount: ptClasses.length,
                    itemBuilder: (context, index) {
                      final gymClass = ptClasses[index];
                      return _TrainerPtCard(gymClass: gymClass)
                          .animate()
                          .fadeIn(delay: (index * 100).ms)
                          .slideX(begin: 0.05);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCalendar(WidgetRef ref, DateTime selectedDate) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final days = List.generate(14, (index) => normalizedToday.add(Duration(days: index)));

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = date.isAtSameMomentAs(selectedDate);
          final dayName = DateFormat('E', 'pl_PL').format(date).toLowerCase();

          return GestureDetector(
            onTap: () => ref.read(selectedDateProvider.notifier).state = date,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayName, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(height: 6),
                  Text('${date.day}', style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surface, border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
            child: const Icon(Icons.person_off_rounded, size: 60, color: AppColors.textSecondary),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          const Text('Brak zaplanowanych\ntreningów w tym dniu', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TrainerPtCard extends ConsumerWidget {
  final GymClass gymClass;

  const _TrainerPtCard({required this.gymClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBooked = gymClass.currentParticipants > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isBooked ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          if (isBooked)
            _buildClientAvatar(ref)
          else
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.background,
              child: Icon(Icons.person_add_alt_1_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBooked)
                  _buildClientName(ref)
                else
                  const Text('Wolny termin', style: TextStyle(color: AppColors.textSecondary, fontSize: 17, fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('${gymClass.startTimeFormatted} (${gymClass.durationMinutes} min)', style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zarządzanie treningiem wkrótce!')));
            },
          )
        ],
      ),
    );
  }

  Widget _buildClientAvatar(WidgetRef ref) {
    final participantsAsync = ref.watch(classParticipantsProvider(gymClass.id));

    return participantsAsync.when(
      data: (users) {
        if (users.isEmpty) return const CircleAvatar(radius: 26, backgroundColor: AppColors.background);
        return CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.background,
          backgroundImage: NetworkImage(users.first.displayAvatarUrl),
        );
      },
      loading: () => const AppSkeleton(width: 52, height: 52, shape: BoxShape.circle),
      error: (_, _) => const CircleAvatar(radius: 26, backgroundColor: AppColors.error, child: Icon(Icons.error, size: 20)),
    );
  }

  Widget _buildClientName(WidgetRef ref) {
    final participantsAsync = ref.watch(classParticipantsProvider(gymClass.id));

    return participantsAsync.when(
      data: (users) {
        if (users.isEmpty) return const Text('Błąd pobierania', style: TextStyle(color: AppColors.error));
        return Text(
            '${users.first.firstName} ${users.first.lastName}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: -0.3)
        );
      },
      loading: () => const AppSkeleton(width: 120, height: 20),
      error: (_, _) => const Text('Błąd', style: TextStyle(color: AppColors.error)),
    );
  }
}