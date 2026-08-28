import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/cluster_model.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../auth/providers/auth_provider.dart';

// ── Language model ──────────────────────────────────────────────────────────
class _LangOption {
  final String code;
  final String native;
  final String english;
  const _LangOption(this.code, this.native, this.english);
}

const _languages = [
  _LangOption('en', 'English', 'English'),
  _LangOption('hi', 'हिंदी', 'Hindi'),
  _LangOption('bn', 'বাংলা', 'Bengali'),
  _LangOption('ta', 'தமிழ்', 'Tamil'),
  _LangOption('te', 'తెలుగు', 'Telugu'),
  _LangOption('mr', 'मराठी', 'Marathi'),
  _LangOption('kn', 'ಕನ್ನಡ', 'Kannada'),
  _LangOption('gu', 'ગુજરાતી', 'Gujarati'),
];

// ── Craft options ────────────────────────────────────────────────────────────
const _crafts = [
  {'name': 'Textiles & Handloom', 'emoji': '🧵'},
  {'name': 'Clay & Pottery', 'emoji': '🏺'},
  {'name': 'Jewelry & Silver', 'emoji': '💎'},
  {'name': 'Woodwork & Inlay', 'emoji': '🪵'},
  {'name': 'Folk Paintings', 'emoji': '🎨'},
  {'name': 'Metal Craft', 'emoji': '🔨'},
  {'name': 'Bamboo & Cane', 'emoji': '🎋'},
  {'name': 'Leather Craft', 'emoji': '👞'},
];

// ── Indian states ────────────────────────────────────────────────────────────
const _states = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
  'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
  'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
  'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
  'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
  'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Puducherry',
];

/// Steps:
///  1 → Language
///  2 → Personal Details (name, phone, aadhaar)
///  3 → OTP Verification
///  4 → Role
///  5 → Craft type (Artisan only)
///  6 → Location + Cluster setup (Aggregator extra section)
///  7 → Password
///  8 → Success
class RegistrationWizardScreen extends ConsumerStatefulWidget {
  const RegistrationWizardScreen({super.key});

  @override
  ConsumerState<RegistrationWizardScreen> createState() => _RegistrationWizardScreenState();
}

class _RegistrationWizardScreenState extends ConsumerState<RegistrationWizardScreen> {
  int _step = 2;
  static const int _totalSteps = 7; // visible numbered steps (not counting success)

  
  // ── OTP State ─────────────────────────────────────────────────────────────
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;

  // ── Form state ───────────────────────────────────────────────────────────
  String _langCode = 'en';
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  String _role = 'Artisan';
  String _craft = '';
  String _state = '';
  String _district = '';
  final _districtCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // ── Cluster state (Aggregator) ────────────────────────────────────────────
  String _clusterMode = 'join'; // 'join' | 'create'
  List<ClusterModel> _availableClusters = [];
  bool _loadingClusters = false;
  String? _selectedClusterId;
  final _clusterNameCtrl = TextEditingController();
  final _clusterCraftCtrl = TextEditingController();

  // ── Submission ────────────────────────────────────────────────────────────
  bool _submitting = false;
  String? _error;

