// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
    Report({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory Report.fromJson(Map<String, dynamic> json) => Report(
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
        required this.fullName,
        required this.address,
        required this.tariff,
        required this.billBreakdown,
        required this.billSaving,
        required this.roiToDate,
        required this.carbonSaving,
        required this.annualPowerGeneration,
        required this.plantHealth,
        required this.dateRange,
    });

    String fullName;
    String address;
    List<Tariff> tariff;
    BillBreakdown billBreakdown;
    List<BillSaving> billSaving;
    RoiToDate roiToDate;
    CarbonSaving carbonSaving;
    List<AnnualPowerGeneration> annualPowerGeneration;
    String plantHealth;
    String dateRange;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        fullName: json["FullName"],
        address: json["Address"],
        tariff: List<Tariff>.from(json["Tariff"].map((x) => Tariff.fromJson(x))),
        billBreakdown: BillBreakdown.fromJson(json["BillBreakdown"]),
        billSaving: List<BillSaving>.from(json["BillSaving"].map((x) => BillSaving.fromJson(x))),
        roiToDate: RoiToDate.fromJson(json["ROIToDate"]),
        carbonSaving: CarbonSaving.fromJson(json["CarbonSaving"]),
        annualPowerGeneration: List<AnnualPowerGeneration>.from(json["AnnualPowerGeneration"].map((x) => AnnualPowerGeneration.fromJson(x))),
        plantHealth: json["PlantHealth"],
        dateRange: json["DateRange"],
    );

    Map<String, dynamic> toJson() => {
        "FullName": fullName,
        "Address": address,
        "Tariff": List<dynamic>.from(tariff.map((x) => x.toJson())),
        "BillBreakdown": billBreakdown.toJson(),
        "BillSaving": List<dynamic>.from(billSaving.map((x) => x.toJson())),
        "ROIToDate": roiToDate.toJson(),
        "CarbonSaving": carbonSaving.toJson(),
        "AnnualPowerGeneration": List<dynamic>.from(annualPowerGeneration.map((x) => x.toJson())),
        "PlantHealth": plantHealth,
        "DateRange": dateRange,
    };
}

class AnnualPowerGeneration {
    AnnualPowerGeneration({
        required this.numberOfYears,
        required this.systemSize,
        required this.dailyProjectedProduction,
        required this.efficiency,
        required this.year,
    });

    num numberOfYears;
    String systemSize;
    String dailyProjectedProduction;
    String efficiency;
    String year;

    factory AnnualPowerGeneration.fromJson(Map<String, dynamic> json) => AnnualPowerGeneration(
        numberOfYears: json["NumberOfYears"],
        systemSize: json["SystemSize"],
        dailyProjectedProduction: json["DailyProjectedProduction"],
        efficiency: json["Efficiency"],
        year: json["Year"],
    );

    Map<String, dynamic> toJson() => {
        "NumberOfYears": numberOfYears,
        "SystemSize": systemSize,
        "DailyProjectedProduction": dailyProjectedProduction,
        "Efficiency": efficiency,
        "Year": year,
    };
}

class BillBreakdown {
    BillBreakdown({
        required this.importUnit,
        required this.importCost,
        required this.exportCost,
        required this.exportUnit,
        required this.consumptionKwhstExempt,
        required this.consumptionKwhstApplied,
        required this.consumptionRmstExempt,
        required this.consumptionRmstApplied,
        required this.serviceTaxTotal,
        required this.kwtbb,
        required this.currentCharge,
        required this.grandTotal,
    });

    double importUnit;
    double importCost;
    double exportCost;
    double exportUnit;
    double consumptionKwhstExempt;
    num consumptionKwhstApplied;
    double consumptionRmstExempt;
    num consumptionRmstApplied;
    num serviceTaxTotal;
    double kwtbb;
    double currentCharge;
    double grandTotal;

