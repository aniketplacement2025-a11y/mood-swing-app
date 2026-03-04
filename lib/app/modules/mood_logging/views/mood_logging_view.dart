import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/mood_logging_controller.dart';

class MoodLoggingView extends GetView<MoodLoggingController> {
  const MoodLoggingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How are you? 🎭'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Mood',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMoodGrid(),

            const SizedBox(height: 32),

            Text(
              'Intensity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: [
                  Slider(
                    value: controller.intensity.value,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: controller.intensity.value.round().toString(),
                    activeColor: AppColors.primary,
                    onChanged: (value) => controller.intensity.value = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mild',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Intense',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Tags',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableTags.map((tag) {
                  final isSelected = controller.selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => controller.toggleTag(tag),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Notes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ),

            const SizedBox(height: 48),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.saveMood,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Entry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodGrid() {
    final moods = [
      {'label': 'Happy', 'emoji': '😊', 'color': AppColors.moodHappy},
      {'label': 'Calm', 'emoji': '😌', 'color': AppColors.moodCalm},
      {'label': 'Energetic', 'emoji': '⚡', 'color': AppColors.moodEnergetic},
      {'label': 'Grateful', 'emoji': '🌻', 'color': AppColors.moodGrateful},
      {'label': 'Sad', 'emoji': '😢', 'color': AppColors.moodSad},
      {'label': 'Anxious', 'emoji': '😰', 'color': AppColors.moodAnxious},
      {'label': 'Angry', 'emoji': '😡', 'color': AppColors.moodAngry},
      {'label': 'Stressed', 'emoji': '😫', 'color': AppColors.moodStressed},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        return Obx(() {
          final isSelected = controller.selectedEmotion.value == mood['label'];
          return InkWell(
            onTap: () => controller.selectEmotion(mood['label'] as String),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? (mood['color'] as Color).withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? (mood['color'] as Color)
                      : Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood['emoji'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? (mood['color'] as Color)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
