
import 'dart:convert';

InverterData inverterDataFromJson(String str) => InverterData.fromJson(json.decode(str));

String inverterDataToJson(InverterData data) => json.encode(data.toJson());

class InverterData {
    InverterData({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory InverterData.fromJson(Map<String, dynamic> json) => InverterData(
        error: json["error"],
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message.toJson(),
    };
}

class Message {
    Message({
        required this.data,
        required this.status,
        required this.rtData,
        required this.aggData,
    });

    List<Datum> data;
    Status status;
    RtData rtData;
    AggData aggData;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
        status: Status.fromJson(json["Status"]),
        rtData: RtData.fromJson(json["RTData"]),
        aggData: AggData.fromJson(json["AggData"]),
    );

    Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Status": status.toJson(),
        "RTData": rtData.toJson(),
        "AggData": aggData.toJson(),
    };
}

class AggData {
    AggData({
        required this.voltMin,
        required this.voltMax,
        required this.voltAvg,
        required this.ampMin,
        required this.ampMax,
        required this.ampAvg,
        required this.energyMin,
        required this.energyMax,
        required this.energyAvg,
    });

    double voltMin;
    double voltMax;
    double voltAvg;
    double ampMin;
    double ampMax;
    double ampAvg;
    double energyMin;
    double energyMax;
    double energyAvg;

    factory AggData.fromJson(Map<String, dynamic> json) => AggData(
        voltMin: json["VoltMin"].toDouble(),
        voltMax: json["VoltMax"].toDouble(),
        voltAvg: json["VoltAvg"].toDouble(),
        ampMin: json["AmpMin"].toDouble(),
        ampMax: json["AmpMax"].toDouble(),
        ampAvg: json["AmpAvg"].toDouble(),
        energyMin: json["EnergyMin"].toDouble(),
        energyMax: json["EnergyMax"].toDouble(),
        energyAvg: json["EnergyAvg"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "VoltMin": voltMin,
        "VoltMax": voltMax,
        "VoltAvg": voltAvg,
        "AmpMin": ampMin,
        "AmpMax": ampMax,
        "AmpAvg": ampAvg,
        "EnergyMin": energyMin,
        "EnergyMax": energyMax,
        "EnergyAvg": energyAvg,
    };
}

class Datum {
    Datum({
        required this.volt1,
        required this.volt2,
        required this.volt3,
        required this.amp1,
        required this.amp2,
        required this.amp3,
        required this.pf1,
        required this.pf2,
        required this.pf3,
        required this.vthd1,
        required this.vthd2,
        required this.vthd3,
        required this.athd1,
        required this.athd2,
        required this.athd3,
        required this.energy1,
        required this.energy2,
        required this.energy3,
        required this.temp,
        required this.powerGenerated,
        required this.duration,
        required this.deviceId,
        required this.directConsumption,
    });

    double volt1;
    double volt2;
    double volt3;
    double amp1;
    double amp2;
    double amp3;
    double pf1;
    double pf2;
    double pf3;
    double vthd1;
    double vthd2;
    double vthd3;
    double athd1;
    double athd2;
    double athd3;
    double energy1;
    double energy2;
    double energy3;
    double temp;
    double powerGenerated;
    String duration;
    String deviceId;
    double directConsumption;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        volt1: json["Volt1"].toDouble(),
        volt2: json["Volt2"].toDouble(),
        volt3: json["Volt3"].toDouble(),
        amp1: json["Amp1"].toDouble(),
        amp2: json["Amp2"].toDouble(),
        amp3: json["Amp3"].toDouble(),
        pf1: json["Pf1"].toDouble(),
        pf2: json["Pf2"].toDouble(),
        pf3: json["Pf3"].toDouble(),
        vthd1: json["Vthd1"].toDouble(),
        vthd2: json["Vthd2"].toDouble(),
        vthd3: json["Vthd3"].toDouble(),
        athd1: json["Athd1"].toDouble(),
        athd2: json["Athd2"].toDouble(),
        athd3: json["Athd3"].toDouble(),
        energy1: json["Energy1"].toDouble(),
        energy2: json["Energy2"].toDouble(),
        energy3: json["Energy3"].toDouble(),
        temp: json["Temp"].toDouble().toDouble(),
        powerGenerated: json["PowerGenerated"].toDouble(),
        duration: json["Duration"],
        deviceId: json["DeviceID"],
        directConsumption: json["DirectConsumption"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Volt1": volt1,
        "Volt2": volt2,
        "Volt3": volt3,
        "Amp1": amp1,
        "Amp2": amp2,
        "Amp3": amp3,
        "Pf1": pf1,
        "Pf2": pf2,
        "Pf3": pf3,
        "Vthd1": vthd1,
        "Vthd2": vthd2,
        "Vthd3": vthd3,
        "Athd1": athd1,
        "Athd2": athd2,
        "Athd3": athd3,
        "Energy1": energy1,
        "Energy2": energy2,
        "Energy3": energy3,
        "Temp": temp,
        "PowerGenerated": powerGenerated,
        "Duration": duration,
        "DeviceID": deviceId,
        "DirectConsumption": directConsumption,
    };
}

class RtData {
    RtData({
        required this.volt1,
        required this.volt2,
        required this.volt3,
        required this.amp1,
        required this.amp2,
        required this.amp3,
        required this.pf1,
        required this.pf2,
        required this.pf3,
        required this.vthd1,
        required this.vthd2,
        required this.vthd3,
        required this.athd1,
        required this.athd2,
        required this.athd3,
        required this.energy1,
        required this.energy2,
        required this.energy3,
        required this.temp,
        required this.powerGenerated,
        required this.duration,
        required this.deviceId,
        required this.directConsumption,
    });