    factory BillBreakdown.fromJson(Map<String, dynamic> json) => BillBreakdown(
        importUnit: json["ImportUnit"].toDouble(),
        importCost: json["ImportCost"].toDouble(),
        exportCost: json["ExportCost"].toDouble(),
        exportUnit: json["ExportUnit"].toDouble(),
        consumptionKwhstExempt: json["ConsumptionKWHSTExempt"].toDouble(),
        consumptionKwhstApplied: json["ConsumptionKWHSTApplied"],
        consumptionRmstExempt: json["ConsumptionRMSTExempt"].toDouble(),
        consumptionRmstApplied: json["ConsumptionRMSTApplied"],
        serviceTaxTotal: json["ServiceTaxTotal"],
        kwtbb: json["KWTBB"].toDouble(),
        currentCharge: json["CurrentCharge"].toDouble(),
        grandTotal: json["GrandTotal"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "ImportUnit": importUnit,
        "ImportCost": importCost,
        "ExportCost": exportCost,
        "ExportUnit": exportUnit,
        "ConsumptionKWHSTExempt": consumptionKwhstExempt,
        "ConsumptionKWHSTApplied": consumptionKwhstApplied,
        "ConsumptionRMSTExempt": consumptionRmstExempt,
        "ConsumptionRMSTApplied": consumptionRmstApplied,
        "ServiceTaxTotal": serviceTaxTotal,
        "KWTBB": kwtbb,
        "CurrentCharge": currentCharge,
        "GrandTotal": grandTotal,
    };
}

class PortBreakdownMap {
    PortBreakdownMap({
        required this.the0,
    });

    The0 the0;

    factory PortBreakdownMap.fromJson(Map<String, dynamic> json) => PortBreakdownMap(
        the0: The0.fromJson(json["0"]),
    );

    Map<String, dynamic> toJson() => {
        "0": the0.toJson(),
    };
}

class The0 {
    The0({
        required this.blockKwh,
        required this.cost,
    });

    double blockKwh;
    double cost;

    factory The0.fromJson(Map<String, dynamic> json) => The0(
        blockKwh: json["BlockKWH"].toDouble(),
        cost: json["Cost"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "BlockKWH": blockKwh,
        "Cost": cost,
    };
}

class BillSaving {
    BillSaving({
        required this.month,
        required this.tnbBill,
    });

    String month;
    double tnbBill;

    factory BillSaving.fromJson(Map<String, dynamic> json) => BillSaving(
        month: json["Month"],
        tnbBill: json["TNBBill"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Month": month,
        "TNBBill": tnbBill,
    };
}

class CarbonSaving {
    CarbonSaving({
        required this.carbon,
        required this.powerGenerated,
    });

    double carbon;
    double powerGenerated;

    factory CarbonSaving.fromJson(Map<String, dynamic> json) => CarbonSaving(
        carbon: json["Carbon"].toDouble(),
        powerGenerated: json["PowerGenerated"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Carbon": carbon,
        "PowerGenerated": powerGenerated,
    };
}

class RoiToDate {
    RoiToDate({
        required this.systemPrice,
        required this.roi,
        required this.roiPercentage,
    });

    num systemPrice;
    double roi;
    double roiPercentage;

    factory RoiToDate.fromJson(Map<String, dynamic> json) => RoiToDate(
        systemPrice: json["SystemPrice"],
        roi: json["ROI"].toDouble(),
        roiPercentage: json["ROIPercentage"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "SystemPrice": systemPrice,
        "ROI": roi,
        "ROIPercentage": roiPercentage,
    };
}

class Tariff {
    Tariff({
        required this.categoryStart,
        required this.categoryEnd,
        required this.rate,
        required this.importUnitKwh,
        required this.importCost,
        required this.exportUnitKwh,
        required this.exportCost,
    });

    num categoryStart;
    num categoryEnd;
    double rate;
    double importUnitKwh;
    double importCost;
    double exportUnitKwh;
    double exportCost;

    factory Tariff.fromJson(Map<String, dynamic> json) => Tariff(
        categoryStart: json["CategoryStart"],
        categoryEnd: json["CategoryEnd"],
        rate: json["Rate"].toDouble(),
        importUnitKwh: json["ImportUnitKWH"].toDouble(),
        importCost: json["ImportCost"].toDouble(),
        exportUnitKwh: json["ExportUnitKWH"].toDouble(),
        exportCost: json["ExportCost"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "CategoryStart": categoryStart,
        "CategoryEnd": categoryEnd,
        "Rate": rate,
        "ImportUnitKWH": importUnitKwh,
        "ImportCost": importCost,
        "ExportUnitKWH": exportUnitKwh,
        "ExportCost": exportCost,
    };
}
