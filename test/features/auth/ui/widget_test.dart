import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart'; // Dodaj dla dat
import 'package:mobile_gym_app/features/auth/ui/login_page.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';
import 'package:mobile_gym_app/core/models/result.dart';
import 'package:mobile_gym_app/l10n/app_localizations.dart';
import 'package:mobile_gym_app/l10n/app_localizations_pl.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AppLocalizationsPl l10n;

  setUpAll(() async {
    await initializeDateFormatting('pl_PL', null);
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    mockAuthRepository = MockAuthRepository();
    l10n = AppLocalizationsPl();
  });

  Future<void> pumpLoginPage(WidgetTester tester) async {
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
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Login page visibility test', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    expect(find.textContaining(l10n.authLoginSubtitle), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, l10n.authLoginAction),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('shows required validation errors for empty form', (
    WidgetTester tester,
  ) async {
    await pumpLoginPage(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, l10n.authLoginAction));
    await tester.pump();

    expect(find.text(l10n.validationEmailRequired), findsOneWidget);
    expect(find.text(l10n.validationPasswordRequired), findsOneWidget);
    verifyNever(() => mockAuthRepository.login(any(), any()));
  });

  testWidgets('shows format and min length validation errors', (
    WidgetTester tester,
  ) async {
    await pumpLoginPage(tester);

    await tester.enterText(find.byType(TextField).at(0), 'bad-email');
    await tester.enterText(find.byType(TextField).at(1), 'abc');
    await tester.tap(find.widgetWithText(ElevatedButton, l10n.authLoginAction));
    await tester.pump();

    expect(find.text(l10n.validationEmailInvalid), findsOneWidget);
    expect(find.text(l10n.validationPasswordMinLength(4)), findsOneWidget);
    verifyNever(() => mockAuthRepository.login(any(), any()));
  });

  testWidgets('toggles password visibility', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    TextField passwordField = tester.widget(find.byType(TextField).at(1));
    expect(passwordField.obscureText, isTrue);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    passwordField = tester.widget(find.byType(TextField).at(1));
    expect(passwordField.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('submits trimmed email and password to repository', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Invalid credentials';
    when(
      () => mockAuthRepository.login('john@example.com', 'password123'),
    ).thenAnswer((_) async => const Result.failure(errorMessage));

    await pumpLoginPage(tester);

    await tester.enterText(
      find.byType(TextField).at(0),
      '  john@example.com  ',
    );
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, l10n.authLoginAction));
    await tester.pumpAndSettle();

    verify(
      () => mockAuthRepository.login('john@example.com', 'password123'),
    ).called(1);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('navigates to register route from login page', (
    WidgetTester tester,
  ) async {
    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(body: Text('Register')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: MaterialApp.router(
          routerConfig: testRouter,
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.authRegisterAction));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
  });
}
