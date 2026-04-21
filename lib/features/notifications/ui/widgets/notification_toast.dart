import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification.dart';

class NotificationToast {
  static OverlayEntry? _current;

  static void show(BuildContext context, AppNotification notification) {
    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        notification: notification,
        onDismiss: () {
          entry.remove();
          _current = null;
        },
      ),
    );

    _current = entry;
    Overlay.of(context).insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;

  const _ToastWidget({required this.notification, required this.onDismiss});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _timer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _timer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward().then((_) => _dismiss());
  }

  void _dismiss() {
    if (_dismissing) return;
    _dismissing = true;
    widget.onDismiss();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
              onTap: _dismiss,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.97),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scaleXY(
                            begin: 1.0,
                            end: 1.12,
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NOWE POWIADOMIENIE',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.notification.content,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _dismiss,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      AnimatedBuilder(
                        animation: _timer,
                        builder: (ctx, _) {
                          final progress = 1 - _timer.value;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 3,
                              backgroundColor: Colors.white.withValues(alpha: 0.08),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress < 0.25
                                    ? AppColors.error
                                    : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              .animate()
              .slideY(
            begin: -1.5,
            end: 0,
            duration: 450.ms,
            curve: Curves.easeOutBack,
          )
              .fadeIn(duration: 300.ms),
        ),
      ),
        ),
    );
  }
}