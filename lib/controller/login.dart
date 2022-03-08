import 'package:flutter/material.dart';
import 'package:verdant_solar/model/login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/route_manager.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';

class LoginController extends GetxController {
  final network = Get.find<APIService>();
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  var forgotPass = TextEditingController().obs;
  var rememberMe = false.obs;
  var isPasswordVisible = true.obs;
  final box = GetStorage();

  @override
  void onInit() {
    if (!box.hasData('email')) {
      email.value.text = "";
      password.value.text = "";
    } else {
      email.value.text = box.read('email');
      password.value.text = box.read('password');
    }

    super.onInit();
  }

  login() async {
    var body = {"Email": email.value.text, "Password": password.value.text};
    var res = await network.post("/sso/auth/login", body: body);

    if (res["error"]) return warningDialog(res["message"]);

    Login data = Login.fromJson(res);
    if (rememberMe.value) {
      // SAVE EMAIL & PASSWORD
      box.write('email', email.value.text);
      box.write('password', password.value.text);
    } else {
      // SET EMAIL & PASSWORD TO EMPTY STRING
      email.value.text = "";
      password.value.text = "";
      box.write('email', "");
      box.write('password', "");
    }

    // SET NETWORK HEADER TO CONTAIN TOKEN
    network.header["Authorization"] = "Bearer ${data.message.jwtToken}";

    // PARSE TOKEN
    var parseToken = network.parseToken(token: data.message.jwtToken);
    print(parseToken);
    box.write('user-id', parseToken["UserID"]);
    box.write('role', parseToken["Roles"]);
    box.write('username', parseToken["FirstName"]);

    // DETERMINE USER ROLE BASED ON
    switch (parseToken["Roles"]) {
      case "1":
        Get.toNamed("/power-plant");
        break;
      case "2":
        Get.toNamed("/power-plant");
        break;
      case "3":
        Get.toNamed("/cust-overview");
        break;
      case "4":
        Get.toNamed("/cust-overview");
        break;
      default:
    }
  }

  forgotPassword() async {
    var body = {"Email": forgotPass.value.text};
    var res = await network.post("/sso/auth/forgot-password", body: body);
    print(res);
    if (res["error"]) {
      return warningDialog(res["message"]);
    } else {
      return successDialogBack(res["message"]);
    }
  }
}
