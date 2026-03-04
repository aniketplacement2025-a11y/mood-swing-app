import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Storage Service
  await Get.putAsync(() => StorageService().init());

  runApp(
    GetMaterialApp(
      title: "Mood Swing",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ),
  );
}
