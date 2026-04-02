import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class NoConnectionView extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const NoConnectionView({
    super.key,
    required this.onRetry,
    this.message = 'Nie udało się pobrać danych. Sprawdź połączenie internetowe i spróbuj ponownie.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.error),
                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

                const SizedBox(height: 32),

                const Text(
                  'Brak połączenia',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    label: const Text('Spróbuj ponownie', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}