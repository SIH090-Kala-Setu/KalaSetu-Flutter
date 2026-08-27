# 🎨 कलाSetu (KalaSetu Mobile) | Flutter Frontend

> **AI-Powered Mobile Application for Direct Market Linkage, Multilingual Smart Cataloging, and Governance of Marginalized Artisans, Weavers & Micro-Entrepreneurs**  
> *Under the mandate of the Ministry of Social Justice and Empowerment (MoSJE) | Smart India Hackathon (SIH26090)*

---

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2.svg?style=flat&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/State-Riverpod%203.x-blue.svg?style=flat)
![GoRouter](https://img.shields.io/badge/Router-GoRouter%2017.x-orange.svg?style=flat)
![Languages](https://img.shields.io/badge/Languages-8%20Indic%20Locales-brightgreen.svg?style=flat)
![FastAPI Backend](https://img.shields.io/badge/Backend-FastAPI%20%2B%20PostgreSQL-009688.svg?style=flat&logo=fastapi&logoColor=white)
![Lint](https://img.shields.io/badge/flutter%20analyze-0%20issues-success.svg?style=flat)

</div>

---

## 📌 Table of Contents

1. [Overview & Problem Mandate](#-overview--problem-mandate)
2. [Tech Stack & Architecture](#️-tech-stack--architecture)
3. [Folder Structure](#-folder-structure)
4. [Design System & Accessibility](#-design-system--accessibility)
5. [Multilingual Localization (8 Indian Languages)](#-multilingual-localization-8-indian-languages)
6. [Role-Based Modules & User Journeys](#-role-based-modules--user-journeys)
   - [Artisan Capability Suite](#1--artisan--karigar-suite-artisan)
   - [Cluster Aggregator Suite](#2--cluster-aggregator-suite-aggregator)
   - [B2B Buyer Suite](#3--b2b-enterprise-buyer-suite-buyer)
7. [API Endpoint Client Reference](#-api-endpoint-client-reference)
8. [Backend Configuration & Live PostgreSQL Connection](#-backend-configuration--live-postgresql-connection)
9. [Pre-configured Database Test Accounts](#-pre-configured-database-test-accounts)
10. [Setup & How to Run](#-setup--how-to-run)
11. [Testing & Quality Verification](#-testing--quality-verification)

---

## 📖 Overview & Problem Mandate

- **Problem Statement ID:** SIH26090
- **Mandating Ministry:** Ministry of Social Justice and Empowerment (MoSJE)
- **Target Beneficiaries:** Rural Artisans, Handloom Weavers, Pottery Masters, Tribal Craftsmen, and SHG Micro-Enterprises.

Traditional government exhibitions (**Shilp Samagam**, **Surajkund Mela**, **Dilli Haat**) provide only brief, temporary sales windows. **कलाSetu** provides permanent digital continuity by serving as an autonomous **Virtual Business Manager** on the artisan's mobile device:

* 📸 **Studio AI Enhancement**: Removes cluttered workshop backgrounds and optimizes studio lighting using lightweight edge models.
* 🎙️ **Voice-to-Catalog in Native Tongues**: Transcribes voice recordings in 8 Indian languages and automatically generates bilingual English & Hindi product stories with SEO keywords via Gemini AI.
* 💰 **Dynamic Fair Wage Pricing**: Computes fair hourly compensation (₹150/hr benchmark) and craft category multipliers (1.3× to 2.0×) to prevent middleman exploitation.
* 🛍️ **Direct B2B Linkages**: Connects artisans directly to verified bulk buyers and export houses without commissions.
* 🏛️ **MoSJE Governance & Cluster Aggregation**: Enables field aggregators to onboard illiterate artisans, broadcast welfare schemes, and relay reports to Ministry Administrators.

---

## 🛠️ Tech Stack & Architecture

| Component | Technology | Description |
|:---|:---|:---|
| **Framework** | **Flutter 3.x (Dart 3.x)** | High-performance cross-platform client (Android, iOS, Web, Windows) |
| **State Management** | **Flutter Riverpod 3.x** | Pure functional, reactive state management using `Notifier` and `ProviderScope` |
| **Navigation** | **GoRouter 17.x** | Declarative URL-based routing with role-specific `ShellRoute` bars and auth state redirects |
| **HTTP & Networking** | **Dio 5.x** | Typed HTTP client with dynamic `baseUrl`, request logging, and JWT bearer interceptors |
| **Token Security** | **flutter_secure_storage** | Hardware-backed encrypted keystore/keychain storage for auth tokens |
| **User Preferences** | **shared_preferences** | Persistent locale and offline configuration cache |
| **Typography** | **google_fonts (Noto Sans)** | Unicode-compliant typography rendering all Indic script ligatures cleanly |
| **Localization** | **flutter_localizations & intl** | Native ARB catalogs supporting 8 Indian languages |
| **Camera & Media** | **image_picker, camera** | Native viewfinder capture, torch control, and gallery picker |
| **Image Rendering** | **ProductThumbnail Widget** | Base64 Data URI decoder + remote image caching with error fallbacks |

---

## 📁 Folder Structure

```
learningdart/
├── .gitignore                               # Comprehensive ignore rules (Flutter, Dart, Android, iOS, Windows, macOS)
├── pubspec.yaml                             # Dependencies, assets, and localization declarations
├── l10n.yaml                                # Localization generator configuration
├── README.md                                # Project documentation
├── lib/
│   ├── main.dart                            # Initializes WidgetsBinding, SharedPreferences, Riverpod ProviderScope
│   ├── app.dart                             # MaterialApp.router with RestartWidget, 8-language localization & AppTheme
│   ├── core/
│   │   ├── theme/                           # AppTheme, AppColors, AppTextStyles
│   │   ├── router/                          # AppRouter with role guards and ShellRoutes
│   │   ├── network/                         # DioClient, AuthInterceptor, ApiEndpoints, ApiClient
│   │   ├── storage/                         # LocalStorage (SecureStorage & SharedPrefs wrappers)
│   │   ├── l10n/                            # 8 ARB files (en, hi, bn, ta, te, mr, kn, gu) & generated AppLocalizations
│   │   └── utils/                           # Validators, formatters, and extensions
│   ├── features/
│   │   ├── onboarding/                      # Language picker, Splash welcome, Role selection, OTP, 7-step Registration
│   │   ├── auth/                            # Login screen, AuthNotifier state machine
│   │   ├── artisan/                         # Shell (4 tabs), Home, 4-Phase AI Camera Studio, Catalogue, Inquiries, Exhibitions, Profile
│   │   ├── aggregator/                      # Shell (4 tabs), Cluster Dashboard, My Artisans, Cluster Analytics, Alerts & Reporting
│   │   ├── buyer/                           # Shell (3 tabs), B2B Discover Marketplace, Product Detail, My Inquiries, Buyer Profile
│   │   └── shared/                          # Notifications & Government Alert Center
│   └── shared/
│       ├── widgets/                         # AppButton (56px min tap target), AppCard, AppTextField, ProductThumbnail, StatusBadge, ShimmerLoader
│       ├── models/                          # UserModel, ProductModel, InquiryModel, ClusterModel, ExhibitionModel, GovtSchemeModel
│       └── providers/                       # LocaleNotifier, AuthNotifier, ApiClientProvider
```

---

## 🎨 Design System & Accessibility

* **Palette**:
  * **Primary**: `#2E4057` (Deep Indigo Blue — government authority & trust)
  * **Accent**: `#F4A226` (Warm Saffron / Amber — Indian cultural heritage)
  * **Background**: `#F8F7F2` (Warm Off-White / Natural Canvas — low eye strain)
  * **Surface**: `#FFFFFF` (Card white)
  * **Success**: `#3B8A4F` (Forest Green — verified badge & active status)
  * **Warning**: `#D68910` (Golden Amber — KYC pending)
  * **Error**: `#C0392B` (Terracotta Crimson — sold out / errors)
* **Accessibility Guidelines**:
  * **Minimum 56px Tap Targets** on all interactive touch buttons and input fields.
  * **Iconography + Visual Guides** paired with text labels for low-literacy artisans.
  * **100% Zero Hardcoded Strings** — all text resolves via `AppLocalizations`.

---

## 🌐 Multilingual Localization (8 Indian Languages)

| Language | Script | Locale Code | ARB Resource File |
|:---|:---|:---|:---|
| **English** | Latin | `en` | `lib/core/l10n/app_en.arb` |
| **हिंदी (Hindi)** | Devanagari | `hi` | `lib/core/l10n/app_hi.arb` |
| **বাংলা (Bengali)** | Bengali | `bn` | `lib/core/l10n/app_bn.arb` |
| **தமிழ் (Tamil)** | Tamil | `ta` | `lib/core/l10n/app_ta.arb` |
| **తెలుగు (Telugu)** | Telugu | `te` | `lib/core/l10n/app_te.arb` |
| **मराठी (Marathi)** | Devanagari | `mr` | `lib/core/l10n/app_mr.arb` |
| **ಕನ್ನಡ (Kannada)** | Kannada | `kn` | `lib/core/l10n/app_kn.arb` |
| **ગુજરાતી (Gujarati)** | Gujarati | `gu` | `lib/core/l10n/app_gu.arb` |

---

## 👥 Role-Based Modules & User Journeys

### 1. 🧵 Artisan / Karigar Suite (`/artisan/*`)
- **Bottom Navigation**: `Home` · `Catalogue` · `Inquiries` · `Profile`.
- **Home Dashboard**: Total earnings card, 2x2 quick action grid (*Add Product, My Catalogue, Inquiries, Exhibitions*), recent inquiry cards, and MoSJE verified badge.
- **AI Camera Studio (4-Phase Pipeline)**:
  1. *Capture*: Camera viewfinder with product alignment guide, torch, and gallery import.
  2. *AI Enhance*: Calls `POST /enhance` for background removal & studio lighting + quality score badge (92/100).
  3. *Voice Cataloger*: Voice recording waveform, Gemini AI bilingual translation (`POST /catalog`), and editable fields.
  4. *Dynamic Pricing*: 3-tier price cards (*Minimum*, *Suggested ★*, *Premium*), raw material margin calculator (`POST /suggest-price`), and 1-click publish (`POST /products`).
- **Catalogue Manager**: 2-column grid, status filter chips, inline price editing (`PUT /products/{id}/price`), stock incrementer ($+/-$), and exhibition QR code generator dialog (`GET /products/{id}/qr`).
- **Inquiries**: Wholesale RFQs, message thread modal, and quotation response handler (`POST /inquiries/{id}/respond`).
- **Exhibitions**: National fairs (*Shilp Samagam*, *Surajkund Mela*, *Dilli Haat*) with 1-click digital stall registration.
- **Profile & Reports**: Bank & UPI details editor (`PUT /artisan/profile`), cluster info, and downloadable CSV Sales Report (`GET /artisan/report`).

### 2. 🤝 Cluster Aggregator Suite (`/aggregator/*`)
- **Bottom Navigation**: `Clusters` · `Artisans` · `Analytics` · `Alerts`.
- **Cluster Dashboard**: Health overview (*Total Artisans, Active Listings, Inquiries*), and unlisted artisans needing support list.
- **Assisted Onboarding**: In-field registration modal for illiterate artisans with automatic cluster assignment (`POST /aggregator/artisans/onboard`).
- **My Artisans Roster**: Searchable list with status filters (*All, Verified, Pending, Needs Help*) and "Assist" studio launcher.
- **Cluster Analytics**: Craft distribution progress bars and 30-day inquiry trends (`GET /aggregator/dashboard`).
- **Alerts & Reporting**: Broadcast MoSJE scheme alerts to cluster artisans (`POST /aggregator/schemes/relay`), and submit monthly progress reports to MoSJE Admin (`POST /aggregator/reports/submit`).

### 3. 🛍️ B2B Enterprise Buyer Suite (`/buyer/*`)
- **Bottom Navigation**: `Marketplace` · `My Inquiries` · `Profile`.
- **Discover Marketplace**: Search & filter by craft category, state, material, and price brackets (`GET /products`).
- **Product Detail**: Full image gallery, English/Hindi story toggle, wholesale margin calculator, artisan verified badge, and "Send Bulk Inquiry" drawer (`POST /inquiries`).
- **My Inquiries**: Sent wholesale RFQ tracking with lifecycle status (*Pending*, *Responded*, *Completed*) (`GET /buyer/dashboard`).
- **Buyer Profile**: Company details, verified buyer badge, and procurement metrics.

---

## 📡 API Endpoint Client Reference

All 62+ endpoints are typed and wired in [`ApiClient`](lib/core/network/api_client.dart):

| Module | Method | Endpoint | Description |
|:---|:---|:---|:---|
| **Auth** | `POST` | `/auth/register` | Register Artisan, Buyer, or Aggregator with craft/cluster details |
| | `POST` | `/auth/login` | JWT Bearer token authentication |
| | `GET` | `/auth/me` | Current user profile and KYC status |
| | `POST` | `/auth/send-otp` | Trigger 6-digit SMS OTP |
| | `POST` | `/auth/verify-otp` | Verify OTP code and return auth session |
| **AI Studio** | `POST` | `/enhance` | AI background removal & studio lighting via `u2netp` ONNX |
| | `POST` | `/enhance/batch` | Batch process multiple product photos |
| | `POST` | `/catalog` | Bilingual EN+HI product description generator via Gemini 1.5 Flash |
| | `POST` | `/suggest-price` | Cost-plus fair wage & craft multiplier pricing engine |
| **Products** | `GET` | `/products` | Filter products by craft, state, price, or keyword |
| | `POST` | `/products` | Create listing (routes to Pending Review if unverified) |
| | `GET` | `/products/{id}` | Standalone product details (tracks `ProductView`) |
| | `PUT` | `/products/{id}` | Full product update |
| | `PUT` | `/products/{id}/status` | Update listing status (`Active`, `Draft`, `Sold Out`, `Archived`) |
| | `PUT` | `/products/{id}/stock` | Update inventory stock count |
| | `PUT` | `/products/{id}/price` | Update base price and suggested retail price |
| | `GET` | `/products/{id}/qr` | Generate scannable QR code PNG for exhibition stalls |
| | `DELETE` | `/products/{id}` | Archive / soft-delete listing |
| **Artisan** | `GET` | `/artisan/dashboard` | Artisan statistics, inquiry counters, and upcoming fairs |
| | `GET` | `/artisan/profile` | Full profile with bank account, IFSC, UPI, and cluster |
| | `PUT` | `/artisan/profile` | Update personal and bank settlement details |
| | `GET` | `/artisan/analytics` | Per-product view and inquiry performance |
| | `GET` | `/artisan/report` | Export sales and analytics as downloadable CSV |
| **Aggregator**| `GET` | `/aggregator/dashboard` | Aggregate cluster metrics and unlisted member list |
| | `GET` | `/aggregator/artisans` | Roster of artisans in managed clusters |
| | `POST` | `/aggregator/artisans/onboard` | Field-assisted artisan registration |
| | `POST` | `/aggregator/schemes/relay` | Broadcast scheme alerts to cluster artisans |
| | `POST` | `/aggregator/reports/submit` | Transmit monthly cluster progress report to Admin |
| | `GET` | `/clusters` | List all handicraft clusters |
| | `GET` | `/clusters/my-clusters` | List clusters assigned to aggregator |
| | `GET` | `/clusters/{id}/artisans`| List all members in a cluster |
| | `POST` | `/clusters/{id}/artisans`| Add artisan to cluster |
| **Buyer** | `GET` | `/buyer/dashboard` | Sent inquiry history and AI-matched artisan recommendations |
| | `POST` | `/inquiries` | Submit bulk wholesale quotation request |
| | `GET` | `/inquiries` | Fetch received or sent inquiries |
| | `POST` | `/inquiries/{id}/respond`| Respond to buyer quotation request |
| **Shared** | `GET` | `/notifications` | User notifications and broadcast alerts |
| | `PUT` | `/notifications/{id}/read`| Mark single notification as read |
| | `PUT` | `/notifications/mark-all-read` | Mark all notifications as read |
| | `GET` | `/admin/exhibitions` | List scheduled physical fairs (Shilp Samagam, Surajkund) |
| | `POST` | `/admin/exhibitions/{id}/register` | Register artisan stall for fair |
| | `GET` | `/admin/schemes` | List central & state welfare schemes |

---

## 🔌 Backend Configuration & Live PostgreSQL Connection

The application connects directly to the FastAPI server (`http://127.0.0.1:8000`) and displays live PostgreSQL records.

- **Dynamic Platform Resolution**:
  - **Windows Desktop / Web / iOS**: Resolves to `http://127.0.0.1:8000` (or `http://localhost:8000`).
  - **Android Emulator**: Resolves to `http://10.0.2.2:8000` (automatic host loopback).
  - **Physical Device**: Tap the **⚙️ Server Settings** icon on the Welcome Screen to enter your PC's local Wi-Fi IP (e.g., `http://192.168.1.15:8000`) or run `adb reverse tcp:8000 tcp:8000`.

---

## 🔑 Pre-configured Database Test Accounts

All pre-seeded database accounts use the password: **`asdfghjkl`**

| Role | Username / Phone | Password | Access / Scope |
|:---|:---|:---|:---|
| **Artisan** | `1234567890` | `asdfghjkl` | MoSJE Verified Artisan (`Handicrafts`, active listings, live inquiries) |
| **Artisan** | `8595630567` | `asdfghjkl` | Registered Artisan |
| **Aggregator** | `1234` | `asdfghjkl` | Cluster Aggregator (`Co-op Cluster`, assisted onboarding, relay) |
| **B2B Buyer** | `123` | `asdfghjkl` | Verified Enterprise Buyer |
| **B2B Buyer** | `pkgirpade` | `asdfghjkl` | Registered Buyer |
| **Admin** | `admin` | `asdfghjkl` | MoSJE Governance Console |

---

## 💻 Setup & How to Run

### 1. Prerequisites
- **Flutter SDK**: `>= 3.11.0`
- **Dart SDK**: `>= 3.11.0`
- **FastAPI Backend Server**: Running on `http://127.0.0.1:8000` with PostgreSQL

### 2. Installation
```bash
cd learningdart
flutter pub get
flutter gen-l10n
```

### 3. Run on Target Platform
```bash
# Run on Windows Desktop
flutter run -d windows

# Run on Android Emulator
flutter run -d emulator-5554

# Run on Web (Chrome)
flutter run -d chrome
```

---

## 🧪 Testing & Quality Verification

Run the static analyzer to confirm **0 errors, 0 warnings, and 0 lints**:
```bash
flutter analyze
```

Expected output:
```
Analyzing learningdart...
No issues found!
```

---

## 🏛️ Ministry Mandate & Attribution

Developed for the **Ministry of Social Justice and Empowerment (MoSJE)** under **Smart India Hackathon (SIH26090)** to democratize AI technology for rural Indian artisans and handloom weavers.
