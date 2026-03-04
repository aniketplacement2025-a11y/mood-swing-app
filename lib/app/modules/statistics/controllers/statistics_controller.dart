import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';

class StatisticsController extends GetxController {
  final StorageService _storage = StorageService.to;

  final allEntries = <MoodEntry>[].obs;
  
  // Statistics Data
  final moodCounts = <String, int>{}.obs;
  final weeklyAverages = <double>[].obs; // Index 0-6 for Mon-Sun or last 7 days
  final topTags = <String>[].obs;
  final averageIntensity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    processData();
    _storage.moodBox.watch().listen((_) => processData());
  }

  void processData() {
    final entries = _storage.moodBox.values.toList();
    allEntries.value = entries;

    if (entries.isEmpty) return;

    // 1. Mood Distribution
    final counts = <String, int>{};
    double totalIntensity = 0;
    final tagCounts = <String, int>{};

    for (var entry in entries) {
      counts[entry.emotion] = (counts[entry.emotion] ?? 0) + 1;
      totalIntensity += entry.intensity;
      
      for (var tag in entry.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    moodCounts.value = counts;
    averageIntensity.value = totalIntensity / entries.length;

    // 2. Top Tags
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topTags.value = sortedTags.take(3).map((e) => e.key).toList();

    // 3. Weekly Trends (Last 7 days)
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
    final weeklyAvgs = <double>[];

    for (var date in last7Days) {
      final dayEntries = entries.where((e) => 
        e.date.year == date.year && e.date.month == date.month && e.date.day == date.day
      ).toList();

      if (dayEntries.isEmpty) {
        weeklyAvgs.add(0.0);
      } else {
        final avg = dayEntries.map((e) => e.intensity).reduce((a, b) => a + b) / dayEntries.length;
        weeklyAvgs.add(avg);
      }
    }
    weeklyAverages.value = weeklyAvgs;
  }

  Color getMoodColor(String emotion) {
    switch (emotion) {
      case 'Happy': return AppColors.moodHappy;
      case 'Calm': return AppColors.moodCalm;
      case 'Energetic': return AppColors.moodEnergetic;
      case 'Grateful': return AppColors.moodGrateful;
      case 'Sad': return AppColors.moodSad;
      case 'Anxious': return AppColors.moodAnxious;
      case 'Angry': return AppColors.moodAngry;
      case 'Stressed': return AppColors.moodStressed;
      default: return AppColors.primary;
    }
  }
}
