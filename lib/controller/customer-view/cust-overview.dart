import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:verdant_solar/controller/overview.dart';
import 'package:verdant_solar/model/get-file.dart';
import 'package:verdant_solar/model/performance-overview.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/service/pusher_service.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:web_socket_channel/status.dart' as status;

class CustOverviewController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var pusher = Get.put(PusherService());
  var selectedTab = 0.obs;

  var intervals = ["Today", "Daily", "Monthly", "Yearly"];
  var selectedInterval = "Today".obs;
  var showBadge = false.obs;
  var closeSocket = false.obs;
  var notiCount = 0.obs;

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
  var solarData = <SolarGeneration>[].obs;
  var powerData = <PowerConsumption>[].obs;
  var fromGrid = <Grid>[].obs;
  var toGrid = <Grid>[].obs;
  var powerUsage = "0.0 kWh".obs;
  var solarPower = "0.0 kWh".obs;
  var fromGridCard = "0.0 kWh".obs;
  var toGridCard = "0.0 kWh".obs;

  // DAILY, MONTHLY, YEARLY POWER METER DATA
  var solarDataMonthly = <SolarGeneration>[].obs;
  var powerDataMonthly = <PowerConsumption>[].obs;

  // TNB BILL
  var billLastMonth = "RM 0".obs;
  var billNextMonth = "RM 0".obs;

  // Co2
  var co2 = "0 kg".obs;
  var treePlanted = "Equals to 0 Trees Planted".obs;
  var costSaving = "0".obs;
  var totalEnergy = "0".obs;

  // ANNUAL POWER GENERATION CHART
  var annualPowerData = <PowerConsumption>[].obs;
  var estimateProjection = 300.obs;
  var year = "-".obs;

  var roiData = <PieChartData>[
    PieChartData("ROI", 3000, Color(kPrimaryColor)),
    PieChartData("Investment", 30000, Colors.grey.shade200),
  ].obs;
  var roiPercent = "0".obs;

  // FILE TABLE
  var files = <CustomerFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    setInteval('Today');
    powerFlow();
    setupNotification();
  }

  @override
  void onClose() {
    closeSocket(true);
    super.onClose();
  }

  setupNotification() {
    var userID = box.read('user-id');
    Channel channel = pusher.getInstance().subscribe('verdant-01');

    channel.bind(userID, (event) {
      print(event!.eventName);
      showBadge(true);
      notiCount.value++;
    });
  }

  powerFlow() {
    var userID = box.read('user-id');
    final channel = network.createChannel(
        '/solar/api/v1/ws/mobile/performance/powergraph/$userID');

    channel.stream.listen(
      (message) {
        var data = json.decode(message);
        var powerGen = data['Powergen'];
        var powerFlow = data['Powerflow'];

        if (data['Powerflow'] > 0) {
          solarToConsume(true);
          gridToConsume(true);
          solarToGrid(false);
          solar.value = powerGen.toStringAsFixed(2);
          grid.value = powerFlow.toStringAsFixed(2);
          consume.value = (powerGen + powerFlow).toStringAsFixed(2);
        } else {
          solarToConsume(true);
          gridToConsume(false);
          solarToGrid(true);
          solar.value = (powerGen + (powerFlow).abs()).toStringAsFixed(2);
          grid.value = (powerFlow).abs().toStringAsFixed(2);
          consume.value = powerGen.toStringAsFixed(2);
        }

        if (closeSocket.value) {
          // print("CLOSING SOCKET...");
          channel.sink.close(status.goingAway);
        }
      },
    );
  }

  setFile() async {
    var userID = box.read('user-id');
    var res = await network.get('/solar/api/v1/performance/files/$userID');
    if (!res['error']) {
      GetFile data = GetFile.fromJson(res);

      for (var item in data.message) {
        files.add(CustomerFile(item.fileName, item.fileSize, item.filePath));
      }
    }
  }

  setInteval(value) async {
    // RESET GRAPH
    solarData.value = <SolarGeneration>[];
    powerData.value = <PowerConsumption>[];
    solarDataMonthly.value = <SolarGeneration>[];
    powerDataMonthly.value = <PowerConsumption>[];
    toGrid.value = <Grid>[];
    fromGrid.value = <Grid>[];

    selectedInterval.value = value;

    // RETRIEVE QUERY PARAMATER
    var userID = box.read('user-id');
    String interval;
    if (selectedInterval.value == "Today") {
      interval = "current";
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network
        .get('/solar/api/v1/performance/analytics/$userID?interval=$interval');

    if (!res['error']) {
      PerformanceOverview data = PerformanceOverview.fromJson(res);

      powerUsage.value =
          '${data.message.householdPowerUsage.toStringAsFixed(1)}kWh';
      solarPower.value =
          '${data.message.solarPowerGenerated.toStringAsFixed(1)}kWh';
      fromGridCard.value = '${data.message.fromGrid.toStringAsFixed(1)}kWh';
      toGridCard.value = '${data.message.toGrid.toStringAsFixed(1)}kWh';
      billLastMonth.value = 'RM ${data.message.billLastMonth}';
      billNextMonth.value = 'RM ${data.message.billNextMonth}';

      // SAVINGS DATA
      co2.value = '${data.message.carbonSavings.toStringAsFixed(1)} kg';
      treePlanted.value =
          "Equals to ${data.message.treesPlanted.round().toString()} Trees Planted";
      totalEnergy.value = "${data.message.solarPowerGenerated}";

      annualPowerData.add(
        PowerConsumption(
            " ", data.message.annualPowerGenerated.roundToDouble()),
      );
      estimateProjection.value = data.message.annualEstimatedProjection.round();
      year.value = data.message.year.toString();

      roiData[0] = PieChartData(
          "ROI", data.message.roi.toDouble(), Color(kPrimaryColor));
      roiData[1] = PieChartData("Investment",
          data.message.totalInvestment.toDouble(), Colors.grey.shade200);
      roiPercent.value = data.message.roiPercentage;

      final RegExp regexp = new RegExp(r'^0+(?=.)');
      if (interval == 'current') {
        for (var item in data.message.data) {
          solarData.add(SolarGeneration(
              item.duration.replaceAll(regexp, ''), item.powerGenerated));
          powerData.add(PowerConsumption(
              item.duration.replaceAll(regexp, ''), item.powerConsumption));
          toGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.toGrid));
          fromGrid
              .add(Grid(item.duration.replaceAll(regexp, ''), item.fromGrid));
        }
      } else {
        for (var item in data.message.data) {
          solarDataMonthly.add(SolarGeneration(
              item.duration.replaceAll(regexp, ''), item.powerGenerated));
          powerDataMonthly.add(PowerConsumption(
              item.duration.replaceAll(regexp, ''), item.powerConsumption));
          toGrid.add(Grid(item.duration.replaceAll(regexp, ''), item.toGrid));
          fromGrid
              .add(Grid(item.duration.replaceAll(regexp, ''), item.fromGrid));
        }
      }
    }
  }

  onItemTapped(int index) {
    // selectedTab.value = index;

    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed('/premium');
        break;
      case 2:
        Get.toNamed('/my-profile');
        break;
      default:
    }
  }
}
