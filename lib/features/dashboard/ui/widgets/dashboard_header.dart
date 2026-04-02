import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user/providers/user_provider.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => _buildSkeleton(),
      error: (err, stack) => _buildSkeleton(),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2)),
                  child: CircleAvatar(radius: 22, backgroundColor: AppColors.surface, backgroundImage: NetworkImage(user.avatarUrl)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cześć, ${user.firstName}!', style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text('Gotowy na trening? 🔥', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28), onPressed: () {}),
                Positioned(
                  top: 10, right: 12,
                  child: Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle, border: Border.all(color: AppColors.background, width: 2))),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 20, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)), margin: const EdgeInsets.only(bottom: 6)),
                Container(width: 80, height: 14, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ],
        ),
        Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle)),
      ],
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: Colors.white24);
  }
}