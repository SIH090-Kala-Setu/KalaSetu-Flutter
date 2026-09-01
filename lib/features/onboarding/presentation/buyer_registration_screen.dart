import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../auth/providers/auth_provider.dart';

class BuyerRegistrationScreen extends ConsumerStatefulWidget {
  final String phone;

  const BuyerRegistrationScreen({super.key, required this.phone});

  @override
  ConsumerState<BuyerRegistrationScreen> createState() => _BuyerRegistrationScreenState();
}

class _BuyerRegistrationScreenState extends ConsumerState<BuyerRegistrationScreen> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _requirementsController = TextEditingController();
  String _businessType = 'Retailer / Brand';
  bool _isLoading = false;

  final List<String> _businessTypes = [
    'Retailer / Brand',
    'Export House',
    'E-Commerce Marketplace',
    'Government Agency / PSU',
    'Hospitality / Interior Designer',
    'Other Institution',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final username = widget.phone.isNotEmpty ? widget.phone : name.toLowerCase().replaceAll(' ', '_');

      await apiClient.register(
        username: username,
        password: 'Password@123',
        role: 'Buyer',
        fullName: name,
        region: 'Delhi',
      );

      await ref.read(authProvider.notifier).loginWithSession(
        token: 'token_buyer_${DateTime.now().millisecondsSinceEpoch}',
        role: 'Buyer',
        fullName: name,
        phone: widget.phone,
        isVerified: true,
      );

      if (mounted) {
        context.go('/buyer/home');
      }
    } catch (_) {
      await ref.read(authProvider.notifier).loginWithSession(
        token: 'token_buyer_mock',
        role: 'Buyer',
        fullName: name,
        phone: widget.phone,
        isVerified: true,
      );
      if (mounted) {
        context.go('/buyer/home');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('B2B Buyer Registration'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Procurement Profile',
                style: AppTextStyles.display.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Access wholesale bulk prices directly from MoSJE verified artisans and clusters.',
                style: AppTextStyles.caption.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _nameController,
                label: 'Contact Person Name',
                hint: 'e.g. Vikram Singhania',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _companyController,
                label: 'Company / Organization',
                hint: 'e.g. FabCraft Retail Ltd',
                prefixIcon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              Text('Business Type', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
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
                    value: _businessType,
                    items: _businessTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _businessType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                label: 'Business Email',
                hint: 'e.g. procurement@fabcraft.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _requirementsController,
                label: 'Procurement Requirements',
                hint: 'e.g. Looking for Banarasi Silk Sarees & Blue Pottery in 100+ unit quantities',
                maxLines: 3,
              ),
              const SizedBox(height: 36),
              AppButton(
                label: 'Start Procuring on KalaSetu',
                isLoading: _isLoading,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

