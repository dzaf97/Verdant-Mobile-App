
import 'dart:convert';

LuxData luxDataFromJson(String str) => LuxData.fromJson(json.decode(str));

String luxDataToJson(LuxData data) => json.encode(data.toJson());

class LuxData {
    LuxData({
        required this.error,
        required this.message,
    });

    final bool error;
    final Message message;

    factory LuxData.fromJson(Map<String, dynamic> json) => LuxData(
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
        required this.value,
        required this.duration,
        required this.deviceId,
    });

    final double value;
    final String duration;
    final String deviceId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        value: json["Value"].toDouble(),
        duration: json["Duration"],
        deviceId: json["DeviceID"],
    );

    Map<String, dynamic> toJson() => {
        "Value": value,
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
    });

    final bool modbus;
    final bool wifi;
    final bool cellular;
    final String deviceid;
    final bool activeStatus;
    final String lastHeartbeat;

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        modbus: json["modbus"],
        wifi: json["wifi"],
        cellular: json["cellular"],
        deviceid: json["deviceid"],
        activeStatus: json["active_status"],
        lastHeartbeat: json["last_heartbeat"],
    );

    Map<String, dynamic> toJson() => {
        "modbus": modbus,
        "wifi": wifi,
        "cellular": cellular,
        "deviceid": deviceid,
        "active_status": activeStatus,
        "last_heartbeat": lastHeartbeat,
    };
}
