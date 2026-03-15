import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/animation_utils.dart';
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
            FadeInSlide(
              child: Text(
                'Select Mood',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FadeInSlide(
              delay: const Duration(milliseconds: 100),
              child: _buildMoodGrid(),
            ),

            const SizedBox(height: 32),

            Text(
              'Intensity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FadeInSlide(
              delay: const Duration(milliseconds: 250),
              child: Obx(
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
            ),

            const SizedBox(height: 32),

            FadeInSlide(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Tags',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            FadeInSlide(
              delay: const Duration(milliseconds: 350),
              child: Obx(
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
            ),

            const SizedBox(height: 32),

            FadeInSlide(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Notes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            FadeInSlide(
              delay: const Duration(milliseconds: 450),
              child: TextField(
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
            ),

            const SizedBox(height: 48),

            FadeInSlide(
              delay: const Duration(milliseconds: 500),
              child: Obx(
                () => ScaleButton(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.saveMood,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF8A84FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
          return ScaleButton(
            onTap: () => controller.selectEmotion(mood['label'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
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
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (mood['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: isSelected ? 1.2 : 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          mood['emoji'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                      );
                    },
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
