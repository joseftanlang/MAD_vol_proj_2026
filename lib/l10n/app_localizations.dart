import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('zh'),
  ];

  /// No description provided for @accessibilityEditPreference.
  ///
  /// In en, this message translates to:
  /// **'Edit user preference'**
  String get accessibilityEditPreference;

  /// No description provided for @fontSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Size (Default: 1)'**
  String get fontSizeTitle;

  /// No description provided for @currentSettings.
  ///
  /// In en, this message translates to:
  /// **'Current settings:'**
  String get currentSettings;

  /// No description provided for @editFontSize.
  ///
  /// In en, this message translates to:
  /// **'Edit your font size:'**
  String get editFontSize;

  /// No description provided for @exampleBody.
  ///
  /// In en, this message translates to:
  /// **'Example of body'**
  String get exampleBody;

  /// No description provided for @noUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'No unsaved changes'**
  String get noUnsavedChanges;

  /// No description provided for @pressSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Press save to save changes!'**
  String get pressSaveChanges;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get previewTitle;

  /// No description provided for @previewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get previewSubtitle;

  /// No description provided for @previewBodyText.
  ///
  /// In en, this message translates to:
  /// **'Body text'**
  String get previewBodyText;

  /// No description provided for @tapBoxToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap this box to change'**
  String get tapBoxToChange;

  /// No description provided for @appContrast.
  ///
  /// In en, this message translates to:
  /// **'App contrast'**
  String get appContrast;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred language:'**
  String get preferredLanguage;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current: {language}'**
  String currentLanguage(Object language);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get selectLanguage;

  /// No description provided for @searchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Search a language...'**
  String get searchLanguage;

  /// No description provided for @changeLanguageButton.
  ///
  /// In en, this message translates to:
  /// **'Click to change!'**
  String get changeLanguageButton;

  /// No description provided for @saveChangesDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your changes?'**
  String get saveChangesDialogTitle;

  /// No description provided for @saveChangesDialogContent.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes, return to home without saving?'**
  String get saveChangesDialogContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @dontSave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Save'**
  String get dontSave;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item saved successfully'**
  String get savedSuccessfully;

  /// No description provided for @nothingToSave.
  ///
  /// In en, this message translates to:
  /// **'Nothing to save!!'**
  String get nothingToSave;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @welcomeDefault.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SP!'**
  String get welcomeDefault;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}!'**
  String welcomeBack(Object username);

  /// No description provided for @welcomeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading welcome message'**
  String get welcomeLoadError;

  /// No description provided for @searchOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Search for opportunities'**
  String get searchOpportunities;

  /// No description provided for @noMatchingPage.
  ///
  /// In en, this message translates to:
  /// **'No matching page for: \"{spokenText}\"'**
  String noMatchingPage(Object spokenText);

  /// No description provided for @categoryVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get categoryVolunteer;

  /// No description provided for @categoryTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get categoryTraining;

  /// No description provided for @categoryDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get categoryDonation;

  /// No description provided for @categoryAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get categoryAboutUs;

  /// No description provided for @categoryAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get categoryAccessibility;

  /// No description provided for @categoryLegalService.
  ///
  /// In en, this message translates to:
  /// **'Legal Service'**
  String get categoryLegalService;

  /// No description provided for @categoryQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get categoryQrCode;

  /// No description provided for @categoryLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get categoryLogout;

  /// No description provided for @categorySettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get categorySettings;

  /// No description provided for @categoryChatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get categoryChatbot;

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get bottomNavVolunteer;

  /// No description provided for @bottomNavQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get bottomNavQrCode;

  /// No description provided for @bottomNavEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get bottomNavEducation;

  /// No description provided for @bottomNavDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get bottomNavDonation;

  /// No description provided for @drawerHeader.
  ///
  /// In en, this message translates to:
  /// **'Navigation Menu'**
  String get drawerHeader;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @drawerAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get drawerAboutUs;

  /// No description provided for @drawerVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get drawerVolunteer;

  /// No description provided for @drawerTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get drawerTraining;

  /// No description provided for @drawerLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get drawerLegal;

  /// No description provided for @drawerDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get drawerDonation;

  /// No description provided for @drawerQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get drawerQrCode;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get drawerAccessibility;

  /// No description provided for @drawerChatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get drawerChatbot;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get drawerLogout;

  /// No description provided for @drawerLocationTracker.
  ///
  /// In en, this message translates to:
  /// **'Location Tracker'**
  String get drawerLocationTracker;

  /// No description provided for @aboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsTitle;

  /// No description provided for @aboutUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Train App! We are dedicated to providing you with the best experience for all your train travel needs. Our app offers a range of features including ticket booking, real-time train schedules, and travel updates to ensure a smooth journey.'**
  String get aboutUsDescription;

  /// No description provided for @contactUsButton.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsButton;

  /// No description provided for @feedbackButton.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackButton;

  /// No description provided for @callLabel.
  ///
  /// In en, this message translates to:
  /// **'Call: +65 88454281'**
  String get callLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email: tanjosef03@gmail.com'**
  String get emailLabel;

  /// No description provided for @sendFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedbackTitle;

  /// No description provided for @sendFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Type your feedback here...'**
  String get sendFeedbackHint;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// No description provided for @donationTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to support today?'**
  String get donationTitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get categoryChildren;

  /// No description provided for @categoryElderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly'**
  String get categoryElderly;

  /// No description provided for @categoryEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get categoryEnvironment;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryMigrants.
  ///
  /// In en, this message translates to:
  /// **'Migrants'**
  String get categoryMigrants;

  /// No description provided for @donationListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No donations found'**
  String get donationListEmpty;

  /// No description provided for @donationListError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get donationListError;

  /// No description provided for @donationSelectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select Amount'**
  String get donationSelectAmount;

  /// No description provided for @donationButtonSelectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select an amount to continue'**
  String get donationButtonSelectAmount;

  /// No description provided for @donationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Donation successful ❤️'**
  String get donationSuccessMessage;

  /// No description provided for @settingsUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get settingsUploadPhoto;

  /// No description provided for @settingsUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsUsername;

  /// No description provided for @settingsFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get settingsFullName;

  /// No description provided for @settingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmail;

  /// No description provided for @settingsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get settingsPhone;

  /// No description provided for @settingsAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get settingsAddress;

  /// No description provided for @settingsBloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get settingsBloodType;

  /// No description provided for @settingsDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get settingsDateOfBirth;

  /// No description provided for @settingsCitizenship.
  ///
  /// In en, this message translates to:
  /// **'Citizenship'**
  String get settingsCitizenship;

  /// No description provided for @settingsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSavedSuccess;

  /// No description provided for @settingsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSaveButton;

  /// No description provided for @settingsLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogoutButton;

  /// No description provided for @volunteerImpactToday.
  ///
  /// In en, this message translates to:
  /// **'How would you make an impact today?'**
  String get volunteerImpactToday;

  /// No description provided for @volunteerFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get volunteerFeatured;

  /// No description provided for @volunteerCategoryHeader.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get volunteerCategoryHeader;

  /// No description provided for @volunteerThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for volunteering!'**
  String get volunteerThankYou;

  /// No description provided for @urlErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get urlErrorTitle;

  /// No description provided for @urlErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error redirecting. Please try again.'**
  String get urlErrorMessage;

  /// No description provided for @trainingWhatLearnToday.
  ///
  /// In en, this message translates to:
  /// **'What would you like to learn today?'**
  String get trainingWhatLearnToday;

  /// No description provided for @qrUniqueMessage.
  ///
  /// In en, this message translates to:
  /// **'This QR code is unique to you'**
  String get qrUniqueMessage;

  /// No description provided for @qrCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCodeLabel;

  /// No description provided for @qrScannerLabel.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get qrScannerLabel;

  /// No description provided for @scanQrButton.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrButton;

  /// No description provided for @qrImageButton.
  ///
  /// In en, this message translates to:
  /// **'QR Code Image'**
  String get qrImageButton;

  /// No description provided for @scannedResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {result}'**
  String scannedResultLabel(Object result);
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
