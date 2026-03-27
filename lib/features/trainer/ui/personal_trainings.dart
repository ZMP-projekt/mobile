import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class TrainerPersonalTrainingsPage extends StatelessWidget {
  const TrainerPersonalTrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todayTrainings = [
      {'client': 'Anna Nowak', 'time': '10:00', 'duration': '60 min', 'type': 'Trening siłowy', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Anna&backgroundColor=0a0a14'},
      {'client': 'Michał Kowalski', 'time': '12:30', 'duration': '90 min', 'type': 'Redukcja', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Michal&backgroundColor=0a0a14'},
      {'client': 'Katarzyna Wiśniewska', 'time': '16:00', 'duration': '60 min', 'type': 'Konsultacja', 'avatar': 'https://api.dicebear.com/9.x/thumbs/png?seed=Kasia&backgroundColor=0a0a14'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Podopieczni', style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0))
                        .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                    const SizedBox(height: 8),
                    const Text('Zarządzaj swoimi dzisiejszymi treningami 1 na 1.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.4))
                        .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final training = todayTrainings[index];
                    return _buildTrainingCard(context, training)
                        .animate()
                        .fadeIn(delay: (300 + index * 100).ms)
                        .slideX(begin: 0.05);
                  },
                  childCount: todayTrainings.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingCard(BuildContext context, Map<String, String> training) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.background,
            backgroundImage: NetworkImage(training['avatar']!),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(training['client']!, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text(training['time']!, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zarządzanie treningiem wkrótce!')));
            },
          )
        ],
      ),
    );
  }
}