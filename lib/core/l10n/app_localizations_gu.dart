// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'કલાSetu';

  @override
  String get appTagline => 'AI અને સીધા બજાર દ્વારા કારીગરોનું સશક્તિકરણ';

  @override
  String get selectLanguage => 'તમારી ભાષા પસંદ કરો';

  @override
  String get selectLanguageSub => 'જે ભાષામાં તમને સરળતા રહે તે પસંદ કરો';

  @override
  String get continueButton => 'આગળ વધો';

  @override
  String get welcomeTitle => 'કલાSetu માં સ્વાગત છે';

  @override
  String get welcomeSub =>
      'માસ્ટર કારીગરો અને વણકરો માટે સામાજિક ન્યાય મંત્રાલયની પહેલ';

  @override
  String get iAmNewHere => 'હું અહીં નવો છું (નોંધણી કરો)';

  @override
  String get iHaveAccount => 'મારું ખાતું પહેલેથી છે (લૉગિન)';

  @override
  String get whoAreYou => 'તમે કોણ છો?';

  @override
  String get selectRoleSub => 'આગળ વધવા માટે તમારી ભૂમિકા પસંદ કરો';

  @override
  String get roleArtisan => 'કારીગર / વણકર';

  @override
  String get roleArtisanDesc =>
      'હું હાથબનાવટની વસ્તુઓ બનાવું છું અને સીધા ખરીદદારોને વેચવા માંગુ છું';

  @override
  String get roleAggregator => 'ક્લસ્ટર સંયોજક';

  @override
  String get roleAggregatorDesc =>
      'હું કારીગરોના જૂથનું સંચાલન કરું છું અને ડિજિટલ કેટલોગિંગમાં મદદ કરું છું';

  @override
  String get roleBuyer => 'જથ્થાબંધ ખરીદદાર (B2B)';

  @override
  String get roleBuyerDesc =>
      'હું વ્યવસાયો માટે હસ્તકલા અને હાથશાળ ઉત્પાદનોના જથ્થાબંધ ઓર્ડર ખરીદું છું';

  @override
  String get enterMobile => 'મોબાઇલ નંબર દાખલ કરો';

  @override
  String get enterMobileSub =>
      'અમે તમારો નંબર ચકાસવા માટે 6 અંકનો OTP મોકલીશું';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get verifyOtp => 'OTP ચકાસો';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone પર કોડ મોકલ્યો છે';
  }

  @override
  String get resendOtp => 'OTP ફરી મોકલો';

  @override
  String resendIn(Object seconds) {
    return '$seconds સેકન્ડમાં ફરી મોકલો';
  }

  @override
  String get verifyAndProceed => 'ચકાસો અને આગળ વધો';

  @override
  String get artisanRegistration => 'કારીગર નોંધણી';

  @override
  String step(Object current, Object total) {
    return 'પગલું $current / $total';
  }

  @override
  String get fullName => 'પૂરું નામ';

  @override
  String get fullNameHint => 'તમારું પૂરું નામ દાખલ કરો';

  @override
  String get state => 'રાજ્ય';

  @override
  String get district => 'જિલ્લો';

  @override
  String get block => 'તાલુકો';

  @override
  String get craftType => 'હસ્તકલા પ્રકાર';

  @override
  String get selectCraftType => 'તમારી કલા વિશેષતા પસંદ કરો';

  @override
  String get clusterName => 'ક્લસ્ટરનું નામ';

  @override
  String get clusterHint => 'ક્લસ્ટર શોધો અથવા સ્વતંત્ર પસંદ કરો';

  @override
  String get govtSchemeBeneficiary => 'શું તમે સરકારી યોજનાના લાભાર્થી છો?';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get whichScheme => 'કઈ સરકારી યોજના?';

  @override
  String get profilePhoto => 'પ્રોફાઇલ ફોટો';

  @override
  String get takePhoto => 'ફોટો પાડો';

  @override
  String get chooseFromGallery => 'ગેલેરીમાંથી પસંદ કરો';

  @override
  String get bankDetails => 'બેંક / UPI વિગતો (વૈકલ્પિક)';

  @override
  String get accountNumber => 'બેંક ખાતા નંબર';

  @override
  String get ifscCode => 'IFSC કોડ';

  @override
  String get upiId => 'UPI આઈડી (દા.ત. name@upi)';

  @override
  String get skipForNow => 'પછી ઉમેરો / હમણાં છોડો';

  @override
  String get submitForVerification => 'ચકાસણી માટે સબમિટ કરો';

  @override
  String get registrationPendingTitle => 'અરજી સબમિટ થઈ ગઈ!';

  @override
  String get registrationPendingSub =>
      'તમારી પ્રોફાઇલ MoSJE ચકાસણી હેઠળ છે. તમે અત્યારે ઉત્પાદનો કેટલોગ કરવાનું શરૂ કરી શકો છો.';

  @override
  String get goToDashboard => 'ડેશબોર્ડ પર જાઓ';

  @override
  String get namaste => 'નમસ્તે';

  @override
  String get verificationPending => 'ચકાસણી બાકી છે';

  @override
  String get verifiedArtisan => 'MoSJE પ્રમાણિત કારીગર';

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get addProduct => 'ઉત્પાદન ઉમેરો';

  @override
  String get myCatalogue => 'મારી યાદી';

  @override
  String get inquiries => 'પૂછપરછ';

  @override
  String get exhibitions => 'પ્રદર્શનો';

  @override
  String get recentInquiries => 'તાજેતરની પૂછપરછ';

  @override
  String get viewAll => 'બધા જુઓ';

  @override
  String get activeListings => 'સક્રિય ઉત્પાદનો';

  @override
  String get pendingInquiries => 'બાકી પૂછપરછ';

  @override
  String get totalViews => 'ઉત્પાદન દૃશ્યો';

  @override
  String get estIncome => 'અંદાજિત આવક';

  @override
  String get aiCameraStudio => 'AI કેમેરા સ્ટુડિયો';

  @override
  String get placeProductHere => 'તમારા ઉત્પાદનને ફ્રેમમાં મૂકો';

  @override
  String get capturePhoto => 'ફોટો લો';

  @override
  String get enhancePhoto => 'AI સુધારો';

  @override
  String get removingBg => 'બેકગ્રાઉન્ડ હટાવી રહ્યા છીએ...';

  @override
  String get fixingLight => 'લાઇટિંગ સુધારી રહ્યા છીએ...';

  @override
  String get done => 'પૂર્ણ!';

  @override
  String get beforeAfter => 'પહેલાં / પછી';

  @override
  String get useThisPhoto => 'આ ફોટો વાપરો';

  @override
  String get retake => 'ફરીથી લો';

  @override
  String get qualityScore => 'ગુણવત્તા સ્કોર';

  @override
  String get voiceCataloger => 'તમારા ઉત્પાદનનું વર્ણન કરો';

  @override
  String get speakNow => 'તમારી ભાષામાં બોલવા માટે ટેપ કરો';

  @override
  String get recording => 'રેકોર્ડિંગ ચાલુ છે... સ્પષ્ટ બોલો';

  @override
  String get translateAndGenerate => 'અનુવાદ અને નિર્માણ કરો';

  @override
  String get generatingCatalogue => 'વર્ણન તૈયાર થઈ રહ્યું છે...';

  @override
  String get titleEn => 'શીર્ષક (અંગ્રેજી)';

  @override
  String get titleHi => 'શીર્ષક (હિન્દી)';

  @override
  String get descEn => 'વર્ણન (અંગ્રેજી)';

  @override
  String get descHi => 'વર્ણન (હિન્દી)';

  @override
  String get tags => 'ટેગ્સ અને શ્રેણીઓ';

  @override
  String get pricingAssistant => 'કિંમત નિર્ધારણ સહાયક';

  @override
  String get suggestedPrice => 'સૂચવેલ કિંમત';

  @override
  String get minPrice => 'ન્યૂનતમ (વાજબી વેતન)';

  @override
  String get premiumPrice => 'પ્રીમિયમ છૂટક';

  @override
  String get materialCost => 'કાચા માલનો ખર્ચ (₹)';

  @override
  String get howCalculated => 'આ કિંમતની ગણતરી કેવી રીતે થઈ?';

  @override
  String get listProduct => 'ઉત્પાદન હમણાં સૂચિબદ્ધ કરો';

  @override
  String get stockCount => 'ઉપલબ્ધ સ્ટોક';

  @override
  String get all => 'બધા';

  @override
  String get active => 'સક્રિય';

  @override
  String get draft => 'ડ્રાફ્ટ';

  @override
  String get soldOut => 'વેચાઈ ગયું';

  @override
  String get markSoldOut => 'વેચાયેલ તરીકે ચિહ્નિત કરો';

  @override
  String get accept => 'સ્વીકારો';

  @override
  String get decline => 'અસ્વીકાર કરો';

  @override
  String get markCompleted => 'પૂર્ણ તરીકે ચિહ્નિત કરો';

  @override
  String get reply => 'જવાબ આપો';

  @override
  String get sendReply => 'જવાબ મોકલો';

  @override
  String get logout => 'લૉગ આઉટ';

  @override
  String get noData => 'કોઈ વસ્તુ મળી નથી';

  @override
  String get retry => 'ફરી પ્રયાસ કરો';

  @override
  String get errorOccurred => 'ભૂલ આવી. કૃપા કરીને ફરી પ્રયાસ કરો.';
}
