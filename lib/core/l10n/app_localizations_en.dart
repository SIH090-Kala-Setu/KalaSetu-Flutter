// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KalaSetu';

  @override
  String get appTagline =>
      'Empowering Artisans Through AI & Direct Market Access';

  @override
  String get selectLanguage => 'Select Your Language';

  @override
  String get selectLanguageSub =>
      'Choose the language you are most comfortable with';

  @override
  String get continueButton => 'Continue';

  @override
  String get welcomeTitle => 'Welcome to KalaSetu';

  @override
  String get welcomeSub =>
      'Ministry of Social Justice & Empowerment initiative for master artisans & weavers';

  @override
  String get iAmNewHere => 'I am new here (Register)';

  @override
  String get iHaveAccount => 'I already have an account (Login)';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String get selectRoleSub => 'Select your primary role to proceed';

  @override
  String get roleArtisan => 'Artisan / Karigar';

  @override
  String get roleArtisanDesc =>
      'I craft handmade products and want to sell directly to buyers';

  @override
  String get roleAggregator => 'Cluster Aggregator';

  @override
  String get roleAggregatorDesc =>
      'I manage a cohort of artisans and facilitate digital cataloging';

  @override
  String get roleBuyer => 'B2B Buyer';

  @override
  String get roleBuyerDesc =>
      'I procure bulk handicraft & handloom orders for enterprise';

  @override
  String get enterMobile => 'Enter Mobile Number';

  @override
  String get enterMobileSub =>
      'We will send a 6-digit OTP code to verify your phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String otpSentTo(Object phone) {
    return 'Code sent to +91 $phone';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendIn(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verifyAndProceed => 'Verify & Proceed';

  @override
  String get artisanRegistration => 'Artisan Registration';

  @override
  String step(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get state => 'State';

  @override
  String get district => 'District';

  @override
  String get block => 'Block / Tehsil';

  @override
  String get craftType => 'Craft Type';

  @override
  String get selectCraftType => 'Select your craft specialization';

  @override
  String get clusterName => 'Cluster Name';

  @override
  String get clusterHint => 'Search cluster or select independent';

  @override
  String get govtSchemeBeneficiary => 'Are you a Govt Scheme beneficiary?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get whichScheme => 'Which Government Scheme?';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get bankDetails => 'Bank / UPI Details (Optional)';

  @override
  String get accountNumber => 'Bank Account Number';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get upiId => 'UPI ID (e.g. name@upi)';

  @override
  String get skipForNow => 'Add later / Skip for now';

  @override
  String get submitForVerification => 'Submit for Verification';

  @override
  String get registrationPendingTitle => 'Application Submitted!';

  @override
  String get registrationPendingSub =>
      'Your profile is undergoing MoSJE admin verification. You can start cataloging products now.';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get namaste => 'Namaste';

  @override
  String get verificationPending => 'Verification Pending';

  @override
  String get verifiedArtisan => 'MoSJE Verified Artisan';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addProduct => 'Add Product';

  @override
  String get myCatalogue => 'My Catalogue';

  @override
  String get inquiries => 'Inquiries';

  @override
  String get exhibitions => 'Exhibitions';

  @override
  String get recentInquiries => 'Recent Inquiries';

  @override
  String get viewAll => 'View All';

  @override
  String get activeListings => 'Active Listings';

  @override
  String get pendingInquiries => 'Pending Inquiries';

  @override
  String get totalViews => 'Product Views';

  @override
  String get estIncome => 'Est. Income';

  @override
  String get aiCameraStudio => 'AI Camera Studio';

  @override
  String get placeProductHere => 'Place your product within the frame';

  @override
  String get capturePhoto => 'Capture';

  @override
  String get enhancePhoto => 'AI Enhancement';

  @override
  String get removingBg => 'Removing background...';

  @override
  String get fixingLight => 'Optimizing studio lighting...';

  @override
  String get done => 'Done!';

  @override
  String get beforeAfter => 'Before / After';

  @override
  String get useThisPhoto => 'Use This Photo';

  @override
  String get retake => 'Retake';

  @override
  String get qualityScore => 'Quality Score';

  @override
  String get voiceCataloger => 'Describe Your Product';

  @override
  String get speakNow => 'Tap to speak in your language';

  @override
  String get recording => 'Recording... Speak clearly';

  @override
  String get translateAndGenerate => 'Translate & Generate';

  @override
  String get generatingCatalogue => 'Translating & writing description...';

  @override
  String get titleEn => 'Title (English)';

  @override
  String get titleHi => 'Title (Hindi)';

  @override
  String get descEn => 'Description (English)';

  @override
  String get descHi => 'Description (Hindi)';

  @override
  String get tags => 'Tags & Categories';

  @override
  String get pricingAssistant => 'Pricing Assistant';

  @override
  String get suggestedPrice => 'Suggested Price';

  @override
  String get minPrice => 'Minimum (Fair Wage)';

  @override
  String get premiumPrice => 'Premium Retail';

  @override
  String get materialCost => 'Your Raw Material Cost (₹)';

  @override
  String get howCalculated => 'How was this price calculated?';

  @override
  String get listProduct => 'List Product Now';

  @override
  String get stockCount => 'Available Stock';

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get draft => 'Draft';

  @override
  String get soldOut => 'Sold Out';

  @override
  String get markSoldOut => 'Mark Sold Out';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get markCompleted => 'Mark Completed';

  @override
  String get reply => 'Reply';

  @override
  String get sendReply => 'Send Reply';

  @override
  String get logout => 'Logout';

  @override
  String get noData => 'No items found';

  @override
  String get retry => 'Retry';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';
}
