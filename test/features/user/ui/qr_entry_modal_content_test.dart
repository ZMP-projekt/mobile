import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/user/providers/qr_provider.dart';
import 'package:mobile_gym_app/features/user/ui/widgets/qr_entry_modal_content.dart';
import 'package:mobile_gym_app/l10n/app_localizations.dart';
import 'package:mobile_gym_app/l10n/app_localizations_en.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const screenProtectorChannel = MethodChannel('screen_protector');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenProtectorChannel, (_) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenProtectorChannel, null);
  });

  Future<void> pumpQrModal(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          qrEntryCodeProvider.overrideWith((ref) => Stream.value('entry-code')),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: QrEntryModalContent()),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('uses localized English title and countdown label', (
    tester,
  ) async {
    final l10n = AppLocalizationsEn();

    await pumpQrModal(tester);

    expect(find.text(l10n.qrEntryTitle), findsOneWidget);
    expect(find.textContaining('Code expires in:'), findsOneWidget);
    expect(find.text('Twój kod wejścia'), findsNothing);
    expect(find.textContaining('Kod wygaśnie za:'), findsNothing);
  });
}
