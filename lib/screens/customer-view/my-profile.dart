import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/customer-view/my-profile.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class MyProfile extends StatelessWidget {
  final controller = Get.put(MyProfileController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: PreferredSize(
          preferredSize: Size(Get.width, Get.height),
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      width: Get.width,
                      height: Get.height * 0.5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/Profile BG.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // ClipPath(
                    //   clipper: CurveClipper(),
                    //   child: Container(
                    //     height: Get.height * 0.47,
                    //     color: Colors.grey.shade300,
                    //   ),
                    // ),
                    // ClipPath(
                    //   clipper: CurveClipper2(),
                    //   child: Container(
                    //     color: Color(kPrimaryColor),
                    //     height: Get.height * 0.44,
                    //   ),
                    // ),
                    Positioned.fill(
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: Get.width * 0.55,
                          height: Get.height * 0.55,
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Obx(() {
                            var avatarImgs = [];
                            for (var image in controller.images) {
                              avatarImgs.add(
                                NetworkImage(
                                  image['ProfileImgPath'],
                                ),
                              );
                            }

                            return CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  controller.carouselIndex.value = index;
                                },
                              ),
                              items: avatarImgs.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Color(0xff7fbbb0),
                                          radius: 105,
                                          child: CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: i,
                                          ),
                                        ),
                                        Positioned(
                                          right: 15,
                                          top: 10,
                                          child: InkWell(
                                            onTap: () {
                                              int index = avatarImgs.indexOf(i);
                                              controller.editImage.value =
                                                  controller.images[index];
                                              if (GetPlatform.isIOS) {
                                                Get.bottomSheet(
                                                  CupertinoActionSheet(
                                                    cancelButton:
                                                        CupertinoActionSheetAction(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                    actions: [
                                                      CupertinoActionSheetAction(
                                                        child: const Text(
                                                            'Add New Photo'),
                                                        onPressed: () =>
                                                            controller
                                                                .askImageSource(
                                                                    true),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        child: const Text(
                                                            'Remove Current Photo'),
                                                        onPressed: () {
                                                          var index = avatarImgs
                                                              .indexOf(i);

                                                          controller.deletePhoto(
                                                              controller.images[
                                                                  index]);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/images/Edit Photo Icon.png',
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: Get.width * 0.25,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: Get.width * 0.5,
                          child: Obx(
                            () {
                              List<Widget> bullets = [];

                              for (var i = 0;
                                  i < controller.images.length;
                                  i++) {
                                bullets.add(
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width: Get.width * 0.02,
                                    decoration: BoxDecoration(
                                      color:
                                          (i == controller.carouselIndex.value)
                                              ? Colors.white
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: bullets,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    AppBar(
                      title: Text(
                        "MY PROFILE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "BebasNeue",
                          letterSpacing: 4,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Container(
                height: Get.height * 0.15,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.07,
                            child: Image.asset('assets/images/Profile.png'),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Container(
                            child: Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(kPrimaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.07,
                            child: Icon(
                              Icons.circle,
                              color: Colors.transparent,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    height: 1,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Build up area",
                                  style: TextStyle(
                                    height: 1,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "No. of Rooms",
                                  style: TextStyle(
                                    height: 1,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Household size",
                                  style: TextStyle(
                                    height: 1,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Obx(
                                  () => Text(
                                    ": ${controller.name}",
                                    style: TextStyle(
                                      height: 1,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Obx(
                                  () => Text(
                                    ": ${controller.buildupArea} sqft",
                                    style: TextStyle(
                                      height: 1,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Obx(
                                  () => Text(
                                    ": ${controller.noOfRooms}",
                                    style: TextStyle(
                                      height: 1,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Obx(
                                  () => Text(
                                    ": ${controller.householdSize} person",
                                    style: TextStyle(
                                      height: 1,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SystemSpecs(
                installationDate: controller.installationDate,
                inverter: controller.inverter,
                panel: controller.panel,
                systemSize: controller.systemSize,
              )
            ],
          ),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: Column(
          children: [],
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
              onPressed: () {},
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

class SystemSpecs extends StatelessWidget {
  const SystemSpecs({
    Key? key,
    required this.systemSize,
    required this.installationDate,
    required this.panel,
    required this.inverter,
  }) : super(key: key);

  final RxString systemSize;
  final RxString installationDate;
  final RxString panel;
  final RxString inverter;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
      height: Get.height * 0.15,
      width: Get.width,
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
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 0, 5),
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.07,
                  child: Image.asset('assets/images/System Specs Icon.png'),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Container(
                  child: Text(
                    "System Specifications",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.07,
                  child: Icon(
                    Icons.circle,
                    color: Colors.transparent,
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "System size",
                        style: TextStyle(
                          height: 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Installation Date",
                        style: TextStyle(
                          height: 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Panel",
                        style: TextStyle(
                          height: 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Inverter",
                        style: TextStyle(
                          height: 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Obx(
                        () => Text(
                          ": ${systemSize}kWp",
                          style: TextStyle(
                            height: 1,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Obx(
                        () => Text(
                          ": ${installationDate.split('T')[0]}",
                          style: TextStyle(
                            height: 1,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.5,
                      child: Obx(
                        () => Text(
                          ": $panel",
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            height: 1,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.5,
                      child: Obx(
                        () => Text(
                          ": $inverter",
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            height: 1,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width + 100, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - 60)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 30;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
