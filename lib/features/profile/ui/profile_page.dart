import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../user/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Container(
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
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                const Text('Nie udało się pobrać danych profilu',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => ref.refresh(currentUserProvider),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          data: (user) => RefreshIndicator(
            onRefresh: () => ref.refresh(currentUserProvider.future),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Sekcja Awatara
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.surface,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=${user.email}',
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8)),

                  const SizedBox(height: 24),

                  // Imię i Nazwisko
                  Text(
                    user.firstName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Rola
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      user.role == 'ROLE_TRAINER' ? '👨‍🏫 Trener' : '👤 Użytkownik',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),

                  const SizedBox(height: 40),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuOption(
                          icon: Icons.person_outline_rounded,
                          title: 'Ustawienia konta',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: AppColors.textSecondary.withValues(alpha: 0.1), indent: 56),
                        _buildMenuOption(
                          icon: Icons.notifications_none_rounded,
                          title: 'Powiadomienia',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: AppColors.textSecondary.withValues(alpha: 0.1), indent: 56),
                        _buildMenuOption(
                          icon: Icons.security_rounded,
                          title: 'Prywatność i bezpieczeństwo',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 32),

                  TextButton.icon(
                    onPressed: () => ref.read(authStateProvider.notifier).logout(),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text('Wyloguj się', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary.withValues(alpha: 0.3), size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}