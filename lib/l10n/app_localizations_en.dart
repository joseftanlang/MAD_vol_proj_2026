// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accessibilityEditPreference => 'Edit user preference';

  @override
  String get fontSizeTitle => 'Font Size (Default: 1)';

  @override
  String get currentSettings => 'Current settings:';

  @override
  String get editFontSize => 'Edit your font size:';

  @override
  String get exampleBody => 'Example of body';

  @override
  String get noUnsavedChanges => 'No unsaved changes';

  @override
  String get pressSaveChanges => 'Press save to save changes!';

  @override
  String get previewTitle => 'Title';

  @override
  String get previewSubtitle => 'Subtitle';

  @override
  String get previewBodyText => 'Body text';

  @override
  String get tapBoxToChange => 'Tap this box to change';

  @override
  String get appContrast => 'App contrast';

  @override
  String get preferredLanguage => 'Preferred language:';

  @override
  String currentLanguage(Object language) {
    return 'Current: $language';
  }

  @override
  String get selectLanguage => 'Select a language';

  @override
  String get searchLanguage => 'Search a language...';

  @override
  String get changeLanguageButton => 'Click to change!';

  @override
  String get saveChangesDialogTitle => 'Save your changes?';

  @override
  String get saveChangesDialogContent =>
      'You have unsaved changes, return to home without saving?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get dontSave => 'Don\'t Save';

  @override
  String get savedSuccessfully => 'Item saved successfully';

  @override
  String get nothingToSave => 'Nothing to save!!';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get welcomeDefault => 'Welcome to SP!';

  @override
  String welcomeBack(Object username) {
    return 'Welcome back, $username!';
  }

  @override
  String get welcomeLoadError => 'Error loading welcome message';

  @override
  String get searchOpportunities => 'Search for opportunities';

  @override
  String noMatchingPage(Object spokenText) {
    return 'No matching page for: \"$spokenText\"';
  }

  @override
  String get categoryVolunteer => 'Volunteer';

  @override
  String get categoryTraining => 'Training';

  @override
  String get categoryDonation => 'Donation';

  @override
  String get categoryAboutUs => 'About Us';

  @override
  String get categoryAccessibility => 'Accessibility';

  @override
  String get categoryLegalService => 'Legal Service';

  @override
  String get categoryQrCode => 'QR Code';

  @override
  String get categoryLogout => 'Log Out';

  @override
  String get categorySettings => 'Settings';

  @override
  String get categoryChatbot => 'Chatbot';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavVolunteer => 'Volunteer';

  @override
  String get bottomNavQrCode => 'QR Code';

  @override
  String get bottomNavEducation => 'Education';

  @override
  String get bottomNavDonation => 'Donation';

  @override
  String get drawerHeader => 'Navigation Menu';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerAboutUs => 'About Us';

  @override
  String get drawerVolunteer => 'Volunteer';

  @override
  String get drawerTraining => 'Training';

  @override
  String get drawerLegal => 'Legal';

  @override
  String get drawerDonation => 'Donation';

  @override
  String get drawerQrCode => 'QR Code';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerAccessibility => 'Accessibility';

  @override
  String get drawerChatbot => 'Chatbot';

  @override
  String get drawerLogout => 'Log Out';

  @override
  String get drawerLocationTracker => 'Location Tracker';

  @override
  String get aboutUsTitle => 'About Us';

  @override
  String get aboutUsDescription =>
      'Welcome to the Train App! We are dedicated to providing you with the best experience for all your train travel needs. Our app offers a range of features including ticket booking, real-time train schedules, and travel updates to ensure a smooth journey.';

  @override
  String get contactUsButton => 'Contact Us';

  @override
  String get feedbackButton => 'Feedback';

  @override
  String get callLabel => 'Call: +65 88454281';

  @override
  String get emailLabel => 'Email: tanjosef03@gmail.com';

  @override
  String get sendFeedbackTitle => 'Send Feedback';

  @override
  String get sendFeedbackHint => 'Type your feedback here...';

  @override
  String get sendButton => 'Send';

  @override
  String get donationTitle => 'What would you like to support today?';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryChildren => 'Children';

  @override
  String get categoryElderly => 'Elderly';

  @override
  String get categoryEnvironment => 'Environment';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryMigrants => 'Migrants';

  @override
  String get donationListEmpty => 'No donations found';

  @override
  String get donationListError => 'Something went wrong';

  @override
  String get donationSelectAmount => 'Select Amount';

  @override
  String get donationButtonSelectAmount => 'Select an amount to continue';

  @override
  String get donationSuccessMessage => 'Donation successful ❤️';

  @override
  String get settingsUploadPhoto => 'Upload Photo';

  @override
  String get settingsUsername => 'Username';

  @override
  String get settingsFullName => 'Full Name';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsPhone => 'Phone';

  @override
  String get settingsAddress => 'Address';

  @override
  String get settingsBloodType => 'Blood Type';

  @override
  String get settingsDateOfBirth => 'Date of Birth';

  @override
  String get settingsCitizenship => 'Citizenship';

  @override
  String get settingsSavedSuccess => 'Settings saved successfully';

  @override
  String get settingsSaveButton => 'Save';

  @override
  String get settingsLogoutButton => 'Logout';

  @override
  String get volunteerImpactToday => 'How would you make an impact today?';

  @override
  String get volunteerFeatured => 'Featured';

  @override
  String get volunteerCategoryHeader => 'Category';

  @override
  String get volunteerThankYou => 'Thank you for volunteering!';

  @override
  String get urlErrorTitle => 'Error';

  @override
  String get urlErrorMessage => 'Error redirecting. Please try again.';

  @override
  String get trainingWhatLearnToday => 'What would you like to learn today?';

  @override
  String get qrUniqueMessage => 'This QR code is unique to you';

  @override
  String get qrCodeLabel => 'QR Code';

  @override
  String get qrScannerLabel => 'QR Scanner';

  @override
  String get scanQrButton => 'Scan QR Code';

  @override
  String get qrImageButton => 'QR Code Image';

  @override
  String scannedResultLabel(Object result) {
    return 'Scanned: $result';
  }
}
