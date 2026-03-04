import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/mood_entry.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History 🗓️'),
      ),
      body: Column(
        children: [
          _buildCalendar(context),
          const Divider(),
          Expanded(
            child: _buildEntriesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Obx(() => TableCalendar<MoodEntry>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: controller.focusedDay.value,
      selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
      onDaySelected: controller.onDaySelected,
      eventLoader: controller.getEntriesForDay,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: events.take(3).map((event) {
              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  color: _getMoodColor(event.emotion),
                  shape: BoxShape.circle,
                ),
              );
            }).toList(),
          );
        },
      ),
    ));
  }

  Widget _buildEntriesList(BuildContext context) {
    return Obx(() {
      if (controller.selectedDayEntries.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                'No entries for ${DateFormat('MMMM d').format(controller.selectedDay.value)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.selectedDayEntries.length,
        itemBuilder: (context, index) {
          final entry = controller.selectedDayEntries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getMoodColor(entry.emotion).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(_getEmoji(entry.emotion), style: const TextStyle(fontSize: 20)),
                ),
              ),
              title: Text(
                entry.emotion,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.notes.isNotEmpty) 
                    Text(entry.notes, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: entry.tags.map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ),
              trailing: Text(
                DateFormat('h:mm a').format(entry.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              isThreeLine: entry.notes.isNotEmpty || entry.tags.isNotEmpty,
            ),
          );
        },
      );
    });
  }

  Color _getMoodColor(String emotion) {
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

  String _getEmoji(String emotion) {
    switch (emotion) {
      case 'Happy': return '😊';
      case 'Calm': return '😌';
      case 'Energetic': return '⚡';
      case 'Grateful': return '🌻';
      case 'Sad': return '😢';
      case 'Anxious': return '😰';
      case 'Angry': return '😡';
      case 'Stressed': return '😫';
      default: return '😐';
    }
  }
}
