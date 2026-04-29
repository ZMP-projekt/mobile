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
import 'package:mobile_gym_app/l10n/app_localizations.dart';
import 'package:mobile_gym_app/l10n/app_localizations_pl.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUpAll(() async {
    await initializeDateFormatting('pl_PL', null);
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
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
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    await tester.pumpAndSettle();

    final l10n = AppLocalizationsPl();
    expect(find.textContaining(l10n.authLoginSubtitle), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, l10n.authLoginAction),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
