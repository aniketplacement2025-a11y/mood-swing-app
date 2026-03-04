import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/services/storage_service.dart';

class JournalController extends GetxController {
  final StorageService _storage = StorageService.to;

  // Observables
  final allEntries = <MoodEntry>[].obs;
  final filteredEntries = <MoodEntry>[].obs;
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
    // Watch for Hive changes
    _storage.moodBox.watch().listen((_) => loadEntries());
    
    // Setup reactive filtering
    everAll([searchQuery, selectedFilter], (_) => applyFilters());
  }

  void loadEntries() {
    allEntries.value = _storage.moodBox.values.toList();
    applyFilters();
  }

  void applyFilters() {
    var result = allEntries.toList();

    // 1. Filter by Search Query (Notes & Tags)
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((e) {
        final matchesNotes = e.notes.toLowerCase().contains(query);
        final matchesTags = e.tags.any((tag) => tag.toLowerCase().contains(query));
        return matchesNotes || matchesTags;
      }).toList();
    }

    // 2. Filter by Emotion
    if (selectedFilter.value != 'All') {
      result = result.where((e) => e.emotion == selectedFilter.value).toList();
    }

    // 3. Sort by Date Descending
    result.sort((a, b) => b.date.compareTo(a.date));

    filteredEntries.value = result;
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> deleteEntry(MoodEntry entry) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('Are you sure you want to remove this mood entry?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true), 
            child: const Text('Delete', style: TextStyle(color: Colors.red))
          ),
        ],
      )
    );

    if (confirmed == true) {
      await entry.delete();
      Get.snackbar('Deleted', 'Mood entry removed successfully.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
