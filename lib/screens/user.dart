import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/user.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/bottom_nav_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class User extends StatelessWidget {
  final controller = Get.put(UserController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: MyAppBar(
          showBack: true,
          appBar: AppBar(),
          title: Obx(
            () => Text(
              controller.title.value ,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "BebasNeue",
                letterSpacing: 4,
              ),
            ),
          ),
          route: () => Get.offAndToNamed('/power-plant'),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: Get.width * 0.2,
                      height: 30,
                      child: Button(
                        onPressed: () => Get.offNamed('/add-user'),
                        textLabel: "Add User",
                        color: Color(kPrimaryColor),
                        textColor: Colors.white,
                        btnHeight: 5,
                        style: TextStyle(),
                        radius: 20,
                      ),
                    ),
                    Container(
                      child: DropdownLevel(
                        selectedLevel: controller.selectedLevel,
                        levels: controller.levels,
                        callback: controller.setLevel,
                      ),
                    ),
                    Container(
                      width: Get.width * 0.4,
                      height: 30,
                      child: TextField(
                        controller: controller.searchText,
                        cursorHeight: 15,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 13,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                        // onChanged: controller.searchUser,
                      ),
                    ),

                    // Container(
                    //   width: Get.width,
                    //   height: Get.height * 0.6,
                    //   child: Obx(
                    //     () {
                    //       if (controller.customerNearMe.length != 0) {
                    //         return ListView(
                    //           children: controller.customerNearMe,
                    //         );
                    //       } else {
                    //         return Align(
                    //           alignment: Alignment.center,
                    //           child: Text(
                    //             "NO NEARBY CUSTOMER",
                    //             style: TextStyle(
                    //               fontSize: 20,
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(110),
                    1: FixedColumnWidth(60),
                    2: FixedColumnWidth(70),
                    3: FixedColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'User',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(kPrimaryColor),
                          ),
                        ),
                        Text(
                          'Level',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(kPrimaryColor),
                          ),
                        ),
                        Text(
                          'Date Reg',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(kPrimaryColor),
                          ),
                        ),
                        Text(
                          'Edit',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(kPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: Get.height * 0.6,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    Obx(() {
                      var userRows = <TableRow>[];
                      for (var item in controller.user) {
                        userRows.add(
                          userRow(
                            customerName: item.fullName,
                            level: item.userType,
                            date: item.dateReg,
                            userID: item.userId.toString(),
                          ),
                        );
                      }
                      return Table(
                        columnWidths: {
                          0: FixedColumnWidth(110),
                          1: FixedColumnWidth(60),
                          2: FixedColumnWidth(70),
                          3: FixedColumnWidth(1),
                        },
                        children: userRows,
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
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

class DropdownLevel extends StatelessWidget {
  const DropdownLevel({
    Key? key,
    required this.selectedLevel,
    required this.levels,
    required this.callback,
  }) : super(key: key);

  final RxString selectedLevel;
  final List<String> levels;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.22,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.black26, width: 1.5),
      ),
      child: Theme(
        data: ThemeData(
          canvasColor: Colors.white,
        ),
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Color(kPrimaryColor),
              size: 30,
            ),
            underline: Container(color: Colors.transparent),
            value: selectedLevel.value,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (value) => callback(value),
            items: levels.map((level) {
              return new DropdownMenuItem<String>(
                value: level,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    level,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

TableRow userRow({
  required String customerName,
  required String level,
  required String date,
  required String userID,
}) {
  return TableRow(
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          customerName,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          level,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          date,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: () => Get.offNamed('/edit-user/$userID'),
          splashColor: Colors.transparent,
          child: Icon(
            Icons.edit,
            size: 18,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    ],
  );
}
