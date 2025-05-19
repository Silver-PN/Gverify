import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get_common/get_reset.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:xverifydemoapp/app_page.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/presentation/home/home_view.dart';


import 'channels/native_channel_manager.dart';
import 'core/utils/local_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await LocalNotifications.init();
  sendEnvironmentVariablesToNative();
  sendDeviceIdToNative();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      useInheritedMediaQuery: true,
      getPages: AppPage.pages,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        fontFamily: 'GoogleSansRegular',
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: BrandColors.colorTextOnPrimary,
          displayColor: BrandColors.colorTextOnPrimary,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}
