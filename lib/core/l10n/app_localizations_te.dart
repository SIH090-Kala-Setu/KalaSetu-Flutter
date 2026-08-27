// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'KalaSetu';

  @override
  String get appTagline =>
      'AI మరియు ప్రత్యక్ష మార్కెట్ ప్రాప్యతతో కళాకారుల సాధికారత';

  @override
  String get selectLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get selectLanguageSub => 'మీకు సౌకర్యంగా ఉండే భాషను ఎంచుకోండి';

  @override
  String get continueButton => 'కొనసాగించండి';

  @override
  String get welcomeTitle => 'KalaSetu కి స్వాగతం';

  @override
  String get welcomeSub =>
      'చేతివృత్తుల కళాకారులు & నేత కార్మికుల కోసం సాంఘిక న్యాయ మంత్రిత్వ శాఖ చొరవ';

  @override
  String get iAmNewHere => 'నేను ఇక్కడ కొత్త (నమోదు చేసుకోండి)';

  @override
  String get iHaveAccount => 'నాకు ఇప్పటికే ఖాతా ఉంది (లాగిన్)';

  @override
  String get whoAreYou => 'మీరు ఎవరు?';

  @override
  String get selectRoleSub => 'కొనసాగడానికి మీ పాత్రను ఎంచుకోండి';

  @override
  String get roleArtisan => 'చేతివృత్తి కళాకారుడు / నేత కార్మికుడు';

  @override
  String get roleArtisanDesc =>
      'నేను చేతితో తయారు చేసిన వస్తువులను నేరుగా కొనుగోలుదారులకు అమ్మాలనుకుంటున్నాను';

  @override
  String get roleAggregator => 'క్లస్టర్ అగ్రిగేటర్';

  @override
  String get roleAggregatorDesc =>
      'నేను కళాకారుల బృందాన్ని నిర్వహిస్తాను మరియు డిజిటల్ కేటలాగింగ్‌లో సహాయం చేస్తాను';

  @override
  String get roleBuyer => 'టోకు కొనుగోలుదారు (B2B)';

  @override
  String get roleBuyerDesc =>
      'నేను సంస్థల కోసం హస్తకళల బల్క్ ఆర్డర్‌లను కొనుగోలు చేస్తాను';

  @override
  String get enterMobile => 'మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get enterMobileSub =>
      'మేము మీ నంబర్‌ను ధృవీకరించడానికి 6 అంకెల OTP పంపుతాము';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get verifyOtp => 'OTP ధృవీకరించండి';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone కి కోడ్ పంపబడింది';
  }

  @override
  String get resendOtp => 'OTP మళ్లీ పంపండి';

  @override
  String resendIn(Object seconds) {
    return '$seconds సెకన్లలో మళ్లీ పంపండి';
  }

  @override
  String get verifyAndProceed => 'ధృవీకరించి కొనసాగండి';

  @override
  String get artisanRegistration => 'కళాకారుల నమోదు';

  @override
  String step(Object current, Object total) {
    return 'దశ $current / $total';
  }

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get fullNameHint => 'మీ పూర్తి పేరు నమోదు చేయండి';

  @override
  String get state => 'రాష్ట్రం';

  @override
  String get district => 'జిల్లా';

  @override
  String get block => 'బ్లాక్ / మండలం';

  @override
  String get craftType => 'చేతిపని రకం';

  @override
  String get selectCraftType => 'మీ నైపుణ్యాన్ని ఎంచుకోండి';

  @override
  String get clusterName => 'క్లస్టర్ పేరు';

  @override
  String get clusterHint => 'క్లస్టర్ శోధించండి లేదా స్వతంత్రంగా ఎంచుకోండి';

  @override
  String get govtSchemeBeneficiary => 'మీరు ప్రభుత్వ పథకం లబ్ధిదారులా?';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get whichScheme => 'ఏ ప్రభుత్వ పథకం?';

  @override
  String get profilePhoto => 'ప్రొఫైల్ ఫోటో';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get chooseFromGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get bankDetails => 'బ్యాంక్ / UPI వివరాలు (ఐచ్ఛికం)';

  @override
  String get accountNumber => 'బ్యాంక్ ఖాతా సంఖ్య';

  @override
  String get ifscCode => 'IFSC కోడ్';

  @override
  String get upiId => 'UPI ఐడి (ఉదా. name@upi)';

  @override
  String get skipForNow => 'తర్వాత జోడించండి / ఇప్పుడే దాటవేయండి';

  @override
  String get submitForVerification => 'ధృవీకరణ కోసం సమర్పించండి';

  @override
  String get registrationPendingTitle => 'దరఖాస్తు సమర్పించబడింది!';

  @override
  String get registrationPendingSub =>
      'మీ ప్రొఫైల్ MoSJE ధృవీకరణలో ఉంది. మీరు ఇప్పుడే ఉత్పత్తులను కేటలాగ్ చేయడం ప్రారంభించవచ్చు.';

  @override
  String get goToDashboard => 'డ్యాష్‌బోర్డ్‌కు వెళ్లండి';

  @override
  String get namaste => 'నమస్కారం';

  @override
  String get verificationPending => 'ధృవీకరణ పెండింగ్‌లో ఉంది';

  @override
  String get verifiedArtisan => 'MoSJE ధృవీకరించబడిన కళాకారుడు';

  @override
  String get quickActions => 'త్వరిత చర్యలు';

  @override
  String get addProduct => 'ఉత్పత్తి జోడించండి';

  @override
  String get myCatalogue => 'నా కేటలాగ్';

  @override
  String get inquiries => 'విచారణలు';

  @override
  String get exhibitions => 'ప్రదర్శనలు';

  @override
  String get recentInquiries => 'ఇటీవలి విచారణలు';

  @override
  String get viewAll => 'అన్నీ చూడండి';

  @override
  String get activeListings => 'లైవ్ ఉత్పత్తులు';

  @override
  String get pendingInquiries => 'పెండింగ్ విచారణలు';

  @override
  String get totalViews => 'వీక్షణలు';

  @override
  String get estIncome => 'అంచనా ఆదాయం';

  @override
  String get aiCameraStudio => 'AI కెమెరా స్టూడియో';

  @override
  String get placeProductHere => 'మీ ఉత్పత్తిని ఫ్రేమ్‌లో ఉంచండి';

  @override
  String get capturePhoto => 'ఫోటో తీయండి';

  @override
  String get enhancePhoto => 'AI మెరుగుదల';

  @override
  String get removingBg => 'నేపథ్యాన్ని తొలగిస్తోంది...';

  @override
  String get fixingLight => 'లైటింగ్‌ని మెరుగుపరుస్తోంది...';

  @override
  String get done => 'పూర్తయింది!';

  @override
  String get beforeAfter => 'ముందు / తర్వాత';

  @override
  String get useThisPhoto => 'ఈ ఫోటోను ఉపయోగించండి';

  @override
  String get retake => 'మళ్లీ తీయండి';

  @override
  String get qualityScore => 'నాణ్యత స్కోర్';

  @override
  String get voiceCataloger => 'మీ ఉత్పత్తిని వివరించండి';

  @override
  String get speakNow => 'మీ భాషలో మాట్లాడటానికి నొక్కండి';

  @override
  String get recording => 'రికార్డింగ్ అవుతోంది... స్పష్టంగా మాట్లాడండి';

  @override
  String get translateAndGenerate => 'అనువదించి సృష్టించండి';

  @override
  String get generatingCatalogue => 'వివరణను రూపొందిస్తోంది...';

  @override
  String get titleEn => 'శీర్షిక (ఇంగ్లీష్)';

  @override
  String get titleHi => 'శీర్షిక (హిందీ)';

  @override
  String get descEn => 'వివరణ (ఇంగ్లీష్)';

  @override
  String get descHi => 'వివరణ (హిందీ)';

  @override
  String get tags => 'ట్యాగ్‌లు & వర్గాలు';

  @override
  String get pricingAssistant => 'ధర నిర్ణయ సహాయకుడు';

  @override
  String get suggestedPrice => 'సూచించిన ధర';

  @override
  String get minPrice => 'కనీస ధర (న్యాయమైన వేతనం)';

  @override
  String get premiumPrice => 'ప్రీమియం రిటైల్';

  @override
  String get materialCost => 'ముడి పదార్థాల ఖర్చు (₹)';

  @override
  String get howCalculated => 'ఈ ధర ఎలా లెక్కించబడింది?';

  @override
  String get listProduct => 'ఉత్పత్తిని జాబితా చేయండి';

  @override
  String get stockCount => 'అందుబాటులో ఉన్న స్టాక్';

  @override
  String get all => 'అన్నీ';

  @override
  String get active => 'యాక్టివ్';

  @override
  String get draft => 'డ్రాఫ్ట్';

  @override
  String get soldOut => 'అమ్ముడైపోయింది';

  @override
  String get markSoldOut => 'అమ్మినట్లు గుర్తించండి';

  @override
  String get accept => 'అంగీకరించు';

  @override
  String get decline => 'తిరస్కరించు';

  @override
  String get markCompleted => 'పూర్తయినట్లు గుర్తించండి';

  @override
  String get reply => 'సమాధానం ఇవ్వండి';

  @override
  String get sendReply => 'సమాధానం పంపండి';

  @override
  String get logout => 'లాగౌట్';

  @override
  String get noData => 'వస్తువులు ఏవీ కనుగొనబడలేదు';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get errorOccurred => 'లోపం సంభవించింది. దయచేసి మళ్లీ ప్రయత్నించండి.';
}
