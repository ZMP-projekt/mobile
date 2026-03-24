import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/classes_provider.dart';
import '../data/models/gym_class.dart';
import '../../main/main_screen.dart';
import 'class_details_page.dart';

class MyClassesPage extends ConsumerWidget {
  const MyClassesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myClassesAsync = ref.watch(myClassesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: const Text(
                'Moje Treningi',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            ),
            Expanded(
              child: myClassesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Błąd: $err', style: const TextStyle(color: AppColors.error))),
                data: (classes) {
                  if (classes.isEmpty) return _buildEmptyState(ref);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 130),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      return FeaturedCard(gymClass: classes[index], index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_rounded, size: 80, color: AppColors.surface),
          const SizedBox(height: 24),
          const Text('Brak zaplanowanych zajęć', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Znajdź coś dla siebie w grafiku', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => ref.read(mainNavigationProvider.notifier).state = 1,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Przejdź do grafiku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}

class FeaturedCard extends ConsumerWidget {
  final GymClass gymClass;
  final int index;

  const FeaturedCard({super.key, required this.gymClass, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(bookingNotifierProvider);
    final imageUrl = _getImageForClass(gymClass.name);

    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassDetailsPage(gymClass: gymClass, imageUrl: imageUrl),
            ),
          );
        },
    child: Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: NetworkImage(_getImageForClass(gymClass.name)),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black12, Colors.black87],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        '${gymClass.dateFormatted} • ${gymClass.startTimeFormatted}',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gymClass.name,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Trener: ${gymClass.trainer.fullName}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading ? null : () => _confirmCancel(context, ref, gymClass),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
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
    ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms).slideY(begin: 0.1, end: 0)
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, GymClass gymClass) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Zrezygnować?', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Czy na pewno chcesz anulować:\n${gymClass.name}?', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anuluj', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(bookingNotifierProvider.notifier).cancelBooking(gymClass.id);
            },
            child: const Text('Odwołaj', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _getImageForClass(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('yoga')) return 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('crossfit') || nameLower.contains('hiit')) return 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('pilates') || nameLower.contains('stretch')) return 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('spinning')) return 'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('zumba')) return 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('boxing')) return 'https://images.unsplash.com/photo-1549719386-74dfcbf7dbed?auto=format&fit=crop&w=600&q=80';
    if (nameLower.contains('trx')) return 'https://images.unsplash.com/photo-1526506114842-8395dc559384?auto=format&fit=crop&w=600&q=80';
    return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=600&q=80';
  }
}