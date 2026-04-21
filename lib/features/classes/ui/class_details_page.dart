import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../ui/widgets/participants_list.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/gym_class.dart';
import '../../user/providers/user_provider.dart';
import '../providers/classes_provider.dart';
import 'widgets/class_action_panel.dart';

class ClassDetailsPage extends ConsumerWidget {
  final GymClass gymClass;
  final String imageUrl;

  const ClassDetailsPage({
    super.key,
    required this.gymClass,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isTrainer = userAsync.valueOrNull?.isTrainer ?? false;
    final size = MediaQuery.of(context).size;

    final targetDate = DateTime(gymClass.startTime.year, gymClass.startTime.month, gymClass.startTime.day);

    final classesList = ref.watch(classesForDateProvider(targetDate)).valueOrNull ?? [];

    final currentClass = classesList.firstWhere(
          (c) => c.id == gymClass.id,
      orElse: () => gymClass,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,

      bottomNavigationBar: ClassActionPanel(
          gymClass: currentClass,
          isTrainer: isTrainer
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context, size, currentClass),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(currentClass),
                  const SizedBox(height: 15),

                  // SEKCJA ODZNAK (z lokalizacją)
                  _buildBadgesRow(currentClass),

                  const SizedBox(height: 35),
                  if (isTrainer)
                    ParticipantsList(
                      classId: currentClass.id,
                      maxParticipants: currentClass.maxParticipants,
                    )
                  else
                    _buildInstructorAndDescription(currentClass),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, Size size, GymClass currentClass) {
    return Stack(
      children: [
        Hero(
          tag: 'class_image_${currentClass.id}',
          child: Container(
            height: size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.3),
                  AppColors.background,
                ],
                stops: const [0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10, width: 1),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(GymClass currentClass) {
    return Text(
      currentClass.name,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0, height: 1.1),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBadgesRow(GymClass currentClass) {
    final locName = currentClass.locationName ?? 'Lokalizacja nieznana';

    // Zmienione na Wrap, aby badge ładnie układały się w nowych rzędach jeśli brakuje miejsca
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildBadge(Icons.access_time_rounded, '${currentClass.startTimeFormatted} (${currentClass.durationMinutes} min)'),
        _buildBadge(
            Icons.people_alt_rounded,
            '${currentClass.spotsLeft} wolnych',
            color: currentClass.isFull ? AppColors.error : AppColors.primary
        ),
        // Nowy badge z lokalizacją
        _buildBadge(Icons.location_on_rounded, locName),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInstructorAndDescription(GymClass currentClass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05))
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.background,
                backgroundImage: NetworkImage(currentClass.trainer.photoUrl ?? currentClass.trainer.displayAvatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Instruktor', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(currentClass.trainer.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 35),
        const Text('O treningu', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 12),
        Text(
            currentClass.description ?? 'Dołącz do nas i poczuj energię grupowego treningu. Idealne dla każdego poziomu zaawansowania.',
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 16, height: 1.6)
        ).animate().fadeIn(delay: 450.ms),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text, {Color color = AppColors.textSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}