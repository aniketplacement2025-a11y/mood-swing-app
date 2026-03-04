import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_entry.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late Box<MoodEntry> _moodBox;
  late Box _settingsBox;

  Box<MoodEntry> get moodBox => _moodBox;
  Box get settingsBox => _settingsBox;

  Future<StorageService> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(MoodEntryAdapter());

    // Open Boxes
    _moodBox = await Hive.openBox<MoodEntry>('moods');
    _settingsBox = await Hive.openBox('settings');

    return this;
  }
}