  int _resendTimer = 60;
  Timer? _timer;

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger rebuilds when name/phone change so Continue button re-evaluates
    _nameCtrl.addListener(() => setState(() {}));
    _phoneCtrl.addListener(() => setState(() {}));
    _passwordCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _aadhaarCtrl.dispose();
    _districtCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _clusterNameCtrl.dispose();
    _clusterCraftCtrl.dispose();
    super.dispose();
  }

  void _goStep(int s) => setState(() {
        _step = s;
        _error = null;
      });

  void _next() {
    _error = null;
    if (_step == 4) {
      // After role: Artisan → step 4 (craft), others → step 5 (location)
      setState(() => _step = _role == 'Artisan' ? 5 : 6);
    } else if (_step == 6) {
      setState(() => _step = 6);
      if (_role == 'Aggregator') _loadClusters();
    } else {
      setState(() => _step++);
    }

    // Load clusters when entering step 5 as Aggregator
    if (_step == 6 && _role == 'Aggregator') _loadClusters();
  }

  void _prev() {
    _error = null;
    if (_step == 6) {
      setState(() => _step = _role == 'Artisan' ? 5 : 4);
    } else if (_step > 2) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  Future<void> _loadClusters() async {
    if (_loadingClusters) return;
    setState(() => _loadingClusters = true);
    try {
      final api = ref.read(apiClientProvider);
      final clusters = await api.getClustersUnassigned();
      setState(() => _availableClusters = clusters);
    } catch (_) {
      setState(() => _availableClusters = []);
    } finally {
      setState(() => _loadingClusters = false);
    }
  }

  Future<void> _submit() async {
    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    if (_passwordCtrl.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final phone = _phoneCtrl.text.trim();
      final name = _nameCtrl.text.trim();

      // 1. Register user
      await api.register(
        username: phone,
        password: _passwordCtrl.text,
        role: _role,
        preferredLang: _langCode,
        craftType: _craft.isNotEmpty ? _craft : null,
        region: _state.isNotEmpty ? _state : null,
        aadhaarNumber: _aadhaarCtrl.text.trim().isNotEmpty ? _aadhaarCtrl.text.trim() : null,
      );

      // 2. Login & persist session
      final loginRes = await api.login(username: phone, password: _passwordCtrl.text);
      await ref.read(authProvider.notifier).loginWithSession(
            token: loginRes['access_token'] ?? '',
            role: _role,
            fullName: name,
            phone: phone,
            isVerified: false,
          );

      // 3. Handle cluster for Aggregator
      if (_role == 'Aggregator') {
        if (_clusterMode == 'join' && _selectedClusterId != null) {
          try {
            await api.joinCluster(_selectedClusterId!);
          } catch (e) {
            // Non-fatal — cluster join fails don't block registration
          }
        } else if (_clusterMode == 'create' && _clusterNameCtrl.text.trim().isNotEmpty) {
          try {
            await api.createCluster(
              clusterName: _clusterNameCtrl.text.trim(),
              state: _state,
              district: _districtCtrl.text.trim(),
              craftSpecialization: _clusterCraftCtrl.text.trim().isNotEmpty
                  ? _clusterCraftCtrl.text.trim()
                  : _craft.isNotEmpty ? _craft : 'General Crafts',
            );
          } catch (e) {
            // Non-fatal
          }
        }
      }

      // 4. Success screen
      setState(() => _step = 8);
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _step == 8
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _prev,
              ),
              title: const Text('Create Account'),
              elevation: 0,
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (_step < 8) _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: _buildStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> _sendOtp() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.length != 10) return;
    setState(() { _submitting = true; _error = null; });
    try {
      await ref.read(apiClientProvider).sendOtp(phone);
      setState(() { _otpSent = true; _step = 3; });
      _startResendTimer();
    } catch (e) {
      setState(() => _error = 'Failed to send OTP.');
    } finally {
      setState(() => _submitting = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;
    final phone = _phoneCtrl.text.trim();
    if (phone.length != 10) return;
    try {
      await ref.read(apiClientProvider).sendOtp(phone);
      _startResendTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      }
    } catch (e) {
      setState(() => _error = 'Failed to resend OTP.');
    }
  }


  Future<void> _verifyOtp() async {
    final otp = _otpCtrl.text.trim();
    if (otp.length < 4) return;
    setState(() { _submitting = true; _error = null; });
    try {
      final res = await ref.read(apiClientProvider).verifyOtp(_phoneCtrl.text.trim(), otp);
      if (res['is_registered'] == true) {
        // User already registered
        await ref.read(authProvider.notifier).loginWithSession(
          token: res['access_token'] ?? '',
          role: res['role'] ?? 'Artisan',
          phone: _phoneCtrl.text.trim(),
          isVerified: true,
          fullName: 'Welcome Back'
        );
        // Let GoRouter redirect based on auth provider state
      } else {
        setState(() => _step = 4);
      }
    } catch (e) {
      setState(() => _error = 'Invalid OTP');
    } finally {
      setState(() => _submitting = false);
    }
  }

  Widget _buildProgressBar() {
    final visibleStep = _step.clamp(1, _totalSteps);
    return Column(
      children: [
        LinearProgressIndicator(
          value: visibleStep / _totalSteps,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          minHeight: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $visibleStep of $_totalSteps',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${((visibleStep / _totalSteps) * 100).toInt()}% done',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1: return _step1Language();
      case 2: return _step2Details();
      case 3: return _step3Otp();
      case 4: return _step4Role();
      case 5: return _step5Craft();
      case 6: return _step6Location();
      case 7: return _step7Password();
      case 8: return _step8Success();
      default: return const SizedBox.shrink();
    }
  }

  // ── Step 1: Language ───────────────────────────────────────────────────────
  Widget _step1Language() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🌐 Choose your Language',
            style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('अपनी भाषा चुनें · Select your preferred language',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: _languages.length,
          itemBuilder: (ctx, i) {
            final lang = _languages[i];
            final sel = _langCode == lang.code;
            return InkWell(
              onTap: () {
                setState(() => _langCode = lang.code);
                ref.read(localeProvider.notifier).setLocale(lang.code);
                _next();
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppColors.primary : AppColors.border,
                    width: sel ? 2.5 : 1,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(lang.native,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 19,
                        color: sel ? Colors.white : AppColors.textPrimary,
                      )),
                  const SizedBox(height: 3),
                  Text(lang.english,
                      style: AppTextStyles.caption.copyWith(
                        color: sel ? Colors.white70 : AppColors.textSecondary,
                        fontSize: 12,
                      )),
                ]),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancel',
                style: AppTextStyles.button.copyWith(color: AppColors.textSecondary)),
          ),
        ),
      ],
    );
  }

  // ── Step 2: Personal Details ───────────────────────────────────────────────
  Widget _step2Details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('👤 Your Details', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('This appears on your verified profile and artisan certificate.',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 24),
        AppTextField(
          controller: _nameCtrl,
          label: 'Full Name *',
          hint: 'e.g. Ramesh Kumar',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        // Phone with +91 prefix
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mobile Number *',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: Text('🇮🇳 +91',
                    style: AppTextStyles.heading.copyWith(fontSize: 16)),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: AppTextStyles.heading.copyWith(fontSize: 18, letterSpacing: 1.5),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        AppTextField(
          controller: _aadhaarCtrl,
          label: 'Aadhaar Number (optional · for faster KYC)',
          hint: '12-digit Aadhaar number',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 32),
        AppButton(
          label: _submitting ? 'Sending...' : 'Send OTP',
          isLoading: _submitting,
          onPressed: _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.length == 10
              ? _sendOtp
              : null,
        ),
      ],
    );
  }

  // ── Step 3: Role ───────────────────────────────────────────────────────────
  
  // ── Step 3: OTP Verification ─────────────────────────────────────────────
  Widget _step3Otp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('💬 Verify your Phone', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('We sent a code to +91 ${_phoneCtrl.text.trim()}',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 24),
        AppTextField(
          controller: _otpCtrl,
          label: 'Enter OTP *',
          hint: '123456',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.message_outlined,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
        ],
        const SizedBox(height: 16),
        Center(
          child: _resendTimer > 0
              ? Text('Resend OTP in $_resendTimer s', style: AppTextStyles.caption)
              : TextButton(
                  onPressed: _resendOtp,
                  child: Text('Resend OTP',
                      style: AppTextStyles.button.copyWith(color: AppColors.primary, decoration: TextDecoration.underline)),
                ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Verify OTP',
          isLoading: _submitting,
          onPressed: _otpCtrl.text.length >= 4 ? _verifyOtp : null,
        ),
      ],
    );
  }

  Widget _step4Role() {
    final roles = [
      {'role': 'Artisan', 'emoji': '🎨', 'desc': 'I make and sell handcrafted products'},
      {'role': 'Aggregator', 'emoji': '🤝', 'desc': 'I manage a cluster or cooperative of artisans'},
      {'role': 'Buyer', 'emoji': '🛍️', 'desc': 'I want to discover and purchase authentic crafts'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🎭 What is your role?', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('Choose the role that best describes you.',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 24),
        ...roles.map((r) {
          final sel = _role == r['role'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _role = r['role']!),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppColors.primary : AppColors.border,
                    width: sel ? 2.5 : 1,
                  ),
                ),
                child: Row(children: [
                  Text(r['emoji']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r['role']!,
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 17,
                            color: sel ? AppColors.primary : AppColors.textPrimary,
                          )),
                      const SizedBox(height: 3),
                      Text(r['desc']!,
                          style: AppTextStyles.caption.copyWith(fontSize: 13, height: 1.3)),
                    ]),
                  ),
                  Icon(
                    sel ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: sel ? AppColors.primary : AppColors.textDisabled,
                  ),
                ]),
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        AppButton(label: 'Continue', onPressed: _next),
      ],
    );
  }

  // ── Step 4: Craft Type ─────────────────────────────────────────────────────
  Widget _step5Craft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🧵 What do you make?', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('Select your primary craft tradition.',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _crafts.length,
          itemBuilder: (ctx, i) {
            final c = _crafts[i];
            final sel = _craft == c['name'];
            return InkWell(
              onTap: () => setState(() => _craft = c['name']!),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? AppColors.primary : AppColors.border),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(c['emoji']!, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text(c['name']!,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
            );
          },
        ),
        const SizedBox(height: 28),
        AppButton(
          label: 'Continue',
          onPressed: _craft.isNotEmpty ? _next : null,
        ),
      ],
    );
  }

  // ── Step 5: Location + Cluster ─────────────────────────────────────────────
  Widget _step6Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📍 Where are you located?', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 20),
        // State dropdown
        Text('State *', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _dropdown(
          value: _state.isEmpty ? null : _state,
          items: _states,
          hint: 'Select State',
          onChanged: (v) => setState(() => _state = v ?? ''),
        ),
        const SizedBox(height: 16),
        // District
        AppTextField(
          controller: _districtCtrl,
          label: 'District *',
          hint: 'e.g. Varanasi',
          prefixIcon: Icons.location_on_outlined,
        ),

        // ── Aggregator Cluster Setup ─────────────────────────────────────
        if (_role == 'Aggregator') ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🏘️ Cluster Setup',
                  style: AppTextStyles.heading.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text('Join an existing cluster or create a new one.',
                  style: AppTextStyles.caption.copyWith(fontSize: 13)),
              const SizedBox(height: 14),

              // Toggle buttons
              Row(children: [
                Expanded(
                  child: _clusterToggle(
                    label: 'Join Existing',
                    icon: Icons.group_add_outlined,
                    active: _clusterMode == 'join',
                    onTap: () => setState(() => _clusterMode = 'join'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _clusterToggle(
                    label: 'Create New',
                    icon: Icons.add_circle_outline,
                    active: _clusterMode == 'create',
                    onTap: () => setState(() => _clusterMode = 'create'),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // Join mode
              if (_clusterMode == 'join') ...[
                if (_loadingClusters)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_availableClusters.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'No unassigned clusters available right now.\nSwitch to "Create New" to set up your own cluster.',
                      style: AppTextStyles.caption.copyWith(fontSize: 13, height: 1.4),
                    ),
                  )
                else ...[
                  Text('Select a cluster to manage:',
                      style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  _dropdown(
                    value: _selectedClusterId,
                    items: _availableClusters.map((c) => c.id).toList(),
                    displayItems: _availableClusters
                        .map((c) => '${c.clusterName} — ${c.state}')
                        .toList(),
                    hint: 'Choose a cluster',
                    onChanged: (v) => setState(() => _selectedClusterId = v),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'These clusters were created by MoSJE Admin with no assigned aggregator.',
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                  ),
                ],
              ],

              // Create mode
              if (_clusterMode == 'create') ...[
                AppTextField(
                  controller: _clusterNameCtrl,
                  label: 'Cluster Name *',
                  hint: 'e.g. Varanasi Silk Weaver Cluster',
                  prefixIcon: Icons.hub_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _clusterCraftCtrl,
                  label: 'Craft Specialization',
                  hint: 'e.g. Silk Handloom',
                  prefixIcon: Icons.category_outlined,
                ),
              ],
            ]),
          ),
        ],

        const SizedBox(height: 28),
        AppButton(
          label: 'Continue',
          onPressed: _state.isNotEmpty && _districtCtrl.text.trim().isNotEmpty ? _next : null,
        ),
      ],
    );
  }

  // ── Step 6: Password ───────────────────────────────────────────────────────
  Widget _step7Password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🔒 Create a Password', style: AppTextStyles.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('Use at least 6 characters with a mix of letters and numbers.',
            style: AppTextStyles.caption.copyWith(fontSize: 13)),
        const SizedBox(height: 24),

        // Password
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Password *', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePass,
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 16),

        // Confirm Password
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Confirm Password *', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _confirmCtrl.text.isNotEmpty && _confirmCtrl.text != _passwordCtrl.text
                    ? AppColors.error
                    : AppColors.border,
              ),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  onChanged: (_) => setState(() {}),
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ]),
          ),
          if (_confirmCtrl.text.isNotEmpty && _confirmCtrl.text != _passwordCtrl.text)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Passwords do not match',
                  style: AppTextStyles.caption.copyWith(color: AppColors.error, fontSize: 12)),
            ),
        ]),

        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error)),
        ],

        const SizedBox(height: 32),
        AppButton(
          label: 'Finish & Sign In',
          isLoading: _submitting,
          onPressed: _passwordCtrl.text.length >= 6 &&
                  _passwordCtrl.text == _confirmCtrl.text &&
                  !_submitting
              ? _submit
              : null,
        ),
      ],
    );
  }

  // ── Step 7: Success ────────────────────────────────────────────────────────
  Widget _step8Success() {
    final dashRoute = _role == 'Aggregator'
        ? '/aggregator/home'
        : _role == 'Buyer'
            ? '/buyer/home'
            : '/artisan/home';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 40),
          const Text('🎉', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text('Welcome to KalaSetu!', style: AppTextStyles.display.copyWith(fontSize: 26)),
          const SizedBox(height: 12),
          Text(
            _role == 'Artisan'
                ? 'Your profile is under verification. You can list products once approved.'
                : _role == 'Aggregator'
                    ? 'Your cluster dashboard is ready. Start onboarding artisans!'
                    : 'Explore authentic Indian handicrafts on the marketplace.',
            style: AppTextStyles.caption.copyWith(fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          AppButton(
            label: 'Go to Dashboard →',
            onPressed: () => context.go(dashRoute),
          ),
        ]),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _dropdown({
    required String? value,
    required List<String> items,
    List<String>? displayItems,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    final display = displayItems ?? items;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: AppTextStyles.caption),
          items: List.generate(items.length, (i) {
            return DropdownMenuItem(value: items[i], child: Text(display[i]));
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _clusterToggle({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: active ? Colors.white : AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ]),
      ),
    );
  }
}
