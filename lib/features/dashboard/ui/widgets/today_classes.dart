import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../classes/providers/classes_provider.dart';
import '../../../classes/utils/gym_class_extension.dart';

class TodayClassesCarousel extends ConsumerWidget {
  const TodayClassesCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayClassesAsync = ref.watch(todayClassesProvider);

    return todayClassesAsync.when(
      // 🟢 OBA STANY WSKAZUJĄ NA SKELETON
      loading: () => _buildSkeleton(),
      error: (err, stack) => _buildSkeleton(),
      data: (classes) {
        if (classes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text('Brak zajęć na resztę dnia. Czas na odpoczynek! 🧘', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final gymClass = classes[index];
              final imageUrl = gymClass.displayImageUrl;

              return GestureDetector(
                onTap: () => context.push('/class-details', extra: {'gymClass': gymClass, 'imageUrl': imageUrl}),
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black12, Colors.black87]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                color: Colors.white.withValues(alpha: 0.2),
                                child: Text(gymClass.startTimeFormatted, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(gymClass.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text(gymClass.trainer.fullName, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  // 🟢 EFEKT SZKIELETU
  Widget _buildSkeleton() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // pokazujemy 3 atrapy kart
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
          );
        },
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: Colors.white24);
  }
}