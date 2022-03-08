import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verdant_solar/controller/customer-view/premium.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Premium extends StatelessWidget {
  final controller = Get.put(PremiumController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: PreferredSize(
          preferredSize: Size(Get.width, Get.height * 0.25),
          child: Stack(
            children: [
              Container(
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/Verdant Banner BG.png',
                      ),
                      fit: BoxFit.fill),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "PREMIUM FEATURES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              AppBar(
                // leading: Theme(
                //   data: ThemeData(
                //       splashColor: Colors.transparent,
                //       highlightColor: Colors.transparent),
                //   child: IconButton(
                //     onPressed: () => Get.toNamed('/power-plant'),
                //     icon: Icon(
                //       Icons.arrow_back_ios_new_outlined,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: Get.width * 0.93,
                height: Get.height * 0.18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: Get.width * 0.32,
                      child: InkWell(
                        onTap: () => (controller.userRole.value != "3")
                            ? null
                            : Get.toNamed('/compare'),
                        child: Image.asset(
                            'assets/images/Solar Comparison Icon.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Solar Performance Comparison',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.5,
                          child: Text(
                            'Compare your solar performance with other Verdant Solar users.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Spacer(),
                        Obx(() {
                          if (controller.userRole.value != "3") {
                            return Container(
                              height: 35,
                              width: 90,
                              child: Button(
                                radius: 20,
                                onPressed: askPremium,
                                textLabel: "Learn More",
                                color: Color(kPrimaryColor),
                                textColor: Colors.white,
                                btnHeight: 1,
                                style: TextStyle(),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Spacer(),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: Get.width * 0.93,
                height: Get.height * 0.18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: Get.width * 0.32,
                      child: InkWell(
                        onTap: () => (controller.userRole.value != "3")
                            ? null
                            : Get.toNamed('/report'),
                        child: Image.asset('assets/images/Solar Report.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Solar Performance Report',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.5,
                          child: Text(
                            'Generate and download your solar performance report.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Spacer(),
                        Obx(() {
                          if (controller.userRole.value != "3") {
                            return Container(
                              height: 35,
                              width: 90,
                              child: Button(
                                radius: 20,
                                onPressed: askPremium,
                                textLabel: "Learn More",
                                color: Color(kPrimaryColor),
                                textColor: Colors.white,
                                btnHeight: 1,
                                style: TextStyle(),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Spacer(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: Color(kSecondaryColor),
            selectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.home_outlined,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: Color(kPrimaryColor),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.attach_money,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.attach_money,
                  color: Color(kPrimaryColor),
                ),
                label: 'Premium',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outlined,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: Color(kPrimaryColor),
                ),
                label: 'My Profile',
              ),
            ],
            currentIndex: controller.selectedTab.value,
            onTap: (index) {
              controller.onItemTapped(index);
            },
            unselectedItemColor: Colors.black,
            selectedItemColor: Color(kPrimaryColor),
          ),
        ),
      ),
    );
  }

  void askPremium() => Get.defaultDialog(
        title: "",
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(20),
        content: Text(
          'Would you like to access our Premium Features?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          Container(
            width: 100,
            child: Button(
              radius: 20,
              onPressed: () {
                var phone = "+60125801568";
                if (GetPlatform.isIOS) {
                  launch("whatsapp://wa.me/$phone");
                } else {
                  launch("https://api.whatsapp.com/send?phone=$phone");
                }
              },
              textLabel: "Yes, please!",
              color: Color(kPrimaryColor),
              textColor: Colors.white,
              btnHeight: 12,
              style: TextStyle(),
            ),
          ),
          Container(
            width: 100,
            child: Button(
              radius: 20,
              onPressed: () => Get.back(),
              textLabel: "No, thanks",
              color: Colors.grey.shade400,
              textColor: Colors.black.withOpacity(0.7),
              btnHeight: 12,
              style: TextStyle(),
            ),
          )
        ],
      );
}
