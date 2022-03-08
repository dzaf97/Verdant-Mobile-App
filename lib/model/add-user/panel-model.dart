
import 'dart:convert';

PanelModel panelModelFromJson(String str) => PanelModel.fromJson(json.decode(str));

String panelModelToJson(PanelModel data) => json.encode(data.toJson());

class PanelModel {
    PanelModel({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory PanelModel.fromJson(Map<String, dynamic> json) => PanelModel(
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
        required this.solarPanelId,
        required this.modelName,
        required this.brandName,
        required this.dsy,
        required this.warrantyPeriod,
    });

    final int solarPanelId;
    final String modelName;
    final String brandName;
    final int dsy;
    final int warrantyPeriod;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        solarPanelId: json["SolarPanelID"],
        modelName: json["ModelName"],
        brandName: json["BrandName"],
        dsy: json["DSY"],
        warrantyPeriod: json["WarrantyPeriod"],
    );

    Map<String, dynamic> toJson() => {
        "SolarPanelID": solarPanelId,
        "ModelName": modelName,
        "BrandName": brandName,
        "DSY": dsy,
        "WarrantyPeriod": warrantyPeriod,
    };
}
