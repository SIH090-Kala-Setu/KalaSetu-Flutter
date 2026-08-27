// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'KalaSetu';

  @override
  String get appTagline =>
      'AI மற்றும் நேரடி சந்தை அணுகல் மூலம் கைவினைஞர்களுக்கு அதிகாரம்';

  @override
  String get selectLanguage => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectLanguageSub => 'உங்களுக்கு வசதியான மொழியைத் தேர்வுசெய்யவும்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get welcomeTitle => 'KalaSetu-விற்கு நல்வரவு';

  @override
  String get welcomeSub =>
      'கைவினைஞர்கள் மற்றும் நெசவாளர்களுக்கான சமூக நீதி அமைச்சகத்தின் முயற்சி';

  @override
  String get iAmNewHere => 'நான் புதியவன் (பதிவு செய்க)';

  @override
  String get iHaveAccount => 'ஏற்கனவே கணக்கு உள்ளது (உள்நுழைக)';

  @override
  String get whoAreYou => 'நீங்கள் யார்?';

  @override
  String get selectRoleSub => 'தொடர உங்கள் பங்கைத் தேர்ந்தெடுக்கவும்';

  @override
  String get roleArtisan => 'கைவினைஞர் / நெசவாளர்';

  @override
  String get roleArtisanDesc =>
      'நான் கைவினைப் பொருட்களை உருவாக்குகிறேன், நேரடியாக விற்க விரும்புகிறேன்';

  @override
  String get roleAggregator => 'கிளஸ்டர் ஒருங்கிணைப்பாளர்';

  @override
  String get roleAggregatorDesc =>
      'நான் கைவினைஞர்களை நிர்வகித்து டிஜிட்டல் ஆக்கத்திற்கு உதவுகிறேன்';

  @override
  String get roleBuyer => 'மொத்த வாங்குபவர் (B2B)';

  @override
  String get roleBuyerDesc =>
      'நான் நிறுவனங்களுக்காக மொத்தமாக கைவினைப் பொருட்களை வாங்குகிறேன்';

  @override
  String get enterMobile => 'மொபைல் எண் உள்ளிடவும்';

  @override
  String get enterMobileSub =>
      'உங்கள் எண்ணை சரிபார்க்க 6 இலக்க OTP அனுப்புவோம்';

  @override
  String get sendOtp => 'OTP அனுப்புக';

  @override
  String get verifyOtp => 'OTP சரிபார்க்கவும்';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone எண்ணிற்கு அனுப்பப்பட்டது';
  }

  @override
  String get resendOtp => 'மீண்டும் OTP அனுப்புக';

  @override
  String resendIn(Object seconds) {
    return '$seconds வினாடிகளில் மீண்டும் அனுப்புக';
  }

  @override
  String get verifyAndProceed => 'சரிபார்த்து தொடரவும்';

  @override
  String get artisanRegistration => 'கைவினைஞர் பதிவு';

  @override
  String step(Object current, Object total) {
    return 'படி $current / $total';
  }

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get fullNameHint => 'உங்கள் முழு பெயரை உள்ளிடவும்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get district => 'மாவட்டம்';

  @override
  String get block => 'வட்டம் / தாலுகா';

  @override
  String get craftType => 'கைவினை வகை';

  @override
  String get selectCraftType =>
      'உங்கள் கைவினை நிபுணத்துவத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get clusterName => 'கிளஸ்டர் பெயர்';

  @override
  String get clusterHint =>
      'கிளஸ்டரைத் தேடவும் அல்லது தனி நபரைத் தேர்வுசெய்யவும்';

  @override
  String get govtSchemeBeneficiary => 'நீங்கள் அரசு திட்டப் பயனாளியா?';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get whichScheme => 'எந்த அரசு திட்டம்?';

  @override
  String get profilePhoto => 'சுயவிவரப் படம்';

  @override
  String get takePhoto => 'புகைப்படம் எடுக்கவும்';

  @override
  String get chooseFromGallery => 'கேலரியில் இருந்து தேர்வுசெய்க';

  @override
  String get bankDetails => 'வங்கி / UPI விவரங்கள் (விருப்பமானது)';

  @override
  String get accountNumber => 'வங்கி கணக்கு எண்';

  @override
  String get ifscCode => 'IFSC குறியீடு';

  @override
  String get upiId => 'UPI முகவரி (எ.கா. name@upi)';

  @override
  String get skipForNow => 'பிறகு சேர்க்கவும் / இப்போது தவிர்க்கவும்';

  @override
  String get submitForVerification => 'சரிபார்ப்பிற்குச் சமர்ப்பிக்கவும்';

  @override
  String get registrationPendingTitle => 'விண்ணப்பம் சமர்ப்பிக்கப்பட்டது!';

  @override
  String get registrationPendingSub =>
      'உங்கள் சுயவிவரம் MoSJE சரிபார்ப்பில் உள்ளது. நீங்கள் இப்போதே தயாரிப்புகளைப் பட்டியலிடத் தொடங்கலாம்.';

  @override
  String get goToDashboard => 'முகப்பிற்குச் செல்லவும்';

  @override
  String get namaste => 'வணக்கம்';

  @override
  String get verificationPending => 'சரிபார்ப்பு நிலுவையில் உள்ளது';

  @override
  String get verifiedArtisan => 'MoSJE சரிபார்க்கப்பட்ட கைவினைஞர்';

  @override
  String get quickActions => 'விரைவுச் செயல்கள்';

  @override
  String get addProduct => 'பொருள் சேர்க்க';

  @override
  String get myCatalogue => 'என் அட்டவணை';

  @override
  String get inquiries => 'விசாரணைகள்';

  @override
  String get exhibitions => 'கண்காட்சிகள்';

  @override
  String get recentInquiries => 'சமீபத்திய விசாரணைகள்';

  @override
  String get viewAll => 'அனைத்தையும் பார்க்க';

  @override
  String get activeListings => 'நேரடி தயாரிப்புகள்';

  @override
  String get pendingInquiries => 'நிலுவை விசாரணைகள்';

  @override
  String get totalViews => 'பார்வைகள்';

  @override
  String get estIncome => 'மதிப்பிடப்பட்ட வருமானம்';

  @override
  String get aiCameraStudio => 'AI கேமரா ஸ்டுடியோ';

  @override
  String get placeProductHere => 'உங்கள் பொருளை சட்டகத்திற்குள் வைக்கவும்';

  @override
  String get capturePhoto => 'படம் எடுக்கவும்';

  @override
  String get enhancePhoto => 'AI மேம்பாடு';

  @override
  String get removingBg => 'பின்னணியை நீக்குகிறது...';

  @override
  String get fixingLight => 'ஒளி அமைப்பை மேம்படுத்துகிறது...';

  @override
  String get done => 'முடிந்தது!';

  @override
  String get beforeAfter => 'முன் / பின்';

  @override
  String get useThisPhoto => 'இப்படத்தைப் பயன்படுத்தவும்';

  @override
  String get retake => 'மீண்டும் எடுக்கவும்';

  @override
  String get qualityScore => 'தர மதிப்பீடு';

  @override
  String get voiceCataloger => 'உங்கள் பொருளை விவரிக்கவும்';

  @override
  String get speakNow => 'உங்கள் மொழியில் பேச தட்டவும்';

  @override
  String get recording => 'பதிவாகிறது... தெளிவாகப் பேசுங்கள்';

  @override
  String get translateAndGenerate => 'மொழிபெயர்த்து உருவாக்கவும்';

  @override
  String get generatingCatalogue => 'விளக்கத்தை உருவாக்குகிறது...';

  @override
  String get titleEn => 'தலைப்பு (ஆங்கிலம்)';

  @override
  String get titleHi => 'தலைப்பு (இந்தி)';

  @override
  String get descEn => 'விளக்கம் (ஆங்கிலம்)';

  @override
  String get descHi => 'விளக்கம் (இந்தி)';

  @override
  String get tags => 'குறிச்சொற்கள்';

  @override
  String get pricingAssistant => 'விலை நிர்ணய உதவியாளர்';

  @override
  String get suggestedPrice => 'பரிந்துரைக்கப்பட்ட விலை';

  @override
  String get minPrice => 'குறைந்தபட்சம் (நியாயமான கூலி)';

  @override
  String get premiumPrice => 'பிரீமியம் சில்லறை';

  @override
  String get materialCost => 'மூலப்பொருள் செலவு (₹)';

  @override
  String get howCalculated => 'இந்த விலை எவ்வாறு கணக்கிடப்பட்டது?';

  @override
  String get listProduct => 'பொருளைப் பட்டியலிடுக';

  @override
  String get stockCount => 'கிடைக்கும் இருப்பு';

  @override
  String get all => 'அனைத்தும்';

  @override
  String get active => 'செயலில்';

  @override
  String get draft => 'வரைவு';

  @override
  String get soldOut => 'விற்றுத் தீர்ந்தது';

  @override
  String get markSoldOut => 'விற்றதாகக் குறிக்க';

  @override
  String get accept => 'ஏற்கவும்';

  @override
  String get decline => 'நிராகரி';

  @override
  String get markCompleted => 'முடிந்ததாகக் குறிக்க';

  @override
  String get reply => 'பதிலளிக்கவும்';

  @override
  String get sendReply => 'பதில் அனுப்புக';

  @override
  String get logout => 'வெளியேறுக';

  @override
  String get noData => 'பொருட்கள் எதுவும் இல்லை';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get errorOccurred => 'பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.';
}
