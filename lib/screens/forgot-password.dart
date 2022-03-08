import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/login.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/button.dart';

class ForgotPassword extends StatelessWidget {
  final controller = Get.put(LoginController());
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Color(kPrimaryColor),
              ),
              Stack(
                children: [
                  Container(
                    height: Get.height * 0.3,
                    width: Get.width,
                    child: Image.asset(
                      'assets/images/Profile BG.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          "Just enter your email and we'll send you a link for you to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: TextField(
                  controller: controller.forgotPass.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                  ),
                  decoration: InputDecoration(
                    hintText: "EMAIL",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: Get.width * 0.45,
                child: Button(
                  onPressed: () => controller.forgotPassword(),
                  textLabel: "RESET PASSWORD",
                  color: Color(kPrimaryColor),
                  textColor: Colors.white,
                  btnHeight: 10,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
