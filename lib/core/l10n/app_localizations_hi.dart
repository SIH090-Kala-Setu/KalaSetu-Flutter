// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कलाSetu';

  @override
  String get appTagline => 'एआई और सीधी बाजार पहुंच से कारीगरों का सशक्तिकरण';

  @override
  String get selectLanguage => 'अपनी भाषा चुनें';

  @override
  String get selectLanguageSub => 'वह भाषा चुनें जिसमें आप सबसे अधिक सहज हैं';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get welcomeTitle => 'कलाSetu में आपका स्वागत है';

  @override
  String get welcomeSub =>
      'मास्टर कारीगरों और बुनकरों के लिए सामाजिक न्याय एवं अधिकारिता मंत्रालय की पहल';

  @override
  String get iAmNewHere => 'मैं यहाँ नया हूँ (पंजीकरण करें)';

  @override
  String get iHaveAccount => 'मेरा पहले से खाता है (लॉग इन)';

  @override
  String get whoAreYou => 'आप कौन हैं?';

  @override
  String get selectRoleSub => 'आगे बढ़ने के लिए अपनी मुख्य भूमिका चुनें';

  @override
  String get roleArtisan => 'कारीगर / शिल्पकार';

  @override
  String get roleArtisanDesc =>
      'मैं हस्तनिर्मित उत्पाद बनाता हूँ और सीधे खरीदारों को बेचना चाहता हूँ';

  @override
  String get roleAggregator => 'क्लस्टर एग्रीगेटर';

  @override
  String get roleAggregatorDesc =>
      'मैं कारीगरों के समूह का प्रबंधन करता हूँ और डिजिटल कैटलॉगिंग में सहायता करता हूँ';

  @override
  String get roleBuyer => 'थोक खरीदार (B2B)';

  @override
  String get roleBuyerDesc =>
      'मैं उद्यमों के लिए हस्तशिल्प और हथकरघा के थोक ऑर्डर खरीदता हूँ';

  @override
  String get enterMobile => 'मोबाइल नंबर दर्ज करें';

  @override
  String get enterMobileSub =>
      'हम आपके फ़ोन नंबर को सत्यापित करने के लिए 6 अंकों का ओटीपी भेजेंगे';

  @override
  String get sendOtp => 'ओटीपी भेजें';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone पर भेजा गया कोड';
  }

  @override
  String get resendOtp => 'ओटीपी पुनः भेजें';

  @override
  String resendIn(Object seconds) {
    return '$seconds सेकंड में पुनः भेजें';
  }

  @override
  String get verifyAndProceed => 'सत्यापित करें और आगे बढ़ें';

  @override
  String get artisanRegistration => 'कारीगर पंजीकरण';

  @override
  String step(Object current, Object total) {
    return 'चरण $current / $total';
  }

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get fullNameHint => 'अपना पूरा नाम दर्ज करें';

  @override
  String get state => 'राज्य';

  @override
  String get district => 'ज़िला';

  @override
  String get block => 'प्रखंड / तहसील';

  @override
  String get craftType => 'शिल्प का प्रकार';

  @override
  String get selectCraftType => 'अपनी शिल्प विशेषता चुनें';

  @override
  String get clusterName => 'क्लस्टर का नाम';

  @override
  String get clusterHint => 'क्लस्टर खोजें या स्वतंत्र चुनें';

  @override
  String get govtSchemeBeneficiary => 'क्या आप सरकारी योजना के लाभार्थी हैं?';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get whichScheme => 'कौन सी सरकारी योजना?';

  @override
  String get profilePhoto => 'प्रोफ़ाइल फोटो';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get bankDetails => 'बैंक / यूपीआई विवरण (वैकल्पिक)';

  @override
  String get accountNumber => 'बैंक खाता संख्या';

  @override
  String get ifscCode => 'आईएफएससी (IFSC) कोड';

  @override
  String get upiId => 'यूपीआई आईडी (उदा. name@upi)';

  @override
  String get skipForNow => 'बाद में जोड़ें / अभी छोड़ें';

  @override
  String get submitForVerification => 'सत्यापन के लिए सबमिट करें';

  @override
  String get registrationPendingTitle => 'आवेदन जमा हो गया!';

  @override
  String get registrationPendingSub =>
      'आपकी प्रोफ़ाइल MoSJE व्यवस्थापक सत्यापन के अधीन है। आप अभी उत्पाद कैटलॉग करना शुरू कर सकते हैं।';

  @override
  String get goToDashboard => 'डैशबोर्ड पर जाएं';

  @override
  String get namaste => 'नमस्ते';

  @override
  String get verificationPending => 'सत्यापन लंबित';

  @override
  String get verifiedArtisan => 'MoSJE सत्यापित कारीगर';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get addProduct => 'उत्पाद जोड़ें';

  @override
  String get myCatalogue => 'मेरी सूची';

  @override
  String get inquiries => 'पूछताछ';

  @override
  String get exhibitions => 'प्रदर्शनियां';

  @override
  String get recentInquiries => 'हाल की पूछताछ';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get activeListings => 'सक्रिय उत्पाद';

  @override
  String get pendingInquiries => 'लंबित पूछताछ';

  @override
  String get totalViews => 'उत्पाद दृश्य';

  @override
  String get estIncome => 'अनुमानित आय';

  @override
  String get aiCameraStudio => 'एआई कैमरा स्टूडियो';

  @override
  String get placeProductHere => 'अपने उत्पाद को फ्रेम के अंदर रखें';

  @override
  String get capturePhoto => 'फोटो लें';

  @override
  String get enhancePhoto => 'एआई सुधार';

  @override
  String get removingBg => 'पृष्ठभूमि हटा रहे हैं...';

  @override
  String get fixingLight => 'स्टूडियो लाइटिंग ठीक कर रहे हैं...';

  @override
  String get done => 'पूर्ण!';

  @override
  String get beforeAfter => 'पहले / बाद में';

  @override
  String get useThisPhoto => 'इस फोटो का उपयोग करें';

  @override
  String get retake => 'पुनः लें';

  @override
  String get qualityScore => 'गुणवत्ता स्कोर';

  @override
  String get voiceCataloger => 'अपने उत्पाद का वर्णन करें';

  @override
  String get speakNow => 'अपनी भाषा में बोलने के लिए टैप करें';

  @override
  String get recording => 'रिकॉर्डिंग हो रही है... स्पष्ट बोलें';

  @override
  String get translateAndGenerate => 'अनुवाद और निर्माण करें';

  @override
  String get generatingCatalogue => 'अनुवाद और विवरण तैयार किया जा रहा है...';

  @override
  String get titleEn => 'शीर्षक (अंग्रेज़ी)';

  @override
  String get titleHi => 'शीर्षक (हिंदी)';

  @override
  String get descEn => 'विवरण (अंग्रेज़ी)';

  @override
  String get descHi => 'विवरण (हिंदी)';

  @override
  String get tags => 'टैग और श्रेणियां';

  @override
  String get pricingAssistant => 'मूल्य निर्धारण सहायक';

  @override
  String get suggestedPrice => 'सुझाया गया मूल्य';

  @override
  String get minPrice => 'न्यूनतम (उचित मजदूरी)';

  @override
  String get premiumPrice => 'प्रीमियम खुदरा';

  @override
  String get materialCost => 'आपकी कच्ची सामग्री लागत (₹)';

  @override
  String get howCalculated => 'इस मूल्य की गणना कैसे की गई?';

  @override
  String get listProduct => 'उत्पाद अभी सूचीबद्ध करें';

  @override
  String get stockCount => 'उपलब्ध स्टॉक';

  @override
  String get all => 'सभी';

  @override
  String get active => 'सक्रिय';

  @override
  String get draft => 'ड्राफ्ट';

  @override
  String get soldOut => 'बिक गया';

  @override
  String get markSoldOut => 'बिका हुआ चिह्नित करें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get markCompleted => 'पूर्ण चिह्नित करें';

  @override
  String get reply => 'उत्तर दें';

  @override
  String get sendReply => 'उत्तर भेजें';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get noData => 'कोई वस्तु नहीं मिली';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get errorOccurred => 'एक त्रुटि हुई। कृपया पुनः प्रयास करें।';
}
