import 'package:flutter/material.dart';
import 'package:verdant_solar/model/battery.dart';
import 'package:verdant_solar/model/inverter.dart';
import 'package:verdant_solar/model/lux.dart';
import 'package:verdant_solar/model/power-meter.dart';
import 'package:verdant_solar/model/string-data.dart';
import 'package:verdant_solar/model/string-list.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/utils/constants.dart';

class DeviceController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 0.obs;
  var title = "Power Plant".obs;
  var menuPage = <Widget>[].obs;
  var intervals = ["Today", "Daily", "Monthly", "Yearly"];
  var selectedInterval = "Today".obs;

  // POWER METER DATA
  var voltageData1 = <AnalyticData>[].obs;
  var voltageData2 = <AnalyticData>[].obs;
  var voltageData3 = <AnalyticData>[].obs;

  var currentData1 = <AnalyticData>[].obs;
  var currentData2 = <AnalyticData>[].obs;
  var currentData3 = <AnalyticData>[].obs;

  var energyData1 = <AnalyticData>[].obs;
  var energyData2 = <AnalyticData>[].obs;
  var energyData3 = <AnalyticData>[].obs;

  var solarData = <SolarEnergy>[].obs;

  // MODBUS STATUS
  var isStatus = false.obs;
  var isComms = false.obs;
  var isWifi = false.obs;
  var isCellular = false.obs;

  // GRID MODBUS STATUS
  var isGridStatus = false.obs;
  var isGridComms = false.obs;

  // INVERTER CARD DATA
  var voltageL1 = "0".obs;
  var voltageL2 = "0".obs;
  var voltageL3 = "0".obs;
  var voltageMin = "0".obs;
  var voltageMax = "0".obs;
  var voltageAvg = "0".obs;

  var energyL1 = "0".obs;
  var energyL2 = "0".obs;
  var energyL3 = "0".obs;
  var energyMin = "0".obs;
  var energyMax = "0".obs;
  var energyAvg = "0".obs;

  var currentL1 = "0".obs;
  var currentL2 = "0".obs;
  var currentL3 = "0".obs;
  var currentMin = "0".obs;
  var currentMax = "0".obs;
  var currentAvg = "0".obs;

  var vpf1 = "0".obs;
  var vpf2 = "0".obs;
  var vpf3 = "0".obs;

  var vthdL1 = "0".obs;
  var vthdL2 = "0".obs;
  var vthdL3 = "0".obs;

  var ithdL1 = "0".obs;
  var ithdL2 = "0".obs;
  var ithdL3 = "0".obs;

  var temperature = "0".obs;

  // INVERTER GRAPH DATA
  var inverterVoltageGraph1 = <InverterGraphData>[].obs;
  var inverterVoltageGraph2 = <InverterGraphData>[].obs;
  var inverterVoltageGraph3 = <InverterGraphData>[].obs;

  var inverterEnergyGraph1 = <InverterGraphData>[].obs;
  var inverterEnergyGraph2 = <InverterGraphData>[].obs;
  var inverterEnergyGraph3 = <InverterGraphData>[].obs;

  var inverterCurrentGraph1 = <InverterGraphData>[].obs;
  var inverterCurrentGraph2 = <InverterGraphData>[].obs;
  var inverterCurrentGraph3 = <InverterGraphData>[].obs;

  var inverterTempGraph = <InverterGraphData>[].obs;

  // STRING GRAPH DATA
  var strings = ["Overall"];
  var selectedString = "Overall".obs;
  var stringVoltGraph = <InverterGraphData>[].obs;
  var stringEnergyGraph = <InverterGraphData>[].obs;
  var stringCurrentGraph = <InverterGraphData>[].obs;

  // LUX DATA
  var isLuxStatus = false.obs;
  var isLuxComms = false.obs;
  var luxGraph = <AnalyticData>[].obs;
  var isLuxUnavailable = false.obs;

  // BATTERY DATA
  var isBattStatus = false.obs;
  var isBattComms = false.obs;
  var chargingRate = "0".obs;
  var battVoltage = "0".obs;
  var battTemp = "0".obs;
  var isBattUnavailable = false.obs;

  var batteryPie = <BatteryData>[
    BatteryData("SOC", 30, Color(kPrimaryColor)),
    BatteryData("full", 100, Colors.white),
  ].obs;

  @override
  void onInit() {
    setAvailableString();
    setInverter();
    setPowerMeter();
    setLux();
    setBattery();
    super.onInit();
  }

  setInterval(value) {
    selectedInterval.value = value;
    setInverter();
    setPowerMeter();
    setLux();
    setBattery();
  }

  setAvailableString() async {
    String userID = box.read('selected-id');
    var res = await network.get('/solar/api/v1/device/list/string/$userID');

    if (res['error']) return;
    StringList data = StringList.fromJson(res);

    for (var string in data.message) {
      strings.add(string.deviceId);
    }
  }

  setString(value) async {
    selectedString.value = value;
    String interval = '';
    stringVoltGraph.value = <InverterGraphData>[];
    stringEnergyGraph.value = <InverterGraphData>[];
    stringCurrentGraph.value = <InverterGraphData>[];
    if (selectedInterval.value == "Today") {
      interval = 'current';
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network.get(
        '/solar/api/v1/device/analytics/string/${selectedString.value}?interval=$interval');

    if (res['error']) return;
    StringData data = StringData.fromJson(res);

    for (var item in data.message.data) {
      stringVoltGraph
          .add(InverterGraphData(item.duration, item.volt.toDouble()));
      stringEnergyGraph.add(
          InverterGraphData(item.duration, item.powerGenerated.toDouble()));
      stringCurrentGraph
          .add(InverterGraphData(item.duration, item.current.toDouble()));
    }
  }

  setBattery() async {
    String userID = box.read('selected-id');
    batteryPie.value = <BatteryData>[];

    var res =
        await network.get('/solar/api/v1/device/analytics/battery/$userID');

    if (res['error']) {
      isBattUnavailable.value = true;
      return;
    }

    BattData data = BattData.fromJson(res);

    isBattStatus.value = data.message.status;
    isBattComms.value = data.message.data.modbus;
    chargingRate.value = data.message.data.chargingRate.toString();
    battVoltage.value = data.message.data.voltage.toString();
    battTemp.value = data.message.data.temperature.toString();

    batteryPie.value = <BatteryData>[
      BatteryData("SOC", data.message.data.stateOfCharge.toDouble(),
          Color(kPrimaryColor)),
      BatteryData("full", 100, Colors.white),
    ];
  }

  setLux() async {
    var interval;
    String userID = box.read('selected-id');
    luxGraph.value = <AnalyticData>[];

    if (selectedInterval.value == "Today") {
      interval = 'current';
    } else {
      interval = selectedInterval.value.toLowerCase();
    }
    var res = await network
        .get('/solar/api/v1/device/analytics/lux/$userID?interval=$interval');

    if (res['error']) {
      isLuxUnavailable.value = true;
      return;
    }
    LuxData data = LuxData.fromJson(res);

    isLuxStatus.value = data.message.status.activeStatus;
    isLuxComms.value = data.message.status.modbus;
    for (var item in data.message.data) {
      final RegExp regexp = new RegExp(r'^0+(?=.)');
      // LUX GRAPH
      luxGraph
          .add(AnalyticData(item.duration.replaceAll(regexp, ''), item.value));
    }
  }

  setPowerMeter() async {
    var interval;
    String userID = box.read('selected-id');
    if (selectedInterval.value == "Today") {
      interval = 'current';
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    voltageData1.value = <AnalyticData>[];
    voltageData2.value = <AnalyticData>[];
    voltageData3.value = <AnalyticData>[];

    energyData1.value = <AnalyticData>[];
    energyData2.value = <AnalyticData>[];
    energyData3.value = <AnalyticData>[];

    currentData1.value = <AnalyticData>[];
    currentData2.value = <AnalyticData>[];
    currentData3.value = <AnalyticData>[];

    var res = await network
        .get('/solar/api/v1/device/analytics/grid/$userID?interval=$interval');

    if (res['error']) return;

    PowerMeterData data = PowerMeterData.fromJson(res);

    isGridStatus.value = data.message.status.activeStatus;
    isGridComms.value = data.message.status.modbus;
    bool is3Phase = data.message.status.is3phased;

    for (var item in data.message.data) {
      final RegExp regexp = new RegExp(r'^0+(?=.)');

      // VOLTAGE GRAPH
      voltageData1
          .add(AnalyticData(item.duration.replaceAll(regexp, ''), item.volt1));

      if (is3Phase) {
        voltageData2.add(
            AnalyticData(item.duration.replaceAll(regexp, ''), item.volt2));

        voltageData3.add(
            AnalyticData(item.duration.replaceAll(regexp, ''), item.volt3));
      }

      // ENERGY GRAPH
      energyData1.add(
          AnalyticData(item.duration.replaceAll(regexp, ''), item.energy1));

      if (is3Phase) {
        energyData2.add(
            AnalyticData(item.duration.replaceAll(regexp, ''), item.energy2));

        energyData3.add(
            AnalyticData(item.duration.replaceAll(regexp, ''), item.energy3));
      }

      // CURRENT GRAPH
      currentData1
          .add(AnalyticData(item.duration.replaceAll(regexp, ''), item.amp1));

      if (is3Phase) {
        currentData2
            .add(AnalyticData(item.duration.replaceAll(regexp, ''), item.amp2));

        currentData3
            .add(AnalyticData(item.duration.replaceAll(regexp, ''), item.amp3));
      }
    }
  }

  setInverter() async {
    var interval;
    if (selectedInterval.value == "Today") {
      interval = 'current';
    } else {
      interval = selectedInterval.value.toLowerCase();
    }
    String userID = box.read('selected-id');
    solarData.value = <SolarEnergy>[];

    inverterVoltageGraph1.value = <InverterGraphData>[];
    inverterVoltageGraph2.value = <InverterGraphData>[];
    inverterVoltageGraph3.value = <InverterGraphData>[];

    inverterEnergyGraph1.value = <InverterGraphData>[];
    inverterEnergyGraph2.value = <InverterGraphData>[];
    inverterEnergyGraph3.value = <InverterGraphData>[];

    inverterCurrentGraph1.value = <InverterGraphData>[];
    inverterCurrentGraph2.value = <InverterGraphData>[];
    inverterCurrentGraph3.value = <InverterGraphData>[];

    inverterTempGraph.value = <InverterGraphData>[];

    var res = await network.get(
        '/solar/api/v1/device/analytics/inverter/$userID?interval=$interval');

    if (res['error']) return;
    InverterData data = InverterData.fromJson(res);

    isStatus.value = data.message.status.activeStatus;
    isComms.value = data.message.status.modbus;
    isWifi.value = data.message.status.wifi;
    isCellular.value = data.message.status.cellular;
    bool is3Phase = data.message.status.is3Phased;

    for (var item in data.message.data) {
      final RegExp regexp = new RegExp(r'^0+(?=.)');

      // SOLAR ENERGY GRAPH
      solarData.add(SolarEnergy(
          item.duration.replaceAll(regexp, ''), item.directConsumption));

      // VOLTAGE GRAPH
      inverterVoltageGraph1.add(
          InverterGraphData(item.duration.replaceAll(regexp, ''), item.volt1));

      if (is3Phase) {
        inverterVoltageGraph2.add(InverterGraphData(
            item.duration.replaceAll(regexp, ''), item.volt2));

        inverterVoltageGraph3.add(InverterGraphData(
            item.duration.replaceAll(regexp, ''), item.volt3));
      }

      // ENERGY GRAPH
      inverterEnergyGraph1.add(InverterGraphData(
          item.duration.replaceAll(regexp, ''), item.energy1));

      if (is3Phase) {
        inverterEnergyGraph2.add(InverterGraphData(
            item.duration.replaceAll(regexp, ''), item.energy2));

        inverterEnergyGraph3.add(InverterGraphData(
            item.duration.replaceAll(regexp, ''), item.energy3));
      }

      // CURRENT GRAPH
      inverterCurrentGraph1.add(
          InverterGraphData(item.duration.replaceAll(regexp, ''), item.amp1));

      if (is3Phase) {
        inverterCurrentGraph2.add(
            InverterGraphData(item.duration.replaceAll(regexp, ''), item.amp2));

        inverterCurrentGraph3.add(
            InverterGraphData(item.duration.replaceAll(regexp, ''), item.amp3));
      }

      // TEMPERAUTE GRAPH
      inverterTempGraph.add(
          InverterGraphData(item.duration.replaceAll(regexp, ''), item.temp));
    }

    // SET VOLTAGE
    voltageL1.value = data.message.rtData.volt1.round().toString();
    voltageL2.value = data.message.rtData.volt2.round().toString();
    voltageL3.value = data.message.rtData.volt3.round().toString();

    voltageMin.value = data.message.aggData.voltMin.round().toString();
    voltageMax.value = data.message.aggData.voltMax.round().toString();
    voltageAvg.value = data.message.aggData.voltAvg.round().toString();

    // SET VPF
    vpf1.value = data.message.rtData.pf1.toStringAsFixed(2);
    vpf2.value = data.message.rtData.pf2.toStringAsFixed(2);
    vpf3.value = data.message.rtData.pf3.toStringAsFixed(2);

    // SET ENERGY
    energyL1.value = data.message.rtData.energy1.toStringAsFixed(2);
    energyL2.value = data.message.rtData.energy2.toStringAsFixed(2);
    energyL3.value = data.message.rtData.energy3.toStringAsFixed(2);

    energyMin.value = data.message.aggData.energyMin.toStringAsFixed(2);
    energyMax.value = data.message.aggData.energyMax.toStringAsFixed(2);
    energyAvg.value = data.message.aggData.energyAvg.toStringAsFixed(2);

    // SET CURRENT
    currentL1.value = data.message.rtData.amp1.toStringAsFixed(2);
    currentL2.value = data.message.rtData.amp2.toStringAsFixed(2);
    currentL3.value = data.message.rtData.amp3.toStringAsFixed(2);

    currentMin.value = data.message.aggData.ampMin.toStringAsFixed(2);
    currentMax.value = data.message.aggData.ampMax.toStringAsFixed(2);
    currentAvg.value = data.message.aggData.ampAvg.toStringAsFixed(2);
    print("SINII");
    print(data.message.aggData.ampAvg.toStringAsFixed(2));

    // SET THD
    vthdL1.value = data.message.rtData.vthd1.toStringAsFixed(2);
    vthdL2.value = data.message.rtData.vthd2.toStringAsFixed(2);
    vthdL3.value = data.message.rtData.vthd3.toStringAsFixed(2);

    ithdL1.value = data.message.rtData.athd1.toStringAsFixed(2);
    ithdL2.value = data.message.rtData.athd2.toStringAsFixed(2);
    ithdL3.value = data.message.rtData.athd3.toStringAsFixed(2);

    // SET TEMPERATURE
    temperature.value = data.message.rtData.temp.toStringAsFixed(1);
  }

  onItemTapped(int index) {
    var userID = Get.arguments;

    switch (index) {
      case 0:
        break;
      case 1:
        box.write('last-route', '/device');
        Get.offAndToNamed('/performance', arguments: userID);
        break;
      case 2:
        box.write('last-route', '/device');
        Get.offAndToNamed('/user-management', arguments: userID);
        break;
      default:
    }
  }
}

class SolarEnergy {
  SolarEnergy(this.hour, this.data);

  final String hour;
  final double data;
}

class AnalyticData {
  AnalyticData(this.hour, this.data);

  final String hour;
  final double data;
}

class InverterGraphData {
  InverterGraphData(this.hour, this.data);

  final String hour;
  final double data;
}

class BatteryData {
  BatteryData(this.title, this.value, this.color);
  final String title;
  final double value;
  final Color color;
}
