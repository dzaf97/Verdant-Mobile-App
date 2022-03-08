import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/routes.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:verdant_solar/utils/constants.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  Get.put(APIService());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Calibri",
        colorScheme: ColorScheme.light(primary: Color(kPrimaryColor)),
      ),
      color: Color(kPrimaryColor),
      initialRoute: '/login',
      defaultTransition: Transition.noTransition,
      builder: EasyLoading.init(),
      getPages: routes(),
    ),
  );
}

