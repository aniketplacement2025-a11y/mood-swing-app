import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => Text(
          'Hi, ${controller.userName.value} 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )),
        actions: [
          IconButton(
            onPressed: controller.goToSettings,
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        'Hello, ${controller.userName.value} 👋',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
                      )),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, MMMM d').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  _buildStreakBadge(context),
                ],
              ),
              
              const SizedBox(height: 32),

              // Today's Check-in Card
              _buildTodayCard(context),

              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Explore',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.calendar_month,
                      title: 'Calendar',
                      color: AppColors.moodCalm,
                      onTap: controller.goToCalendar,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.bar_chart,
                      title: 'Insights',
                      color: AppColors.moodGrateful,
                      onTap: controller.goToStatistics,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Entries
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Entries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: controller.goToJournal,
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.recentEntries.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No entries yet. Start tracking!'),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recentEntries.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = controller.recentEntries[index];
                    return _buildEntryCard(context, entry);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToMoodLogging,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Track Mood', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.moodHappy.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.moodHappy, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.moodIrritated, size: 20),
          const SizedBox(width: 4),
          Obx(() => Text(
            '${controller.currentStreak.value} Days',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight, // Might need adapting for dark mode
            ).copyWith(color: Theme.of(context).colorScheme.onBackground),
          )),
        ],
      ),
    );
  }

  Widget _buildTodayCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF8A84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(() {
        if (!controller.hasCheckedInToday.value) {
          return Column(
            children: [
              const Text(
                'How are you feeling today?',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.goToMoodLogging,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Log Mood Now'),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Text(
                'Your Mood Today',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                controller.todayMoodEmoji.value,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                controller.todayMoodText.value,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(BuildContext context, entry) {
    // Basic mapping for emoji based on string (just for mock preview)
    String getEmoji(String emotion) {
      if (emotion == 'Happy') return '😊';
      if (emotion == 'Calm') return '😌';
      return '😐';
    }
    
    Color getMoodColor(String emotion) {
      if (emotion == 'Happy') return AppColors.moodHappy;
      if (emotion == 'Calm') return AppColors.moodCalm;
      return AppColors.primary;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: getMoodColor(entry.emotion).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(getEmoji(entry.emotion), style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.emotion, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: entry.tags.map<Widget>((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(tag, style: const TextStyle(fontSize: 10)),
                        )).toList(),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('MMM d').format(entry.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
