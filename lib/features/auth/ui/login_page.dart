import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'registration_page.dart';
import '../../../core/theme/app_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _handleLogin() async {
    if (emailController.text.isNotEmpty && passwordController.text.length >= 6) {

      final success = await ref.read(authStateProvider.notifier).login(
          emailController.text,
          passwordController.text);

      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Zalogowano! (Mock)' : 'Blad polaczenia!'),
            backgroundColor: success ? AppColors.success : AppColors.error,
      ));

      /*
      if (success) {
        Navigator.pushReplacement(context, DashboardPage());
      }
      */

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Błędny email lub za krótkie hasło',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,)
            ),
              backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final auth = ref.watch(authStateProvider);
    final isLoading = auth.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),

              Text(
                'Gotowy na trening?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Zaloguj się, aby kontynuować',
                style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6), fontSize: 16),
              ),

              const SizedBox(height: 50),

              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: passwordController,
                label: 'Hasło',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              Padding (
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child:
                GestureDetector(
                  onTap: isLoading ? null : _handleLogin,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      boxShadow: AppColors.primaryGlow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: AppColors.textPrimary,
                            strokeWidth: 3),
                        )
                          : const Text(
                        'ZALOGUJ SIĘ',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Nie masz konta? ',
                      style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6)),
                      children: const [
                        TextSpan(
                          text: 'Zarejestruj się',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}