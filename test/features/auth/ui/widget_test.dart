import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart'; // Dodaj dla dat
import 'package:mobile_gym_app/features/auth/ui/login_page.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUpAll(() async {
    await initializeDateFormatting('pl_PL', null);
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  testWidgets('Login page visibility test', (WidgetTester tester) async {

    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: MaterialApp.router(
          routerConfig: testRouter,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Witaj ponownie'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Zaloguj się'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}