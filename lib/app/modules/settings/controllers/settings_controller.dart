import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = StorageService.to;

  // Observables
  final isDarkMode = Get.isDarkMode.obs;
  final notificationsEnabled = true.obs;
  final reminderTime = const TimeOfDay(hour: 20, minute: 0).obs;
  final appVersion = '1.0.0'.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    if (value) {
      Get.snackbar('Reminders Set', 'We\'ll nudge you at ${reminderTime.value.format(Get.context!)}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reminderTime.value,
    );
    if (picked != null && picked != reminderTime.value) {
      reminderTime.value = picked;
      if (notificationsEnabled.value) {
        Get.snackbar('Time Updated', 'New reminder set for ${picked.format(context)}',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> clearAllData() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This will permanently delete all your mood logs. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Clear Everything', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.moodBox.clear();
      Get.offAllNamed('/home'); // Refresh home
      Get.snackbar('Data Cleared', 'All entries have been removed.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void exportData() {
    // Placeholder for actual export logic
    Get.snackbar('Export Started', 'Generating your mood report...', snackPosition: SnackPosition.BOTTOM);
    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar('Success', 'Report saved to Downloads folder (Mock)', snackPosition: SnackPosition.BOTTOM);
    });
  }
}
