import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verdant_solar/utils/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget title;
  final AppBar appBar;
  final GestureTapCallback route;

  MyAppBar({
    required this.showBack,
    required this.appBar,
    required this.title,
    required this.route,
  });

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      leading: (showBack)
          ? Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: IconButton(
                onPressed: route,
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
            )
          : Container(),
      backgroundColor: Color(kPrimaryColor),
      title: title,
      elevation: 0,
    );
  }
}

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget title;
  final AppBar appBar;
  final GestureTapCallback route;
  final RxBool showBadge;
  final RxInt notiCount;

  CustomerAppBar({
    required this.showBack,
    required this.appBar,
    required this.title,
    required this.route,
    required this.showBadge,
    required this.notiCount,
  });

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 80,
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      leading: Row(
        children: [
          Obx(
            () => Badge(
              animationType: BadgeAnimationType.slide,
              badgeContent: Obx(
                () => Text(
                  '${notiCount.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              position: BadgePosition.topEnd(
                top: 10,
                end: 10,
              ),
              showBadge: showBadge.value,
              child: IconButton(
                onPressed: () {
                  int count = notiCount.value;
                  notiCount.value = 0;
                  showBadge.value = false;
                  Get.toNamed('/notification/$count');
                },
                splashRadius: 15,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              var phone = "+60125801568";
              if (GetPlatform.isIOS) {
                launch("whatsapp://wa.me/$phone");
              } else {
                launch("https://api.whatsapp.com/send?phone=$phone");
              }
            },
            child: Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Color(kPrimaryColor),
      title: title,
      elevation: 0,
    );
  }
}
