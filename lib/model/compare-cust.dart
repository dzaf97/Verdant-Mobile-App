import 'dart:convert';

CompareCust compareCustFromJson(String str) => CompareCust.fromJson(json.decode(str));

String compareCustToJson(CompareCust data) => json.encode(data.toJson());

class CompareCust {
    CompareCust({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory CompareCust.fromJson(Map<String, dynamic> json) => CompareCust(
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
        required this.buildingId,
        required this.customer,
        required this.systemSize,
        required this.location,
        required this.data,
    });

    final String buildingId;
    final String customer;
    final String systemSize;
    final String location;
    final List<Datum> data;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        buildingId: json["building_id"],
        customer: json["customer"],
        systemSize: json["system_size"],
        location: json["location"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "building_id": buildingId,
        "customer": customer,
        "system_size": systemSize,
        "location": location,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.totalProduction,
        required this.duration,
        required this.adpkwh,
        required this.dsykwhkwp,
    });

    final String totalProduction;
    final String duration;
    final double adpkwh;
    final double dsykwhkwp;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalProduction: json["total_production"],
        duration: json["duration"],
        adpkwh: json["adpkwh"].toDouble(),
        dsykwhkwp: json["dsykwhkwp"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "total_production": totalProduction,
        "duration": duration,
        "adpkwh": adpkwh,
        "dsykwhkwp": dsykwhkwp,
    };
}
