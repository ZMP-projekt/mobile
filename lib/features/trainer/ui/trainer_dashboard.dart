import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../user/providers/user_provider.dart';
import '../../classes/providers/classes_provider.dart';
import '../../classes/data/models/gym_class.dart';

class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    // Pobieramy dzisiejszą datę do API
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classesAsync = ref.watch(classesForDateProvider(today));

    final hasError = userAsync.hasError || classesAsync.hasError;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(classesForDateProvider);
            await Future.wait([
              ref.refresh(currentUserProvider.future),
              ref.read(classesForDateProvider(today).future),
            ]);
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟢 Baner braku internetu
                if (hasError)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 18),
                        SizedBox(width: 8),
                        Text('Jesteś offline. Zła jakość połączenia.', style: TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.1),

                // 🟢 Nagłówek Trenera
                userAsync.when(
                  loading: () => _buildHeaderSkeleton(),
                  error: (_, __) => _buildHeaderSkeleton(),
                  data: (user) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2)),
                            child: CircleAvatar(radius: 22, backgroundColor: AppColors.surface, backgroundImage: NetworkImage(user?.avatarUrl ?? '')),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cześć, ${user?.firstName}!', style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                              const Text('Panel Trenera', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                        child: IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24), onPressed: () {}),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),
                ),

                const SizedBox(height: 35),

                // 🟢 Szybkie Akcje Trenera
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                          context,
                          title: 'Dodaj zajęcia',
                          icon: Icons.add_circle_outline_rounded,
                          color: AppColors.primary,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wkrótce: Formularz dodawania zajęć')));
                          }
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionCard(
                          context,
                          title: 'Nowy klient',
                          icon: Icons.person_add_alt_1_rounded,
                          color: AppColors.secondary,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wkrótce: Baza klientów')));
                          }
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                const SizedBox(height: 40),

                const Text(
                  'Twoje zajęcia grupowe na dziś',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                const SizedBox(height: 20),

                // 🟢 Dynamiczna lista zajęć z API
                classesAsync.when(
                  loading: () => _buildListSkeleton(),
                  error: (_, __) => _buildListSkeleton(),
                  data: (allClasses) {
                    final user = userAsync.valueOrNull;
                    if (user == null) return const SizedBox.shrink();

                    // Filtrujemy tylko zajęcia tego trenera
                    final myClasses = allClasses.where((c) => c.trainer.fullName == user.fullName).toList();

                    if (myClasses.isEmpty) {
                      return _buildEmptyState('Brak zajęć grupowych w dzisiejszym grafiku.');
                    }

                    return Column(
                      children: myClasses.map((gymClass) => _buildClassItem(gymClass).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05)).toList(),
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  'Treningi personalne (Symulacja)',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 20),

                // Zostawiamy statyczne treningi jako podgląd dla backendowców
                _buildPersonalTrainingItem('12:30', 'Michał Kowalski', 'Redukcja', isActive: true).animate().fadeIn(delay: 500.ms),
                _buildPersonalTrainingItem('15:00', 'Anna Nowak', 'Budowa siły').animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(GymClass gymClass) {
    final isPast = gymClass.isPast;
    final opacity = isPast ? 0.5 : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Opacity(
        opacity: opacity,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Text(gymClass.startTimeFormatted, style: const TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${gymClass.durationMinutes} min', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gymClass.name, style: TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.bold, decoration: isPast ? TextDecoration.lineThrough : null)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_rounded, color: AppColors.textSecondary, size: 14),
                      const SizedBox(width: 6),
                      Text('${gymClass.currentParticipants} / ${gymClass.maxParticipants} zapisanych', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTrainingItem(String time, String clientName, String goal, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.primaryGradient.withOpacity(0.1) : null,
        color: isActive ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: isActive ? AppColors.primary : AppColors.background, borderRadius: BorderRadius.circular(14)),
            child: Text(time, style: TextStyle(color: isActive ? Colors.white : AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Cel: $goal', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, height: 20, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)), margin: const EdgeInsets.only(bottom: 6)),
            Container(width: 80, height: 14, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
          ],
        ),
      ],
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: Colors.white24);
  }

  Widget _buildListSkeleton() {
    return Column(
      children: List.generate(2, (index) => Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      )).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: Colors.white24),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        children: [
          const Icon(Icons.event_available_rounded, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}