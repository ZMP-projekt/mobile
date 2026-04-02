import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class AppSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: 1200.ms,
      color: Colors.white24,
    );
  }
}