import 'dart:convert';

GetPowerPlant getPowerPlantFromJson(String str) =>
    GetPowerPlant.fromJson(json.decode(str));

String getPowerPlantToJson(GetPowerPlant data) => json.encode(data.toJson());

class GetPowerPlant {
  GetPowerPlant({
    required this.error,
    required this.message,
  });

  bool error;
  Message message;

  factory GetPowerPlant.fromJson(Map<String, dynamic> json) => GetPowerPlant(
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
    required this.user,
    required this.building,
    required this.powerplant,
    required this.inverter,
    required this.efficiency,
    required this.panelstring,
  });

  User user;
  Building building;
  Powerplant powerplant;
  Inverter inverter;
  List<Efficiency> efficiency;
  List<Panelstring> panelstring;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        user: User.fromJson(json["user"]),
        building: Building.fromJson(json["building"]),
        powerplant: Powerplant.fromJson(json["powerplant"]),
        inverter: Inverter.fromJson(json["inverter"]),
        efficiency: List<Efficiency>.from(
            json["efficiency"].map((x) => Efficiency.fromJson(x))),
        panelstring: List<Panelstring>.from(
            json["panelstring"].map((x) => Panelstring.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "building": building.toJson(),
        "powerplant": powerplant.toJson(),
        "inverter": inverter.toJson(),
        "efficiency": List<dynamic>.from(efficiency.map((x) => x.toJson())),
        "panelstring": List<dynamic>.from(panelstring.map((x) => x.toJson())),
      };
}

class Building {
  Building({
    required this.buildingId,
    required this.address,
    required this.postcode,
    required this.householdSize,
    required this.numberOfRooms,
    required this.buildupArea,
    required this.stateId,
    required this.latitude,
    required this.longitude,
  });

  int buildingId;
  String address;
  String postcode;
  int householdSize;
  int numberOfRooms;
  int buildupArea;
  int stateId;
  double latitude;
  double longitude;

  factory Building.fromJson(Map<String, dynamic> json) => Building(
        buildingId: json["BuildingID"],
        address: json["Address"],
        postcode: json["Postcode"],
        householdSize: json["HouseholdSize"],
        numberOfRooms: json["NumberOfRooms"],
        buildupArea: json["BuildupArea"],
        stateId: json["StateID"],
        latitude: json["Latitude"].toDouble(),
        longitude: json["Longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "BuildingID": buildingId,
        "Address": address,
        "Postcode": postcode,
        "HouseholdSize": householdSize,
        "NumberOfRooms": numberOfRooms,
        "BuildupArea": buildupArea,
        "StateID": stateId,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}

class Efficiency {
  Efficiency({
    required this.entryId,
    required this.year,
    required this.efficiency,
    required this.plantId,
  });

  int entryId;
  int year;
  int efficiency;
  int plantId;

  factory Efficiency.fromJson(Map<String, dynamic> json) => Efficiency(
        entryId: json["EntryID"],
        year: json["Year"],
        efficiency: json["Efficiency"],
        plantId: json["PlantID"],
      );

  Map<String, dynamic> toJson() => {
        "EntryID": entryId,
        "Year": year,
        "Efficiency": efficiency,
        "PlantID": plantId,
      };
}

class Inverter {
  Inverter({
    required this.inverterInstallationId,
    required this.inverterId,
    required this.installationDate,
  });

  int inverterInstallationId;
  int inverterId;
  String installationDate;

  factory Inverter.fromJson(Map<String, dynamic> json) => Inverter(
        inverterInstallationId: json["InverterInstallationID"],
        inverterId: json["InverterID"],
        installationDate: json["InstallationDate"],
      );

  Map<String, dynamic> toJson() => {
        "InverterInstallationID": inverterInstallationId,
        "InverterID": inverterId,
        "InstallationDate": installationDate,
      };
}

class Panelstring {
  Panelstring({
    required this.stringInstallationId,
    required this.stringModelId,
    required this.solarPanelId,
    required this.elevation,
    required this.orientation,
    required this.numberOfPanels,
    required this.systemSize,
    required this.productionOffset,
    required this.installationDate,
  });

  int stringInstallationId;
  int stringModelId;
  int solarPanelId;
  int elevation;
  String orientation;
  int numberOfPanels;
  double systemSize;
  int productionOffset;
  String installationDate;

  factory Panelstring.fromJson(Map<String, dynamic> json) => Panelstring(
        stringInstallationId: json["StringInstallationID"],
        stringModelId: json["StringModelID"],
        solarPanelId: json["SolarPanelID"],
        elevation: json["Elevation"],
        orientation: json["Orientation"],
        numberOfPanels: json["NumberOfPanels"],
        systemSize: json["SystemSize"].toDouble(),
        productionOffset: json["ProductionOffset"],
        installationDate: json["InstallationDate"],
      );

  Map<String, dynamic> toJson() => {
        "StringInstallationID": stringInstallationId,
        "StringModelID": stringModelId,
        "SolarPanelID": solarPanelId,
        "Elevation": elevation,
        "Orientation": orientation,
        "NumberOfPanels": numberOfPanels,
        "SystemSize": systemSize,
        "ProductionOffset": productionOffset,
        "InstallationDate": installationDate,
      };
}

class Powerplant {
  Powerplant({
    required this.plantId,
    required this.initialInvestmentCost,
    required this.maintenanceCost,
  });

  int plantId;
  int initialInvestmentCost;
  int maintenanceCost;

  factory Powerplant.fromJson(Map<String, dynamic> json) => Powerplant(
        plantId: json["PlantID"],
        initialInvestmentCost: json["InitialInvestmentCost"],
        maintenanceCost: json["MaintenanceCost"],
      );

  Map<String, dynamic> toJson() => {
        "PlantID": plantId,
        "InitialInvestmentCost": initialInvestmentCost,
        "MaintenanceCost": maintenanceCost,
      };
}

class User {
  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.username,
    required this.roleId,
  });

  int userId;
  String firstName;
  String lastName;
  String email;
  String phoneNo;
  String username;
  int roleId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phoneNo: json["PhoneNo"],
        username: json["Username"],
        roleId: json["RoleID"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNo": phoneNo,
        "Username": username,
        "RoleID": roleId,
      };
}
