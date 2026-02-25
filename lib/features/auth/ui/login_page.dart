import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Color vividOrange = const Color(0xFFFF8C00);
  final Color midnightBlue = const Color(0xFF162133);
  final Color cloudWhite = const Color(0xFFE0E6ED);

  void _handleLogin() {
    if (emailController.text.isNotEmpty && passwordController.text.length >= 6) {
      debugPrint("Dane poprawne: ${emailController.text}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Błędny email lub za krótkie hasło")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              Text(
                "Witaj,\nGotowy na trening?",
                style: TextStyle(
                  color: cloudWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Zaloguj się, aby kontynuować",
                style: TextStyle(color: cloudWhite.withValues(alpha: 0.6), fontSize: 16),
              ),

              const SizedBox(height: 50),

              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: passwordController,
                label: "Hasło",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vividOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "ZALOGUJ SIĘ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      style: TextStyle(color: cloudWhite),
      decoration: InputDecoration(
        filled: true,
        fillColor: midnightBlue,
        labelText: label,
        labelStyle: TextStyle(color: cloudWhite.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: vividOrange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: vividOrange, width: 1),
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