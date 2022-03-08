
import 'dart:convert';

StringData stringDataFromJson(String str) => StringData.fromJson(json.decode(str));

String stringDataToJson(StringData data) => json.encode(data.toJson());

class StringData {
    StringData({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory StringData.fromJson(Map<String, dynamic> json) => StringData(
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
    });

    List<Datum> data;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.deviceId,
        required this.volt,
        required this.current,
        required this.powerGenerated,
        required this.duration,
    });

    String deviceId;
    int volt;
    int current;
    int powerGenerated;
    String duration;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        deviceId: json["DeviceID"],
        volt: json["Volt"],
        current: json["Current"],
        powerGenerated: json["PowerGenerated"],
        duration: json["Duration"],
    );

    Map<String, dynamic> toJson() => {
        "DeviceID": deviceId,
        "Volt": volt,
        "Current": current,
        "PowerGenerated": powerGenerated,
        "Duration": duration,
    };
}
