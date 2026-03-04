import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/journal_controller.dart';

class JournalView extends GetView<JournalController> {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal History 📔'),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(context),
          Expanded(
            child: _buildEntriesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    final moods = ['All', 'Happy', 'Calm', 'Energetic', 'Grateful', 'Sad', 'Anxious', 'Angry', 'Stressed'];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search notes or tags...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final mood = moods[index];
                return Obx(() {
                  final isSelected = controller.selectedFilter.value == mood;
                  return FilterChip(
                    label: Text(mood),
                    selected: isSelected,
                    onSelected: (_) => controller.setFilter(mood),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context) {
    return Obx(() {
      if (controller.filteredEntries.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text('No entries found matching your criteria.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.filteredEntries.length,
        itemBuilder: (context, index) {
          final entry = controller.filteredEntries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onLongPress: () => controller.deleteEntry(entry),
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.emotion, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    DateFormat('MMM d, h:mm a').format(entry.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(entry.notes),
                  ],
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: entry.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                      )).toList(),
                    ),
                  ],
                ],
              ),
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
