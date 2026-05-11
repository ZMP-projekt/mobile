import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../classes/providers/classes_provider.dart';
import '../../main/main_screen.dart';
import '../../membership/providers/membership_provider.dart';
import '../../notifications/providers/notification_provider.dart';
import '../../user/providers/user_provider.dart';

final authSessionCleanerProvider = Provider<AuthSessionCleaner>((ref) {
  return const AuthSessionCleaner();
});

class AuthSessionCleaner {
  const AuthSessionCleaner();

  void resetNavigation(Ref ref) {
    ref.read(mainNavigationProvider.notifier).state = 0;
  }

  void invalidateUserData(Ref ref) {
    ref.invalidate(currentUserProvider);
    ref.invalidate(currentMembershipProvider);
    ref.invalidate(classesForDateProvider);
    ref.invalidate(todayClassesProvider);
    ref.invalidate(trainerClassesProvider);
    ref.invalidate(notificationsProvider);
  }
}
