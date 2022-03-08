import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verdant_solar/controller/customer-view/report.dart';
import 'package:verdant_solar/controller/overview.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/screens/customer-view/report.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/bottom_nav_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/chart.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Overview extends StatelessWidget {
  final controller = Get.put(OverviewController());
  final report = Get.put(ReportController());
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
          controller: controller.scrollController,
          key: controller.listViewKey,
          children: [
            PerformanceTab(
              solarToConsume: controller.solarToConsume,
              gridToConsume: controller.gridToConsume,
              solarToGrid: controller.solarToGrid,
              solar: controller.solar,
              grid: controller.grid,
              consume: controller.consume,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.35,
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade400,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                DropdownIntervalOverview(
                    selectedInterval: controller.selectedInterval,
                    intervals: controller.intervals,
                    callback: controller.setInteval),
                Container(
                  width: Get.width * 0.35,
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade400,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            Graph(
              interval: controller.selectedInterval,
              isSolar: controller.isSolar,
              isPower: controller.isPower,
              isGrid: controller.isGrid,
              solarDataToday: controller.solarToday,
              powerDataToday: controller.powerToday,
              toGridToday: controller.toGrid,
              fromGridToday: controller.fromGrid,
              solarDataMonthly: controller.solarMonthly,
              powerDataMonthly: controller.powerMonthly,
            ),
            Container(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PerformanceCard(
                    data: controller.powerUsage,
                    title: "Household Power Usage",
                    image: 'assets/images/Household power usage icon.png',
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  PerformanceCard(
                    data: controller.solarPower,
                    title: "Solar Power Generated",
                    image: 'assets/images/Solar Power Generated Icon.png',
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
              width: Get.width,
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PerformanceCard(
                    data: controller.fromGridCard,
                    title: "From Grid",
                    image: 'assets/images/From grid icon.png',
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  PerformanceCard(
                    data: controller.toGridCard,
                    title: "To Grid",
                    image: 'assets/images/To grid icon.png',
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.5,
              color: Colors.grey.shade400,
              indent: 20,
              endIndent: 20,
            ),
            ROIGraph(
              data: controller.roiData,
              roiPercent: controller.roiPercent,
            ),
            Container(
              width: Get.width,
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PerformanceCard(
                    data: controller.billLastMonth,
                    title: "Est. Last Month Electricity Bill",
                    image: 'assets/images/TNB estimate icons V2.png',
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  PerformanceCard(
                    data: controller.billNextMonth,
                    title: "Est. Current Month Electricity Bill",
                    image: 'assets/images/TNB estimate icons V2.png',
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.5,
              color: Colors.grey.shade400,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: Get.width,
              child: LongCard(
                data: controller.co2,
                subTitle: controller.treePlanted,
                title: "CO\u2082 Savings",
                image: 'assets/images/Co2 Savings Icon.png',
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: Get.width,
              child: LongCard(
                data: controller.totalEnergy,
                subTitle: RxString(""),
                title: "Total Energy",
                image: 'assets/images/total energy.png',
              ),
            ),
            Obx(() {
              if (controller.selectedInterval.value == "Monthly" ||
                  controller.selectedInterval.value == "Yearly") {
                return Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: Get.width,
                  child: LongCard(
                    data: controller.costSaving,
                    subTitle: RxString(""),
                    title: "Cost Saving",
                    image: 'assets/images/cost savings.png',
                  ),
                );
              } else {
                return Container();
              }
            }),
            Divider(
              thickness: 1.5,
              color: Colors.grey.shade400,
              indent: 20,
              endIndent: 20,
            ),
            AnnualPowerBarChart(
              data: controller.annualPower,
              estimateProjection: controller.estimateProjection,
              year: controller.year,
            ),
            Divider(
              thickness: 1.5,
              color: Colors.grey.shade400,
              indent: 20,
              endIndent: 20,
            ),
            FileTable(
              files: controller.files,
            ),
            Divider(
              thickness: 1.5,
              color: Colors.grey.shade400,
              indent: 20,
              endIndent: 20,
            ),
            ReportWidget(report: report),
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

class ReportWidget extends StatelessWidget {
  const ReportWidget({
    Key? key,
    required this.report,
  }) : super(key: key);

  final ReportController report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: Get.width * 0.93,
            height: Get.height * 0.18,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Generate and download customer solar\nperformance report',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: DropdownInterval(
                            datePickerController: report.datePickerController,
                            startDate: report.startDate,
                            endDate: report.endDate,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 130,
                          child: Button(
                            radius: 20,
                            onPressed: () => report.generateReport(true),
                            textLabel: "Generate Report",
                            color: Color(kPrimaryColor),
                            textColor: Colors.white,
                            btnHeight: 1,
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PerformanceTab extends StatelessWidget {
  const PerformanceTab({
    Key? key,
    required this.solarToConsume,
    required this.gridToConsume,
    required this.solarToGrid,
    required this.solar,
    required this.grid,
    required this.consume,
  }) : super(key: key);

  final RxBool solarToConsume;
  final RxBool gridToConsume;
  final RxBool solarToGrid;
  final RxString solar;
  final RxString grid;
  final RxString consume;
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
              onPressed: () {},
              textLabel: "Performance",
              color: Color(kPrimaryColor),
              textColor: Colors.white,
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
              onPressed: () => Get.offNamed('/profile'),
              textLabel: "Profile",
              color: Colors.grey.shade400,
              textColor: Colors.black,
              btnHeight: 12,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
          height: Get.height * 0.4,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // GRID TO COMSUMPTION
              Obx(
                () {
                  if (gridToConsume.value) {
                    return Positioned(
                      bottom: 80,
                      left: Get.width * 0.23,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(180 / 360),
                        child: Image.asset(
                          'assets/images/Direction Arrow.gif',
                          width: Get.width * 0.46,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              // SOLAR TO COMSUMPTION
              Obx(
                () {
                  if (solarToConsume.value) {
                    return Positioned(
                      top: Get.height * 0.18,
                      right: Get.width * 0.06,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(235 / 360),
                        child: Image.asset(
                          'assets/images/Direction Arrow.gif',
                          width: Get.width * 0.46,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              // SOLAR TO GRID
              Obx(
                () {
                  if (solarToGrid.value) {
                    return Positioned(
                      top: Get.height * 0.18,
                      left: Get.width * 0.06,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(305 / 360),
                        child: Image.asset(
                          'assets/images/Direction Arrow.gif',
                          width: Get.width * 0.46,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "POWER FLOW",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Positioned(
                top: 18,
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Color(kPrimaryColor),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Solar Power Generated Icon.png',
                        scale: 15,
                        color: Colors.white,
                      ),
                      Obx(
                        () => Text(
                          "${solar}kW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: Get.height * 0.03,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color(kPrimaryColor),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Power Tower PNG.png',
                              scale: 8,
                              color: Colors.white,
                            ),
                            Obx(
                              () => Text(
                                "${grid}kW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 60)),
                      Container(
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                          color: Color(kPrimaryColor),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/Consumption Icon.png',
                              scale: 8,
                            ),
                            Positioned.fill(
                              bottom: 18,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(
                                  () => Text(
                                    "${consume}kW",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
    required this.isSolar,
    required this.isPower,
    required this.isGrid,
    required this.solarDataToday,
    required this.powerDataToday,
    required this.toGridToday,
    required this.fromGridToday,
    required this.solarDataMonthly,
    required this.powerDataMonthly,
    required this.interval,
  }) : super(key: key);

  final RxString interval;
  final RxBool isSolar;
  final RxBool isPower;
  final RxBool isGrid;
  final RxList<SolarGeneration> solarDataToday;
  final RxList<PowerConsumption> powerDataToday;
  final RxList<SolarGeneration> solarDataMonthly;
  final RxList<PowerConsumption> powerDataMonthly;
  final RxList<Grid> toGridToday;
  final RxList<Grid> fromGridToday;
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
            child: Obx(
              () => Button(
                onPressed: () {
                  isGrid.value = false;
                  if (isSolar.value) {
                    if (isSolar.value && isPower.value) {
                      isSolar.value = !isSolar.value;
                    }
                  } else {
                    isSolar.value = !isSolar.value;
                  }
                },
                textLabel: "Solar Generation",
                color: (isSolar.value)
                    ? Color(kPrimaryColor)
                    : Colors.grey.shade400,
                textColor: (isSolar.value) ? Colors.white : Colors.black,
                btnHeight: 12,
                style: TextStyle(
                  fontSize: 12,
                ),
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
            child: Obx(
              () => Button(
                onPressed: () {
                  isGrid.value = false;
                  if (isPower.value) {
                    if (isSolar.value && isPower.value) {
                      isPower.value = !isPower.value;
                    }
                  } else {
                    isPower.value = !isPower.value;
                  }
                },
                textLabel: "Power Consumption",
                color: (isPower.value)
                    ? Color(kPrimaryColor)
                    : Colors.grey.shade400,
                textColor: (isPower.value) ? Colors.white : Colors.black,
                btnHeight: 12,
                style: TextStyle(
                  fontSize: 12,
                ),
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
              child: Obx(
                () => Button(
                  onPressed: () {
                    isGrid.value = true;
                    isSolar.value = false;
                    isPower.value = false;
                  },
                  textLabel: "Grid",
                  color: (isGrid.value)
                      ? Color(kPrimaryColor)
                      : Colors.grey.shade400,
                  textColor: (isGrid.value) ? Colors.white : Colors.black,
                  btnHeight: 12,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              )),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
            height: Get.height * 0.25,
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
            child: Obx(() {
              switch (interval.toLowerCase()) {
                case "today":
                  if (isSolar.value && isPower.value) {
                    return CombineGraph(
                      data: powerDataToday,
                      data2: solarDataToday,
                    );
                  } else if (isPower.value) {
                    return PowerGraph(data: powerDataToday);
                  } else if (isSolar.value) {
                    return SolarGraph(data: solarDataToday);
                  } else {
                    return GridGraph(
                      toGrid: toGridToday,
                      fromGrid: fromGridToday,
                    );
                  }

                default:
                  if (isSolar.value && isPower.value) {
                    return CombineBarChart(
                      data: powerDataMonthly,
                      data2: solarDataMonthly,
                    );
                  } else if (isPower.value) {
                    return PowerBarChart(data: powerDataMonthly);
                  } else if (isSolar.value) {
                    return SolarBarChart(data: solarDataMonthly);
                  } else {
                    return GridBarChart(
                      toGrid: toGridToday,
                      fromGrid: fromGridToday,
                    );
                  }
              }
            }),
          ),
        ),
      ],
    );
  }
}

class DropdownIntervalOverview extends StatelessWidget {
  const DropdownIntervalOverview({
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
      width: Get.width * 0.3,
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

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({
    Key? key,
    required this.data,
    required this.title,
    required this.image,
  }) : super(key: key);

  final RxString data;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.45,
      height: Get.height * 0.1,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(left: 5),
              child: Image.asset(
                image,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    child: Text(
                      title,
                      softWrap: true,
                      style: TextStyle(
                        height: 1,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Obx(
                    () => Container(
                      width: Get.width * 0.3,
                      child: Text(
                        data.value,
                        style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LongCard extends StatelessWidget {
  const LongCard({
    Key? key,
    required this.data,
    required this.title,
    required this.image,
    required this.subTitle,
  }) : super(key: key);

  final RxString data;
  final String title;
  final String image;
  final RxString subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      height: Get.height * 0.1,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
            alignment: Alignment.centerRight,
            width: Get.width * 0.2,
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Image.asset(
              image,
              width: Get.width * 0.15,
            ),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width * 0.6,
                child: Text(
                  title,
                  softWrap: true,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.6,
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        data.value,
                        style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '\t${subTitle.value}',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FileTable extends StatelessWidget {
  const FileTable({
    Key? key,
    required this.files,
  }) : super(key: key);

  final RxList files;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<TableRow> rows = [
          TableRow(
            children: [
              Text(
                "File",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(kPrimaryColor),
                ),
              ),
              Text(
                "Size",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(kPrimaryColor),
                ),
              ),
              Text(
                "View",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(kPrimaryColor),
                ),
              ),
            ],
          ),
        ];

        for (var i = 0; i < files.length; i++) {
          CustomerFile file = files[i];
          rows.add(
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: (i != files.length - 1)
                        ? Colors.grey
                        : Colors.transparent,
                  ),
                ),
              ),
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      file.fileName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      file.size,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  height: Get.height * 0.025,
                  width: 5,
                  decoration: BoxDecoration(
                      color: Color(kPrimaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: InkWell(
                    onTap: () async {
                      bool isCanLaunch = await canLaunch(file.link);
                      try {
                        if (isCanLaunch) {
                          await launch(file.link);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Center(
                      child: Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Customer Files",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.3,
                child: SingleChildScrollView(
                  child: Table(
                    children: rows,
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              )
            ],
          ),
        );
      },
    );
  }
}
