import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

class MainActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MainActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72, width: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.surface, width: 4),
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.3)),
    );
  }
}