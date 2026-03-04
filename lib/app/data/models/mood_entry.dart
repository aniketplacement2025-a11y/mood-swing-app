import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String emotion; // e.g., 'Happy', 'Sad'

  @HiveField(3)
  final double intensity; // 1 to 10

  @HiveField(4)
  final String notes;

  @HiveField(5)
  final List<String> tags; // e.g., 'Work', 'Family'

  @HiveField(6)
  final double sleepHours;

  @HiveField(7)
  final String? photoPath;

  MoodEntry({
    required this.id,
    required this.date,
    required this.emotion,
    required this.intensity,
    this.notes = '',
    this.tags = const [],
    this.sleepHours = 0.0,
    this.photoPath,
  });
}
