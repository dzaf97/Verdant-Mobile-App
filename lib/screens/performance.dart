import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/performance.dart';
import 'package:verdant_solar/model/compare-cust.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/bottom_nav_bar.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Performance extends StatelessWidget {
  final controller = Get.put(PerformanceController());
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
                    "SOLAR PERFORMANCE\nCOMPARISON",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              AppBar(
                leading: Theme(
                  data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: IconButton(
                    onPressed: () => Get.offAndToNamed('/power-plant'),
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: DropdownRadius(
                        selectedRadius: controller.selectedRadius,
                        radiuses: controller.radiuses,
                        callback: controller.setRadius,
                      ),
                    ),
                    Container(
                      child: DropdownInterval(
                        selectedInterval: controller.selectedInterval,
                        intervals: controller.intervals,
                        callback: controller.setInterval,
                      ),
                    ),
                    // Container(
                    //   width: Get.width * 0.2,
                    //   height: 30,
                    //   child: Button(
                    //     onPressed: () {},
                    //     textLabel: "Compare",
                    //     color: Color(kPrimaryColor),
                    //     textColor: Colors.white,
                    //     btnHeight: 5,
                    //     style: TextStyle(),
                    //     radius: 20,
                    //   ),
                    // ),
                    Container(
                      width: Get.width * 0.4,
                      height: 30,
                      child: TextField(
                        controller: controller.searchController,
                        cursorHeight: 15,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(kPrimaryColor)),
                            child: Icon(
                              Icons.search,
                              size: 15,
                              color: Color(kSecondaryColor),
                            ),
                          ),
                          hintText: "Search Customer",
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
                        // onChanged: controller.searchCustomer,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Container(
                width: Get.width,
                height: Get.height * 0.6,
                child: Obx(
                  () {
                    if (controller.customerNearMe.length != 0) {
                      return ListView(
                        children: controller.customerNearMe,
                      );
                    } else {
                      return Container();
                    }
                  },
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

class CompareTile extends StatelessWidget {
  const CompareTile({
    Key? key,
    required this.customerName,
    required this.solarGeneration,
    required this.systemSize,
    required this.dsy,
  }) : super(key: key);

  final String customerName;
  final String solarGeneration;
  final String systemSize;
  final String dsy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 15, 20),
                color: Color(kPrimaryColor),
                width: 10,
                height: 10,
                child: Text(''),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "System Size",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "Solar Generation",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "DSY (kWh/kWp)",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ": $customerName",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                ": ${systemSize}kWp",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                ": ${solarGeneration}kWh",
                style: TextStyle(
                  color: Color(kPrimaryColor),
                ),
              ),
              Text(
                ": $dsy",
                style: TextStyle(
                  color: Colors.grey.shade700,
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

class DropdownInterval extends StatelessWidget {
  const DropdownInterval({
    Key? key,
    required this.selectedInterval,
    required this.intervals,
    required this.callback,
  }) : super(key: key);

  final RxString selectedInterval;
  final List<String> intervals;
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
            value: selectedInterval.value,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (value) => callback(value),
            items: intervals.map((interval) {
              return new DropdownMenuItem<String>(
                value: interval,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "$interval",
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

class DropdownRadius extends StatelessWidget {
  const DropdownRadius({
    Key? key,
    required this.selectedRadius,
    required this.radiuses,
    required this.callback,
  }) : super(key: key);

  final RxString selectedRadius;
  final List<String> radiuses;
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
            value: selectedRadius.value,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (value) => callback(value),
            items: radiuses.map((radius) {
              return new DropdownMenuItem<String>(
                value: radius,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "${radius}km",
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

class MultipleCompareTile extends StatelessWidget {
  const MultipleCompareTile({
    Key? key,
    required this.customer,
    required this.systemSize,
    required this.multiple,
    required this.interval,
  }) : super(key: key);

  final List<Datum> multiple;
  final String customer;
  final String systemSize;
  final String interval;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Builder(builder: (context) {
            List<Widget> widgets = [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 15, 20),
                    color: Color(kPrimaryColor),
                    width: 10,
                    height: 10,
                    child: Text(''),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "System Size",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 5)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ": $customer",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    ": $systemSize",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ];

            for (var item in multiple) {
              widgets.add(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (interval == 'Daily')
                            ? '${item.duration}/${DateTime.now().month}'
                            : item.duration,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(kPrimaryColor),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Solar Generation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "${(double.parse(item.totalProduction) * 1000).toStringAsFixed(2)}kWh",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            children: [
                              Text(
                                'DSY (kWh/kWp)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "${(item.dsykwhkwp * 1000).toStringAsFixed(2)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return Row(
              children: widgets,
            );
          })),
    );
  }
}
