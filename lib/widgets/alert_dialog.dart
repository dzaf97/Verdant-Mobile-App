import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/button.dart';

successDialog(message) {
  return Get.defaultDialog(
    title: "Success!",
    titleStyle: TextStyle(
      height: 2,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(kPrimaryColor),
    ),
    content: Column(
      children: [
        Container(
          child: Text(
            message,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    confirm: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.3,
      child: Button(
        onPressed: () => Get.back(),
        textLabel: "Okay",
        color: Color(kPrimaryColor),
        textColor: Colors.black,
        btnHeight: 10,
        style: TextStyle(fontSize: 12),
      ),
    ),
  );
}

warningDialog(message) {
  return Get.defaultDialog(
    title: "Something went wrong!",
    titleStyle: TextStyle(
        height: 2,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent),
    content: Column(
      children: [
        Container(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    confirm: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.3,
      child: Button(
        onPressed: () => Get.back(),
        textLabel: "Okay",
        color: Colors.red,
        textColor: Colors.black,
        btnHeight: 10,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}

sessionExpired() {
  return Get.defaultDialog(
    title: "Your session has expired!",
    titleStyle: TextStyle(
        height: 2,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent),
    content: Column(
      children: [
        Container(
          child: Text(
            "You will be redirected to login page",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    confirm: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.3,
      child: Button(
        onPressed: () => Get.back(),
        textLabel: "Okay",
        color: Colors.red,
        textColor: Colors.red,
        btnHeight: 10,
        style: TextStyle(fontSize: 12),
      ),
    ),
  );
}

Future<dynamic> successDialogBack(String message) {
  return Get.defaultDialog(
    title: "Success!",
    titleStyle: TextStyle(
      height: 2,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(kPrimaryColor),
    ),
    content: Column(
      children: [
        Container(
          child: Text(
            message,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    confirm: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.3,
      child: Button(
        onPressed: () {
          Get.back();
          Get.back();
        },
        textLabel: "Okay",
        color: Color(kPrimaryColor),
        textColor: Colors.black,
        btnHeight: 10,
        style: TextStyle(fontSize: 12),
      ),
    ),
  );
}

Future<dynamic> warningDialogBack(String message) {
  return Get.defaultDialog(
    title: "Something went wrong!",
    titleStyle: TextStyle(
        height: 2,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent),
    content: Column(
      children: [
        Container(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    confirm: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.3,
      child: Button(
        onPressed: () {
          Get.back();
          Get.back();
        },
        textLabel: "Okay",
        color: Colors.red,
        textColor: Colors.black,
        btnHeight: 10,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}
