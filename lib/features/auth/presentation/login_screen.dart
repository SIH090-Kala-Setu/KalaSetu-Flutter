import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(
        () => _errorMessage = 'Please enter your username/phone and password',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final res = await apiClient.login(username: username, password: password);

      final token = res['access_token'] ?? '';
      final role = res['role'] ?? 'Artisan';
      final name = res['username'] ?? username;

      await ref
          .read(authProvider.notifier)
          .loginWithSession(
            token: token,
            role: role,
            fullName: name,
            phone: username,
          );

      // Register FCM token with backend after successful login
      await FcmService.instance.init(ref);

      if (mounted) {
        if (role == 'Aggregator') {
          context.go('/aggregator/home');
        } else if (role == 'Buyer') {
          context.go('/buyer/home');
        } else {
          context.go('/artisan/home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: AppTextStyles.display.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                'Log in with your registered phone number or username.',
                style: AppTextStyles.caption.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 32),
              AppTextField(
                controller: _usernameController,
                label: 'Phone Number / Username',
                hint: 'e.g. 9876543210',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 32),
              AppButton(
                label: 'Log In',
                isLoading: _isLoading,
                onPressed: _onLogin,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.push('/onboarding/language');
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
