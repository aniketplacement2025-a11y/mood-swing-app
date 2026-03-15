import 'package:get/get.dart';
import 'package:collection/collection.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/services/storage_service.dart';

class HomeController extends GetxController {
  final StorageService _storage = StorageService.to;

  // Observables
  final userName = 'Aniket'.obs; // Mock for now
  final currentStreak = 3.obs;
  final recentEntries = <MoodEntry>[].obs;

  // Today's Check-in
  final hasCheckedInToday = false.obs;
  final todayMoodEmoji = '😐'.obs;
  final todayMoodText = 'Neutral'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    // Listen for changes in the mood box to refresh the dashboard
    _storage.moodBox.watch().listen((_) => loadDashboardData());
  }

  void loadDashboardData() {
    final allEntries = _storage.moodBox.values.toList();

    // Sort by date descending
    allEntries.sort((a, b) => b.date.compareTo(a.date));

    // Take recent 5
    recentEntries.value = allEntries.take(5).toList();

    // Check if there's an entry for today
    final now = DateTime.now();
    final todayEntry = allEntries.firstWhereOrNull(
      (e) =>
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day,
    );

    if (todayEntry != null) {
      hasCheckedInToday.value = true;
      todayMoodEmoji.value = _getEmoji(todayEntry.emotion);
      todayMoodText.value = todayEntry.emotion;
    } else {
      hasCheckedInToday.value = false;
    }

    // Calculate streak (basic mock logic or real calculation)
    _calculateStreak(allEntries);
  }

  String _getEmoji(String emotion) {
    switch (emotion) {
      case 'Happy':
        return '😊';
      case 'Calm':
        return '😌';
      case 'Energetic':
        return '⚡';
      case 'Grateful':
        return '🌻';
      case 'Sad':
        return '😢';
      case 'Anxious':
        return '😰';
      case 'Angry':
        return '😡';
      case 'Stressed':
        return '😫';
      default:
        return '😐';
    }
  }

  void _calculateStreak(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      currentStreak.value = 0;
      return;
    }
    // Basic mock streak, real implementation would count consecutive days
    currentStreak.value = entries.length;
  }

  void goToMoodLogging() {
    Get.toNamed(Routes.MOOD_LOGGING);
  }

  void goToCalendar() {
    Get.toNamed(Routes.CALENDAR);
  }

  void goToStatistics() {
    Get.toNamed(Routes.STATISTICS);
  }

  void goToJournal() {
    Get.toNamed(Routes.JOURNAL);
  }

  void goToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }
}
