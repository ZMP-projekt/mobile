import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/ui/login_page.dart';
import '../../features/auth/ui/registration_page.dart';
import '../../features/main/main_screen.dart';
import '../../features/classes/ui/class_details_page.dart';
import '../../features/classes/data/models/gym_class.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
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
        builder: (context, state) {
          // Pobieramy dane przekazane w extra (obiekt GymClass i URL zdjęcia)
          final extra = state.extra as Map<String, dynamic>;
          return ClassDetailsPage(
            gymClass: extra['gymClass'] as GymClass,
            imageUrl: extra['imageUrl'] as String,
          );
        },
      ),
    ],
  );
});