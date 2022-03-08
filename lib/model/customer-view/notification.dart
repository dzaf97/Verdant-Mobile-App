import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    required this.error,
    required this.message,
  });

  bool error;
  List<Message> message;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        error: json["error"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.alertName,
    required this.deviceId,
    required this.alertReportedAt,
    required this.plantId,
    required this.isRecovered,
    required this.alertDesc,
  });

  String alertName;
  String deviceId;
  String alertReportedAt;
  int plantId;
  bool isRecovered;
  String alertDesc;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        alertName: json["AlertName"],
        deviceId: json["DeviceID"],
        alertReportedAt: json["AlertReportedAt"],
        plantId: json["PlantID"],
        isRecovered: json["IsRecovered"],
        alertDesc: json["AlertDesc"],
      );

  Map<String, dynamic> toJson() => {
        "AlertName": alertName,
        "DeviceID": deviceId,
        "AlertReportedAt": alertReportedAt,
        "PlantID": plantId,
        "IsRecovered": isRecovered,
        "AlertDesc": alertDesc,
      };
}
