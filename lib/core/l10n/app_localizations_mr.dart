// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'कलाSetu';

  @override
  String get appTagline => 'एआय आणि थेट बाजारपेठेद्वारे कारागिरांचे सक्षमीकरण';

  @override
  String get selectLanguage => 'आपली भाषा निवडा';

  @override
  String get selectLanguageSub => 'आपल्या सोयीची भाषा निवडा';

  @override
  String get continueButton => 'पुढे जा';

  @override
  String get welcomeTitle => 'कलाSetu मध्ये आपले स्वागत आहे';

  @override
  String get welcomeSub =>
      'मास्टर कारागीर आणि विणकरांसाठी सामाजिक न्याय मंत्रालयाचा पुढाकार';

  @override
  String get iAmNewHere => 'मी येथे नवीन आहे (नोंदणी करा)';

  @override
  String get iHaveAccount => 'माझे आधीच खाते आहे (लॉगिन)';

  @override
  String get whoAreYou => 'आपण कोण आहात?';

  @override
  String get selectRoleSub => 'पुढे जाण्यासाठी आपली भूमिका निवडा';

  @override
  String get roleArtisan => 'कारागीर / विणकर';

  @override
  String get roleArtisanDesc =>
      'मी हस्तकला उत्पादने बनवतो आणि थेट ग्राहकांना विकू इच्छितो';

  @override
  String get roleAggregator => 'क्लस्टर समन्वयक';

  @override
  String get roleAggregatorDesc =>
      'मी कारागिरांच्या गटाचे व्यवस्थापन करतो आणि डिजिटल कॅटलॉगिंगमध्ये मदत करतो';

  @override
  String get roleBuyer => 'घाऊक खरेदीदार (B2B)';

  @override
  String get roleBuyerDesc =>
      'मी उद्योगांसाठी हस्तकला आणि हातमाग उत्पादनांच्या मोठ्या ऑर्डर्स खरेदी करतो';

  @override
  String get enterMobile => 'मोबाईल नंबर टाका';

  @override
  String get enterMobileSub =>
      'आम्ही आपला नंबर सत्यापित करण्यासाठी ६ अंकी ओटीपी पाठवू';

  @override
  String get sendOtp => 'ओटीपी पाठवा';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करा';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone वर पाठवलेला कोड';
  }

  @override
  String get resendOtp => 'ओटीपी पुन्हा पाठवा';

  @override
  String resendIn(Object seconds) {
    return '$seconds सेकंदात पुन्हा पाठवा';
  }

  @override
  String get verifyAndProceed => 'सत्यापित करा आणि पुढे जा';

  @override
  String get artisanRegistration => 'कारागीर नोंदणी';

  @override
  String step(Object current, Object total) {
    return 'पायरी $current / $total';
  }

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get fullNameHint => 'आपले पूर्ण नाव टाका';

  @override
  String get state => 'राज्य';

  @override
  String get district => 'जिल्हा';

  @override
  String get block => 'तालुका';

  @override
  String get craftType => 'हस्तकलेचा प्रकार';

  @override
  String get selectCraftType => 'आपले हस्तकला कौशल्य निवडा';

  @override
  String get clusterName => 'क्लस्टरचे नाव';

  @override
  String get clusterHint => 'क्लस्टर शोधा किंवा स्वतंत्र निवडा';

  @override
  String get govtSchemeBeneficiary => 'आपण सरकारी योजनेचे लाभार्थी आहात का?';

  @override
  String get yes => 'होय';

  @override
  String get no => 'नाही';

  @override
  String get whichScheme => 'कोणती सरकारी योजना?';

  @override
  String get profilePhoto => 'प्रोफाइल फोटो';

  @override
  String get takePhoto => 'फोटो काढा';

  @override
  String get chooseFromGallery => 'गॅलरीतून निवडा';

  @override
  String get bankDetails => 'बँक / UPI तपशील (पर्यायी)';

  @override
  String get accountNumber => 'बँक खाते क्रमांक';

  @override
  String get ifscCode => 'IFSC कोड';

  @override
  String get upiId => 'UPI आयडी (उदा. name@upi)';

  @override
  String get skipForNow => 'नंतर जोडा / आता वगळा';

  @override
  String get submitForVerification => 'सत्यापनासाठी सबमिट करा';

  @override
  String get registrationPendingTitle => 'अर्ज सबमिट केला!';

  @override
  String get registrationPendingSub =>
      'आपले प्रोफाइल MoSJE पडताळणी अंतर्गत आहे. आपण आता उत्पादने सूचीबद्ध करू शकता.';

  @override
  String get goToDashboard => 'डॅशबोर्डवर जा';

  @override
  String get namaste => 'नमस्ते';

  @override
  String get verificationPending => 'पडताळणी प्रलंबित';

  @override
  String get verifiedArtisan => 'MoSJE प्रमाणित कारागीर';

  @override
  String get quickActions => 'जलद कृती';

  @override
  String get addProduct => 'उत्पादन जोडा';

  @override
  String get myCatalogue => 'माझी यादी';

  @override
  String get inquiries => 'चौकशी';

  @override
  String get exhibitions => 'प्रदर्शने';

  @override
  String get recentInquiries => 'अलीकडील चौकशी';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String get activeListings => 'सक्रिय उत्पादने';

  @override
  String get pendingInquiries => 'प्रलंबित चौकशी';

  @override
  String get totalViews => 'उत्पादन दृश्ये';

  @override
  String get estIncome => 'अंदाजे उत्पन्न';

  @override
  String get aiCameraStudio => 'एआय कॅमेरा स्टुडिओ';

  @override
  String get placeProductHere => 'आपले उत्पादन फ्रेममध्ये ठेवा';

  @override
  String get capturePhoto => 'फोटो काढा';

  @override
  String get enhancePhoto => 'एआय सुधारणा';

  @override
  String get removingBg => 'पार्श्वभूमी काढत आहे...';

  @override
  String get fixingLight => 'स्टुडिओ प्रकाश सुधारत आहे...';

  @override
  String get done => 'पूर्ण!';

  @override
  String get beforeAfter => 'आधी / नंतर';

  @override
  String get useThisPhoto => 'हा फोटो वापरा';

  @override
  String get retake => 'पुन्हा काढा';

  @override
  String get qualityScore => 'गुणवत्ता स्कोअर';

  @override
  String get voiceCataloger => 'आपल्या उत्पादनाचे वर्णन करा';

  @override
  String get speakNow => 'आपल्या भाषेत बोलण्यासाठी टॅप करा';

  @override
  String get recording => 'रेकॉर्डिंग सुरू आहे... स्पष्ट बोला';

  @override
  String get translateAndGenerate => 'भाषांतर करा आणि तयार करा';

  @override
  String get generatingCatalogue => 'तपशील तयार करत आहे...';

  @override
  String get titleEn => 'शीर्षक (इंग्रजी)';

  @override
  String get titleHi => 'शीर्षक (हिंदी)';

  @override
  String get descEn => 'वर्णन (इंग्रजी)';

  @override
  String get descHi => 'वर्णन (हिंदी)';

  @override
  String get tags => 'टॅग्ज आणि श्रेणी';

  @override
  String get pricingAssistant => 'किंमत निर्धारण सहाय्यक';

  @override
  String get suggestedPrice => 'सुचवलेली किंमत';

  @override
  String get minPrice => 'किमान (वाजवी मजुरी)';

  @override
  String get premiumPrice => 'प्रीमियम किरकोळ';

  @override
  String get materialCost => 'कच्च्या मालाचा खर्च (₹)';

  @override
  String get howCalculated => 'ही किंमत कशी मोजली गेली?';

  @override
  String get listProduct => 'उत्पादन आत्ताच सूचीबद्ध करा';

  @override
  String get stockCount => 'उपलब्ध स्टॉक';

  @override
  String get all => 'सर्व';

  @override
  String get active => 'सक्रिय';

  @override
  String get draft => 'मसुदा';

  @override
  String get soldOut => 'विकले गेले';

  @override
  String get markSoldOut => 'विकले गेले म्हणून चिन्हांकित करा';

  @override
  String get accept => 'स्वीकारा';

  @override
  String get decline => 'नाकारा';

  @override
  String get markCompleted => 'पूर्ण चिन्हांकित करा';

  @override
  String get reply => 'उत्तर द्या';

  @override
  String get sendReply => 'उत्तर पाठवा';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get noData => 'कोणतेही आयटम सापडले नाहीत';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get errorOccurred => 'त्रुटी आली. कृपया पुन्हा प्रयत्न करा.';
}
