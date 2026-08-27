import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KalaSetu'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Empowering Artisans Through AI & Direct Market Access'**
  String get appTagline;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you are most comfortable with'**
  String get selectLanguageSub;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to KalaSetu'**
  String get welcomeTitle;

  /// No description provided for @welcomeSub.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Social Justice & Empowerment initiative for master artisans & weavers'**
  String get welcomeSub;

  /// No description provided for @iAmNewHere.
  ///
  /// In en, this message translates to:
  /// **'I am new here (Register)'**
  String get iAmNewHere;

  /// No description provided for @iHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account (Login)'**
  String get iHaveAccount;

  /// No description provided for @whoAreYou.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYou;

  /// No description provided for @selectRoleSub.
  ///
  /// In en, this message translates to:
  /// **'Select your primary role to proceed'**
  String get selectRoleSub;

  /// No description provided for @roleArtisan.
  ///
  /// In en, this message translates to:
  /// **'Artisan / Karigar'**
  String get roleArtisan;

  /// No description provided for @roleArtisanDesc.
  ///
  /// In en, this message translates to:
  /// **'I craft handmade products and want to sell directly to buyers'**
  String get roleArtisanDesc;

  /// No description provided for @roleAggregator.
  ///
  /// In en, this message translates to:
  /// **'Cluster Aggregator'**
  String get roleAggregator;

  /// No description provided for @roleAggregatorDesc.
  ///
  /// In en, this message translates to:
  /// **'I manage a cohort of artisans and facilitate digital cataloging'**
  String get roleAggregatorDesc;

  /// No description provided for @roleBuyer.
  ///
  /// In en, this message translates to:
  /// **'B2B Buyer'**
  String get roleBuyer;

  /// No description provided for @roleBuyerDesc.
  ///
  /// In en, this message translates to:
  /// **'I procure bulk handicraft & handloom orders for enterprise'**
  String get roleBuyerDesc;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobile;

  /// No description provided for @enterMobileSub.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit OTP code to verify your phone number'**
  String get enterMobileSub;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to +91 {phone}'**
  String otpSentTo(Object phone);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(Object seconds);

  /// No description provided for @verifyAndProceed.
  ///
  /// In en, this message translates to:
  /// **'Verify & Proceed'**
  String get verifyAndProceed;

  /// No description provided for @artisanRegistration.
  ///
  /// In en, this message translates to:
  /// **'Artisan Registration'**
  String get artisanRegistration;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String step(Object current, Object total);

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block / Tehsil'**
  String get block;

  /// No description provided for @craftType.
  ///
  /// In en, this message translates to:
  /// **'Craft Type'**
  String get craftType;

  /// No description provided for @selectCraftType.
  ///
  /// In en, this message translates to:
  /// **'Select your craft specialization'**
  String get selectCraftType;

  /// No description provided for @clusterName.
  ///
  /// In en, this message translates to:
  /// **'Cluster Name'**
  String get clusterName;

  /// No description provided for @clusterHint.
  ///
  /// In en, this message translates to:
  /// **'Search cluster or select independent'**
  String get clusterHint;

  /// No description provided for @govtSchemeBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Are you a Govt Scheme beneficiary?'**
  String get govtSchemeBeneficiary;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @whichScheme.
  ///
  /// In en, this message translates to:
  /// **'Which Government Scheme?'**
  String get whichScheme;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank / UPI Details (Optional)'**
  String get bankDetails;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Number'**
  String get accountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID (e.g. name@upi)'**
  String get upiId;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Add later / Skip for now'**
  String get skipForNow;

  /// No description provided for @submitForVerification.
  ///
  /// In en, this message translates to:
  /// **'Submit for Verification'**
  String get submitForVerification;

  /// No description provided for @registrationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get registrationPendingTitle;

  /// No description provided for @registrationPendingSub.
  ///
  /// In en, this message translates to:
  /// **'Your profile is undergoing MoSJE admin verification. You can start cataloging products now.'**
  String get registrationPendingSub;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @namaste.
  ///
  /// In en, this message translates to:
  /// **'Namaste'**
  String get namaste;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// No description provided for @verifiedArtisan.
  ///
  /// In en, this message translates to:
  /// **'MoSJE Verified Artisan'**
  String get verifiedArtisan;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @myCatalogue.
  ///
  /// In en, this message translates to:
  /// **'My Catalogue'**
  String get myCatalogue;

  /// No description provided for @inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get inquiries;

  /// No description provided for @exhibitions.
  ///
  /// In en, this message translates to:
  /// **'Exhibitions'**
  String get exhibitions;

  /// No description provided for @recentInquiries.
  ///
  /// In en, this message translates to:
  /// **'Recent Inquiries'**
  String get recentInquiries;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @activeListings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get activeListings;

  /// No description provided for @pendingInquiries.
  ///
  /// In en, this message translates to:
  /// **'Pending Inquiries'**
  String get pendingInquiries;

  /// No description provided for @totalViews.
  ///
  /// In en, this message translates to:
  /// **'Product Views'**
  String get totalViews;

  /// No description provided for @estIncome.
  ///
  /// In en, this message translates to:
  /// **'Est. Income'**
  String get estIncome;

  /// No description provided for @aiCameraStudio.
  ///
  /// In en, this message translates to:
  /// **'AI Camera Studio'**
  String get aiCameraStudio;

  /// No description provided for @placeProductHere.
  ///
  /// In en, this message translates to:
  /// **'Place your product within the frame'**
  String get placeProductHere;

  /// No description provided for @capturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capturePhoto;

  /// No description provided for @enhancePhoto.
  ///
  /// In en, this message translates to:
  /// **'AI Enhancement'**
  String get enhancePhoto;

  /// No description provided for @removingBg.
  ///
  /// In en, this message translates to:
  /// **'Removing background...'**
  String get removingBg;

  /// No description provided for @fixingLight.
  ///
  /// In en, this message translates to:
  /// **'Optimizing studio lighting...'**
  String get fixingLight;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get done;

  /// No description provided for @beforeAfter.
  ///
  /// In en, this message translates to:
  /// **'Before / After'**
  String get beforeAfter;

  /// No description provided for @useThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Use This Photo'**
  String get useThisPhoto;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @qualityScore.
  ///
  /// In en, this message translates to:
  /// **'Quality Score'**
  String get qualityScore;

  /// No description provided for @voiceCataloger.
  ///
  /// In en, this message translates to:
  /// **'Describe Your Product'**
  String get voiceCataloger;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak in your language'**
  String get speakNow;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording... Speak clearly'**
  String get recording;

  /// No description provided for @translateAndGenerate.
  ///
  /// In en, this message translates to:
  /// **'Translate & Generate'**
  String get translateAndGenerate;

  /// No description provided for @generatingCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Translating & writing description...'**
  String get generatingCatalogue;

  /// No description provided for @titleEn.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get titleEn;

  /// No description provided for @titleHi.
  ///
  /// In en, this message translates to:
  /// **'Title (Hindi)'**
  String get titleHi;

  /// No description provided for @descEn.
  ///
  /// In en, this message translates to:
  /// **'Description (English)'**
  String get descEn;

  /// No description provided for @descHi.
  ///
  /// In en, this message translates to:
  /// **'Description (Hindi)'**
  String get descHi;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags & Categories'**
  String get tags;

  /// No description provided for @pricingAssistant.
  ///
  /// In en, this message translates to:
  /// **'Pricing Assistant'**
  String get pricingAssistant;

  /// No description provided for @suggestedPrice.
  ///
  /// In en, this message translates to:
  /// **'Suggested Price'**
  String get suggestedPrice;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Minimum (Fair Wage)'**
  String get minPrice;

  /// No description provided for @premiumPrice.
  ///
  /// In en, this message translates to:
  /// **'Premium Retail'**
  String get premiumPrice;

  /// No description provided for @materialCost.
  ///
  /// In en, this message translates to:
  /// **'Your Raw Material Cost (₹)'**
  String get materialCost;

  /// No description provided for @howCalculated.
  ///
  /// In en, this message translates to:
  /// **'How was this price calculated?'**
  String get howCalculated;

  /// No description provided for @listProduct.
  ///
  /// In en, this message translates to:
  /// **'List Product Now'**
  String get listProduct;

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'Available Stock'**
  String get stockCount;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOut;

  /// No description provided for @markSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Mark Sold Out'**
  String get markSoldOut;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark Completed'**
  String get markCompleted;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get sendReply;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
