import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/async_value_widget.dart';
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
                      backgroundImage: NetworkImage(user.displayAvatarUrl),
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

                  _buildSectionHeader('INFORMACJE'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          user.role == 'ROLE_TRAINER' ? Icons.fitness_center_rounded : Icons.person,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user.role == 'ROLE_TRAINER' ? 'Konto Trenera' : 'Konto Użytkownika',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),

                  const SizedBox(height: 24),

                  _buildSectionHeader('USTAWIENIA'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.language_rounded,
                          title: 'Język aplikacji',
                          trailing: const Text('Polski', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                          onTap: () {
                            // Tu w przyszłości podepniemy przełączanie języka (i18n)
                          },
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                        _buildActionTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Powiadomienia Push',
                          trailing: Switch(
                            value: true,
                            onChanged: (val) {},
                            activeThumbColor: AppColors.primary,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),

                  const SizedBox(height: 24),

                  _buildSectionHeader('O APLIKACJI'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Pomoc i kontakt',
                          onTap: () {},
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                        _buildActionTile(
                          icon: Icons.description_outlined,
                          title: 'Regulamin klubu',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.05),

                  const SizedBox(height: 40),

                  SizedBox(
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
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 32),

                  const Text(
                    'Wersja 1.0.0',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              if (trailing != null) trailing
              else const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}