import 'dart:convert';

SystemSpec systemSpecFromJson(String str) => SystemSpec.fromJson(json.decode(str));

String systemSpecToJson(SystemSpec data) => json.encode(data.toJson());

class SystemSpec {
    SystemSpec({
        required this.error,
        required this.message,
    });

    final bool error;
    final Message message;

    factory SystemSpec.fromJson(Map<String, dynamic> json) => SystemSpec(
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
        required this.systemSize,
        required this.installationDate,
        required this.solarModelName,
        required this.inverterModelName,
    });

    final double systemSize;
    final String installationDate;
    final String solarModelName;
    final String inverterModelName;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        systemSize: json["SystemSize"].toDouble(),
        installationDate: json["InstallationDate"],
        solarModelName: json["SolarModelName"],
        inverterModelName: json["InverterModelName"],
    );

    Map<String, dynamic> toJson() => {
        "SystemSize": systemSize,
        "InstallationDate": installationDate,
        "SolarModelName": solarModelName,
        "InverterModelName": inverterModelName,
    };
}
