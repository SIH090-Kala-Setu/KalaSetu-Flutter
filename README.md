# 🎨 कलाSetu (KalaSetu Mobile) | Flutter Frontend

> **AI-Powered Mobile Application for Direct Market Linkage, Multilingual Cataloging, and Governance of Marginalized Artisans, Weavers & Micro-Entrepreneurs**  
> *Under the mandate of the Ministry of Social Justice and Empowerment (MoSJE) | Smart India Hackathon (SIH26090)*

---

## 📌 Overview

**कलाSetu** mobile frontend is a production-grade, low-literacy-first Flutter mobile application built for Android & iOS. It connects directly to the high-performance FastAPI backend to empower rural artisans to photograph their craft, speak in their native tongue, receive dynamic AI pricing suggestions, and publish wholesale catalogs directly to national B2B buyers and government exhibition portals.

---

## 🛠️ Tech Stack & Key Libraries

| Component | Library / Framework | Purpose |
|:---|:---|:---|
| **Framework** | **Flutter 3.x (Dart 3.x)** | Cross-platform mobile (Android & iOS) |
| **State Management** | **Flutter Riverpod 3.x** | Reactive, testable state management (`Notifier`, `NotifierProvider`) |
| **Navigation & Routing** | **GoRouter 17.x** | Declarative routing with role-based auth redirection & `ShellRoute` |
| **Networking & HTTP** | **Dio 5.x** | HTTP client with automatic JWT Bearer token injection & 401 interceptors |
| **Secure Token Storage** | **flutter_secure_storage** | Encrypted storage for JWT access and refresh tokens |
| **Local Preferences** | **shared_preferences** | Fast persistent storage for active language code & app settings |
| **Typography & Fonts** | **google_fonts (Noto Sans)** | Clean typography supporting all Indic scripts |
| **Localization (8 Languages)** | **flutter_localizations & intl** | Native ARB catalogs: English, Hindi, Bengali, Tamil, Telugu, Marathi, Kannada, Gujarati |
| **Camera & Media** | **image_picker, camera** | Low-light camera capture, torch controls, and gallery picker |
| **UI Loaders & Skeletons** | **shimmer** | Elegant placeholder shimmer loaders during async fetches |

---

## 🎨 Design System & Accessibility

- **Theme Palette**:
  - Primary: `#2E4057` (Deep Indigo Blue)
  - Accent: `#F4A226` (Warm Saffron / Amber)
  - Background: `#F8F7F2` (Warm Off-White / Natural Canvas)
  - Surface: `#FFFFFF` (Clean White)
  - Success: `#3B8A4F` (Forest Green)
  - Warning: `#D68910` (Golden Amber)
  - Error: `#C0392B` (Terracotta Crimson)
- **Accessibility Constraints**:
  - **Minimum 56px Tap Targets** for all interactive buttons and inputs.
  - **Visual & Voice-First UX** designed for artisans with minimal digital literacy.
  - **Zero Hardcoded Strings**: 100% of UI copy resolved through `AppLocalizations`.

---

## 👥 Role-Based Capabilities & Modules

The application automatically identifies the user's role post-OTP authentication and routes into dedicated dashboards:

### 1. 🧵 Artisan / Karigar (`/artisan/*`)
- **Home Dashboard**: Namaste greeting, MoSJE KYC verification banner, total earnings overview card, 2x2 quick action grid, recent wholesale inquiries, and live scheme alerts.
- **AI Camera Studio (4-Phase Flow)**:
  1. **Phase 1 (Capture)**: Viewfinder with dashed guide box (*"Place your product within the frame"*), 72px shutter button, torch toggle, and gallery import.
  2. **Phase 2 (AI Enhance)**: Calls `POST /enhance` for background removal & studio lighting balance, before/after preview, and quality score badge (92/100).
  3. **Phase 3 (Voice Cataloger)**: Pulsing mic button recording, Gemini AI bilingual transcription (`POST /catalog`), side-by-side English + Hindi description editor, and tags.
  4. **Phase 4 (Pricing Assistant)**: 3-tier price cards (*Minimum Fair Wage*, *Suggested ★*, *Premium Retail*), raw material margin recalculator (`POST /suggest-price`), and 1-click product publish (`POST /products`).
- **Catalogue Manager**: 2-column grid, status filter chips (*All*, *Active*, *Draft*, *Sold Out*), swipe-to-archive, stock incrementer ($+/-$), and catalog QR code generator.
- **Inquiries**: Buyer quotation requests, message thread, quotation response modal (`POST /inquiries/{id}/respond`), and Accept / Mark Completed actions.
- **National Exhibitions**: Fairs (*Shilp Samagam*, *Surajkund Mela*, *Dilli Haat*) with 1-click stall registration.
- **Profile & Analytics**: Personal & bank/UPI details, performance metrics, CSV Sales Report export (`GET /artisan/report`), language switch, and logout.

