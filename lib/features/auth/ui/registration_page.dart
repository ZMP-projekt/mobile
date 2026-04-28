import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_gym_app/core/util/app_logger.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../core/util/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      try {
        final success = await ref.read(authStateProvider.notifier).register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (success && mounted) {
          context.pop();
        }

      } catch (e) {
        AppLogger.e('Blad: ', e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: -50, left: -100,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.15),
                boxShadow: const [BoxShadow(blurRadius: 100, spreadRadius: 50, color: AppColors.secondary)],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.authRegisterTitle,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1.0),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      Text(
                        l10n.authRegisterSubtitle,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 40),

                      CustomTextField(
                        label: l10n.fieldFirstName,
                        icon: Icons.person_outline_rounded,
                        controller: _firstNameController,
                        validator: (val) => AppValidators.validateRequired(
                          val,
                          l10n.fieldFirstName,
                          l10n,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: l10n.fieldLastName,
                        icon: Icons.person_outline_rounded,
                        controller: _lastNameController,
                        validator: (val) => AppValidators.validateRequired(
                          val,
                          l10n.fieldLastName,
                          l10n,
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: l10n.fieldEmail,
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            AppValidators.validateEmail(value, l10n),
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: l10n.fieldPassword,
                        icon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        validator: (value) =>
                            AppValidators.validatePassword(value, l10n),
                      ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: l10n.fieldRepeatPassword,
                        icon: Icons.lock_outline_rounded,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onTogglePassword: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationPasswordConfirmationRequired;
                          }
                          if (value != _passwordController.text) {
                            return l10n.validationPasswordsDoNotMatch;
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 40),

                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(l10n.authRegisterAction, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.authAlreadyHaveAccount, style: const TextStyle(color: AppColors.textSecondary)),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(l10n.authLoginAction, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ).animate().fadeIn(delay: 900.ms),
                  ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
