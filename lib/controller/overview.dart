import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:verdant_solar/model/get-file.dart';
import 'package:verdant_solar/model/performance-overview.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:web_socket_channel/status.dart' as status;

class OverviewController extends GetxController
    with SingleGetTickerProviderMixin {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 0.obs;
  var title = "Overview".obs;
  var closeSocket = false.obs;
  late AnimationController animation;
  final scrollController = new ScrollController();
  final listViewKey = new GlobalKey();
  final animatedBoxKey = new GlobalKey();

  var intervals = ["Today", "Daily", "Monthly", "Yearly"];
  var selectedInterval = "Today".obs;

  // HANDLE TAB
  var isSolar = true.obs;
  var isPower = false.obs;
  var isGrid = false.obs;

  // POWER FLOW
  var gridToConsume = false.obs;
  var solarToConsume = false.obs;
  var solarToGrid = false.obs;
  var solar = "0".obs;
  var grid = "0".obs;
  var consume = "0".obs;

  // POWER METER DATA
  var solarToday = <SolarGeneration>[].obs;
  var powerToday = <PowerConsumption>[].obs;
  var fromGrid = <Grid>[].obs;
  var toGrid = <Grid>[].obs;
  var powerUsage = "0.0 kWh".obs;
  var solarPower = "0.0 kWh".obs;
  var fromGridCard = "0.0 kWh".obs;
  var toGridCard = "0.0 kWh".obs;

  // DAILY, MONTHLY, YEARLY POWER METER DATA
  var solarMonthly = <SolarGeneration>[].obs;
  var powerMonthly = <PowerConsumption>[].obs;

  // SAVINGS
  var co2 = "0 kg".obs;
  var treePlanted = "Equals to 0 Trees Planted".obs;
  var costSaving = "0".obs;
  var totalEnergy = "0".obs;

  // ANNUAL POWER GENERATION CHART
  var annualPower = <PowerConsumption>[].obs;
  var estimateProjection = 300.obs;
  var year = "-".obs;

  // ROI SOLAR INVESTMENT
  var roiData = <PieChartData>[
    PieChartData("ROI", 3000, Color(kPrimaryColor)),
    PieChartData("Investment", 30000, Colors.grey.shade200),
  ].obs;
  var roiPercent = "0".obs;

  // TNB BILL
  var billLastMonth = "RM 0".obs;
  var billNextMonth = "RM 0".obs;

  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    // updateAnimation();

    // scrollController.addListener(() {
    // });

    setInteval(selectedInterval.value);
    setFile();
    powerFlow();
  }

  @override
  void onClose() {
    super.onClose();
    animation.dispose();
  }

  static const enterAnimationMinHeight = 100.0;

  // updateAnimation() {
  //   Tween(
  //     begin: 0.0,
  //     end: 1.0,
  //   ).animate(animation);
  // animation.addStatusListener((status) {});
  // RenderObject? listViewObject =
  //     listViewKey.currentContext?.findRenderObject();
  // RenderObject? animatedBoxObject =
  //     animatedBoxKey.currentContext?.findRenderObject();
  // if (listViewObject == null || animatedBoxObject == null) return;

  // final listViewHeight = listViewObject.paintBounds.height;
  // final animatedObjectTop =
  //     animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;

  // final animatedBoxVisible =
  //     (animatedObjectTop + enterAnimationMinHeight < listViewHeight);

  // if (animatedBoxVisible) {}
  // }

  powerFlow() {
    String userID = box.read('selected-id');
    print('USERID SELECTED: $userID');
    final channel = network.createChannel(
        '/solar/api/v1/ws/mobile/performance/powergraph/$userID');

    channel.stream.listen(
      (message) {
        var data = json.decode(message);
        var powerGen = data['Powergen'];
        var powerFlow = data['Powerflow'];

        if (data['Powergen'] == 0) {
          solarToConsume(false);
          gridToConsume(true);
          solarToGrid(false);
          solar.value = powerGen.toStringAsFixed(2);
          grid.value = powerFlow.toStringAsFixed(2);
          consume.value = (powerGen + powerFlow).toStringAsFixed(2);
        }

        if (data['Powerflow'] > 0) {
          solarToConsume(true);
          gridToConsume(true);
          solarToGrid(false);
          solar.value = powerGen.toStringAsFixed(2);
          grid.value = powerFlow.toStringAsFixed(2);
          consume.value = (powerGen + powerFlow).toStringAsFixed(2);
        }

        if (data['Powerflow'] < 0) {
          solarToConsume(true);
          gridToConsume(false);
          solarToGrid(true);
          solar.value = (powerGen + (powerFlow).abs()).toStringAsFixed(2);
          grid.value = (powerFlow).abs().toStringAsFixed(2);
          consume.value = powerGen.toStringAsFixed(2);
        }

        if (closeSocket.value) {
          print("CLOSING SOCKET...");
          channel.sink.close(status.goingAway);
        }
      },
    );
  }

  setInteval(value) async {
    // SET INTERVAL VALUE
    selectedInterval.value = value;

    // RESET GRAPH
    solarToday.value = <SolarGeneration>[];
    powerToday.value = <PowerConsumption>[];
    solarMonthly.value = <SolarGeneration>[];
    powerMonthly.value = <PowerConsumption>[];
    annualPower.value = <PowerConsumption>[];

    toGrid.value = <Grid>[];
    fromGrid.value = <Grid>[];

    // RETRIEVE QUERY PARAMATER
    String userID = box.read('selected-id');
    String interval;
    if (selectedInterval.value == "Today") {
      interval = "current";
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network
        .get('/solar/api/v1/performance/analytics/$userID?interval=$interval');
    if (res['error']) return;
    PerformanceOverview data = PerformanceOverview.fromJson(res);

    // POWER METER CARD DATA
    powerUsage.value =
        '${data.message.householdPowerUsage.toStringAsFixed(1)}kWh';
    solarPower.value =
        '${data.message.solarPowerGenerated.toStringAsFixed(1)}kWh';
    fromGridCard.value = '${data.message.fromGrid.toStringAsFixed(1)}kWh';
    toGridCard.value = '${data.message.toGrid.toStringAsFixed(1)}kWh';

    // LONG CARD DATA
    co2.value = '${data.message.carbonSavings.toStringAsFixed(1)} kg';
    treePlanted.value =
        "Equals to ${data.message.treesPlanted.round().toString()} Trees Planted";
    totalEnergy.value = "${data.message.solarPowerGenerated}";

    // COST SAVING IS ONLY AVAILABLE FOR MONTHLY AND YEARLY ONLY
    if (interval == "monthly" || interval == "yearly")
      costSaving.value = "${data.message.costSavings}";

    // ANNUAL POWER GENERATION BAR CHART
    estimateProjection.value =
        (data.message.annualEstimatedProjection.round() != 0)
            ? data.message.annualEstimatedProjection.round()
            : 1;
    year.value = data.message.year.toString();
    annualPower.add(
      PowerConsumption(
          " ",
          (data.message.annualPowerGenerated.roundToDouble() != 0)
              ? data.message.annualPowerGenerated.roundToDouble()
              : 1000),
    );

    // ROI SOLAR INVESTMENT
    roiData[0] =
        PieChartData("ROI", data.message.roi.toDouble(), Color(kPrimaryColor));
    roiData[1] = PieChartData("Investment",
        data.message.totalInvestment.toDouble(), Colors.grey.shade200);
    roiPercent.value = data.message.roiPercentage;
    billLastMonth.value = 'RM ${data.message.billLastMonth}';
    billNextMonth.value = 'RM ${data.message.billNextMonth}';

    final RegExp regexp = new RegExp(r'^0+(?=.)');
    if (interval == 'current') {
      // LINE GRAPH FOR TODAY DATA (INTERVAL: CURRENT)
      for (var item in data.message.data) {
        solarToday.add(SolarGeneration(
            item.duration.replaceAll(regexp, ''), item.powerGenerated));
        powerToday.add(PowerConsumption(
            item.duration.replaceAll(regexp, ''), item.powerConsumption));
        toGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.toGrid));
        fromGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.fromGrid));
      }
    } else {
      // BAR GRAPH DATA (INTERVAL: DAILY, MONTHLY, YEARLY)
      for (var item in data.message.data) {
        solarMonthly.add(SolarGeneration(
            item.duration.replaceAll(regexp, ''), item.powerGenerated));
        powerMonthly.add(PowerConsumption(
            item.duration.replaceAll(regexp, ''), item.powerConsumption));
        toGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.toGrid));
        fromGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.fromGrid));
      }
    }
  }

  // FILE TABLE
  var files = <CustomerFile>[].obs;

  setFile() async {
    String userID = box.read('selected-id');
    var res = await network.get('/solar/api/v1/performance/files/$userID');
    if (res['error']) return;

    GetFile data = GetFile.fromJson(res);
    for (var item in data.message) {
      files.add(CustomerFile(item.fileName, item.fileSize, item.filePath));
    }
  }

  onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        box.write('last-route', '/overview');
        Get.offAndToNamed('/performance');
        break;
      case 2:
        box.write('last-route', '/overview');
        Get.offAndToNamed('/user-management');
        break;
      default:
    }
  }
}

class SolarGeneration {
  SolarGeneration(this.hour, this.data);

  final String hour;
  final double data;
}

class PowerConsumption {
  PowerConsumption(this.hour, this.data);

  final String hour;
  final double data;
}

class Grid {
  Grid(this.hour, this.data);

  final String hour;
  final double data;
}

class PieChartData {
  PieChartData(this.title, this.value, this.color);
  final String title;
  final double value;
  final Color color;
}

class CustomerFile {
  CustomerFile(this.fileName, this.size, this.link);

  final String fileName;
  final String size;
  final String link;
}