### 2. 🤝 Cluster Aggregator (`/aggregator/*`)
- **Cluster Dashboard**: Managed cluster overview (*Patan Patola Cluster*), health metrics (*Total Artisans, Active Listings, Pending KYC, Inquiries*), and unlisted artisans needing support list.
- **Assisted Onboarding**: Field registration modal for low-literacy artisans (`POST /aggregator/artisans/onboard`).
- **My Artisans Roster**: Searchable list with status filters (*All, Verified, Pending, Needs Help*) and "Assist" studio launcher.
- **Cluster Analytics**: Craft distribution progress bars and 30-day inquiry volume trends.
- **Alerts & Reporting**: Broadcast MoSJE scheme alerts to cluster artisans via SMS (`POST /aggregator/schemes/relay`), and submit monthly progress reports to MoSJE Admin (`POST /aggregator/reports/submit`).

### 3. 🛍️ B2B Enterprise Buyer (`/buyer/*`)
- **Discover Marketplace**: Multi-criteria keyword search, craft category filter chips, and 2-column product grid with B2B wholesale prices and minimum order quantities (`GET /products`).
- **Product Detail**: Full image gallery, English/Hindi toggle, wholesale margin calculator, artisan credentials with verified badge, and "Send Bulk Inquiry" CTA.
- **Inquiry Drawer**: Quantity selector, pre-filled RFQ note, and submission to artisan (`POST /inquiries`).
- **My Inquiries**: Sent wholesale inquiries tracking (*Pending*, *Responded*, *Completed*).
- **Buyer Profile**: Company details, MoSJE verified buyer badge, and procurement metrics.

---

## 📁 Directory Structure

```
learningdart/lib/
├── main.dart                                # Initializes WidgetsBinding, SharedPreferences, Riverpod ProviderScope
├── app.dart                                 # MaterialApp.router with RestartWidget, 8-language localization & AppTheme
├── core/
│   ├── theme/                               # AppTheme, AppColors (#2E4057, #F4A226, #F8F7F2), AppTextStyles (Noto Sans)
│   ├── router/                              # GoRouter with auth state guards, ShellRoutes for Artisan, Aggregator & Buyer
│   ├── network/                             # DioClient, AuthInterceptor (JWT injection & 401 refresh), ApiEndpoints, ApiClient
│   ├── storage/                             # LocalStorage (FlutterSecureStorage for tokens, SharedPreferences for language/prefs)
│   └── l10n/                                # 8 ARB files (en, hi, bn, ta, te, mr, kn, gu) & generated AppLocalizations
├── features/
│   ├── onboarding/                          # 8-language picker, Splash welcome, Role selection, Phone entry, OTP, 7-step Registration
│   ├── auth/                                # Login screen, AuthNotifier state machine
│   ├── artisan/                             # Shell (4 tabs), Home, 4-Phase AI Camera Studio, Catalogue, Inquiries, Exhibitions, Profile
│   ├── aggregator/                          # Shell (4 tabs), Cluster Dashboard, My Artisans, Cluster Analytics, Alerts & Reporting
│   ├── buyer/                               # Shell (3 tabs), B2B Discover Marketplace, Product Detail, My Inquiries, Buyer Profile
│   └── shared/                              # Notifications & Government Alert Center
└── shared/
    ├── widgets/                             # AppButton (56px min tap target), AppCard, AppTextField, StatusBadge, ShimmerLoader, EmptyState
    ├── models/                              # UserModel, ProductModel, InquiryModel, ClusterModel, ExhibitionModel, GovtSchemeModel
    └── providers/                           # LocaleNotifier, AuthNotifier, ApiClientProvider
```

---

## 🚀 Getting Started & Setup

### 1. Prerequisites
- **Flutter SDK**: `>= 3.11.0`
- **Dart SDK**: `>= 3.11.0`
- **Android Studio / Xcode** (with Android Emulator or connected physical device)
- **FastAPI Backend Server** running on `http://localhost:8000`

### 2. Installation

1. Navigate to the `learningdart` project directory:
   ```bash
   cd learningdart
   ```

2. Install all required dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

4. Verify code quality (zero issues):
   ```bash
   flutter analyze
   ```

---

## 💻 How to Run

### Run on Android Emulator
```bash
flutter run
```

*(Note: In Android Emulator, `http://10.0.2.2:8000` maps automatically to your host machine's `localhost:8000`)*

### Run on Web
```bash
flutter run -d chrome
```

### Run on Physical Device
Ensure your phone and computer are on the same Wi-Fi network and update `ApiEndpoints.baseUrl` in `lib/core/network/api_endpoints.dart` to your computer's local IP address (e.g., `http://192.168.1.X:8000`).

---

## 🧪 Testing & Validation

Run the static analyzer:
```bash
flutter analyze
```
Expected output:
```
Analyzing learningdart...
No issues found!
```

---

## 🏛️ Ministry Mandate

Developed for the **Ministry of Social Justice and Empowerment (MoSJE)** under **Smart India Hackathon (SIH26090)** to eliminate digital barriers and deliver direct market access to master artisans, handloom weavers, and micro-entrepreneurs across India.
