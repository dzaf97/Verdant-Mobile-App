import 'dart:convert';

Strings stringsFromJson(String str) => Strings.fromJson(json.decode(str));

String stringsToJson(Strings data) => json.encode(data.toJson());

class Strings {
    Strings({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory Strings.fromJson(Map<String, dynamic> json) => Strings(
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
        required this.elevation,
        required this.orientation,
        required this.systemSize,
    });

    final int elevation;
    final String orientation;
    final String systemSize;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        elevation: json["Elevation"],
        orientation: json["Orientation"],
        systemSize: json["SystemSize"],
    );

    Map<String, dynamic> toJson() => {
        "Elevation": elevation,
        "Orientation": orientation,
        "SystemSize": systemSize,
    };
}
