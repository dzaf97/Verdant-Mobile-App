import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:verdant_solar/controller/device.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/bottom_nav_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Device extends StatelessWidget {
  final controller = Get.put(DeviceController());
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
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: Get.width * 0.35),
              child: DropdownInterval(
                selectedInterval: controller.selectedInterval,
                intervals: controller.intervals,
                callback: controller.setInterval,
              ),
            ),
            DeviceTab(
              isStatus: controller.isStatus,
              isComms: controller.isComms,
              isWifi: controller.isWifi,
              isCellular: controller.isCellular,
            ),
            PowerMeterAnalytics(
              isGridStatus: controller.isGridStatus,
              isGridComms: controller.isGridComms,
              solarEnergy: controller.solarData,
              voltageData1: controller.voltageData1,
              voltageData2: controller.voltageData2,
              voltageData3: controller.voltageData3,
              currentData1: controller.currentData1,
              currentData2: controller.currentData2,
              currentData3: controller.currentData3,
              energyData1: controller.energyData1,
              energyData2: controller.energyData2,
              energyData3: controller.energyData3,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              height: Get.height * 0.28,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Text(
                      "Direct Consumption of Solar Energy",
                      style: TextStyle(
                        color: Color(kPrimaryColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.23,
                    child: SafeArea(
                      child: SolarEnergyGraph(data: controller.solarData),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
                        child: Text(
                          "INVERTER & STRING",
                          style: TextStyle(
                            color: Color(kPrimaryColor),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownnString(
                          selectedString: controller.selectedString,
                          strings: controller.strings,
                          callback: controller.setString,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InverterCard(
                                title: "VOLTAGE (V)",
                                l1: controller.voltageL1,
                                l2: controller.voltageL2,
                                l3: controller.voltageL3,
                                min: controller.voltageMin,
                                max: controller.voltageMax,
                                avg: controller.voltageAvg,
                              ),
                            ),
                            Expanded(
                              child: VPF(
                                vpf1: controller.vpf1,
                                vpf2: controller.vpf2,
                                vpf3: controller.vpf3,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InverterCard(
                                title: "ENERGY (kWh)",
                                l1: controller.energyL1,
                                l2: controller.energyL2,
                                l3: controller.energyL3,
                                min: controller.energyMin,
                                max: controller.energyMax,
                                avg: controller.energyAvg,
                              ),
                            ),
                            Expanded(
                              child: InverterCard(
                                title: "CURRENT (A)",
                                l1: controller.currentL1,
                                l2: controller.currentL2,
                                l3: controller.currentL3,
                                min: controller.currentMin,
                                max: controller.currentMax,
                                avg: controller.currentMin,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            THDTempCard(
                              vl1: controller.vthdL1,
                              vl2: controller.vthdL2,
                              vl3: controller.vthdL3,
                              il1: controller.ithdL1,
                              il2: controller.ithdL2,
                              il3: controller.ithdL3,
                            ),
                            TemperatureCard(temperature: controller.temperature)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return Divider(
                          color: Colors.grey.shade700,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return InverterGraph(
                          title: "Hourly Voltage",
                          graphData1: controller.inverterVoltageGraph1,
                          graphData2: controller.inverterVoltageGraph2,
                          graphData3: controller.inverterVoltageGraph3,
                        );
                      } else {
                        return SingleLineGraph(
                          title: "Hourly Voltage",
                          graphData: controller.stringVoltGraph,
                        );
                      }
                    },
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return InverterGraph(
                          title: "Hourly Energy",
                          graphData1: controller.inverterEnergyGraph1,
                          graphData2: controller.inverterEnergyGraph2,
                          graphData3: controller.inverterEnergyGraph3,
                        );
                      } else {
                        return SingleLineGraph(
                          title: "Hourly Energy",
                          graphData: controller.stringEnergyGraph,
                        );
                      }
                    },
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return InverterGraph(
                          title: "Hourly Current",
                          graphData1: controller.inverterCurrentGraph1,
                          graphData2: controller.inverterCurrentGraph2,
                          graphData3: controller.inverterCurrentGraph3,
                        );
                      } else {
                        return SingleLineGraph(
                          title: "Hourly Current",
                          graphData: controller.stringCurrentGraph,
                        );
                      }
                    },
                  ),
                  Obx(
                    () {
                      if (controller.selectedString.value == "Overall") {
                        return Column(
                          children: [
                            Divider(
                              color: Colors.grey.shade700,
                            ),
                            SingleLineGraph(
                              title: "Hourly Temperature",
                              graphData: controller.inverterTempGraph,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
            LuxGraph(
              status: controller.isLuxStatus,
              communication: controller.isLuxComms,
              graphData: controller.luxGraph,
              isLuxUnavailable: controller.isLuxUnavailable,
            ),
            BatteryPie(
              communication: controller.isBattComms,
              status: controller.isBattStatus,
              data: controller.batteryPie,
              chargingRate: controller.chargingRate,
              battVoltage: controller.battVoltage,
              battTemp: controller.battTemp,
              isBattUnavailable: controller.isBattUnavailable,
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

class DeviceTab extends StatelessWidget {
  const DeviceTab({
    Key? key,
    required this.isStatus,
    required this.isComms,
    required this.isWifi,
    required this.isCellular,
  }) : super(key: key);

  final RxBool isStatus;
  final RxBool isComms;
  final RxBool isWifi;
  final RxBool isCellular;

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
              onPressed: () {},
              textLabel: "Device",
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
          height: Get.height * 0.12,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Text(
                  "MODBUS",
                  style: TextStyle(
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  "Communication",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    ": ${(isStatus.value) ? "ON" : "OFF"}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    ": ${(isComms.value) ? "OK" : "OFF"}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Connectivity 1",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  "Connectivity 2",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    ": ${(isWifi.value) ? "OK (Wifi)" : "OFF (Wifi)"}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    ": ${(isCellular.value) ? "OK (Cellular)" : "OFF (Cellular)"}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class PowerMeterAnalytics extends StatelessWidget {
  const PowerMeterAnalytics({
    Key? key,
    required this.isGridStatus,
    required this.isGridComms,
    required this.solarEnergy,
    required this.voltageData1,
    required this.voltageData2,
    required this.voltageData3,
    required this.currentData1,
    required this.currentData2,
    required this.currentData3,
    required this.energyData1,
    required this.energyData2,
    required this.energyData3,
  }) : super(key: key);

  final RxBool isGridStatus;
  final RxBool isGridComms;
  final RxList<SolarEnergy> solarEnergy;
  final RxList<AnalyticData> voltageData1;
  final RxList<AnalyticData> voltageData2;
  final RxList<AnalyticData> voltageData3;
  final RxList<AnalyticData> currentData1;
  final RxList<AnalyticData> currentData2;
  final RxList<AnalyticData> currentData3;
  final RxList<AnalyticData> energyData1;
  final RxList<AnalyticData> energyData2;
  final RxList<AnalyticData> energyData3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Text(
              "POWER METER",
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "Communication",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        ": ${(isGridStatus.value) ? "ON" : "OFF"}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        ": ${(isGridComms.value) ? "OK" : "OFF"}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade700,
          ),
          // Container(
          //   alignment: Alignment.center,
          //   child: Text(
          //     "Direct Consumption of Solar Energy",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Color(kPrimaryColor),
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
          // Container(
          //   height: Get.height * 0.23,
          //   child: SafeArea(
          //     child: SolarEnergyGraph(data: solarEnergy),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              "Voltage",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.23,
            child: SafeArea(
              child: AnalyticGraph(
                data1: voltageData1,
                data2: voltageData2,
                data3: voltageData3,
                unit: "   V",
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade700,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              "Current",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.23,
            child: SafeArea(
              child: AnalyticGraph(
                data1: currentData1,
                data2: currentData2,
                data3: currentData3,
                unit: "   A",
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade700,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              "Energy",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.23,
            child: SafeArea(
              child: AnalyticGraph(
                data1: energyData1,
                data2: energyData2,
                data3: energyData3,
                unit: "kWh",
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AnalyticGraph extends StatelessWidget {
  const AnalyticGraph({
    Key? key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.unit,
  }) : super(key: key);

  final RxList<AnalyticData> data1;
  final RxList<AnalyticData> data2;
  final RxList<AnalyticData> data3;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        print(data1.length);
        if (data2.length != 0) {
          return SfCartesianChart(
            title: ChartTitle(
              text: unit,
              textStyle: TextStyle(
                fontSize: 8,
              ),
              alignment: ChartAlignment.near,
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                format: 'point.x: point.y kW'),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<AnalyticData, String>(
                name: "${unit}1",
                color: Color(kPrimaryColor),
                dataSource: data1,
                xValueMapper: (AnalyticData data, _) => data.hour,
                yValueMapper: (AnalyticData data, _) => data.data,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  color: Color(kPrimaryColor),
                  width: 5,
                  height: 5,
                ),
              ),
              LineSeries<AnalyticData, String>(
                name: "${unit}2",
                color: Color(0xfff6b642),
                dataSource: data2,
                xValueMapper: (AnalyticData data, _) => data.hour,
                yValueMapper: (AnalyticData data, _) => data.data,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  color: Color(0xfff6b642),
                  width: 5,
                  height: 5,
                ),
              ),
              LineSeries<AnalyticData, String>(
                name: "${unit}3",
                color: Color(kThirdColor),
                dataSource: data3,
                xValueMapper: (AnalyticData data, _) => data.hour,
                yValueMapper: (AnalyticData data, _) => data.data,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  color: Color(kPrimaryColor),
                  width: 5,
                  height: 5,
                ),
              ),
            ],
          );
        } else {
          return SfCartesianChart(
            title: ChartTitle(
              text: unit,
              textStyle: TextStyle(
                fontSize: 8,
              ),
              alignment: ChartAlignment.near,
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                format: 'point.x: point.y kW'),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<AnalyticData, String>(
                name: "$unit",
                color: Color(kPrimaryColor),
                dataSource: data1,
                xValueMapper: (AnalyticData data, _) => data.hour,
                yValueMapper: (AnalyticData data, _) => data.data,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  color: Color(kPrimaryColor),
                  width: 5,
                  height: 5,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class SolarEnergyGraph extends StatelessWidget {
  const SolarEnergyGraph({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RxList<SolarEnergy> data;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(data);
      return SfCartesianChart(
        title: ChartTitle(
          text: "kWh",
          textStyle: TextStyle(
            fontSize: 8,
          ),
          alignment: ChartAlignment.near,
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true, canShowMarker: true, format: 'point.x: point.y kW'),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<SolarEnergy, String>(
            name: "Hourly Energy",
            color: Color(0xfff6b642),
            dataSource: data,
            xValueMapper: (SolarEnergy data, _) => data.hour,
            yValueMapper: (SolarEnergy data, _) => data.data,
            markerSettings: MarkerSettings(
              isVisible: true,
              color: Color(0xfff6b642),
              width: 5,
              height: 5,
            ),
          ),
        ],
      );
    });
  }
}

class DropdownnString extends StatelessWidget {
  const DropdownnString({
    Key? key,
    required this.selectedString,
    required this.strings,
    required this.callback,
  }) : super(key: key);

  final RxString selectedString;
  final List<String> strings;
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
            value: selectedString.value,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (value) => callback(value),
            items: strings.map((string) {
              return new DropdownMenuItem<String>(
                value: string,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "$string",
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

class InverterCard extends StatelessWidget {
  const InverterCard({
    Key? key,
    required this.title,
    required this.l1,
    required this.l2,
    required this.l3,
    required this.min,
    required this.max,
    required this.avg,
  }) : super(key: key);

  final String title;
  final RxString l1;
  final RxString l2;
  final RxString l3;
  final RxString min;
  final RxString max;
  final RxString avg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: Get.height * 0.14,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: Colors.black26),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                decoration: TextDecoration.underline,
                color: Color(kPrimaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "L1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            ": $l1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $l2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $l3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Min",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "Avg",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "Max",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            ": $min",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $avg",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $max",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class THDTempCard extends StatelessWidget {
  const THDTempCard({
    Key? key,
    required this.vl1,
    required this.vl2,
    required this.vl3,
    required this.il1,
    required this.il2,
    required this.il3,
  }) : super(key: key);

  final RxString vl1;
  final RxString vl2;
  final RxString vl3;
  final RxString il1;
  final RxString il2;
  final RxString il3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: Get.height * 0.14,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: Colors.black26),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "V THD (%) I THD (%)",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 17,
                color: Color(kPrimaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "L1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            ": $vl1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $vl2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $vl3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "L1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            ": $il1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $il2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $il3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class TemperatureCard extends StatelessWidget {
  const TemperatureCard({
    Key? key,
    required this.temperature,
  }) : super(key: key);

  final RxString temperature;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: Get.height * 0.14,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: Colors.black26),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "TEMPERATURE (C)",
              style: TextStyle(
                fontSize: 17,
                decoration: TextDecoration.underline,
                color: Color(kPrimaryColor),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              temperature.value,
              style: TextStyle(
                fontSize: 43,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VPF extends StatelessWidget {
  const VPF({
    Key? key,
    required this.vpf1,
    required this.vpf2,
    required this.vpf3,
  }) : super(key: key);

  final RxString vpf1;
  final RxString vpf2;
  final RxString vpf3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: Get.height * 0.14,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: Colors.black26),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "V PF (%)",
              style: TextStyle(
                fontSize: 17,
                decoration: TextDecoration.underline,
                color: Color(kPrimaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "L1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          ),
                          Text(
                            "L3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            ": $vpf1",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $vpf2",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ": $vpf3",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InverterGraph extends StatelessWidget {
  const InverterGraph({
    Key? key,
    required this.title,
    required this.graphData1,
    required this.graphData2,
    required this.graphData3,
  }) : super(key: key);

  final String title;
  final graphData1;
  final graphData2;
  final graphData3;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.27,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              title,
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.22,
            child: SafeArea(
              child: Obx(
                () {
                  if (graphData2.length == 0) {
                    return SfCartesianChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      primaryXAxis: CategoryAxis(),
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          canShowMarker: true,
                          format: 'point.x: point.y kW'),
                      series: <ChartSeries>[
                        LineSeries<InverterGraphData, String>(
                          name: "${title.split(" ")[1]}",
                          color: Color(kPrimaryColor),
                          dataSource: graphData1,
                          xValueMapper: (InverterGraphData data, _) =>
                              data.hour,
                          yValueMapper: (InverterGraphData data, _) =>
                              data.data,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Color(kPrimaryColor),
                            width: 5,
                            height: 5,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SfCartesianChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          canShowMarker: true,
                          format: 'point.x: point.y kW'),
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        LineSeries<InverterGraphData, String>(
                          name: "${title.split(" ")[1]}1",
                          color: Color(kPrimaryColor),
                          dataSource: graphData1,
                          xValueMapper: (InverterGraphData data, _) =>
                              data.hour,
                          yValueMapper: (InverterGraphData data, _) =>
                              data.data,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Color(kPrimaryColor),
                            width: 5,
                            height: 5,
                          ),
                        ),
                        LineSeries<InverterGraphData, String>(
                          name: "${title.split(" ")[1]}2",
                          color: Color(0xfff6b642),
                          dataSource: graphData2,
                          xValueMapper: (InverterGraphData data, _) =>
                              data.hour,
                          yValueMapper: (InverterGraphData data, _) =>
                              data.data,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Color(0xfff6b642),
                            width: 5,
                            height: 5,
                          ),
                        ),
                        LineSeries<InverterGraphData, String>(
                          name: "${title.split(" ")[1]}3",
                          color: Colors.grey,
                          dataSource: graphData3,
                          xValueMapper: (InverterGraphData data, _) =>
                              data.hour,
                          yValueMapper: (InverterGraphData data, _) =>
                              data.data,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Colors.grey,
                            width: 5,
                            height: 5,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SingleLineGraph extends StatelessWidget {
  const SingleLineGraph({
    Key? key,
    required this.title,
    required this.graphData,
  }) : super(key: key);

  final String title;
  final graphData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Text(
              title,
              style: TextStyle(
                color: Color(kPrimaryColor),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.14,
            child: SafeArea(
              child: Obx(
                () {
                  print(graphData.length);
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(
                        enable: true,
                        canShowMarker: true,
                        format: 'point.x: point.y kW'),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      LineSeries<InverterGraphData, String>(
                        color: Color(kPrimaryColor),
                        name: title,
                        dataSource: graphData,
                        xValueMapper: (InverterGraphData data, _) => data.hour,
                        yValueMapper: (InverterGraphData data, _) => data.data,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          color: Color(kPrimaryColor),
                          width: 5,
                          height: 5,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LuxGraph extends StatelessWidget {
  const LuxGraph({
    Key? key,
    required this.status,
    required this.communication,
    required this.graphData,
    required this.isLuxUnavailable,
  }) : super(key: key);

  final RxBool status;
  final RxBool communication;
  final RxBool isLuxUnavailable;
  final graphData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Text(
                  "LUX",
                  style: TextStyle(
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "Communication",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            ": ${(status.value) ? "OK" : "OFF"}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            ": ${(communication.value) ? "OK" : "OFF"}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
              ),
              Container(
                height: Get.height * 0.18,
                child: SafeArea(
                  child: Obx(
                    () {
                      print(graphData.length);
                      return SfCartesianChart(
                        title: ChartTitle(
                          text: "Klux",
                          textStyle: TextStyle(
                            fontSize: 8,
                          ),
                          alignment: ChartAlignment.near,
                        ),
                        tooltipBehavior: TooltipBehavior(
                            enable: true,
                            canShowMarker: true,
                            format: 'point.x: point.y kW'),
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          LineSeries<AnalyticData, String>(
                            color: Color(0xfff6b642),
                            dataSource: graphData,
                            xValueMapper: (AnalyticData data, _) => data.hour,
                            yValueMapper: (AnalyticData data, _) => data.data,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          Obx(
            () {
              if (isLuxUnavailable.value) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        "DEVICE NOT AVAILABLE",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}

class BatteryPie extends StatelessWidget {
  const BatteryPie({
    Key? key,
    required this.data,
    required this.status,
    required this.communication,
    required this.chargingRate,
    required this.battVoltage,
    required this.battTemp,
    required this.isBattUnavailable,
  }) : super(key: key);

  final RxList<BatteryData> data;
  final RxBool status;
  final RxBool communication;
  final RxString chargingRate;
  final RxString battVoltage;
  final RxString battTemp;
  final RxBool isBattUnavailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Text(
                  "BATTERY",
                  style: TextStyle(
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "Communication",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            ": ${(status.value) ? "OK" : "OFF"}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            ": ${(communication.value) ? "OK" : "OFF"}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.width * 0.4,
                    height: Get.height * 0.25,
                    padding: EdgeInsets.only(left: 20),
                    child: SafeArea(
                      child: SfCircularChart(
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Container(
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: (data.length != 0)
                                          ? "${data[0].value}%\n"
                                          : "",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 34,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "SoC",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 24,
                                          height: 0.5),
                                    )
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<BatteryData, String>(
                            dataSource: data,
                            pointColorMapper: (BatteryData data, _) =>
                                data.color,
                            xValueMapper: (BatteryData data, _) => data.title,
                            yValueMapper: (BatteryData data, _) => data.value,
                            innerRadius: '85%',
                            strokeColor: Colors.black26,
                            strokeWidth: 1.5,
                            radius: "80",
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: Get.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Battery Status",
                          style: TextStyle(
                              color: Color(kPrimaryColor), fontSize: 22),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Charging Rate",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Voltage",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Temperature",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ": ${chargingRate}A",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  ": ${battVoltage}V",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  ": $battTemp°C",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Obx(
            () {
              if (isBattUnavailable.value) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        "DEVICE NOT AVAILABLE",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
