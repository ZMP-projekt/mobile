import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/async_value_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../../user/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final locale = ref.watch(localeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AsyncValueWidget(
          value: userAsync,
          data: (user) {
            if (user == null) {
              return Center(child: Text(l10n.profileNoData, style: const TextStyle(color: AppColors.textSecondary)));
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

                  _buildSectionHeader(l10n.profileInfoSection),
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
                          user.role == 'ROLE_TRAINER'
                              ? l10n.profileTrainerAccount
                              : l10n.profileUserAccount,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),

                  const SizedBox(height: 24),

                  _buildSectionHeader(l10n.profileSettingsSection),
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
                          title: l10n.profileLanguage,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _languageName(l10n, locale),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () => _showLanguagePicker(context, ref),
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                        _buildActionTile(
                          icon: Icons.notifications_active_outlined,
                          title: l10n.profilePushNotifications,
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

                  _buildSectionHeader(l10n.profileAboutSection),
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
                          title: l10n.profileHelpContact,
                          onTap: () {},
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                        _buildActionTile(
                          icon: Icons.description_outlined,
                          title: l10n.profileClubRules,
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
                      label: Text(
                        l10n.profileLogout,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.5),
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

                  Text(
                    l10n.profileVersion('1.0.0'),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
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

  String _languageName(AppLocalizations l10n, Locale locale) {
    return switch (locale.languageCode) {
      'en' => l10n.profileLanguageEnglish,
      _ => l10n.profileLanguagePolish,
    };
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final currentLocale = ref.watch(localeNotifierProvider);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileSelectLanguage,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    RadioGroup<String>(
                      groupValue: currentLocale.languageCode,
                      onChanged: (String? value) {
                        if (value != null) {
                          final newLocale = LocaleNotifier.supportedLocales
                              .firstWhere((l) => l.languageCode == value);

                          ref.read(localeNotifierProvider.notifier).setLocale(newLocale);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            if (context.mounted) Navigator.pop(context);
                          });
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: LocaleNotifier.supportedLocales.map((locale) {
                          final isSelected = locale.languageCode == currentLocale.languageCode;

                          return RadioListTile<String>(
                            value: locale.languageCode,
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _languageName(l10n, locale),
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                            secondary: Icon(
                              locale.languageCode == 'pl'
                                  ? Icons.flag_rounded
                                  : Icons.language_rounded,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
