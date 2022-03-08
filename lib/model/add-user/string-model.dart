import 'dart:convert';

StringModel stringModelFromJson(String str) => StringModel.fromJson(json.decode(str));

String stringModelToJson(StringModel data) => json.encode(data.toJson());

class StringModel {
    StringModel({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory StringModel.fromJson(Map<String, dynamic> json) => StringModel(
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
        required this.warrantyPeriod,
    });

    final int id;
    final String modelName;
    final String brandName;
    final int warrantyPeriod;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["ID"],
        modelName: json["ModelName"],
        brandName: json["BrandName"],
        warrantyPeriod: json["WarrantyPeriod"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "ModelName": modelName,
        "BrandName": brandName,
        "WarrantyPeriod": warrantyPeriod,
    };
}
