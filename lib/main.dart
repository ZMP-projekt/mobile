import 'package:flutter/material.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_gym_app/features/auth/ui/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_gym_app/features/dashboard/ui/dashboard_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    )
  );
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isAuthenticated) {
      return const DashboardPage();
    } else {
      return const LoginPage();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B121E),
      ),
      home: const AuthGate(),
    );
  }
}