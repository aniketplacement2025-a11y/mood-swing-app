import 'package:get/get.dart';
import '../../home/bindings/home_binding.dart';
import '../../home/views/home_view.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Using simple obs variables for UI state
  final isLogin = true.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Mock Authentication Methods
  Future<void> loginWithEmail() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate network request
    isLoading.value = false;
    
    // Navigate to Home
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> signUpWithEmail() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate network request
    isLoading.value = false;
    
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.offAllNamed(Routes.HOME);
  }
}