    double volt1;
    double volt2;
    double volt3;
    double amp1;
    double amp2;
    double amp3;
    double pf1;
    double pf2;
    double pf3;
    double vthd1;
    double vthd2;
    double vthd3;
    double athd1;
    double athd2;
    double athd3;
    double energy1;
    double energy2;
    double energy3;
    double temp;
    double powerGenerated;
    String duration;
    String deviceId;
    double directConsumption;

    factory RtData.fromJson(Map<String, dynamic> json) => RtData(
        volt1: json["Volt1"].toDouble(),
        volt2: json["Volt2"].toDouble(),
        volt3: json["Volt3"].toDouble(),
        amp1: json["Amp1"].toDouble(),
        amp2: json["Amp2"].toDouble(),
        amp3: json["Amp3"].toDouble(),
        pf1: json["Pf1"].toDouble(),
        pf2: json["Pf2"].toDouble(),
        pf3: json["Pf3"].toDouble(),
        vthd1: json["Vthd1"].toDouble(),
        vthd2: json["Vthd2"].toDouble(),
        vthd3: json["Vthd3"].toDouble(),
        athd1: json["Athd1"].toDouble(),
        athd2: json["Athd2"].toDouble(),
        athd3: json["Athd3"].toDouble(),
        energy1: json["Energy1"].toDouble(),
        energy2: json["Energy2"].toDouble(),
        energy3: json["Energy3"].toDouble(),
        temp: json["Temp"].toDouble(),
        powerGenerated: json["PowerGenerated"].toDouble(),
        duration: json["Duration"],
        deviceId: json["DeviceID"],
        directConsumption: json["DirectConsumption"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Volt1": volt1,
        "Volt2": volt2,
        "Volt3": volt3,
        "Amp1": amp1,
        "Amp2": amp2,
        "Amp3": amp3,
        "Pf1": pf1,
        "Pf2": pf2,
        "Pf3": pf3,
        "Vthd1": vthd1,
        "Vthd2": vthd2,
        "Vthd3": vthd3,
        "Athd1": athd1,
        "Athd2": athd2,
        "Athd3": athd3,
        "Energy1": energy1,
        "Energy2": energy2,
        "Energy3": energy3,
        "Temp": temp,
        "PowerGenerated": powerGenerated,
        "Duration": duration,
        "DeviceID": deviceId,
        "DirectConsumption": directConsumption,
    };
}

class Status {
    Status({
        required this.modbus,
        required this.wifi,
        required this.cellular,
        required this.deviceid,
        required this.activeStatus,
        required this.lastHeartbeat,
        required this.is3Phased,
    });

    bool modbus;
    bool wifi;
    bool cellular;
    String deviceid;
    bool activeStatus;
    String lastHeartbeat;
    bool is3Phased;

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        modbus: json["modbus"],
        wifi: json["wifi"],
        cellular: json["cellular"],
        deviceid: json["deviceid"],
        activeStatus: json["active_status"],
        lastHeartbeat: json["last_heartbeat"],
        is3Phased: json["is3phased"],
    );

    Map<String, dynamic> toJson() => {
        "modbus": modbus,
        "wifi": wifi,
        "cellular": cellular,
        "deviceid": deviceid,
        "active_status": activeStatus,
        "last_heartbeat": lastHeartbeat,
        "is3phased": is3Phased,
    };
}
