
import 'dart:convert';

BattData battDataFromJson(String str) => BattData.fromJson(json.decode(str));

String battDataToJson(BattData data) => json.encode(data.toJson());

class BattData {
    BattData({
        required this.error,
        required this.message,
    });

    final bool error;
    final Message message;

    factory BattData.fromJson(Map<String, dynamic> json) => BattData(
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
        required this.lastUpdated,
        required this.status,
    });

    final Data data;
    final String lastUpdated;
    final bool status;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: Data.fromJson(json["data"]),
        lastUpdated: json["last_updated"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "last_updated": lastUpdated,
        "status": status,
    };
}

class Data {
    Data({
        required this.stateOfCharge,
        required this.chargingRate,
        required this.voltage,
        required this.temperature,
        required this.modbus,
        required this.wifi,
        required this.cellular,
        required this.deviceId,
    });

    final int stateOfCharge;
    final int chargingRate;
    final int voltage;
    final int temperature;
    final bool modbus;
    final bool wifi;
    final bool cellular;
    final String deviceId;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        stateOfCharge: json["StateOfCharge"],
        chargingRate: json["ChargingRate"],
        voltage: json["Voltage"],
        temperature: json["Temperature"],
        modbus: json["modbus"],
        wifi: json["wifi"],
        cellular: json["cellular"],
        deviceId: json["DeviceID"],
    );

    Map<String, dynamic> toJson() => {
        "StateOfCharge": stateOfCharge,
        "ChargingRate": chargingRate,
        "Voltage": voltage,
        "Temperature": temperature,
        "modbus": modbus,
        "wifi": wifi,
        "cellular": cellular,
        "DeviceID": deviceId,
    };
}
