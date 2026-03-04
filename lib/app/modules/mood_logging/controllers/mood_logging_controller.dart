import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/services/storage_service.dart';

class MoodLoggingController extends GetxController {
  final StorageService _storage = StorageService.to;

  // Selected Mood
  final selectedEmotion = ''.obs;
  final intensity = 5.0.obs;
  
  // Tags
  final availableTags = ['Work', 'Family', 'Friends', 'Sleep', 'Exercise', 'Food', 'Hobby', 'Health'].obs;
  final selectedTags = <String>[].obs;

  // Notes
  final notesController = TextEditingController();

  final isLoading = false.obs;

  void selectEmotion(String emotion) {
    selectedEmotion.value = emotion;
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  Future<void> saveMood() async {
    if (selectedEmotion.isEmpty) {
      Get.snackbar('Error', 'Please select a mood first!', 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final entry = MoodEntry(
        id: const Uuid().v4(),
        date: DateTime.now(),
        emotion: selectedEmotion.value,
        intensity: intensity.value,
        notes: notesController.text,
        tags: selectedTags.toList(),
        sleepHours: 0.0, // Default for now
      );

      await _storage.moodBox.add(entry);
      
      Get.back(); // Return to home
      Get.snackbar('Success', 'Mood logged successfully! 🌟', 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save mood: $e', 
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
