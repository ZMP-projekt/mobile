import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user/providers/user_provider.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
        loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
        error: (err, stack) => const Text('Błąd ładowania profilu', style: TextStyle(color: AppColors.error)),
        data: (user) {
          if (user == null) {
            return const Text('Zaloguj się ponownie',
                style: TextStyle(color: AppColors.error));
          }

          return Row(
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
                          width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.surface,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cześć, ${user.firstName}!', style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                      const Text('Gotowy na trening? 🔥', style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                    ],
                  ),
                ],
              ),

              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                        Icons.notifications_none_rounded, color: Colors.white,
                        size: 28),
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
                        border: Border.all(
                            color: AppColors.background, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
    );
  }
}