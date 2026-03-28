import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class PersonalTrainingsPage extends StatelessWidget {
  const PersonalTrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Treningi Personalne',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(35),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          boxShadow: AppColors.subtleGlow,
                        ),
                        child: const Icon(Icons.fitness_center_rounded, size: 70, color: AppColors.primary),
                      ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),

                      const SizedBox(height: 35),

                      const Text(
                        'Nie masz nadchodzących\ntreningów personalnych',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: -0.5),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                      const SizedBox(height: 16),

                      Text(
                        'Spotkaj się ze swoim trenerem\nw ramach członkostwa',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 16, height: 1.5),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 25, spreadRadius: 2, offset: const Offset(0, 8)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wkrótce: Lista dostępnych trenerów!'), backgroundColor: AppColors.surface),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Zarezerwuj Trening Personalny',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}