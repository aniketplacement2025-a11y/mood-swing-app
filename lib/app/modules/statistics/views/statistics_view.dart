import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights 🧠'),
      ),
      body: Obx(() {
        if (controller.allEntries.isEmpty) {
          return const Center(child: Text('Add some moods to see insights!'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 32),
              Text('Mood Distribution', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildPieChart(context),
              const SizedBox(height: 32),
              Text('Mood Intensity (Last 7 Days)', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildLineChart(context),
              const SizedBox(height: 32),
              Text('Top Influencers', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildTopTags(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Avg Intensity',
            controller.averageIntensity.value.toStringAsFixed(1),
            Icons.speed,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Total Logs',
            controller.allEntries.length.toString(),
            Icons.history,
            AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          sections: controller.moodCounts.entries.map((e) {
            return PieChartSectionData(
              color: controller.getMoodColor(e.key),
              value: e.value.toDouble(),
              title: '${e.key}\n${e.value}',
              radius: 60,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: controller.weeklyAverages.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTags() {
    return Wrap(
      spacing: 8,
      children: controller.topTags.map((tag) => Chip(
        label: Text(tag),
        backgroundColor: AppColors.secondary.withOpacity(0.1),
        avatar: const Icon(Icons.tag, size: 16, color: AppColors.secondary),
      )).toList(),
    );
  }
}
