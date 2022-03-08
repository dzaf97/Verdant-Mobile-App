import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/controller/profile.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/bottom_nav_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Profile extends StatelessWidget {
  final controller = Get.put(ProfileController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: MyAppBar(
          showBack: true,
          appBar: AppBar(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  "${controller.title.value}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "BebasNeue",
                    letterSpacing: 4,
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.23,
                child: Text(
                  "${GetStorage().read('selected-name').toString()}",
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontFamily: "BebasNeue",
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          route: () => Get.offAndToNamed('/power-plant'),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: ListView(
          children: [
            ProfileTab(
              images: controller.images,
              carouselIndex: controller.carouselIndex,
              buildupArea: controller.buildupArea,
              name: controller.name,
              householdSize: controller.householdSize,
              noOfRooms: controller.noOfRooms,
              addPhoto: controller.askImageSource,
              deletePhoto: controller.deletePhoto,
            ),
            SystemSpecs(
              installationDate: controller.installationDate,
              inverter: controller.inverter,
              panel: controller.panel,
              systemSize: controller.systemSize,
            ),
            PanelInfo(strings: controller.strings)
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
            items: bars,
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
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    Key? key,
    required this.images,
    required this.carouselIndex,
    required this.name,
    required this.buildupArea,
    required this.noOfRooms,
    required this.householdSize,
    required this.addPhoto,
    required this.deletePhoto,
  }) : super(key: key);

  final RxList images;
  final RxInt carouselIndex;
  final RxString name;
  final RxString buildupArea;
  final RxString noOfRooms;
  final RxString householdSize;
  final Function addPhoto;
  final Function deletePhoto;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 17,
          left: Get.width * 0.1,
          child: Container(
            width: Get.width * 0.25,
            height: 40,
            child: Button(
              onPressed: () => Get.offNamed('/overview'),
              textLabel: "Performance",
              color: Colors.grey.shade400,
              textColor: Colors.black,
              btnHeight: 12,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Positioned(
          top: 17,
          left: Get.width * 0.375,
          child: Container(
            width: Get.width * 0.25,
            height: 40,
            child: Button(
              onPressed: () => Get.offNamed('/device'),
              textLabel: "Device",
              color: Colors.grey.shade400,
              textColor: Colors.black,
              btnHeight: 12,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Positioned(
          top: 17,
          left: Get.width * 0.65,
          child: Container(
            width: Get.width * 0.25,
            height: 40,
            child: Button(
              onPressed: () {},
              textLabel: "Profile",
              color: Color(kPrimaryColor),
              textColor: Colors.white,
              btnHeight: 12,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
          height: Get.height * 0.38,
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
                width: Get.width * 0.45,
                height: Get.height * 0.2,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Obx(() {
                  var avatarImgs = [];
                  for (var image in images) {
                    avatarImgs.add(
                      NetworkImage(
                        image,
                      ),
                    );
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: Get.height * 0.2,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        carouselIndex.value = index;
                      },
                    ),
                    items: avatarImgs.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(kPrimaryColor),
                                radius: Get.width * 0.25,
                                child: CircleAvatar(
                                  radius: Get.width * 0.21,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: i,
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 10,
                                child: InkWell(
                                  onTap: () {
                                    if (GetPlatform.isIOS) {
                                      Get.bottomSheet(
                                        CupertinoActionSheet(
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          actions: [
                                            CupertinoActionSheetAction(
                                              child:
                                                  const Text('Add New Photo'),
                                              onPressed: () => addPhoto(),
                                            ),
                                            CupertinoActionSheetAction(
                                              child: const Text(
                                                  'Remove Current Photo'),
                                              onPressed: () {
                                                var index =
                                                    avatarImgs.indexOf(i);
                                                deletePhoto(images[index]);

                                                // Get.back();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/Edit Photo Icon.png',
                                    width: 32,
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
              Container(
                width: Get.width * 0.5,
                child: Obx(
                  () {
                    List<Widget> bullets = [];

                    for (var i = 0; i < images.length; i++) {
                      bullets.add(
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: Get.width * 0.02,
                          decoration: BoxDecoration(
                            color: (i == carouselIndex.value)
                                ? Color(kPrimaryColor)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(kPrimaryColor),
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
                              ": $name",
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
                              ": $buildupArea sqft",
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
                              ": $noOfRooms",
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
                              ": $householdSize person",
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
        )
      ],
    );
  }
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

class PanelInfo extends StatelessWidget {
  const PanelInfo({
    Key? key,
    required this.strings,
  }) : super(key: key);

  final RxList strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
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
                  child: Image.asset('assets/images/Panel info icon.png'),
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Container(
                  child: Text(
                    "Panel Information",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            List<Widget> stringInfo = [];

            for (var i = 0; i < strings.length; i++) {
              stringInfo.add(
                StringInfo(
                  stringNo: "${i + 1} ",
                  panelElavation: strings[i]["PanelElavation"],
                  orientation: strings[i]["Orientation"],
                  systemSize: strings[i]["SystemSize"],
                ),
              );

              if (i + 1 == strings.length) {
                stringInfo.add(Divider(
                  color: Colors.transparent,
                ));
              }
            }
            return Column(children: stringInfo);
          })
        ],
      ),
    );
  }
}

class StringInfo extends StatelessWidget {
  const StringInfo({
    Key? key,
    required this.stringNo,
    required this.panelElavation,
    required this.orientation,
    required this.systemSize,
  }) : super(key: key);

  final String stringNo;
  final String panelElavation;
  final String orientation;
  final String systemSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                  "String $stringNo",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Panel Elavation",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Orientation",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "System Size",
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
                child: Text(
                  "",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  ": $panelElavation",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  ": $orientation°",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                child: Text(
                  ": ${systemSize}kWp",
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
