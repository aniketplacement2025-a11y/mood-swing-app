import 'package:get/get.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/services/storage_service.dart';

class CalendarController extends GetxController {
  final StorageService _storage = StorageService.to;

  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;
  
  // All entries from Hive
  final allEntries = <MoodEntry>[].obs;
  
  // Entries for the selected day
  final selectedDayEntries = <MoodEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
    // Listen for changes in the mood box
    _storage.moodBox.watch().listen((_) => loadEntries());
  }

  void loadEntries() {
    allEntries.value = _storage.moodBox.values.toList();
    updateSelectedDayEntries();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
    updateSelectedDayEntries();
  }

  void updateSelectedDayEntries() {
    selectedDayEntries.value = allEntries.where((entry) => 
      entry.date.year == selectedDay.value.year && 
      entry.date.month == selectedDay.value.month && 
      entry.date.day == selectedDay.value.day
    ).toList();
    
    // Sort by time (though Hive usually preserves insertion order, manual sort is safer)
    selectedDayEntries.sort((a, b) => b.date.compareTo(a.date));
  }

  List<MoodEntry> getEntriesForDay(DateTime day) {
    return allEntries.where((entry) => 
      entry.date.year == day.year && 
      entry.date.month == day.month && 
      entry.date.day == day.day
    ).toList();
  }
}
