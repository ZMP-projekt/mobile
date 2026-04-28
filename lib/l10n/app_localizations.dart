import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// Application name.
  ///
  /// In pl, this message translates to:
  /// **'Gym App'**
  String get appName;

  /// No description provided for @commonBack.
  ///
  /// In pl, this message translates to:
  /// **'Wróć'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get commonClose;

  /// No description provided for @commonConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź'**
  String get commonConfirm;

  /// No description provided for @commonCreate.
  ///
  /// In pl, this message translates to:
  /// **'Utwórz'**
  String get commonCreate;

  /// No description provided for @commonError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get commonError;

  /// No description provided for @commonLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania'**
  String get commonLoadError;

  /// No description provided for @commonNoData.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych'**
  String get commonNoData;

  /// No description provided for @commonRefresh.
  ///
  /// In pl, this message translates to:
  /// **'Odśwież'**
  String get commonRefresh;

  /// No description provided for @commonRetry.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get commonRetry;

  /// No description provided for @commonRetryUppercase.
  ///
  /// In pl, this message translates to:
  /// **'SPRÓBUJ PONOWNIE'**
  String get commonRetryUppercase;

  /// No description provided for @commonSave.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get commonSave;

  /// No description provided for @commonUnknownError.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd.'**
  String get commonUnknownError;

  /// Fatal app initialization error.
  ///
  /// In pl, this message translates to:
  /// **'Błąd krytyczny: {error}'**
  String criticalError(Object error);

  /// No description provided for @fieldEmail.
  ///
  /// In pl, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldFirstName.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get fieldFirstName;

  /// No description provided for @fieldLastName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get fieldLastName;

  /// No description provided for @fieldPassword.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get fieldPassword;

  /// No description provided for @fieldRepeatPassword.
  ///
  /// In pl, this message translates to:
  /// **'Powtórz hasło'**
  String get fieldRepeatPassword;

  /// No description provided for @fieldName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa'**
  String get fieldName;

  /// No description provided for @fieldDescriptionOptional.
  ///
  /// In pl, this message translates to:
  /// **'Opis (opcjonalnie)'**
  String get fieldDescriptionOptional;

  /// No description provided for @fieldSeatsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Miejsca'**
  String get fieldSeatsLabel;

  /// Seat count with Polish plural forms.
  ///
  /// In pl, this message translates to:
  /// **'{count, plural, =0{Brak miejsc} one{1 miejsce} few{{count} miejsca} many{{count} miejsc} other{{count} miejsca}}'**
  String fieldSeats(int count);

  /// No description provided for @fieldDate.
  ///
  /// In pl, this message translates to:
  /// **'Data'**
  String get fieldDate;

  /// No description provided for @fieldStart.
  ///
  /// In pl, this message translates to:
  /// **'Start'**
  String get fieldStart;

  /// No description provided for @fieldEnd.
  ///
  /// In pl, this message translates to:
  /// **'Koniec'**
  String get fieldEnd;

  /// No description provided for @authLoginTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Witaj z powrotem'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginContinue.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się, aby kontynuować'**
  String get authLoginContinue;

  /// No description provided for @authLoginAction.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get authLoginAction;

  /// No description provided for @authRegisterTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj się'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Stwórz konto i trenuj wygodniej'**
  String get authRegisterSubtitle;

  /// No description provided for @authRegisterAction.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj się'**
  String get authRegisterAction;

  /// No description provided for @authForgotPassword.
  ///
  /// In pl, this message translates to:
  /// **'Zapomniałeś hasła?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz konta? '**
  String get authNoAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In pl, this message translates to:
  /// **'Masz już konto? '**
  String get authAlreadyHaveAccount;

  /// No description provided for @dashboardNoConnection.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia'**
  String get dashboardNoConnection;

  /// Dashboard greeting with first name.
  ///
  /// In pl, this message translates to:
  /// **'Cześć, {name}!'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardReadyQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Gotowy na trening?'**
  String get dashboardReadyQuestion;

  /// No description provided for @dashboardSectionGym.
  ///
  /// In pl, this message translates to:
  /// **'Twoja Siłownia'**
  String get dashboardSectionGym;

  /// No description provided for @dashboardSectionTodayClasses.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiejsze zajęcia'**
  String get dashboardSectionTodayClasses;

  /// No description provided for @dashboardMapAction.
  ///
  /// In pl, this message translates to:
  /// **'MAPA'**
  String get dashboardMapAction;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In pl, this message translates to:
  /// **'ZOBACZ WSZYSTKIE'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardTodayClassesError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać dzisiejszych zajęć.'**
  String get dashboardTodayClassesError;

  /// No description provided for @dashboardMembershipRequiredForToday.
  ///
  /// In pl, this message translates to:
  /// **'Kup karnet, aby zobaczyć grafik na dziś i zapisać się na trening!'**
  String get dashboardMembershipRequiredForToday;

  /// No description provided for @dashboardRestTitle.
  ///
  /// In pl, this message translates to:
  /// **'Czas na odpoczynek'**
  String get dashboardRestTitle;

  /// No description provided for @dashboardRestSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak nadchodzących zajęć na dziś. Zregeneruj siły!'**
  String get dashboardRestSubtitle;

  /// No description provided for @dashboardNoGroupClassesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak zajęć grupowych'**
  String get dashboardNoGroupClassesTitle;

  /// No description provided for @dashboardNoGroupClassesSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nie ma już dzisiaj zaplanowanych zajęć grupowych.'**
  String get dashboardNoGroupClassesSubtitle;

  /// No description provided for @dashboardAvailablePersonalTrainings.
  ///
  /// In pl, this message translates to:
  /// **'Dostępne treningi 1 na 1'**
  String get dashboardAvailablePersonalTrainings;

  /// No description provided for @locationChooseGym.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz siłownię'**
  String get locationChooseGym;

  /// No description provided for @locationUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja nieznana'**
  String get locationUnknown;

  /// Distance in meters.
  ///
  /// In pl, this message translates to:
  /// **'{meters} m'**
  String locationDistanceMeters(int meters);

  /// Distance in kilometers.
  ///
  /// In pl, this message translates to:
  /// **'{kilometers} km'**
  String locationDistanceKilometers(String kilometers);

  /// Membership type label.
  ///
  /// In pl, this message translates to:
  /// **'Karnet {type}'**
  String membershipCardType(String type);

  /// Remaining membership days with Polish plural forms.
  ///
  /// In pl, this message translates to:
  /// **'{days, plural, =0{Karnet wygasł} one{Aktywny jeszcze 1 dzień} few{Aktywny jeszcze {days} dni} many{Aktywny jeszcze {days} dni} other{Aktywny jeszcze {days} dnia}}'**
  String membershipActiveDays(int days);

  /// No description provided for @membershipNoActive.
  ///
  /// In pl, this message translates to:
  /// **'Brak aktywnego karnetu'**
  String get membershipNoActive;

  /// No description provided for @membershipBuyAccessToday.
  ///
  /// In pl, this message translates to:
  /// **'Kup dostęp już dziś!'**
  String get membershipBuyAccessToday;

  /// No description provided for @membershipGuardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Aktywny karnet wymagany'**
  String get membershipGuardTitle;

  /// No description provided for @membershipGuardSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Kup karnet, aby zobaczyć grafik i zapisać się na trening.'**
  String get membershipGuardSubtitle;

  /// No description provided for @membershipBuyNow.
  ///
  /// In pl, this message translates to:
  /// **'Kup karnet teraz'**
  String get membershipBuyNow;

  /// No description provided for @membershipPurchaseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz karnet'**
  String get membershipPurchaseTitle;

  /// No description provided for @membershipPurchaseSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz plan, który najlepiej pasuje do Twojego rytmu treningów.'**
  String get membershipPurchaseSubtitle;

  /// No description provided for @membershipPurchasePopular.
  ///
  /// In pl, this message translates to:
  /// **'HIT'**
  String get membershipPurchasePopular;

  /// No description provided for @membershipPurchaseButton.
  ///
  /// In pl, this message translates to:
  /// **'Kupuję i płacę'**
  String get membershipPurchaseButton;

  /// No description provided for @membershipPurchaseSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Karnet zakupiony pomyślnie!'**
  String get membershipPurchaseSuccess;

  /// No description provided for @membershipPlanOpenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Karnet OPEN'**
  String get membershipPlanOpenTitle;

  /// No description provided for @membershipPlanOpenDescription.
  ///
  /// In pl, this message translates to:
  /// **'Całodobowy dostęp do klubu'**
  String get membershipPlanOpenDescription;

  /// No description provided for @membershipPlanNightTitle.
  ///
  /// In pl, this message translates to:
  /// **'Karnet NIGHT'**
  String get membershipPlanNightTitle;

  /// No description provided for @membershipPlanNightDescription.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp w godzinach 22:00 - 06:00'**
  String get membershipPlanNightDescription;

  /// No description provided for @membershipPlanStudentTitle.
  ///
  /// In pl, this message translates to:
  /// **'Karnet STUDENT'**
  String get membershipPlanStudentTitle;

  /// No description provided for @membershipPlanStudentDescription.
  ///
  /// In pl, this message translates to:
  /// **'Dla osób z ważną legitymacją'**
  String get membershipPlanStudentDescription;

  /// No description provided for @membershipLockedTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp zablokowany'**
  String get membershipLockedTitle;

  /// No description provided for @membershipLockedSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Aby przeglądać grafik zajęć i rezerwować treningi, musisz posiadać aktywny karnet do naszego klubu.'**
  String get membershipLockedSubtitle;

  /// No description provided for @classesSchedule.
  ///
  /// In pl, this message translates to:
  /// **'Grafik'**
  String get classesSchedule;

  /// No description provided for @classesAll.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie zajęcia'**
  String get classesAll;

  /// No description provided for @classesMyBookings.
  ///
  /// In pl, this message translates to:
  /// **'Moje rezerwacje'**
  String get classesMyBookings;

  /// No description provided for @classesToday.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiejsze zajęcia'**
  String get classesToday;

  /// No description provided for @classesNoClassesDateTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak zajęć w tym dniu'**
  String get classesNoClassesDateTitle;

  /// No description provided for @classesNoTrainingsDateTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak dostępnych\ntreningów w tym dniu'**
  String get classesNoTrainingsDateTitle;

  /// No description provided for @classesChooseAnotherDate.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz inną datę z kalendarza powyżej'**
  String get classesChooseAnotherDate;

  /// Trainer label with name.
  ///
  /// In pl, this message translates to:
  /// **'Trener: {name}'**
  String classesTrainer(String name);

  /// No description provided for @classesInstructor.
  ///
  /// In pl, this message translates to:
  /// **'Instruktor'**
  String get classesInstructor;

  /// No description provided for @classesAboutTraining.
  ///
  /// In pl, this message translates to:
  /// **'O treningu'**
  String get classesAboutTraining;

  /// No description provided for @classesBooked.
  ///
  /// In pl, this message translates to:
  /// **'ZAPISANO'**
  String get classesBooked;

  /// No description provided for @classesFull.
  ///
  /// In pl, this message translates to:
  /// **'BRAK MIEJSC'**
  String get classesFull;

  /// No description provided for @classesBook.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get classesBook;

  /// No description provided for @classesBookLong.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz się'**
  String get classesBookLong;

  /// No description provided for @classesCancelBooking.
  ///
  /// In pl, this message translates to:
  /// **'Zrezygnuj z zajęć'**
  String get classesCancelBooking;

  /// No description provided for @classesCancelBookingShort.
  ///
  /// In pl, this message translates to:
  /// **'Zrezygnuj'**
  String get classesCancelBookingShort;

  /// No description provided for @classesFinished.
  ///
  /// In pl, this message translates to:
  /// **'Zakończone'**
  String get classesFinished;

  /// No description provided for @classesParticipantsRegistered.
  ///
  /// In pl, this message translates to:
  /// **'Zapisani uczestnicy'**
  String get classesParticipantsRegistered;

  /// No description provided for @classesParticipantsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak zapisanych osób'**
  String get classesParticipantsEmpty;

  /// Current and maximum class participants.
  ///
  /// In pl, this message translates to:
  /// **'Uczestnicy: {current}/{max}'**
  String classesParticipantsCount(int current, int max);

  /// No description provided for @classesParticipantsLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania listy'**
  String get classesParticipantsLoadError;

  /// Booking failure message.
  ///
  /// In pl, this message translates to:
  /// **'Błąd rezerwacji: {error}'**
  String classesBookingError(Object error);

  /// No description provided for @classesBookingSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano na\ntrening!'**
  String get classesBookingSuccess;

  /// Generic class action error.
  ///
  /// In pl, this message translates to:
  /// **'Błąd: {error}'**
  String classesGenericError(Object error);

  /// No description provided for @classesCancelDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zrezygnować?'**
  String get classesCancelDialogTitle;

  /// Cancel booking confirmation body.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz anulować:\n{name}?'**
  String classesCancelDialogBody(String name);

  /// No description provided for @classesDeleteDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Odwołać zajęcia?'**
  String get classesDeleteDialogTitle;

  /// No description provided for @classesDeleteAction.
  ///
  /// In pl, this message translates to:
  /// **'Odwołaj zajęcia'**
  String get classesDeleteAction;

  /// No description provided for @classesDeleteDialogBody.
  ///
  /// In pl, this message translates to:
  /// **'Zapisani uczestnicy otrzymają powiadomienie. Tej operacji nie można cofnąć.'**
  String get classesDeleteDialogBody;

  /// No description provided for @classesDeleteConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Tak, odwołaj'**
  String get classesDeleteConfirm;

  /// No description provided for @classesRescheduleTitle.
  ///
  /// In pl, this message translates to:
  /// **'Przełóż'**
  String get classesRescheduleTitle;

  /// No description provided for @classesRescheduleConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Zatwierdź zmianę'**
  String get classesRescheduleConfirm;

  /// No description provided for @classesReschedulePastError.
  ///
  /// In pl, this message translates to:
  /// **'Nowy termin nie może być w przeszłości!'**
  String get classesReschedulePastError;

  /// No description provided for @classesNewDate.
  ///
  /// In pl, this message translates to:
  /// **'Nowa data'**
  String get classesNewDate;

  /// No description provided for @classesNewTime.
  ///
  /// In pl, this message translates to:
  /// **'Nowa godzina'**
  String get classesNewTime;

  /// Duration in minutes.
  ///
  /// In pl, this message translates to:
  /// **'{minutes, plural, one{1 min} few{{minutes} min} many{{minutes} min} other{{minutes} min}}'**
  String classesDurationMinutes(int minutes);

  /// No description provided for @classesUnknownTrainer.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany Trener'**
  String get classesUnknownTrainer;

  /// No description provided for @classesUnknownTrainerFirstName.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany'**
  String get classesUnknownTrainerFirstName;

  /// No description provided for @classesOngoing.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia w toku'**
  String get classesOngoing;

  /// No description provided for @classesRescheduledSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia\nprzełożone!'**
  String get classesRescheduledSuccess;

  /// No description provided for @classesDefaultDescription.
  ///
  /// In pl, this message translates to:
  /// **'Dołącz do nas i poczuj energię grupowego treningu. Idealne dla każdego poziomu zaawansowania.'**
  String get classesDefaultDescription;

  /// No description provided for @trainerDashboardGroupClasses.
  ///
  /// In pl, this message translates to:
  /// **'Twoje zajęcia grupowe'**
  String get trainerDashboardGroupClasses;

  /// No description provided for @trainerDashboardAdd.
  ///
  /// In pl, this message translates to:
  /// **'DODAJ'**
  String get trainerDashboardAdd;

  /// No description provided for @trainerSummaryToday.
  ///
  /// In pl, this message translates to:
  /// **'DZISIAJ'**
  String get trainerSummaryToday;

  /// No description provided for @trainerSummaryReadyTitle.
  ///
  /// In pl, this message translates to:
  /// **'Harmonogram gotowy'**
  String get trainerSummaryReadyTitle;

  /// No description provided for @trainerSummaryReadySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie zajęcia są zaplanowane.'**
  String get trainerSummaryReadySubtitle;

  /// No description provided for @trainerSummaryEmptyTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak zaplanowanych zajęć'**
  String get trainerSummaryEmptyTitle;

  /// No description provided for @trainerSummaryLoadErrorSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać grafiku.'**
  String get trainerSummaryLoadErrorSubtitle;

  /// No description provided for @trainerDashboardAllReadyTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wszystko gotowe'**
  String get trainerDashboardAllReadyTitle;

  /// No description provided for @trainerDashboardAllReadySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz już dziś zaplanowanych zajęć grupowych.'**
  String get trainerDashboardAllReadySubtitle;

  /// No description provided for @trainerDashboardPersonalTrainings.
  ///
  /// In pl, this message translates to:
  /// **'Treningi personalne'**
  String get trainerDashboardPersonalTrainings;

  /// No description provided for @trainerDashboardNoClientsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak podopiecznych'**
  String get trainerDashboardNoClientsTitle;

  /// No description provided for @trainerDashboardNoClientsSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz zaplanowanych treningów personalnych na dziś.'**
  String get trainerDashboardNoClientsSubtitle;

  /// No description provided for @trainerClassFetchError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania zajęć'**
  String get trainerClassFetchError;

  /// No description provided for @trainerDataError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd danych'**
  String get trainerDataError;

  /// No description provided for @trainerFreeSlot.
  ///
  /// In pl, this message translates to:
  /// **'Wolny termin'**
  String get trainerFreeSlot;

  /// No description provided for @trainerPersonalTraining.
  ///
  /// In pl, this message translates to:
  /// **'Trening personalny'**
  String get trainerPersonalTraining;

  /// No description provided for @trainerClientsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Podopieczni'**
  String get trainerClientsTitle;

  /// No description provided for @trainerClientsSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zarządzaj swoimi treningami 1 na 1.'**
  String get trainerClientsSubtitle;

  /// No description provided for @trainerManageSoon.
  ///
  /// In pl, this message translates to:
  /// **'Zarządzanie treningiem wkrótce!'**
  String get trainerManageSoon;

  /// No description provided for @trainerFetchErrorShort.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania'**
  String get trainerFetchErrorShort;

  /// No description provided for @trainerAddClassTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowe zajęcia'**
  String get trainerAddClassTitle;

  /// No description provided for @trainerAddPersonalTrainingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Trening personalny'**
  String get trainerAddPersonalTrainingTitle;

  /// No description provided for @trainerAddPersonalTrainingSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia z jednym klientem'**
  String get trainerAddPersonalTrainingSubtitle;

  /// No description provided for @trainerCreateClassButton.
  ///
  /// In pl, this message translates to:
  /// **'UTWÓRZ ZAJĘCIA'**
  String get trainerCreateClassButton;

  /// No description provided for @trainerClassCreatedSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia zostały dodane!'**
  String get trainerClassCreatedSuccess;

  /// No description provided for @trainerNoLocations.
  ///
  /// In pl, this message translates to:
  /// **'Brak dostępnych lokalizacji.'**
  String get trainerNoLocations;

  /// No description provided for @trainerPastClassError.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia nie mogą odbywać się w przeszłości.'**
  String get trainerPastClassError;

  /// No description provided for @trainerClassEndBeforeStartError.
  ///
  /// In pl, this message translates to:
  /// **'Zajęcia muszą kończyć się po ich rozpoczęciu.'**
  String get trainerClassEndBeforeStartError;

  /// No description provided for @trainerLocationsLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się załadować lokalizacji'**
  String get trainerLocationsLoadError;

  /// No description provided for @profileNoData.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych'**
  String get profileNoData;

  /// No description provided for @profileInfoSection.
  ///
  /// In pl, this message translates to:
  /// **'Informacje'**
  String get profileInfoSection;

  /// No description provided for @profileSettingsSection.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get profileSettingsSection;

  /// No description provided for @profileAboutSection.
  ///
  /// In pl, this message translates to:
  /// **'O aplikacji'**
  String get profileAboutSection;

  /// No description provided for @profileTrainerAccount.
  ///
  /// In pl, this message translates to:
  /// **'Konto Trenera'**
  String get profileTrainerAccount;

  /// No description provided for @profileUserAccount.
  ///
  /// In pl, this message translates to:
  /// **'Konto Użytkownika'**
  String get profileUserAccount;

  /// No description provided for @profileLanguage.
  ///
  /// In pl, this message translates to:
  /// **'Język aplikacji'**
  String get profileLanguage;

  /// No description provided for @profileSelectLanguage.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz język'**
  String get profileSelectLanguage;

  /// No description provided for @profileLanguagePolish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get profileLanguagePolish;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In pl, this message translates to:
  /// **'Angielski'**
  String get profileLanguageEnglish;

  /// No description provided for @profilePushNotifications.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia Push'**
  String get profilePushNotifications;

  /// No description provided for @profileHelpContact.
  ///
  /// In pl, this message translates to:
  /// **'Pomoc i kontakt'**
  String get profileHelpContact;

  /// No description provided for @profileClubRules.
  ///
  /// In pl, this message translates to:
  /// **'Regulamin klubu'**
  String get profileClubRules;

  /// No description provided for @profileLogout.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj się'**
  String get profileLogout;

  /// No description provided for @profileAppVersion.
  ///
  /// In pl, this message translates to:
  /// **'Wersja aplikacji'**
  String get profileAppVersion;

  /// Application version label.
  ///
  /// In pl, this message translates to:
  /// **'Wersja {version}'**
  String profileVersion(String version);

  /// No description provided for @notificationsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak powiadomień'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Gdy coś się wydarzy, damy Ci znać.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationsToday.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj'**
  String get notificationsToday;

  /// No description provided for @notificationsEarlier.
  ///
  /// In pl, this message translates to:
  /// **'Wcześniejsze'**
  String get notificationsEarlier;

  /// No description provided for @notificationsNewUppercase.
  ///
  /// In pl, this message translates to:
  /// **'NOWE POWIADOMIENIE'**
  String get notificationsNewUppercase;

  /// Today date label in notification list.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj, {time}'**
  String notificationsDateToday(String time);

  /// Yesterday date label in notification list.
  ///
  /// In pl, this message translates to:
  /// **'Wczoraj, {time}'**
  String notificationsDateYesterday(String time);

  /// Notifications screen error.
  ///
  /// In pl, this message translates to:
  /// **'Błąd: {error}'**
  String notificationsError(Object error);

  /// No description provided for @qrEntryTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kod wejścia'**
  String get qrEntryTitle;

  /// No description provided for @qrEntrySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż kod przy wejściu do klubu.'**
  String get qrEntrySubtitle;

  /// No description provided for @offlineModalTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia'**
  String get offlineModalTitle;

  /// No description provided for @offlineModalSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać danych. Sprawdź połączenie internetowe i spróbuj ponownie.'**
  String get offlineModalSubtitle;

  /// No description provided for @offlineActionUnavailable.
  ///
  /// In pl, this message translates to:
  /// **'Ta akcja wymaga połączenia z internetem.'**
  String get offlineActionUnavailable;

  /// No description provided for @offlineBookingUnavailable.
  ///
  /// In pl, this message translates to:
  /// **'Połącz się z internetem, aby zapisać się na zajęcia.'**
  String get offlineBookingUnavailable;

  /// No description provided for @offlineCancelBookingUnavailable.
  ///
  /// In pl, this message translates to:
  /// **'Połącz się z internetem, aby anulować zapis.'**
  String get offlineCancelBookingUnavailable;

  /// No description provided for @syncOfflineBadge.
  ///
  /// In pl, this message translates to:
  /// **'Tryb offline'**
  String get syncOfflineBadge;

  /// No description provided for @syncCachedDataNotice.
  ///
  /// In pl, this message translates to:
  /// **'Pokazujemy ostatnio zapisane dane.'**
  String get syncCachedDataNotice;

  /// Shows when cached data was last refreshed.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnia aktualizacja: {date}'**
  String syncLastUpdated(String date);

  /// No description provided for @syncRefreshing.
  ///
  /// In pl, this message translates to:
  /// **'Aktualizowanie danych...'**
  String get syncRefreshing;

  /// No description provided for @syncRefreshSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Dane zostały zaktualizowane.'**
  String get syncRefreshSuccess;

  /// No description provided for @syncRefreshFailed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się odświeżyć danych.'**
  String get syncRefreshFailed;

  /// No description provided for @gpsPermissionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do lokalizacji'**
  String get gpsPermissionTitle;

  /// No description provided for @gpsPermissionRationale.
  ///
  /// In pl, this message translates to:
  /// **'Pozwól aplikacji używać lokalizacji, aby pokazać najbliższą siłownię.'**
  String get gpsPermissionRationale;

  /// No description provided for @gpsPermissionDenied.
  ///
  /// In pl, this message translates to:
  /// **'Nie przyznano dostępu do lokalizacji.'**
  String get gpsPermissionDenied;

  /// No description provided for @gpsPermissionDeniedForever.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do lokalizacji jest zablokowany. Zmień ustawienia systemowe, aby go włączyć.'**
  String get gpsPermissionDeniedForever;

  /// No description provided for @gpsServiceDisabled.
  ///
  /// In pl, this message translates to:
  /// **'Usługi lokalizacji są wyłączone.'**
  String get gpsServiceDisabled;

  /// No description provided for @gpsOpenSettings.
  ///
  /// In pl, this message translates to:
  /// **'Otwórz ustawienia'**
  String get gpsOpenSettings;

  /// No description provided for @gpsDistanceUnavailable.
  ///
  /// In pl, this message translates to:
  /// **'Odległość niedostępna'**
  String get gpsDistanceUnavailable;

  /// No description provided for @validationRequired.
  ///
  /// In pl, this message translates to:
  /// **'To pole jest wymagane.'**
  String get validationRequired;

  /// Required field validation message.
  ///
  /// In pl, this message translates to:
  /// **'Pole {fieldName} jest wymagane.'**
  String validationRequiredField(String fieldName);

  /// No description provided for @validationEmailRequired.
  ///
  /// In pl, this message translates to:
  /// **'Podaj adres email.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Podaj poprawny adres email.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In pl, this message translates to:
  /// **'Podaj hasło.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordConfirmationRequired.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź hasło.'**
  String get validationPasswordConfirmationRequired;

  /// Password minimum length validation message.
  ///
  /// In pl, this message translates to:
  /// **'{length, plural, one{Hasło musi mieć co najmniej 1 znak.} few{Hasło musi mieć co najmniej {length} znaki.} many{Hasło musi mieć co najmniej {length} znaków.} other{Hasło musi mieć co najmniej {length} znaku.}}'**
  String validationPasswordMinLength(int length);

  /// No description provided for @validationPasswordsDoNotMatch.
  ///
  /// In pl, this message translates to:
  /// **'Hasła nie są takie same.'**
  String get validationPasswordsDoNotMatch;

  /// No description provided for @validationSeatsMin.
  ///
  /// In pl, this message translates to:
  /// **'Liczba miejsc musi być większa od zera.'**
  String get validationSeatsMin;

  /// Available seats label.
  ///
  /// In pl, this message translates to:
  /// **'{count, plural, =0{Brak wolnych miejsc} one{1 wolne miejsce} few{{count} wolne miejsca} many{{count} wolnych miejsc} other{{count} wolnego miejsca}}'**
  String classSeatsAvailable(int count);

  /// No description provided for @errorServer.
  ///
  /// In pl, this message translates to:
  /// **'Błąd serwera. Spróbuj ponownie później.'**
  String get errorServer;

  /// No description provided for @errorServerWaking.
  ///
  /// In pl, this message translates to:
  /// **'Serwer się wybudza, spróbuj za chwilę.'**
  String get errorServerWaking;

  /// No description provided for @errorConnectionTimeout.
  ///
  /// In pl, this message translates to:
  /// **'Przekroczono czas połączenia. Sprawdź połączenie z internetem.'**
  String get errorConnectionTimeout;

  /// No description provided for @errorRequestCanceled.
  ///
  /// In pl, this message translates to:
  /// **'Żądanie zostało anulowane.'**
  String get errorRequestCanceled;

  /// No description provided for @errorNoInternet.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia z internetem.'**
  String get errorNoInternet;

  /// No description provided for @errorDataLoad.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania danych.'**
  String get errorDataLoad;

  /// No description provided for @errorVerifyAccountAccess.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zweryfikować uprawnień konta. Sprawdź sieć.'**
  String get errorVerifyAccountAccess;

  /// No description provided for @errorUserProfileFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać profilu użytkownika.'**
  String get errorUserProfileFetch;

  /// No description provided for @errorUserProfileUnexpected.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd podczas pobierania profilu.'**
  String get errorUserProfileUnexpected;

  /// No description provided for @errorTrainersFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać listy trenerów.'**
  String get errorTrainersFetch;

  /// No description provided for @errorTrainersUnexpected.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd podczas pobierania trenerów.'**
  String get errorTrainersUnexpected;

  /// No description provided for @errorMembershipFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać karnetu.'**
  String get errorMembershipFetch;

  /// No description provided for @errorMembershipUnexpected.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd podczas pobierania karnetu.'**
  String get errorMembershipUnexpected;

  /// No description provided for @errorMembershipPurchase.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zakupić karnetu.'**
  String get errorMembershipPurchase;

  /// No description provided for @errorClassesFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać grafiku zajęć.'**
  String get errorClassesFetch;

  /// No description provided for @errorTrainerScheduleFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać Twojego grafiku.'**
  String get errorTrainerScheduleFetch;

  /// No description provided for @errorClassParticipantsFetch.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać listy uczestników.'**
  String get errorClassParticipantsFetch;

  /// No description provided for @errorBookClass.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zarezerwować zajęć.'**
  String get errorBookClass;

  /// No description provided for @errorCancelBooking.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się anulować rezerwacji.'**
  String get errorCancelBooking;

  /// No description provided for @errorCreateClass.
  ///
  /// In pl, this message translates to:
  /// **'Błąd tworzenia zajęć.'**
  String get errorCreateClass;

  /// No description provided for @errorRescheduleClass.
  ///
  /// In pl, this message translates to:
  /// **'Błąd przekładania zajęć.'**
  String get errorRescheduleClass;

  /// No description provided for @errorDeleteClass.
  ///
  /// In pl, this message translates to:
  /// **'Błąd usuwania zajęć.'**
  String get errorDeleteClass;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
