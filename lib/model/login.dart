// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
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
        required this.jwtToken,
    });

    String jwtToken;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        jwtToken: json["jwt_token"],
    );

    Map<String, dynamic> toJson() => {
        "jwt_token": jwtToken,
    };
}
