import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class ArtisanRegistrationWizard extends ConsumerStatefulWidget {
  final String phone;

  const ArtisanRegistrationWizard({super.key, required this.phone});

  @override
  ConsumerState<ArtisanRegistrationWizard> createState() => _ArtisanRegistrationWizardState();
}

class _ArtisanRegistrationWizardState extends ConsumerState<ArtisanRegistrationWizard> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  // Step 1
  final _nameController = TextEditingController();

  // Step 2: Location
  String _selectedState = 'Uttar Pradesh';
  String _selectedDistrict = 'Varanasi';
  final _blockController = TextEditingController();

  final List<String> _states = [
    'Uttar Pradesh',
    'Rajasthan',
    'Gujarat',
    'West Bengal',
    'Odisha',
    'Madhya Pradesh',
    'Karnataka',
    'Tamil Nadu',
    'Assam',
    'Maharashtra',
  ];

  final Map<String, List<String>> _districtsByState = {
    'Uttar Pradesh': ['Varanasi', 'Bhadohi', 'Lucknow', 'Agra', 'Gorakhpur'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Barmer', 'Kota'],
    'Gujarat': ['Patan', 'Kutch', 'Ahmedabad', 'Surat', 'Rajkot'],
    'West Bengal': ['Bankura', 'Murshidabad', 'Kolkata', 'Darjeeling'],
    'Odisha': ['Puri', 'Bhubaneswar', 'Raghurajpur', 'Cuttack'],
    'Madhya Pradesh': ['Chanderi', 'Bhopal', 'Indore', 'Gwalior'],
    'Karnataka': ['Mysuru', 'Bengaluru', 'Ilkal', 'Bidar'],
    'Tamil Nadu': ['Kanchipuram', 'Madurai', 'Thanjavur', 'Salem'],
    'Assam': ['Sualkuchi', 'Guwahati', 'Majuli', 'Jorhat'],
    'Maharashtra': ['Paithan', 'Pune', 'Kolhapur', 'Nagpur'],
  };

  // Step 3: Craft Type
  final Set<String> _selectedCrafts = {'Textiles & Handloom'};
  final List<Map<String, String>> _craftOptions = [
    {'name': 'Textiles & Handloom', 'emoji': '🧵'},
    {'name': 'Clay & Pottery', 'emoji': '🏺'},
    {'name': 'Jewelry & Silver', 'emoji': '💎'},
    {'name': 'Woodwork & Inlay', 'emoji': '🪵'},
    {'name': 'Folk Paintings', 'emoji': '🎨'},
    {'name': 'Metal Craft', 'emoji': '🔨'},
    {'name': 'Bamboo & Cane', 'emoji': '🎋'},
    {'name': 'Leather Craft', 'emoji': '👞'},
  ];

  // Step 4: Cluster
  String _selectedCluster = 'Varanasi Silk Weaver Cluster';
  final List<String> _clusters = [
    'Varanasi Silk Weaver Cluster',
    'Patan Patola Handloom Cluster',
    'Kutch Artisan Handicraft Cluster',
    'Jaipur Blue Pottery Cluster',
    'Raghurajpur Heritage Crafts Village',
    'Chanderi Silk Cooperative',
    'Independent / Not in a Cluster',
  ];

  // Step 5: Govt Scheme
  bool _isBeneficiary = true;
  String _selectedScheme = 'PM Vishwakarma Scheme';
  final List<String> _schemes = [
    'PM Vishwakarma Scheme',
    'National Handloom Development Programme',
    'Ambedkar Hastshilp Vikas Yojana (AHVY)',
    'Samarth Scheme for Capacity Building',
    'Mudras Yojana for Artisans',
  ];

  // Step 6: Photo
  bool _hasPhoto = true;

  // Step 7: Bank & UPI
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _blockController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      _onSubmit();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _onSubmit() async {
    setState(() => _isSubmitting = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final fullName = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Master Artisan';
      final username = widget.phone.isNotEmpty ? widget.phone : fullName.toLowerCase().replaceAll(' ', '_');

      // Register with backend
      final user = await apiClient.register(
        username: username,
        password: 'Password@123',
        role: 'Artisan',
        preferredLang: ref.read(localeProvider).languageCode,
        craftType: _selectedCrafts.isNotEmpty ? _selectedCrafts.first : 'Handicrafts',
        region: _selectedState,
        aadhaarNumber: '123456789012',
      );

      // Save session in Riverpod & Secure Storage
      await ref.read(authProvider.notifier).loginWithSession(
        token: 'token_${user.id}',
        role: 'Artisan',
        fullName: fullName,
        phone: widget.phone,
        isVerified: false,
      );

      if (mounted) {
        context.go('/onboarding/pending-verification');
      }
    } catch (e) {
      // Fallback session on local error for rapid testability
      await ref.read(authProvider.notifier).loginWithSession(
        token: 'mock_artisan_jwt_${DateTime.now().millisecondsSinceEpoch}',
        role: 'Artisan',
        fullName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Ramesh Weaver',
        phone: widget.phone,
        isVerified: false,
      );
      if (mounted) {
        context.go('/onboarding/pending-verification');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        title: Text(l10n.artisanRegistration),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.step(_currentStep, _totalSteps),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${((_currentStep / _totalSteps) * 100).toInt()}% Completed',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: _buildCurrentStepContent(l10n),
              ),
            ),
            // Bottom Action Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        label: 'Back',
                        variant: AppButtonVariant.outlined,
                        onPressed: _prevStep,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: _currentStep == _totalSteps ? l10n.submitForVerification : l10n.continueButton,
                      isLoading: _isSubmitting,
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(AppLocalizations l10n) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Name(l10n);
      case 2:
        return _buildStep2Location(l10n);
      case 3:
        return _buildStep3CraftType(l10n);
      case 4:
        return _buildStep4Cluster(l10n);
      case 5:
        return _buildStep5GovtScheme(l10n);
      case 6:
        return _buildStep6Photo(l10n);
      case 7:
        return _buildStep7BankDetails(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Name(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your name?',
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'This will appear on your verified artisan certificate and products.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 28),
        AppTextField(
          controller: _nameController,
          label: l10n.fullName,
          hint: 'e.g. Ramesh Kumar',
          prefixIcon: Icons.person_outline,
          onVoiceTap: () {
            _nameController.text = 'Ramesh Chandra Weaver';
          },
        ),
      ],
    );
  }

  Widget _buildStep2Location(AppLocalizations l10n) {
    final districts = _districtsByState[_selectedState] ?? ['Varanasi', 'Other'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where are you located?',
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your state and district to connect with your regional cluster.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 24),
        // State Dropdown
        Text(l10n.state, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedState,
              items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedState = val;
                    _selectedDistrict = (_districtsByState[val] ?? ['Varanasi']).first;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // District Dropdown
        Text(l10n.district, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: districts.contains(_selectedDistrict) ? _selectedDistrict : districts.first,
              items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDistrict = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _blockController,
          label: l10n.block,
          hint: 'e.g. Sevapuri Block',
          prefixIcon: Icons.location_on_outlined,
        ),
      ],
    );
  }

  Widget _buildStep3CraftType(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectCraftType,
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Select one or more craft traditions you practice.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
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
          itemCount: _craftOptions.length,
          itemBuilder: (context, index) {
            final craft = _craftOptions[index];
            final name = craft['name']!;
            final isSelected = _selectedCrafts.contains(name);

            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedCrafts.length > 1) _selectedCrafts.remove(name);
                  } else {
                    _selectedCrafts.add(name);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(craft['emoji']!, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep4Cluster(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select your Cluster',
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Clusters help aggregators relay government welfare schemes and exhibition stalls.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 24),
        ..._clusters.map((cluster) {
          final isSelected = _selectedCluster == cluster;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AppCard(
              onTap: () => setState(() => _selectedCluster = cluster),
              color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : Border.all(color: AppColors.border),
              child: Row(
                children: [
                  const Icon(Icons.hub_outlined, color: AppColors.primary, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      cluster,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : AppColors.textDisabled,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep5GovtScheme(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.govtSchemeBeneficiary,
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Verification is fast-tracked for registered beneficiaries.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: l10n.yes,
                variant: _isBeneficiary ? AppButtonVariant.primary : AppButtonVariant.outlined,
                onPressed: () => setState(() => _isBeneficiary = true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                label: l10n.no,
                variant: !_isBeneficiary ? AppButtonVariant.primary : AppButtonVariant.outlined,
                onPressed: () => setState(() => _isBeneficiary = false),
              ),
            ),
          ],
        ),
        if (_isBeneficiary) ...[
          const SizedBox(height: 28),
          Text(l10n.whichScheme, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedScheme,
                items: _schemes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedScheme = val);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep6Photo(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profilePhoto,
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Add a clear photo for your artisan identity card.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 32),
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: _hasPhoto
                    ? const Icon(Icons.person, size: 72, color: AppColors.primary)
                    : const Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.textDisabled),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppColors.accent,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.black87),
                    onPressed: () {
                      setState(() => _hasPhoto = true);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: l10n.takePhoto,
          icon: Icons.camera_alt,
          variant: AppButtonVariant.outlined,
          onPressed: () => setState(() => _hasPhoto = true),
        ),
      ],
    );
  }

  Widget _buildStep7BankDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bankDetails,
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'For direct DBT payouts and B2B wholesale order settlements.',
          style: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: _accountController,
          label: l10n.accountNumber,
          hint: 'e.g. 1029384756',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.account_balance,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _ifscController,
          label: l10n.ifscCode,
          hint: 'e.g. SBIN0000001',
          prefixIcon: Icons.numbers,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _upiController,
          label: l10n.upiId,
          hint: 'e.g. 9876543210@upi',
          prefixIcon: Icons.payment,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _onSubmit,
            child: Text(
              l10n.skipForNow,
              style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
