import 'dart:convert';

InverterModel inverterModelFromJson(String str) => InverterModel.fromJson(json.decode(str));

String inverterModelToJson(InverterModel data) => json.encode(data.toJson());

class InverterModel {
    InverterModel({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory InverterModel.fromJson(Map<String, dynamic> json) => InverterModel(
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
        required this.id,
        required this.modelName,
        required this.brandName,
        required this.phase,
        required this.warrantyPeriod,
    });

    final int id;
    final String modelName;
    final String brandName;
    final String phase;
    final int warrantyPeriod;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["ID"],
        modelName: json["ModelName"],
        brandName: json["BrandName"],
        phase: json["Phase"],
        warrantyPeriod: json["WarrantyPeriod"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "ModelName": modelName,
        "BrandName": brandName,
        "Phase": phase,
        "WarrantyPeriod": warrantyPeriod,
    };
}
