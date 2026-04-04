import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/app_skeleton.dart';
import '../../providers/classes_provider.dart';

class ParticipantsList extends ConsumerWidget {
  final int classId;
  final int maxParticipants;

  const ParticipantsList({
    super.key,
    required this.classId,
    required this.maxParticipants,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(classParticipantsProvider(classId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Zapisani uczestnicy',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            participantsAsync.when(
              data: (users) => Text(
                '${users.length}/$maxParticipants',
                style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              loading: () => const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
              error: (_, _) => const Text('0', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: participantsAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Brak zapisanych osób', style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                  ),
                );
              }

              return Column(
                children: List.generate(users.length, (index) {
                  final user = users[index];
                  final isLast = index == users.length - 1;

                  return Column(
                    children: [
                      _ParticipantTile(
                        key: ValueKey(user.id),
                        name: '${user.firstName} ${user.lastName}',
                        avatarUrl: user.displayAvatarUrl,
                      ),
                      if (!isLast)
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                          thickness: 1,
                          indent: 58,
                        ),
                    ],
                  );
                }),
              );
            },
            loading: () => Column(
              children: List.generate(3, (index) => const _ParticipantSkeleton()),
            ),
            error: (err, _) => const Center(
              child: Text('Błąd ładowania listy', style: TextStyle(color: AppColors.error, fontSize: 14)),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const _ParticipantTile({required this.name, required this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.person, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 16),
          Text(
              name,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }
}

class _ParticipantSkeleton extends StatelessWidget {
  const _ParticipantSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: const [
          AppSkeleton(width: 42, height: 42, borderRadius: 21),
          SizedBox(width: 16),
          AppSkeleton(width: 140, height: 18, borderRadius: 8),
        ],
      ),
    );
  }
}