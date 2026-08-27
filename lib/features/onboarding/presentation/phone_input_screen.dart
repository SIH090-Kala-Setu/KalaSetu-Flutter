import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class PhoneInputScreen extends StatefulWidget {
  final String role;
  const PhoneInputScreen({super.key, required this.role});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String val) {
    setState(() {
      _isValid = val.length == 10 && int.tryParse(val) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Mobile Number',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'We will send an OTP to verify your number.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: _validatePhone,
                decoration: const InputDecoration(
                  hintText: '10-digit mobile number',
                  prefixText: '+91 ',
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isValid
                    ? () {
                        context.push(
                          '/otp?phone=${_phoneController.text}&role=${widget.role}',
                        );
                      }
                    : null,
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
