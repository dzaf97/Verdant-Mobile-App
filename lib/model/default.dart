// To parse this JSON data, do
//
//     final default = defaultFromJson(jsonString);

import 'dart:convert';

Default defaultFromJson(String str) => Default.fromJson(json.decode(str));

String defaultToJson(Default data) => json.encode(data.toJson());

class Default {
    Default({
        required this.error,
        required this.message,
    });

    bool error;
    String message;

    factory Default.fromJson(Map<String, dynamic> json) => Default(
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
    };
}
