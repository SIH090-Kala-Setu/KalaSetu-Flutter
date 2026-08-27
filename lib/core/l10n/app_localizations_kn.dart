// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'KalaSetu';

  @override
  String get appTagline =>
      'AI ಮತ್ತು ನೇರ ಮಾರುಕಟ್ಟೆ ಪ್ರವೇಶದ ಮೂಲಕ ಕುಶಲಕರ್ಮಿಗಳ ಸಬಲೀಕರಣ';

  @override
  String get selectLanguage => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get selectLanguageSub => 'ನಿಮಗೆ ಸುಲಭವಾದ ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get continueButton => 'ಮುಂದುವರಿಸಿ';

  @override
  String get welcomeTitle => 'KalaSetu ಗೆ ಸುಸ್ವಾಗತ';

  @override
  String get welcomeSub =>
      'ಕುಶಲಕರ್ಮಿಗಳು ಮತ್ತು ನೇಯ್ಗೆಕಾರರಿಗಾಗಿ ಸಾಮಾಜಿಕ ನ್ಯಾಯ ಸಚಿವಾಲಯದ ಉಪಕ್ರಮ';

  @override
  String get iAmNewHere => 'ನಾನು ಹೊಸಬ (ನೋಂದಾಯಿಸಿ)';

  @override
  String get iHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆ (ಲಾಗಿನ್)';

  @override
  String get whoAreYou => 'ನೀವು ಯಾರು?';

  @override
  String get selectRoleSub => 'ಮುಂದುವರಿಯಲು ನಿಮ್ಮ ಪಾತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get roleArtisan => 'ಕುಶಲಕರ್ಮಿ / ನೇಯ್ಗೆಕಾರ';

  @override
  String get roleArtisanDesc =>
      'ನಾನು ಕೈಯಿಂದ ಮಾಡಿದ ಉತ್ಪನ್ನಗಳನ್ನು ತಯಾರಿಸಿ ನೇರವಾಗಿ ಮಾರಾಟ ಮಾಡಲು ಬಯಸುತ್ತೇನೆ';

  @override
  String get roleAggregator => 'ಕ್ಲಸ್ಟರ್ ಸಂಯೋಜಕ';

  @override
  String get roleAggregatorDesc =>
      'ನಾನು ಕುಶಲಕರ್ಮಿಗಳ ಗುಂಪನ್ನು ನಿರ್ವಹಿಸುತ್ತೇನೆ ಮತ್ತು ಡಿಜಿಟಲ್ ಕ್ಯಾಟಲಾಗ್‌ಗೆ ಸಹಾಯ ಮಾಡುತ್ತೇನೆ';

  @override
  String get roleBuyer => 'ಸಗಟು ಖರೀದಿದಾರ (B2B)';

  @override
  String get roleBuyerDesc =>
      'ನಾನು ಸಂಸ್ಥೆಗಳಿಗಾಗಿ ಕರಕುಶಲ ಉತ್ಪನ್ನಗಳನ್ನು ಸಗಟು ಖರೀದಿಸುತ್ತೇನೆ';

  @override
  String get enterMobile => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get enterMobileSub =>
      'ನಿಮ್ಮ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಲು 6 ಅಂಕಿಯ OTP ಕಳುಹಿಸುತ್ತೇವೆ';

  @override
  String get sendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get verifyOtp => 'OTP ಪರಿಶೀಲಿಸಿ';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone ಗೆ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String get resendOtp => 'OTP ಮರುಕಳುಹಿಸಿ';

  @override
  String resendIn(Object seconds) {
    return '$seconds ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಮರುಕಳುಹಿಸಿ';
  }

  @override
  String get verifyAndProceed => 'ಪರಿಶೀಲಿಸಿ ಮುಂದುವರಿಸಿ';

  @override
  String get artisanRegistration => 'ಕುಶಲಕರ್ಮಿಗಳ ನೋಂದಣಿ';

  @override
  String step(Object current, Object total) {
    return 'ಹಂತ $current / $total';
  }

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get fullNameHint => 'ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರನ್ನು ನಮೂದಿಸಿ';

  @override
  String get state => 'ರಾಜ್ಯ';

  @override
  String get district => 'ಜಿಲ್ಲೆ';

  @override
  String get block => 'ತಾಲೂಕು';

  @override
  String get craftType => 'ಕರಕುಶಲ ಪ್ರಕಾರ';

  @override
  String get selectCraftType => 'ನಿಮ್ಮ ಕಲೆಯ ವಿಶೇಷತೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get clusterName => 'ಕ್ಲಸ್ಟರ್ ಹೆಸರು';

  @override
  String get clusterHint => 'ಕ್ಲಸ್ಟರ್ ಹುಡುಕಿ ಅಥವಾ ಸ್ವತಂತ್ರವಾಗಿ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get govtSchemeBeneficiary => 'ನೀವು ಸರ್ಕಾರಿ ಯೋಜನೆಯ ಫಲಾನುಭವಿಯೇ?';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get whichScheme => 'ಯಾವ ಸರ್ಕಾರಿ ಯೋಜನೆ?';

  @override
  String get profilePhoto => 'ಪ್ರೊಫೈಲ್ ಫೋಟೋ';

  @override
  String get takePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get chooseFromGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ';

  @override
  String get bankDetails => 'ಬ್ಯಾಂಕ್ / UPI ವಿವರಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get accountNumber => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಸಂಖ್ಯೆ';

  @override
  String get ifscCode => 'IFSC ಕೋಡ್';

  @override
  String get upiId => 'UPI ಐಡಿ (ಉದಾ. name@upi)';

  @override
  String get skipForNow => 'ನಂತರ ಸೇರಿಸಿ / ಈಗ ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get submitForVerification => 'ಪರಿಶೀಲನೆಗಾಗಿ ಸಲ್ಲಿಸಿ';

  @override
  String get registrationPendingTitle => 'ಅರ್ಜಿ ಸಲ್ಲಿಸಲಾಗಿದೆ!';

  @override
  String get registrationPendingSub =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ MoSJE ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ. ನೀವು ಈಗಲೇ ಉತ್ಪನ್ನಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಲು ಪ್ರಾರಂಭಿಸಬಹುದು.';

  @override
  String get goToDashboard => 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಹೋಗಿ';

  @override
  String get namaste => 'ನಮಸ್ಕಾರ';

  @override
  String get verificationPending => 'ಪರಿಶೀಲನೆ ಬಾಕಿ ಇದೆ';

  @override
  String get verifiedArtisan => 'MoSJE ಪರಿಶೀಲಿಸಿದ ಕುಶಲಕರ್ಮಿ';

  @override
  String get quickActions => 'ತ್ವರಿತ ಕ್ರಿಯೆಗಳು';

  @override
  String get addProduct => 'ಉತ್ಪನ್ನ ಸೇರಿಸಿ';

  @override
  String get myCatalogue => 'ನನ್ನ ಕ್ಯಾಟಲಾಗ್';

  @override
  String get inquiries => 'ವಿಚಾರಣೆಗಳು';

  @override
  String get exhibitions => 'ಪ್ರದರ್ಶನಗಳು';

  @override
  String get recentInquiries => 'ಇತ್ತೀಚಿನ ವಿಚಾರಣೆಗಳು';

  @override
  String get viewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get activeListings => 'ಸಕ್ರಿಯ ಉತ್ಪನ್ನಗಳು';

  @override
  String get pendingInquiries => 'ಬಾಕಿ ವಿಚಾರಣೆಗಳು';

  @override
  String get totalViews => 'ವೀಕ್ಷಣೆಗಳು';

  @override
  String get estIncome => 'ಅಂದಾಜು ಆದಾಯ';

  @override
  String get aiCameraStudio => 'AI ಕ್ಯಾಮೆರಾ ಸ್ಟುಡಿಯೋ';

  @override
  String get placeProductHere => 'ನಿಮ್ಮ ಉತ್ಪನ್ನವನ್ನು ಚೌಕಟ್ಟಿನೊಳಗೆ ಇರಿಸಿ';

  @override
  String get capturePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get enhancePhoto => 'AI ಸುಧಾರಣೆ';

  @override
  String get removingBg => 'ಹಿನ್ನೆಲೆಯನ್ನು ತೆಗೆದುಹಾಕಲಾಗುತ್ತಿದೆ...';

  @override
  String get fixingLight => 'ಬೆಳಕನ್ನು ಸರಿಹೊಂದಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get done => 'ಮುಗಿಯಿತು!';

  @override
  String get beforeAfter => 'ಮೊದಲು / ನಂತರ';

  @override
  String get useThisPhoto => 'ಈ ಫೋಟೋ ಬಳಸಿ';

  @override
  String get retake => 'ಮತ್ತೆ ತೆಗೆಯಿರಿ';

  @override
  String get qualityScore => 'ಗುಣಮಟ್ಟದ ಸ್ಕೋರ್';

  @override
  String get voiceCataloger => 'ನಿಮ್ಮ ಉತ್ಪನ್ನವನ್ನು ವಿವರಿಸಿ';

  @override
  String get speakNow => 'ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ ಮಾತನಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get recording => 'ರೆಕಾರ್ಡಿಂಗ್ ಆಗುತ್ತಿದೆ... ಸ್ಪಷ್ಟವಾಗಿ ಮಾತನಾಡಿ';

  @override
  String get translateAndGenerate => 'ಅನುವಾದಿಸಿ ರಚಿಸಿ';

  @override
  String get generatingCatalogue => 'ವಿವರಣೆಯನ್ನು ರಚಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get titleEn => 'ಶೀರ್ಷಿಕೆ (ಇಂಗ್ಲಿಷ್)';

  @override
  String get titleHi => 'ಶೀರ್ಷಿಕೆ (ಹಿಂದಿ)';

  @override
  String get descEn => 'ವಿವರಣೆ (ಇಂಗ್ಲಿಷ್)';

  @override
  String get descHi => 'ವಿವರಣೆ (ಹಿಂದಿ)';

  @override
  String get tags => 'ಟ್ಯಾಗ್‌ಗಳು';

  @override
  String get pricingAssistant => 'ಬೆಲೆ ನಿಗದಿ ಸಹಾಯಕ';

  @override
  String get suggestedPrice => 'ಸೂಚಿಸಿದ ಬೆಲೆ';

  @override
  String get minPrice => 'ಕನಿಷ್ಠ ಬೆಲೆ (ನ್ಯಾಯಯುತ ಕೂಲಿ)';

  @override
  String get premiumPrice => 'ಪ್ರೀಮಿಯಂ ಬೆಲೆ';

  @override
  String get materialCost => 'ಕಚ್ಚಾ ವಸ್ತುಗಳ ವೆಚ್ಚ (₹)';

  @override
  String get howCalculated => 'ಈ ಬೆಲೆಯನ್ನು ಹೇಗೆ ಲೆಕ್ಕಹಾಕಲಾಗಿದೆ?';

  @override
  String get listProduct => 'ಉತ್ಪನ್ನವನ್ನು ಪಟ್ಟಿ ಮಾಡಿ';

  @override
  String get stockCount => 'ಲಭ್ಯವಿರುವ ದಾಸ್ತಾನು';

  @override
  String get all => 'ಎಲ್ಲಾ';

  @override
  String get active => 'ಸಕ್ರಿಯ';

  @override
  String get draft => 'ಕರಡು';

  @override
  String get soldOut => 'ಮಾರಾಟವಾಗಿದೆ';

  @override
  String get markSoldOut => 'ಮಾರಾಟವಾಗಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get accept => 'ಸ್ವೀಕರಿಸಿ';

  @override
  String get decline => 'ತಿರಸ್ಕರಿಸಿ';

  @override
  String get markCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get reply => 'ಪ್ರತಿಕ್ರಿಯಿಸಿ';

  @override
  String get sendReply => 'ಉತ್ತರ ಕಳುಹಿಸಿ';

  @override
  String get logout => 'ಲಾಗ್‌ಔಟ್';

  @override
  String get noData => 'ಯಾವುದೇ ವಸ್ತುಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get retry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get errorOccurred => 'ದೋಷ ಸಂಭವಿಸಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
}
