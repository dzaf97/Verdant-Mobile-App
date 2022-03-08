import 'dart:convert';

Roles rolesFromJson(String str) => Roles.fromJson(json.decode(str));

String rolesToJson(Roles data) => json.encode(data.toJson());

class Roles {
    Roles({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory Roles.fromJson(Map<String, dynamic> json) => Roles(
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
        required this.roleId,
        required this.roleName,
    });

    final int roleId;
    final String roleName;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        roleId: json["RoleID"],
        roleName: json["RoleName"],
    );

    Map<String, dynamic> toJson() => {
        "RoleID": roleId,
        "RoleName": roleName,
    };
}
