import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings ⚙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          Obx(() => SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Easier on the eyes at night'),
            secondary: const Icon(Icons.dark_mode),
            value: controller.isDarkMode.value,
            onChanged: controller.toggleTheme,
          )),
          const Divider(),
          _buildSectionHeader('Notifications'),
          Obx(() => SwitchListTile(
            title: const Text('Daily Reminders'),
            subtitle: const Text('Get nudged to log your mood'),
            secondary: const Icon(Icons.notifications),
            value: controller.notificationsEnabled.value,
            onChanged: controller.toggleNotifications,
          )),
          Obx(() => ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(controller.reminderTime.value.format(context)),
            leading: const Icon(Icons.access_time),
            enabled: controller.notificationsEnabled.value,
            onTap: () => controller.selectTime(context),
          )),
          const Divider(),
          _buildSectionHeader('Data Management'),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Download your history as CSV'),
            leading: const Icon(Icons.file_download),
            onTap: controller.exportData,
          ),
          ListTile(
            title: const Text('Clear All Entries'),
            subtitle: const Text('Permanently delete everything'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: controller.clearAllData,
          ),
          const Divider(),
          _buildSectionHeader('About'),
          ListTile(
            title: const Text('Version'),
            subtitle: Obx(() => Text(controller.appVersion.value)),
            leading: const Icon(Icons.info_outline),
          ),
          const ListTile(
            title: Text('Made with ❤️ for Mental Well-being'),
            leading: Icon(Icons.favorite, color: Colors.pink),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
