
import 'dart:convert';

StringList stringListFromJson(String str) => StringList.fromJson(json.decode(str));

String stringListToJson(StringList data) => json.encode(data.toJson());

class StringList {
    StringList({
        required this.error,
        required this.message,
    });

    bool error;
    List<Message> message;

    factory StringList.fromJson(Map<String, dynamic> json) => StringList(
        error: json["error"],
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
    };
}

class Message {
    Message({
        required this.deviceId,
        required this.systemSize,
    });

    String deviceId;
    double systemSize;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        deviceId: json["DeviceID"],
        systemSize: json["SystemSize"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "DeviceID": deviceId,
        "SystemSize": systemSize,
    };
}
