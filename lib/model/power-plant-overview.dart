import 'dart:convert';

PowerPlantOverview powerPlantOverviewFromJson(String str) => PowerPlantOverview.fromJson(json.decode(str));

String powerPlantOverviewToJson(PowerPlantOverview data) => json.encode(data.toJson());

class PowerPlantOverview {
    PowerPlantOverview({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory PowerPlantOverview.fromJson(Map<String, dynamic> json) => PowerPlantOverview(
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
        required this.fullName,
        required this.plantStatus,
        required this.overvoltage,
        required this.undervoltage,
        required this.networkConnection,
        required this.solarInverterConnection,
        required this.powerMeterConnection,
        required this.gridConnection,
        required this.warrantyExpiry,
        required this.dsykwhkwp,
        required this.plantHealth,
        required this.efficiency,
        required this.projectedGeneration,
        required this.daysInstalled,
        required this.plantHealthFailure,
        required this.missingEfficiency,
        required this.efficiencyDrop,
        required this.plantId,
    });

    final int userId;
    final String fullName;
    final String plantStatus;
    final String overvoltage;
    final String undervoltage;
    final String networkConnection;
    final String solarInverterConnection;
    final String powerMeterConnection;
    final String gridConnection;
    final String warrantyExpiry;
    final String dsykwhkwp;
    final String plantHealth;
    final String efficiency;
    final String projectedGeneration;
    final String daysInstalled;
    final bool plantHealthFailure;
    final bool missingEfficiency;
    final bool efficiencyDrop;
    final int plantId;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["UserID"],
        fullName: json["FullName"],
        plantStatus: json["PlantStatus"],
        overvoltage: json["Overvoltage"],
        undervoltage: json["Undervoltage"],
        networkConnection: json["NetworkConnection"],
        solarInverterConnection: json["SolarInverterConnection"],
        powerMeterConnection: json["PowerMeterConnection"],
        gridConnection: json["GridConnection"],
        warrantyExpiry: json["WarrantyExpiry"],
        dsykwhkwp: json["DSYKWHKWP"],
        plantHealth: json["PlantHealth"],
        efficiency: json["Efficiency"],
        projectedGeneration: json["ProjectedGeneration"],
        daysInstalled: json["DaysInstalled"],
        plantHealthFailure: json["PlantHealthFailure"],
        missingEfficiency: json["MissingEfficiency"],
        efficiencyDrop: json["EfficiencyDrop"],
        plantId: json["PlantID"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FullName": fullName,
        "PlantStatus": plantStatus,
        "Overvoltage": overvoltage,
        "Undervoltage": undervoltage,
        "NetworkConnection": networkConnection,
        "SolarInverterConnection": solarInverterConnection,
        "PowerMeterConnection": powerMeterConnection,
        "GridConnection": gridConnection,
        "WarrantyExpiry": warrantyExpiry,
        "DSYKWHKWP": dsykwhkwp,
        "PlantHealth": plantHealth,
        "Efficiency": efficiency,
        "ProjectedGeneration": projectedGeneration,
        "DaysInstalled": daysInstalled,
        "PlantHealthFailure": plantHealthFailure,
        "MissingEfficiency": missingEfficiency,
        "EfficiencyDrop": efficiencyDrop,
        "PlantID": plantId,
    };
}
