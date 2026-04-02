import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/async_value_widget.dart';
import '../../../core/ui/widgets/no_connection_view.dart';
import '../../auth/providers/auth_provider.dart';
import '../../user/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AsyncValueWidget(
          value: userAsync,
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Brak danych', style: TextStyle(color: AppColors.textSecondary)));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                  ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 16),

                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 4),

                  Text(
                    user.email,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 32),

                  _buildFlatSection(
                    title: 'Rola Konta',
                    content: Row(
                      children: [
                        Icon(
                          user.role == 'ROLE_TRAINER' ? Icons.fitness_center_rounded : Icons.person,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user.role == 'ROLE_TRAINER' ? 'Trener' : 'Użytkownik',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),

                  const SizedBox(height: 16),

                  _buildFlatSection(
                    title: 'Ustawienia',
                    content: Column(
                      children: [
                        _buildSettingsRow(Icons.lock_outline_rounded, 'Zmień hasło'),
                        const Divider(color: Colors.white12, height: 24),
                        _buildSettingsRow(Icons.notifications_none_rounded, 'Powiadomienia'),
                        const Divider(color: Colors.white12, height: 24),
                        _buildSettingsRow(Icons.help_outline_rounded, 'Pomoc i wsparcie'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(authStateProvider.notifier).logout();
                        },
                        icon: const Icon(Icons.logout_rounded, size: 22),
                        label: const Text(
                          'Wyloguj się',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error.withValues(alpha: 0.1),
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlatSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: content,
        ),
      ],
    );
  }

  Widget _buildSettingsRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 22),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        const Spacer(),
        const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      ],
    );
  }
}