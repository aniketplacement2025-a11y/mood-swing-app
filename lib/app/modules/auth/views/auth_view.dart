import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Logo or App Icon placeholder
              Center(
                child: Icon(
                  Icons.mood,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mood Swing',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your feelings, understand your mind.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),

              // Form fields
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey<bool>(controller.isLogin.value),
                  children: [
                    if (!controller.isLogin.value) ...[
                      _buildTextField(
                        context,
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildTextField(
                      context,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => _buildTextField(
                      context,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: controller.obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondaryLight,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),
                  ],
                ),
              )),
              
              const SizedBox(height: 24),
              
              // Auth Button
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () {
                      if (controller.isLogin.value) {
                        controller.loginWithEmail();
                      } else {
                        controller.signUpWithEmail();
                      }
                    },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        controller.isLogin.value ? 'Sign In' : 'Create Account',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              )),

              const SizedBox(height: 24),

              // Alternative Login
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              OutlinedButton.icon(
                onPressed: controller.isLoading.value ? null : controller.loginWithGoogle,
                icon: const Icon(Icons.login, size: 20), // Placeholder for Google Icon
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.3)),
                ),
              ),

              const SizedBox(height: 32),

              // Toggle Mode
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(
                    controller.isLogin.value 
                        ? "Don't have an account?" 
                        : "Already have an account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  TextButton(
                    onPressed: controller.toggleAuthMode,
                    child: Obx(() => Text(
                      controller.isLogin.value ? 'Sign Up' : 'Sign In',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {
    required String hint, 
    required IconData icon, 
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondaryLight),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
