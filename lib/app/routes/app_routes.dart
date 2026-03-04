part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const MOOD_LOGGING = _Paths.MOOD_LOGGING;
  static const CALENDAR = _Paths.CALENDAR;
  static const STATISTICS = _Paths.STATISTICS;
  static const JOURNAL = _Paths.JOURNAL;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const MOOD_LOGGING = '/mood-logging';
  static const CALENDAR = '/calendar';
  static const STATISTICS = '/statistics';
  static const JOURNAL = '/journal';
  static const SETTINGS = '/settings';
}
