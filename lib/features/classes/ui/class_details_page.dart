import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/gym_class.dart';
import '../providers/classes_provider.dart';
import '../../user/providers/user_provider.dart';
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

    ref.listen(bookingNotifierProvider, (previous, next) {
      if (previous != null && previous.isLoading && !next.isLoading && !next.hasError) {
        if (context.canPop()) {
          context.pop();
        }
      }
    });

    final participants = [
      {'name': 'Anna Nowak', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Anna&backgroundColor=0a0a14'},
      {'name': 'Michał K.', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Michal&backgroundColor=0a0a14'},
      {'name': 'Kasia W.', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Kasia&backgroundColor=0a0a14'},
      {'name': 'Janek P.', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Janek&backgroundColor=0a0a14'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(context, size),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 15),
                      _buildBadgesRow(),
                      const SizedBox(height: 35),
                      if (isTrainer)
                        _buildParticipantsList(participants)
                      else
                        _buildInstructorAndDescription(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ClassActionPanel(gymClass: gymClass, isTrainer: isTrainer),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, Size size) {
    return Stack(
      children: [
        Hero(
          tag: 'class_image_${gymClass.id}',
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

  Widget _buildTitleSection() {
    return Text(
      gymClass.name,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0, height: 1.1),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBadgesRow() {
    return Row(
      children: [
        _buildBadge(Icons.access_time_rounded, '${gymClass.startTimeFormatted} (${gymClass.durationMinutes} min)'),
        const SizedBox(width: 12),
        _buildBadge(
            Icons.people_alt_rounded,
            '${gymClass.spotsLeft} wolnych',
            color: gymClass.isFull ? AppColors.error : AppColors.primary
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInstructorAndDescription() {
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
                backgroundImage: NetworkImage(gymClass.trainer.photoUrl ?? gymClass.trainer.displayAvatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Instruktor', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(gymClass.trainer.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 35),
        const Text('O treningu', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 12),
        Text(
            gymClass.description ?? 'Dołącz do nas i poczuj energię grupowego treningu. Idealne dla każdego poziomu zaawansowania.',
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 16, height: 1.6)
        ).animate().fadeIn(delay: 450.ms),
      ],
    );
  }

  Widget _buildParticipantsList(List<Map<String, String>> participants) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Zapisani uczestnicy', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            Text('${participants.length}/${gymClass.maxParticipants}', style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: participants.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(p['avatar']!), backgroundColor: AppColors.background),
                  const SizedBox(width: 16),
                  Text(p['name']!, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            )).toList(),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
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