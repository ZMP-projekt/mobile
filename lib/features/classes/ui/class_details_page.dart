import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/gym_class.dart';
import '../providers/classes_provider.dart';

class ClassDetailsPage extends ConsumerWidget {
  final GymClass gymClass;
  final String imageUrl;

  const ClassDetailsPage({
    super.key,
    required this.gymClass,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack( // ZMIANA: Wracamy do Stack, żeby tekst płynnie wchodził pod przycisk
        children: [
          // 1. GŁÓWNA ZAWARTOŚĆ (Przewijana przez cały ekran)
          SingleChildScrollView(
            // Duży padding na dole, żeby można było przewinąć tekst do samego końca nad przyciskiem
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ZDJĘCIE Z HERO I PŁYNNYM GRADIENTEM
                Stack(
                  children: [
                    Hero(
                      tag: 'class_image_${gymClass.id}',
                      child: Container(
                        height: size.height * 0.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withValues(alpha: 0.3),
                              AppColors.background,
                            ],
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // PRZYCISK WSTECZ
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white10, width: 1),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // TREŚĆ WŁAŚCIWA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gymClass.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0, height: 1.1),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          _buildBadge(Icons.access_time_rounded, '${gymClass.startTimeFormatted} (${gymClass.durationMinutes} min)'),
                          const SizedBox(width: 12),
                          _buildBadge(
                              Icons.people_alt_rounded,
                              '${gymClass.spotsLeft} wolnych',
                              color: gymClass.isFull ? AppColors.error : AppColors.primary
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 35),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05))
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.background,
                              backgroundImage: gymClass.trainer.photoUrl != null
                                  ? NetworkImage(gymClass.trainer.photoUrl!)
                                  : NetworkImage('https://api.dicebear.com/9.x/thumbs/png?seed=${gymClass.trainer.firstName}${gymClass.trainer.lastName}&shapeColor=00d2d3,ff2a7a,ff8a00,b721ff&backgroundColor=0a0a14'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Instruktor', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text(gymClass.trainer.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 35),

                      const Text('O treningu', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 12),
                      Text(
                          gymClass.description ?? 'Dołącz do nas i poczuj energię grupowego treningu. Idealne dla każdego poziomu zaawansowania.',
                          style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 16, height: 1.6)
                      ).animate().fadeIn(delay: 450.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.75),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
                  ),
                  child: _buildMainActionButton(context, ref, isProcessing),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, {Color color = AppColors.textSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(BuildContext context, WidgetRef ref, bool isProcessing) {
    if (gymClass.isBookedByUser) {
      return SizedBox(
        height: 58,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isProcessing ? null : () => _confirmCancel(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1)
            ),
            elevation: 0,
          ),
          child: isProcessing
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error))
              : const Text('Zrezygnuj z zajęć', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
        ),
      );
    }

    final isDisabled = gymClass.isFull || gymClass.isPast;

    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : AppColors.primaryGradient,
        color: isDisabled ? AppColors.surface : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDisabled ? [] : [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 2,
              offset: const Offset(0, 8)
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isProcessing || isDisabled) ? null : () {
          ref.read(bookingNotifierProvider.notifier).bookClass(gymClass.id).then((_) {
            if (!context.mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Zapisano na zajęcia!'), backgroundColor: AppColors.success),
            );
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: isProcessing
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
          gymClass.isPast ? 'Zakończone' : gymClass.isFull ? 'Brak miejsc' : 'Zapisz się',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Zrezygnować?', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text('Czy na pewno chcesz anulować:\n${gymClass.name}?', style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anuluj', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(bookingNotifierProvider.notifier).cancelBooking(gymClass.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Zrezygnuj', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}