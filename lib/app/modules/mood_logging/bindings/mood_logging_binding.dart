import 'package:get/get.dart';
import '../controllers/mood_logging_controller.dart';

class MoodLoggingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodLoggingController>(
      () => MoodLoggingController(),
    );
  }
}
