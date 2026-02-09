import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../providers/forgot_password_providers.dart';
import '../providers/forgot_password_state.dart';
import '../viewmodel/forgot_password_viewmodel.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);

    ref.listen(forgotPasswordViewModelProvider, (previous, next) {
      if (next.status == ForgotPasswordStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
      if (next.status == ForgotPasswordStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (state.status == ForgotPasswordStatus.initial || 
                state.status == ForgotPasswordStatus.error && state.email == null)
              _buildEmailStep(viewModel, state),
            if (state.status == ForgotPasswordStatus.otpSent || 
                state.status == ForgotPasswordStatus.error && !state.isOtpVerified && state.email != null)
              _buildOtpStep(viewModel, state),
            if (state.status == ForgotPasswordStatus.otpVerified || 
                state.status == ForgotPasswordStatus.error && state.isOtpVerified)
              _buildResetStep(viewModel, state),
            if (state.status == ForgotPasswordStatus.loading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailStep(ForgotPasswordViewModel viewModel, ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter your email to receive an OTP', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => viewModel.sendOtp(_emailController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Send OTP', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep(ForgotPasswordViewModel viewModel, ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OTP sent to ${state.email}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        TextField(
          controller: _otpController,
          decoration: const InputDecoration(labelText: 'OTP', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => viewModel.verifyOtp(_otpController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Verify OTP', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildResetStep(ForgotPasswordViewModel viewModel, ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reset your password', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_passwordController.text == _confirmPasswordController.text) {
                viewModel.resetPassword(_passwordController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Reset Password', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
