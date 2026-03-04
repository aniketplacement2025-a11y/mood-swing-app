import 'package:get/get.dart';

import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/journal/bindings/journal_binding.dart';
import '../modules/journal/views/journal_view.dart';
import '../modules/statistics/bindings/statistics_binding.dart';
import '../modules/statistics/views/statistics_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/mood_logging/bindings/mood_logging_binding.dart';
import '../modules/mood_logging/views/mood_logging_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH; // App will start at Auth

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MOOD_LOGGING,
      page: () => const MoodLoggingView(),
      binding: MoodLoggingBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.STATISTICS,
      page: () => const StatisticsView(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () => const JournalView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
