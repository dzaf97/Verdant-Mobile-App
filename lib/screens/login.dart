import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/login.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/button.dart';

class Login extends StatelessWidget {
  final controller = Get.put(LoginController());
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              child: Image.asset('assets/images/Login Banner.png'),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Text(
                'WELCOME!',
                style: TextStyle(
                  color: Color(kPrimaryColor),
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                controller: controller.email.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                ),
                decoration: InputDecoration(
                  hintText: "ID",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Obx(
                    () => TextField(
                      controller: controller.password.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                      obscureText: controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () => controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value,
                    icon: Icon(Icons.visibility),
                  ),
                )
              ],
            ),
            Container(
              width: context.width * 0.8,
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                      activeColor: Color(kPrimaryColor),
                      value: controller.rememberMe.value,
                      onChanged: (check) {
                        controller.rememberMe.value =
                            !controller.rememberMe.value;
                      },
                    ),
                  ),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              width: Get.width * 0.4,
              child: Button(
                onPressed: () => controller.login(),
                textLabel: "LOGIN",
                color: Color(kPrimaryColor),
                textColor: Colors.white,
                btnHeight: 10,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: InkWell(
                onTap: () => Get.toNamed('/forgot-password'),
                child: Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
