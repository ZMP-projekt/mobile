import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/full_screen_empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../data/models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              l10n.notificationsTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
            ],
          ],
        ),
      ),
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Text(l10n.notificationsError(err),
              style: const TextStyle(color: AppColors.error)),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return FullScreenEmptyState(
              icon: Icons.notifications_off_outlined,
              title: l10n.notificationsEmptyTitle,
              subtitle: l10n.notificationsEmptySubtitle,
            );
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final todayItems =
          notifications.where((n) => n.createdAt.isAfter(today)).toList();
          final earlierItems =
          notifications.where((n) => !n.createdAt.isAfter(today)).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            children: [
              if (todayItems.isNotEmpty) ...[
                _SectionHeader(
                    title: l10n.notificationsToday,
                    count: todayItems.where((n) => !n.read).length),
                const SizedBox(height: 8),
                ...todayItems.asMap().entries.map((e) =>
                    _buildActionableCard(e.value, e.key, ref) // Zmiana tutaj!
                        .animate()
                        .fadeIn(delay: (e.key * 60).ms, duration: 350.ms)
                        .slideX(
                      begin: 0.08,
                      curve: Curves.easeOutQuad,
                      delay: (e.key * 60).ms,
                    )),
              ],
              if (earlierItems.isNotEmpty) ...[
                if (todayItems.isNotEmpty) const SizedBox(height: 20),
                _SectionHeader(title: l10n.notificationsEarlier, count: 0),
                const SizedBox(height: 8),
                ...earlierItems.asMap().entries.map((e) =>
                    _buildActionableCard(e.value, todayItems.length + e.key, ref) // Zmiana tutaj!
                        .animate()
                        .fadeIn(
                        delay: ((todayItems.length + e.key) * 50).ms,
                        duration: 300.ms)
                        .slideX(
                      begin: 0.06,
                      curve: Curves.easeOutQuad,
                      delay: ((todayItems.length + e.key) * 50).ms,
                    )),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionableCard(AppNotification notification, int index, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(notificationsProvider.notifier).deleteNotification(notification.id);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.read) {
            ref.read(notificationsProvider.notifier).markAsRead(notification.id);
          }
        },
        child: _NotificationCard(notification: notification, index: index),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final int index;

  const _NotificationCard({required this.notification, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.read;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.05),
          width: isUnread ? 1.5 : 1,
        ),
        boxShadow: isUnread ? AppColors.mediumGlow : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isUnread)
                Container(
                  width: 4,
                  color: AppColors.primary,
                ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 72),
                  padding: EdgeInsets.fromLTRB(
                    isUnread ? 14 : 16,
                    14,
                    16,
                    14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnread
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_rounded,
                          color: isUnread
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.content,
                              style: TextStyle(
                                color: isUnread
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(context, notification.createdAt),
                              style: TextStyle(
                                color: isUnread
                                    ? AppColors.primary.withValues(alpha: 0.7)
                                    : AppColors.textSecondary
                                    .withValues(alpha: 0.6),
                                fontSize: 11,
                                fontWeight: isUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(top: 4, left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(
                          begin: 0.8,
                          end: 1.2,
                          duration: 1200.ms,
                          curve: Curves.easeInOut,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    final timeStr = DateFormat('HH:mm').format(date);

    if (dateOnly == today) return l10n.notificationsDateToday(timeStr);
    if (dateOnly == yesterday) {
      return l10n.notificationsDateYesterday(timeStr);
    }
    return DateFormat('dd MMM, HH:mm', l10n.localeName).format(date);
  }
}
