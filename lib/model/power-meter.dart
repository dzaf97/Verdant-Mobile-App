import 'dart:convert';

PowerMeterData powerMeterDataFromJson(String str) => PowerMeterData.fromJson(json.decode(str));

String powerMeterDataToJson(PowerMeterData data) => json.encode(data.toJson());

class PowerMeterData {
    PowerMeterData({
        required this.error,
        required this.message,
    });

    final bool error;
    final Message message;

    factory PowerMeterData.fromJson(Map<String, dynamic> json) => PowerMeterData(
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
    });

    final List<Datum> data;
    final Status status;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
        status: Status.fromJson(json["Status"]),
    );

    Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Status": status.toJson(),
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
        required this.energy1,
        required this.energy2,
        required this.energy3,
        required this.powerFlow,
        required this.duration,
        required this.deviceId,
    });

    final double volt1;
    final double volt2;
    final double volt3;
    final double amp1;
    final double amp2;
    final double amp3;
    final double energy1;
    final double energy2;
    final double energy3;
    final double powerFlow;
    final String duration;
    final String deviceId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        volt1: json["Volt1"].toDouble(),
        volt2: json["Volt2"].toDouble(),
        volt3: json["Volt3"].toDouble(),
        amp1: json["Amp1"].toDouble(),
        amp2: json["Amp2"].toDouble(),
        amp3: json["Amp3"].toDouble(),
        energy1: json["Energy1"].toDouble(),
        energy2: json["Energy2"].toDouble(),
        energy3: json["Energy3"].toDouble(),
        powerFlow:  (json["PowerFlow"] != null) ? json["PowerFlow"].toDouble(): 0,
        duration: json["Duration"],
        deviceId: json["DeviceID"],
    );

    Map<String, dynamic> toJson() => {
        "Volt1": volt1,
        "Volt2": volt2,
        "Volt3": volt3,
        "Amp1": amp1,
        "Amp2": amp2,
        "Amp3": amp3,
        "Energy1": energy1,
        "Energy2": energy2,
        "Energy3": energy3,
        "PowerFlow": powerFlow,
        "Duration": duration,
        "DeviceID": deviceId,
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
        required this.is3phased,
    });

    final bool modbus;
    final bool wifi;
    final bool cellular;
    final String deviceid;
    final bool activeStatus;
    final bool is3phased;
    final String lastHeartbeat;

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        modbus: json["modbus"],
        wifi: json["wifi"],
        cellular: json["cellular"],
        deviceid: json["deviceid"],
        activeStatus: json["active_status"],
        is3phased: json["is3phased"],
        lastHeartbeat: json["last_heartbeat"],
    );

    Map<String, dynamic> toJson() => {
        "modbus": modbus,
        "wifi": wifi,
        "cellular": cellular,
        "deviceid": deviceid,
        "active_status": activeStatus,
        "is3phased": is3phased,
        "last_heartbeat": lastHeartbeat,
    };
}
