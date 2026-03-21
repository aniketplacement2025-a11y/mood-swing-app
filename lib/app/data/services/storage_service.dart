import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_entry.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  // Imp
  late GetStorage _box;

  late Box<MoodEntry> _moodBox;
  late Box _settingsBox;

  Box<MoodEntry> get moodBox => _moodBox;
  Box get settingsBox => _settingsBox;

  Future<StorageService> init() async {
    await Hive.initFlutter();

    //imp
    await GetStorage.init();
    _box = GetStorage();

    // Register Adapters
    Hive.registerAdapter(MoodEntryAdapter());

    // Open Boxes
    _moodBox = await Hive.openBox<MoodEntry>('moods');
    _settingsBox = await Hive.openBox('settings');

    return this;
  }

  // Token Management
  String? getToken() => _box.read('token');
  void setToken(String token) => _box.write('token', token);
  void removeToken() => _box.remove('token');

  // Language Management
  String? getLanguage() => _box.read('language');
  void setLanguage(String language) => _box.write('language', language);

  // Theme Management
  bool isDarkMode() => _box.read('darkMode') ?? false;
  void setDarkMode(String value) => _box.write('darkMode', value);

  // Generic Storage Methods
  T? read<T>(String key) => _box.read(key);
  void write<T>(String key, T value) => _box.write(key, value);
  void remove(String key) => _box.remove(key);
  void clear() => _box.erase();
}
