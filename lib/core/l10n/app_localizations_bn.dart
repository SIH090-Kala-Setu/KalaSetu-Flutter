// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'KalaSetu';

  @override
  String get appTagline => 'এআই ও সরাসরি বাজারের মাধ্যমে কারিগরদের ক্ষমতায়ন';

  @override
  String get selectLanguage => 'আপনার ভাষা নির্বাচন করুন';

  @override
  String get selectLanguageSub =>
      'যে ভাষায় আপনি স্বাচ্ছন্দ্যবোধ করেন তা বেছে নিন';

  @override
  String get continueButton => 'এগিয়ে যান';

  @override
  String get welcomeTitle => 'KalaSetu-তে স্বাগতম';

  @override
  String get welcomeSub =>
      'মাস্টার কারিগর এবং তাঁতিদের জন্য সামাজিক ন্যায় ও ক্ষমতায়ন মন্ত্রকের উদ্যোগ';

  @override
  String get iAmNewHere => 'আমি এখানে নতুন (নিবন্ধন করুন)';

  @override
  String get iHaveAccount => 'আমার অ্যাকাউন্ট আছে (লগইন)';

  @override
  String get whoAreYou => 'আপনি কে?';

  @override
  String get selectRoleSub => 'এগিয়ে যেতে আপনার ভূমিকা বেছে নিন';

  @override
  String get roleArtisan => 'কারিগর / শিল্পী';

  @override
  String get roleArtisanDesc =>
      'আমি হস্তনির্মিত পণ্য তৈরি করি এবং সরাসরি ক্রেতাদের কাছে বিক্রি করতে চাই';

  @override
  String get roleAggregator => 'ক্লাস্টার সমষ্টিকারী';

  @override
  String get roleAggregatorDesc =>
      'আমি কারিগরদের দল পরিচালনা করি এবং ডিজিটাল ক্যাটালগিংয়ে সাহায্য করি';

  @override
  String get roleBuyer => 'পাইকারি ক্রেতা (B2B)';

  @override
  String get roleBuyerDesc =>
      'আমি প্রতিষ্ঠানের জন্য হস্তশিল্প ও তাঁত পণ্যের পাইকারি অর্ডার কিনি';

  @override
  String get enterMobile => 'মোবাইল নম্বর লিখুন';

  @override
  String get enterMobileSub =>
      'আমরা আপনার নম্বর যাচাই করতে একটি ৬ সংখ্যার ওটিপি পাঠাব';

  @override
  String get sendOtp => 'ওটিপি পাঠান';

  @override
  String get verifyOtp => 'ওটিপি যাচাই করুন';

  @override
  String otpSentTo(Object phone) {
    return '+91 $phone নম্বরে কোড পাঠানো হয়েছে';
  }

  @override
  String get resendOtp => 'পুনরায় ওটিপি পাঠান';

  @override
  String resendIn(Object seconds) {
    return '$seconds সেকেন্ডে পুনরায় পাঠান';
  }

  @override
  String get verifyAndProceed => 'যাচাই করে এগিয়ে যান';

  @override
  String get artisanRegistration => 'কারিগর নিবন্ধন';

  @override
  String step(Object current, Object total) {
    return 'ধাপ $current / $total';
  }

  @override
  String get fullName => 'সম্পূর্ণ নাম';

  @override
  String get fullNameHint => 'আপনার পুরো নাম লিখুন';

  @override
  String get state => 'রাজ্য';

  @override
  String get district => 'জেলা';

  @override
  String get block => 'ব্লক / তহশিল';

  @override
  String get craftType => 'শিল্পের ধরন';

  @override
  String get selectCraftType => 'আপনার শিল্পের বিশেষত্ব বেছে নিন';

  @override
  String get clusterName => 'ক্লাস্টারের নাম';

  @override
  String get clusterHint => 'ক্লাস্টার খুঁজুন বা স্বাধীন নির্বাচন করুন';

  @override
  String get govtSchemeBeneficiary => 'আপনি কি সরকারি প্রকল্পের সুবিধাভোগী?';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get whichScheme => 'কোন সরকারি প্রকল্প?';

  @override
  String get profilePhoto => 'প্রোফাইল ছবি';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get bankDetails => 'ব্যাংক / ইউপিআই বিবরণ (ঐচ্ছিক)';

  @override
  String get accountNumber => 'ব্যাংক অ্যাকাউন্ট নম্বর';

  @override
  String get ifscCode => 'আইএফএসসি (IFSC) কোড';

  @override
  String get upiId => 'ইউপিআই আইডি (যেমন name@upi)';

  @override
  String get skipForNow => 'পরে যোগ করুন / এখন এড়িয়ে যান';

  @override
  String get submitForVerification => 'যাচাইয়ের জন্য জমা দিন';

  @override
  String get registrationPendingTitle => 'আবেদন জমা হয়েছে!';

  @override
  String get registrationPendingSub =>
      'আপনার প্রোফাইল MoSJE যাচাইকরণের অধীনে রয়েছে। আপনি এখনই পণ্য ক্যাটালগ শুরু করতে পারেন।';

  @override
  String get goToDashboard => 'ড্যাশবোর্ডে যান';

  @override
  String get namaste => 'নমস্কার';

  @override
  String get verificationPending => 'যাচাইকরণ বাকি';

  @override
  String get verifiedArtisan => 'MoSJE যাচাইকৃত কারিগর';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get addProduct => 'পণ্য যোগ করুন';

  @override
  String get myCatalogue => 'আমার ক্যাটালগ';

  @override
  String get inquiries => 'অনুসন্ধান';

  @override
  String get exhibitions => 'প্রদর্শনী';

  @override
  String get recentInquiries => 'সাম্প্রতিক অনুসন্ধান';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get activeListings => 'সক্রিয় পণ্য';

  @override
  String get pendingInquiries => 'অপেক্ষমাণ অনুসন্ধান';

  @override
  String get totalViews => 'পণ্য ভিউ';

  @override
  String get estIncome => 'আনুমানিক আয়';

  @override
  String get aiCameraStudio => 'এআই ক্যামেরা স্টুডিও';

  @override
  String get placeProductHere => 'ফ্রেমের মধ্যে আপনার পণ্য রাখুন';

  @override
  String get capturePhoto => 'ছবি তুলুন';

  @override
  String get enhancePhoto => 'এআই উন্নতি';

  @override
  String get removingBg => 'ব্যাকগ্রাউন্ড সরানো হচ্ছে...';

  @override
  String get fixingLight => 'স্টুডিও লাইটিং ঠিক করা হচ্ছে...';

  @override
  String get done => 'সম্পন্ন!';

  @override
  String get beforeAfter => 'আগে / পরে';

  @override
  String get useThisPhoto => 'এই ছবি ব্যবহার করুন';

  @override
  String get retake => 'পুনরায় তুলুন';

  @override
  String get qualityScore => 'মান স্কোর';

  @override
  String get voiceCataloger => 'আপনার পণ্যের বর্ণনা দিন';

  @override
  String get speakNow => 'আপনার ভাষায় কথা বলতে ট্যাপ করুন';

  @override
  String get recording => 'রেকর্ডিং হচ্ছে... পরিষ্কারভাবে বলুন';

  @override
  String get translateAndGenerate => 'অনুবাদ ও তৈরি করুন';

  @override
  String get generatingCatalogue => 'অনুবাদ ও বিবরণ তৈরি করা হচ্ছে...';

  @override
  String get titleEn => 'শিরোনাম (ইংরেজি)';

  @override
  String get titleHi => 'শিরোনাম (হিন্দি)';

  @override
  String get descEn => 'বিবরণ (ইংরেজি)';

  @override
  String get descHi => 'বিবরণ (হিন্দি)';

  @override
  String get tags => 'ট্যাগ এবং বিভাগ';

  @override
  String get pricingAssistant => 'মূল্য নির্ধারণ সহকারী';

  @override
  String get suggestedPrice => 'প্রস্তাবিত মূল্য';

  @override
  String get minPrice => 'ন্যূনতম (ন্যায্য মজুরি)';

  @override
  String get premiumPrice => 'প্রিমিয়াম খুচরা';

  @override
  String get materialCost => 'আপনার কাঁচামালের খরচ (₹)';

  @override
  String get howCalculated => 'এই মূল্য কিভাবে হিসাব করা হয়েছে?';

  @override
  String get listProduct => 'এখনই পণ্য তালিকাভুক্ত করুন';

  @override
  String get stockCount => 'উপলব্ধ স্টক';

  @override
  String get all => 'সব';

  @override
  String get active => 'সক্রিয়';

  @override
  String get draft => 'খসড়া';

  @override
  String get soldOut => 'বিক্রি হয়ে গেছে';

  @override
  String get markSoldOut => 'বিক্রি হয়েছে হিসেবে চিহ্নিত করুন';

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get decline => 'প্রত্যাখ্যান করুন';

  @override
  String get markCompleted => 'সম্পন্ন চিহ্নিত করুন';

  @override
  String get reply => 'উত্তর দিন';

  @override
  String get sendReply => 'উত্তর পাঠান';

  @override
  String get logout => 'লগ আউট';

  @override
  String get noData => 'কোনো পণ্য পাওয়া যায়নি';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get errorOccurred =>
      'একটি ত্রুটি হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
}
