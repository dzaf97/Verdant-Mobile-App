import 'dart:convert';

States statesFromJson(String str) => States.fromJson(json.decode(str));

String statesToJson(States data) => json.encode(data.toJson());

class States {
    States({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory States.fromJson(Map<String, dynamic> json) => States(
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
        required this.stateId,
        required this.stateName,
    });

    final int stateId;
    final String stateName;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        stateId: json["StateID"],
        stateName: json["StateName"],
    );

    Map<String, dynamic> toJson() => {
        "StateID": stateId,
        "StateName": stateName,
    };
}
