// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Gym App';

  @override
  String get commonBack => 'Wróć';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonConfirm => 'Potwierdź';

  @override
  String get commonCreate => 'Utwórz';

  @override
  String get commonError => 'Błąd';

  @override
  String get commonLoadError => 'Błąd ładowania';

  @override
  String get commonNoData => 'Brak danych';

  @override
  String get commonRefresh => 'Odśwież';

  @override
  String get commonRetry => 'Spróbuj ponownie';

  @override
  String get commonRetryUppercase => 'SPRÓBUJ PONOWNIE';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonUnknownError => 'Wystąpił nieoczekiwany błąd.';

  @override
  String criticalError(Object error) {
    return 'Błąd krytyczny: $error';
  }

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldFirstName => 'Imię';

  @override
  String get fieldLastName => 'Nazwisko';

  @override
  String get fieldPassword => 'Hasło';

  @override
  String get fieldRepeatPassword => 'Powtórz hasło';

  @override
  String get fieldName => 'Nazwa';

  @override
  String get fieldDescriptionOptional => 'Opis (opcjonalnie)';

  @override
  String get fieldSeatsLabel => 'Miejsca';

  @override
  String fieldSeats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miejsca',
      many: '$count miejsc',
      few: '$count miejsca',
      one: '1 miejsce',
      zero: 'Brak miejsc',
    );
    return '$_temp0';
  }

  @override
  String get fieldDate => 'Data';

  @override
  String get fieldStart => 'Start';

  @override
  String get fieldEnd => 'Koniec';

  @override
  String get authLoginTitle => 'Zaloguj się';

  @override
  String get authLoginSubtitle => 'Witaj z powrotem';

  @override
  String get authLoginContinue => 'Zaloguj się, aby kontynuować';

  @override
  String get authLoginAction => 'Zaloguj się';

  @override
  String get authRegisterTitle => 'Zarejestruj się';

  @override
  String get authRegisterSubtitle => 'Stwórz konto i trenuj wygodniej';

  @override
  String get authRegisterAction => 'Zarejestruj się';

  @override
  String get authForgotPassword => 'Zapomniałeś hasła?';

  @override
  String get authNoAccount => 'Nie masz konta? ';

  @override
  String get authAlreadyHaveAccount => 'Masz już konto? ';

  @override
  String get dashboardNoConnection => 'Brak połączenia';

  @override
  String dashboardGreeting(String name) {
    return 'Cześć, $name!';
  }

  @override
  String get dashboardReadyQuestion => 'Gotowy na trening?';

  @override
  String get dashboardSectionGym => 'Twoja Siłownia';

  @override
  String get dashboardSectionTodayClasses => 'Dzisiejsze zajęcia';

  @override
  String get dashboardMapAction => 'MAPA';

  @override
  String get dashboardSeeAll => 'ZOBACZ WSZYSTKIE';

  @override
  String get dashboardTodayClassesError =>
      'Nie udało się pobrać dzisiejszych zajęć.';

  @override
  String get dashboardMembershipRequiredForToday =>
      'Kup karnet, aby zobaczyć grafik na dziś i zapisać się na trening!';

  @override
  String get dashboardRestTitle => 'Czas na odpoczynek';

  @override
  String get dashboardRestSubtitle =>
      'Brak nadchodzących zajęć na dziś. Zregeneruj siły!';

  @override
  String get dashboardNoGroupClassesTitle => 'Brak zajęć grupowych';

  @override
  String get dashboardNoGroupClassesSubtitle =>
      'Nie ma już dzisiaj zaplanowanych zajęć grupowych.';

  @override
  String get dashboardAvailablePersonalTrainings => 'Dostępne treningi 1 na 1';

  @override
  String get locationChooseGym => 'Wybierz siłownię';

  @override
  String get locationUnknown => 'Lokalizacja nieznana';

  @override
  String locationDistanceMeters(int meters) {
    return '$meters m';
  }

  @override
  String locationDistanceKilometers(String kilometers) {
    return '$kilometers km';
  }

  @override
  String membershipCardType(String type) {
    return 'Karnet $type';
  }

  @override
  String membershipActiveDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Aktywny jeszcze $days dnia',
      many: 'Aktywny jeszcze $days dni',
      few: 'Aktywny jeszcze $days dni',
      one: 'Aktywny jeszcze 1 dzień',
      zero: 'Karnet wygasł',
    );
    return '$_temp0';
  }

  @override
  String get membershipNoActive => 'Brak aktywnego karnetu';

  @override
  String get membershipBuyAccessToday => 'Kup dostęp już dziś!';

  @override
  String get membershipGuardTitle => 'Aktywny karnet wymagany';

  @override
  String get membershipGuardSubtitle =>
      'Kup karnet, aby zobaczyć grafik i zapisać się na trening.';

  @override
  String get membershipBuyNow => 'Kup karnet teraz';

  @override
  String get membershipPurchaseTitle => 'Wybierz karnet';

  @override
  String get membershipPurchaseSubtitle =>
      'Wybierz plan, który najlepiej pasuje do Twojego rytmu treningów.';

  @override
  String get membershipPurchasePopular => 'HIT';

  @override
  String get membershipPurchaseButton => 'Kupuję i płacę';

  @override
  String get membershipPurchaseSuccess => 'Karnet zakupiony pomyślnie!';

  @override
  String get membershipPlanOpenTitle => 'Karnet OPEN';

  @override
  String get membershipPlanOpenDescription => 'Całodobowy dostęp do klubu';

  @override
  String get membershipPlanNightTitle => 'Karnet NIGHT';

  @override
  String get membershipPlanNightDescription =>
      'Dostęp w godzinach 22:00 - 06:00';

  @override
  String get membershipPlanStudentTitle => 'Karnet STUDENT';

  @override
  String get membershipPlanStudentDescription => 'Dla osób z ważną legitymacją';

  @override
  String get membershipLockedTitle => 'Dostęp zablokowany';

  @override
  String get membershipLockedSubtitle =>
      'Aby przeglądać grafik zajęć i rezerwować treningi, musisz posiadać aktywny karnet do naszego klubu.';

  @override
  String get classesSchedule => 'Grafik';

  @override
  String get classesAll => 'Wszystkie zajęcia';

  @override
  String get classesMyBookings => 'Moje rezerwacje';

  @override
  String get classesToday => 'Dzisiejsze zajęcia';

  @override
  String get classesNoClassesDateTitle => 'Brak zajęć w tym dniu';

  @override
  String get classesNoTrainingsDateTitle =>
      'Brak dostępnych\ntreningów w tym dniu';

  @override
  String get classesChooseAnotherDate =>
      'Wybierz inną datę z kalendarza powyżej';

  @override
  String classesTrainer(String name) {
    return 'Trener: $name';
  }

  @override
  String get classesInstructor => 'Instruktor';

  @override
  String get classesAboutTraining => 'O treningu';

  @override
  String get classesBooked => 'ZAPISANO';

  @override
  String get classesFull => 'BRAK MIEJSC';

  @override
  String get classesBook => 'Zapisz';

  @override
  String get classesBookLong => 'Zapisz się';

  @override
  String get classesCancelBooking => 'Zrezygnuj z zajęć';

  @override
  String get classesCancelBookingShort => 'Zrezygnuj';

  @override
  String get classesFinished => 'Zakończone';

  @override
  String get classesParticipantsRegistered => 'Zapisani uczestnicy';

  @override
  String get classesParticipantsEmpty => 'Brak zapisanych osób';

  @override
  String classesParticipantsCount(int current, int max) {
    return 'Uczestnicy: $current/$max';
  }

  @override
  String get classesParticipantsLoadError => 'Błąd ładowania listy';

  @override
  String classesBookingError(Object error) {
    return 'Błąd rezerwacji: $error';
  }

  @override
  String get classesBookingSuccess => 'Zapisano na\ntrening!';

  @override
  String classesGenericError(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get classesCancelDialogTitle => 'Zrezygnować?';

  @override
  String classesCancelDialogBody(String name) {
    return 'Czy na pewno chcesz anulować:\n$name?';
  }

  @override
  String get classesDeleteDialogTitle => 'Odwołać zajęcia?';

  @override
  String get classesDeleteAction => 'Odwołaj zajęcia';

  @override
  String get classesDeleteDialogBody =>
      'Zapisani uczestnicy otrzymają powiadomienie. Tej operacji nie można cofnąć.';

  @override
  String get classesDeleteConfirm => 'Tak, odwołaj';

  @override
  String get classesRescheduleTitle => 'Przełóż';

  @override
  String get classesRescheduleConfirm => 'Zatwierdź zmianę';

  @override
  String get classesReschedulePastError =>
      'Nowy termin nie może być w przeszłości!';

  @override
  String get classesNewDate => 'Nowa data';

  @override
  String get classesNewTime => 'Nowa godzina';

  @override
  String classesDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      many: '$minutes min',
      few: '$minutes min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get classesUnknownTrainer => 'Nieznany Trener';

  @override
  String get classesUnknownTrainerFirstName => 'Nieznany';

  @override
  String get classesOngoing => 'Zajęcia w toku';

  @override
  String get classesRescheduledSuccess => 'Zajęcia\nprzełożone!';

  @override
  String get classesDefaultDescription =>
      'Dołącz do nas i poczuj energię grupowego treningu. Idealne dla każdego poziomu zaawansowania.';

  @override
  String get trainerDashboardGroupClasses => 'Twoje zajęcia grupowe';

  @override
  String get trainerDashboardAdd => 'DODAJ';

  @override
  String get trainerSummaryToday => 'DZISIAJ';

  @override
  String get trainerSummaryReadyTitle => 'Harmonogram gotowy';

  @override
  String get trainerSummaryReadySubtitle => 'Wszystkie zajęcia są zaplanowane.';

  @override
  String get trainerSummaryEmptyTitle => 'Brak zaplanowanych zajęć';

  @override
  String get trainerSummaryLoadErrorSubtitle => 'Nie udało się pobrać grafiku.';

  @override
  String get trainerDashboardAllReadyTitle => 'Wszystko gotowe';

  @override
  String get trainerDashboardAllReadySubtitle =>
      'Nie masz już dziś zaplanowanych zajęć grupowych.';

  @override
  String get trainerDashboardPersonalTrainings => 'Treningi personalne';

  @override
  String get trainerDashboardNoClientsTitle => 'Brak podopiecznych';

  @override
  String get trainerDashboardNoClientsSubtitle =>
      'Nie masz zaplanowanych treningów personalnych na dziś.';

  @override
  String get trainerClassFetchError => 'Błąd pobierania zajęć';

  @override
  String get trainerDataError => 'Błąd danych';

  @override
  String get trainerFreeSlot => 'Wolny termin';

  @override
  String get trainerPersonalTraining => 'Trening personalny';

  @override
  String get trainerClientsTitle => 'Podopieczni';

  @override
  String get trainerClientsSubtitle => 'Zarządzaj swoimi treningami 1 na 1.';

  @override
  String get trainerManageSoon => 'Zarządzanie treningiem wkrótce!';

  @override
  String get trainerFetchErrorShort => 'Błąd pobierania';

  @override
  String get trainerAddClassTitle => 'Nowe zajęcia';

  @override
  String get trainerAddPersonalTrainingTitle => 'Trening personalny';

  @override
  String get trainerAddPersonalTrainingSubtitle => 'Zajęcia z jednym klientem';

  @override
  String get trainerCreateClassButton => 'UTWÓRZ ZAJĘCIA';

  @override
  String get trainerClassCreatedSuccess => 'Zajęcia zostały dodane!';

  @override
  String get trainerNoLocations => 'Brak dostępnych lokalizacji.';

  @override
  String get trainerPastClassError =>
      'Zajęcia nie mogą odbywać się w przeszłości.';

  @override
  String get trainerClassEndBeforeStartError =>
      'Zajęcia muszą kończyć się po ich rozpoczęciu.';

  @override
  String get trainerLocationsLoadError => 'Nie udało się załadować lokalizacji';

  @override
  String get profileNoData => 'Brak danych';

  @override
  String get profileInfoSection => 'Informacje';

  @override
  String get profileSettingsSection => 'Ustawienia';

  @override
  String get profileAboutSection => 'O aplikacji';

  @override
  String get profileTrainerAccount => 'Konto Trenera';

  @override
  String get profileUserAccount => 'Konto Użytkownika';

  @override
  String get profileLanguage => 'Język aplikacji';

  @override
  String get profileSelectLanguage => 'Wybierz język';

  @override
  String get profileLanguagePolish => 'Polski';

  @override
  String get profileLanguageEnglish => 'Angielski';

  @override
  String get profilePushNotifications => 'Powiadomienia Push';

  @override
  String get profileHelpContact => 'Pomoc i kontakt';

  @override
  String get profileClubRules => 'Regulamin klubu';

  @override
  String get profileLogout => 'Wyloguj się';

  @override
  String get profileAppVersion => 'Wersja aplikacji';

  @override
  String profileVersion(String version) {
    return 'Wersja $version';
  }

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsEmptyTitle => 'Brak powiadomień';

  @override
  String get notificationsEmptySubtitle => 'Gdy coś się wydarzy, damy Ci znać.';

  @override
  String get notificationsToday => 'Dzisiaj';

  @override
  String get notificationsEarlier => 'Wcześniejsze';

  @override
  String get notificationsNewUppercase => 'NOWE POWIADOMIENIE';

  @override
  String notificationsDateToday(String time) {
    return 'Dzisiaj, $time';
  }

  @override
  String notificationsDateYesterday(String time) {
    return 'Wczoraj, $time';
  }

  @override
  String notificationsError(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get qrEntryTitle => 'Kod wejścia';

  @override
  String get qrEntrySubtitle => 'Pokaż kod przy wejściu do klubu.';

  @override
  String get offlineModalTitle => 'Brak połączenia';

  @override
  String get offlineModalSubtitle =>
      'Nie udało się pobrać danych. Sprawdź połączenie internetowe i spróbuj ponownie.';

  @override
  String get offlineActionUnavailable =>
      'Ta akcja wymaga połączenia z internetem.';

  @override
  String get offlineBookingUnavailable =>
      'Połącz się z internetem, aby zapisać się na zajęcia.';

  @override
  String get offlineCancelBookingUnavailable =>
      'Połącz się z internetem, aby anulować zapis.';

  @override
  String get syncOfflineBadge => 'Tryb offline';

  @override
  String get syncCachedDataNotice => 'Pokazujemy ostatnio zapisane dane.';

  @override
  String syncLastUpdated(String date) {
    return 'Ostatnia aktualizacja: $date';
  }

  @override
  String get syncRefreshing => 'Aktualizowanie danych...';

  @override
  String get syncRefreshSuccess => 'Dane zostały zaktualizowane.';

  @override
  String get syncRefreshFailed => 'Nie udało się odświeżyć danych.';

  @override
  String get gpsPermissionTitle => 'Dostęp do lokalizacji';

  @override
  String get gpsPermissionRationale =>
      'Pozwól aplikacji używać lokalizacji, aby pokazać najbliższą siłownię.';

  @override
  String get gpsPermissionDenied => 'Nie przyznano dostępu do lokalizacji.';

  @override
  String get gpsPermissionDeniedForever =>
      'Dostęp do lokalizacji jest zablokowany. Zmień ustawienia systemowe, aby go włączyć.';

  @override
  String get gpsServiceDisabled => 'Usługi lokalizacji są wyłączone.';

  @override
  String get gpsOpenSettings => 'Otwórz ustawienia';

  @override
  String get gpsDistanceUnavailable => 'Odległość niedostępna';

  @override
  String get validationRequired => 'To pole jest wymagane.';

  @override
  String validationRequiredField(String fieldName) {
    return 'Pole $fieldName jest wymagane.';
  }

  @override
  String get validationEmailRequired => 'Podaj adres email.';

  @override
  String get validationEmailInvalid => 'Podaj poprawny adres email.';

  @override
  String get validationPasswordRequired => 'Podaj hasło.';

  @override
  String get validationPasswordConfirmationRequired => 'Potwierdź hasło.';

  @override
  String validationPasswordMinLength(int length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Hasło musi mieć co najmniej $length znaku.',
      many: 'Hasło musi mieć co najmniej $length znaków.',
      few: 'Hasło musi mieć co najmniej $length znaki.',
      one: 'Hasło musi mieć co najmniej 1 znak.',
    );
    return '$_temp0';
  }

  @override
  String get validationPasswordsDoNotMatch => 'Hasła nie są takie same.';

  @override
  String get validationSeatsMin => 'Liczba miejsc musi być większa od zera.';

  @override
  String classSeatsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wolnego miejsca',
      many: '$count wolnych miejsc',
      few: '$count wolne miejsca',
      one: '1 wolne miejsce',
      zero: 'Brak wolnych miejsc',
    );
    return '$_temp0';
  }

  @override
  String get errorServer => 'Błąd serwera. Spróbuj ponownie później.';

  @override
  String get errorServerWaking => 'Serwer się wybudza, spróbuj za chwilę.';

  @override
  String get errorConnectionTimeout =>
      'Przekroczono czas połączenia. Sprawdź połączenie z internetem.';

  @override
  String get errorRequestCanceled => 'Żądanie zostało anulowane.';

  @override
  String get errorNoInternet => 'Brak połączenia z internetem.';

  @override
  String get errorDataLoad => 'Błąd ładowania danych.';

  @override
  String get errorVerifyAccountAccess =>
      'Nie udało się zweryfikować uprawnień konta. Sprawdź sieć.';

  @override
  String get errorUserProfileFetch =>
      'Nie udało się pobrać profilu użytkownika.';

  @override
  String get errorUserProfileUnexpected =>
      'Wystąpił nieoczekiwany błąd podczas pobierania profilu.';

  @override
  String get errorTrainersFetch => 'Nie udało się pobrać listy trenerów.';

  @override
  String get errorTrainersUnexpected =>
      'Wystąpił nieoczekiwany błąd podczas pobierania trenerów.';

  @override
  String get errorMembershipFetch => 'Nie udało się pobrać karnetu.';

  @override
  String get errorMembershipUnexpected =>
      'Wystąpił nieoczekiwany błąd podczas pobierania karnetu.';

  @override
  String get errorMembershipPurchase => 'Nie udało się zakupić karnetu.';

  @override
  String get errorClassesFetch => 'Nie udało się pobrać grafiku zajęć.';

  @override
  String get errorTrainerScheduleFetch =>
      'Nie udało się pobrać Twojego grafiku.';

  @override
  String get errorClassParticipantsFetch =>
      'Nie udało się pobrać listy uczestników.';

  @override
  String get errorBookClass => 'Nie udało się zarezerwować zajęć.';

  @override
  String get errorCancelBooking => 'Nie udało się anulować rezerwacji.';

  @override
  String get errorCreateClass => 'Błąd tworzenia zajęć.';

  @override
  String get errorRescheduleClass => 'Błąd przekładania zajęć.';

  @override
  String get errorDeleteClass => 'Błąd usuwania zajęć.';
}
