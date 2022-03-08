import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:verdant_solar/utils/constants.dart';

class PrimaryDrawer extends StatelessWidget {
  const PrimaryDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      child: Theme(
        data: ThemeData(
          canvasColor: Color(kSecondaryColor),
        ),
        child: Drawer(
          child: Column(
            children: [
              Container(
                height: context.height * 0.3,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                color: Color(kSecondaryColor),
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/verdant-logo.png",
                        height: context.height * 0.1,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          GetStorage().read('username')!,
                          // "USERNAME",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "BebasNeue",
                              letterSpacing: 4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: ClipOval(
                  child: Container(
                    height: 35,
                    width: 35,
                    color: Color(kPrimaryColor),
                    child: Icon(
                      Icons.logout_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () async {
                  final box = GetStorage();
                  print(box.read('email'));
                  await Get.find<APIService>()
                      .put("/sso/auth/logout/${box.read('email')}");
                  box.remove("token");
                  Get.offAllNamed('/login');
                },
                selectedTileColor: Color(kPrimaryColor),
              ),
              ListTile(
                leading: ClipOval(
                  child: Container(
                    height: 35,
                    width: 35,
                    color: Color(kPrimaryColor),
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(
                  "Verdant Solar 1.0.0",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
