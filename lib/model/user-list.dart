import 'dart:convert';

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

String userListToJson(UserList data) => json.encode(data.toJson());

class UserList {
    UserList({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory UserList.fromJson(Map<String, dynamic> json) => UserList(
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
        required this.userId,
        required this.username,
        required this.fullName,
        required this.userType,
        required this.dateReg,
    });

    final int userId;
    final String username;
    final String fullName;
    final String userType;
    final String dateReg;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["UserID"],
        username: json["Username"],
        fullName: json["FullName"],
        userType: json["UserType"],
        dateReg: json["DateReg"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Username": username,
        "FullName": fullName,
        "UserType": userType,
        "DateReg": dateReg,
    };
}
