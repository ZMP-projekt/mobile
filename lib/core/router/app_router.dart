import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/ui/login_page.dart';
import '../../features/auth/ui/registration_page.dart';
import '../../features/main/main_screen.dart';
import '../../features/classes/ui/class_details_page.dart';
import '../../features/classes/data/models/gym_class.dart';
import '../../features/notifications/ui/notifications_page.dart';
import '../network/dio_client.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {

  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {

      final authState = ref.read(authStateProvider);
      final token = ref.read(authTokenProvider);

      final isAuth = authState.isAuthenticated && token != null;

      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: '/class-details',
        redirect: (context, state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ClassDetailsPage(
            gymClass: extra['gymClass'] as GymClass,
            imageUrl: extra['imageUrl'] as String,
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );

  ref.listen(
    authStateProvider.select((state) => state.isAuthenticated),
        (previous, next) {
      if (previous != next) {
        router.refresh();
      }
    },
  );

  return router;
});