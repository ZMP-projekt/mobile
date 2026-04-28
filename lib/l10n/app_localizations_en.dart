// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gym App';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonError => 'Error';

  @override
  String get commonLoadError => 'Loading error';

  @override
  String get commonNoData => 'No data';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonRetryUppercase => 'TRY AGAIN';

  @override
  String get commonSave => 'Save';

  @override
  String get commonUnknownError => 'An unexpected error occurred.';

  @override
  String criticalError(Object error) {
    return 'Critical error: $error';
  }

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldFirstName => 'First name';

  @override
  String get fieldLastName => 'Last name';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldRepeatPassword => 'Repeat password';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDescriptionOptional => 'Description (optional)';

  @override
  String get fieldSeatsLabel => 'Seats';

  @override
  String fieldSeats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats',
      one: '1 seat',
      zero: 'No seats',
    );
    return '$_temp0';
  }

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldStart => 'Start';

  @override
  String get fieldEnd => 'End';

  @override
  String get authLoginTitle => 'Log in';

  @override
  String get authLoginSubtitle => 'Welcome back';

  @override
  String get authLoginContinue => 'Log in to continue';

  @override
  String get authLoginAction => 'Log in';

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authRegisterSubtitle =>
      'Create an account and train more comfortably';

  @override
  String get authRegisterAction => 'Create account';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get dashboardNoConnection => 'No connection';

  @override
  String dashboardGreeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get dashboardReadyQuestion => 'Ready to train?';

  @override
  String get dashboardSectionGym => 'Your Gym';

  @override
  String get dashboardSectionTodayClasses => 'Today\'s classes';

  @override
  String get dashboardMapAction => 'MAP';

  @override
  String get dashboardSeeAll => 'SEE ALL';

  @override
  String get dashboardTodayClassesError => 'Could not load today\'s classes.';

  @override
  String get dashboardMembershipRequiredForToday =>
      'Buy a membership to see today\'s schedule and book a workout!';

  @override
  String get dashboardRestTitle => 'Time to rest';

  @override
  String get dashboardRestSubtitle =>
      'No upcoming classes today. Recharge and recover!';

  @override
  String get dashboardNoGroupClassesTitle => 'No group classes';

  @override
  String get dashboardNoGroupClassesSubtitle =>
      'There are no more group classes scheduled for today.';

  @override
  String get dashboardAvailablePersonalTrainings =>
      'Available 1-on-1 trainings';

  @override
  String get locationChooseGym => 'Choose gym';

  @override
  String get locationUnknown => 'Unknown location';

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
    return '$type membership';
  }

  @override
  String membershipActiveDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Active: $days days left',
      one: 'Active: 1 day left',
      zero: 'Membership expired',
    );
    return '$_temp0';
  }

  @override
  String get membershipNoActive => 'No active membership';

  @override
  String get membershipBuyAccessToday => 'Buy access today!';

  @override
  String get membershipGuardTitle => 'Active membership required';

  @override
  String get membershipGuardSubtitle =>
      'Buy a membership to view the schedule and book a workout.';

  @override
  String get membershipBuyNow => 'Buy membership now';

  @override
  String get membershipPurchaseTitle => 'Choose Membership';

  @override
  String get membershipPurchaseSubtitle =>
      'Choose the plan that best fits your training rhythm.';

  @override
  String get membershipPurchasePopular => 'HOT';

  @override
  String get membershipPurchaseButton => 'Buy and pay';

  @override
  String get membershipPurchaseSuccess => 'Membership purchased successfully!';

  @override
  String get membershipPlanOpenTitle => 'OPEN membership';

  @override
  String get membershipPlanOpenDescription => '24/7 club access';

  @override
  String get membershipPlanNightTitle => 'NIGHT membership';

  @override
  String get membershipPlanNightDescription =>
      'Access between 10:00 PM and 6:00 AM';

  @override
  String get membershipPlanStudentTitle => 'STUDENT membership';

  @override
  String get membershipPlanStudentDescription =>
      'For people with a valid student ID';

  @override
  String get membershipLockedTitle => 'Access blocked';

  @override
  String get membershipLockedSubtitle =>
      'To browse the class schedule and book workouts, you need an active club membership.';

  @override
  String get classesSchedule => 'Schedule';

  @override
  String get classesAll => 'All classes';

  @override
  String get classesMyBookings => 'My bookings';

  @override
  String get classesToday => 'Today\'s classes';

  @override
  String get classesNoClassesDateTitle => 'No classes on this day';

  @override
  String get classesNoTrainingsDateTitle =>
      'No available\ntrainings on this day';

  @override
  String get classesChooseAnotherDate =>
      'Choose another date from the calendar above';

  @override
  String classesTrainer(String name) {
    return 'Trainer: $name';
  }

  @override
  String get classesInstructor => 'Instructor';

  @override
  String get classesAboutTraining => 'About training';

  @override
  String get classesBooked => 'BOOKED';

  @override
  String get classesFull => 'FULL';

  @override
  String get classesBook => 'Book';

  @override
  String get classesBookLong => 'Book class';

  @override
  String get classesCancelBooking => 'Cancel booking';

  @override
  String get classesCancelBookingShort => 'Cancel';

  @override
  String get classesFinished => 'Finished';

  @override
  String get classesParticipantsRegistered => 'Registered participants';

  @override
  String get classesParticipantsEmpty => 'No participants yet';

  @override
  String classesParticipantsCount(int current, int max) {
    return 'Participants: $current/$max';
  }

  @override
  String get classesParticipantsLoadError => 'Could not load the list';

  @override
  String classesBookingError(Object error) {
    return 'Booking error: $error';
  }

  @override
  String get classesBookingSuccess => 'Booked for\ntraining!';

  @override
  String classesGenericError(Object error) {
    return 'Error: $error';
  }

  @override
  String get classesCancelDialogTitle => 'Cancel booking?';

  @override
  String classesCancelDialogBody(String name) {
    return 'Are you sure you want to cancel:\n$name?';
  }

  @override
  String get classesDeleteDialogTitle => 'Cancel class?';

  @override
  String get classesDeleteAction => 'Cancel class';

  @override
  String get classesDeleteDialogBody =>
      'Registered participants will be notified. This action cannot be undone.';

  @override
  String get classesDeleteConfirm => 'Yes, cancel';

  @override
  String get classesRescheduleTitle => 'Reschedule';

  @override
  String get classesRescheduleConfirm => 'Confirm change';

  @override
  String get classesReschedulePastError =>
      'The new time cannot be in the past!';

  @override
  String get classesNewDate => 'New date';

  @override
  String get classesNewTime => 'New time';

  @override
  String classesDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get classesUnknownTrainer => 'Unknown Trainer';

  @override
  String get classesUnknownTrainerFirstName => 'Unknown';

  @override
  String get classesOngoing => 'Class in progress';

  @override
  String get classesRescheduledSuccess => 'Class\nrescheduled!';

  @override
  String get classesDefaultDescription =>
      'Join us and feel the energy of group training. Perfect for every fitness level.';

  @override
  String get trainerDashboardGroupClasses => 'Your group classes';

  @override
  String get trainerDashboardAdd => 'ADD';

  @override
  String get trainerSummaryToday => 'TODAY';

  @override
  String get trainerSummaryReadyTitle => 'Schedule ready';

  @override
  String get trainerSummaryReadySubtitle => 'All classes are scheduled.';

  @override
  String get trainerSummaryEmptyTitle => 'No scheduled classes';

  @override
  String get trainerSummaryLoadErrorSubtitle => 'Could not load the schedule.';

  @override
  String get trainerDashboardAllReadyTitle => 'All set';

  @override
  String get trainerDashboardAllReadySubtitle =>
      'You have no more group classes scheduled for today.';

  @override
  String get trainerDashboardPersonalTrainings => 'Personal trainings';

  @override
  String get trainerDashboardNoClientsTitle => 'No clients';

  @override
  String get trainerDashboardNoClientsSubtitle =>
      'You have no personal trainings scheduled for today.';

  @override
  String get trainerClassFetchError => 'Could not load classes';

  @override
  String get trainerDataError => 'Data error';

  @override
  String get trainerFreeSlot => 'Free slot';

  @override
  String get trainerPersonalTraining => 'Personal training';

  @override
  String get trainerClientsTitle => 'Clients';

  @override
  String get trainerClientsSubtitle => 'Manage your one-on-one trainings.';

  @override
  String get trainerManageSoon => 'Training management coming soon!';

  @override
  String get trainerFetchErrorShort => 'Fetch error';

  @override
  String get trainerAddClassTitle => 'New class';

  @override
  String get trainerAddPersonalTrainingTitle => 'Personal training';

  @override
  String get trainerAddPersonalTrainingSubtitle => 'One-client training';

  @override
  String get trainerCreateClassButton => 'CREATE CLASS';

  @override
  String get trainerClassCreatedSuccess => 'Class has been added!';

  @override
  String get trainerNoLocations => 'No locations available.';

  @override
  String get trainerPastClassError =>
      'Classes cannot be scheduled in the past.';

  @override
  String get trainerClassEndBeforeStartError =>
      'Classes must end after they start.';

  @override
  String get trainerLocationsLoadError => 'Could not load locations';

  @override
  String get profileNoData => 'No data';

  @override
  String get profileInfoSection => 'Info';

  @override
  String get profileSettingsSection => 'Settings';

  @override
  String get profileAboutSection => 'About';

  @override
  String get profileTrainerAccount => 'Trainer Account';

  @override
  String get profileUserAccount => 'User Account';

  @override
  String get profileLanguage => 'App language';

  @override
  String get profileSelectLanguage => 'Choose language';

  @override
  String get profileLanguagePolish => 'Polish';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profilePushNotifications => 'Push Notifications';

  @override
  String get profileHelpContact => 'Help and contact';

  @override
  String get profileClubRules => 'Club rules';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileAppVersion => 'App version';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptySubtitle =>
      'When something happens, we\'ll let you know.';

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String get notificationsNewUppercase => 'NEW NOTIFICATION';

  @override
  String notificationsDateToday(String time) {
    return 'Today, $time';
  }

  @override
  String notificationsDateYesterday(String time) {
    return 'Yesterday, $time';
  }

  @override
  String notificationsError(Object error) {
    return 'Error: $error';
  }

  @override
  String get qrEntryTitle => 'Entry code';

  @override
  String get qrEntrySubtitle => 'Show the code at the club entrance.';

  @override
  String get offlineModalTitle => 'No connection';

  @override
  String get offlineModalSubtitle =>
      'Could not load data. Check your internet connection and try again.';

  @override
  String get offlineActionUnavailable =>
      'This action requires an internet connection.';

  @override
  String get offlineBookingUnavailable =>
      'Connect to the internet to book a class.';

  @override
  String get offlineCancelBookingUnavailable =>
      'Connect to the internet to cancel your booking.';

  @override
  String get syncOfflineBadge => 'Offline mode';

  @override
  String get syncCachedDataNotice => 'Showing the last saved data.';

  @override
  String syncLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get syncRefreshing => 'Refreshing data...';

  @override
  String get syncRefreshSuccess => 'Data has been updated.';

  @override
  String get syncRefreshFailed => 'Could not refresh data.';

  @override
  String get gpsPermissionTitle => 'Location access';

  @override
  String get gpsPermissionRationale =>
      'Allow the app to use your location to show the nearest gym.';

  @override
  String get gpsPermissionDenied => 'Location access was not granted.';

  @override
  String get gpsPermissionDeniedForever =>
      'Location access is blocked. Change system settings to enable it.';

  @override
  String get gpsServiceDisabled => 'Location services are disabled.';

  @override
  String get gpsOpenSettings => 'Open settings';

  @override
  String get gpsDistanceUnavailable => 'Distance unavailable';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String validationRequiredField(String fieldName) {
    return '$fieldName is required.';
  }

  @override
  String get validationEmailRequired => 'Enter your email address.';

  @override
  String get validationEmailInvalid => 'Enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Enter your password.';

  @override
  String get validationPasswordConfirmationRequired => 'Confirm your password.';

  @override
  String validationPasswordMinLength(int length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Password must be at least $length characters.',
      one: 'Password must be at least 1 character.',
    );
    return '$_temp0';
  }

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get validationSeatsMin => 'Number of seats must be greater than zero.';

  @override
  String classSeatsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats left',
      one: '1 seat left',
      zero: 'No seats left',
    );
    return '$_temp0';
  }

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorServerWaking =>
      'The server is waking up. Please try again in a moment.';

  @override
  String get errorConnectionTimeout =>
      'Connection timed out. Check your internet connection.';

  @override
  String get errorRequestCanceled => 'The request was canceled.';

  @override
  String get errorNoInternet => 'No internet connection.';

  @override
  String get errorDataLoad => 'Could not load data.';

  @override
  String get errorVerifyAccountAccess =>
      'Could not verify account permissions. Check your network.';

  @override
  String get errorUserProfileFetch => 'Could not load the user profile.';

  @override
  String get errorUserProfileUnexpected =>
      'An unexpected error occurred while loading the profile.';

  @override
  String get errorTrainersFetch => 'Could not load the trainer list.';

  @override
  String get errorTrainersUnexpected =>
      'An unexpected error occurred while loading trainers.';

  @override
  String get errorMembershipFetch => 'Could not load the membership.';

  @override
  String get errorMembershipUnexpected =>
      'An unexpected error occurred while loading the membership.';

  @override
  String get errorMembershipPurchase => 'Could not purchase the membership.';

  @override
  String get errorClassesFetch => 'Could not load the class schedule.';

  @override
  String get errorTrainerScheduleFetch => 'Could not load your schedule.';

  @override
  String get errorClassParticipantsFetch =>
      'Could not load the participant list.';

  @override
  String get errorBookClass => 'Could not book the class.';

  @override
  String get errorCancelBooking => 'Could not cancel the booking.';

  @override
  String get errorCreateClass => 'Could not create the class.';

  @override
  String get errorRescheduleClass => 'Could not reschedule the class.';

  @override
  String get errorDeleteClass => 'Could not delete the class.';
}
