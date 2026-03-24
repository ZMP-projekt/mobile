import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_gym_app/core/util/app_logger.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../core/util/validators.dart';
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
        await ref.read(authStateProvider.notifier).register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } catch (e) {
        AppLogger.e('Blad: ', e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                      const Text(
                        'Dołącz do nas',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1.0),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      const Text(
                        'Stwórz konto i zacznij trening',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 40),

                      CustomTextField(
                        label: 'Imię',
                        icon: Icons.person_outline_rounded,
                        controller: _firstNameController,
                        validator: (val) => AppValidators.validateRequired(val, 'Imię'),
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Nazwisko',
                        icon: Icons.person_outline_rounded,
                        controller: _lastNameController,
                        validator: (val) => AppValidators.validateRequired(val, 'Nazwisko'),
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Hasło',
                        icon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        validator: AppValidators.validatePassword,
                      ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Powtórz hasło',
                        icon: Icons.lock_outline_rounded,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onTogglePassword: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Potwierdź hasło';
                          if (value != _passwordController.text) return 'Hasła nie są identyczne';
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
                              : const Text('Zarejestruj się', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Masz już konto? ', style: TextStyle(color: AppColors.textSecondary)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text('Zaloguj się', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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