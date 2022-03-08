
import 'dart:convert';

PerformanceOverview performanceOverviewFromJson(String str) => PerformanceOverview.fromJson(json.decode(str));

String performanceOverviewToJson(PerformanceOverview data) => json.encode(data.toJson());

class PerformanceOverview {
    PerformanceOverview({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory PerformanceOverview.fromJson(Map<String, dynamic> json) => PerformanceOverview(
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
        required this.data,
        required this.solarPowerGenerated,
        required this.householdPowerUsage,
        required this.fromGrid,
        required this.toGrid,
        required this.roi,
        required this.roiPercentage,
        required this.totalInvestment,
        required this.annualEstimatedProjection,
        required this.annualPowerGenerated,
        required this.carbonSavings,
        required this.treesPlanted,
        required this.year,
        required this.billNextMonth,
        required this.billLastMonth,
        required this.powerGenerationThreshold,
        required this.costSavings,
    });

    List<Datum> data;
    double solarPowerGenerated;
    double householdPowerUsage;
    double fromGrid;
    double toGrid;
    double roi;
    String roiPercentage;
    int totalInvestment;
    double annualEstimatedProjection;
    double annualPowerGenerated;
    double carbonSavings;
    double treesPlanted;
    int year;
    String billNextMonth;
    String billLastMonth;
    int powerGenerationThreshold;
    num costSavings;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        solarPowerGenerated: json["solar_power_generated"].toDouble(),
        householdPowerUsage: json["household_power_usage"].toDouble(),
        fromGrid: json["from_grid"].toDouble(),
        toGrid: json["to_grid"].toDouble(),
        roi: (json["roi"] != null) ? json["roi"].toDouble(): 0.0,
        roiPercentage: json["roi_percentage"],
        totalInvestment: json["total_investment"],
        annualEstimatedProjection: json["annual_estimated_projection"].toDouble(),
        annualPowerGenerated: json["annual_power_generated"].toDouble(),
        carbonSavings: json["carbon_savings"].toDouble(),
        treesPlanted: json["trees_planted"].toDouble(),
        year: json["year"],
        billNextMonth: json["bill_next_month"],
        billLastMonth: json["bill_last_month"],
        powerGenerationThreshold: json["power_generation_threshold"],
        costSavings: json["cost_savings"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "solar_power_generated": solarPowerGenerated,
        "household_power_usage": householdPowerUsage,
        "from_grid": fromGrid,
        "to_grid": toGrid,
        "roi": roi,
        "roi_percentage": roiPercentage,
        "total_investment": totalInvestment,
        "annual_estimated_projection": annualEstimatedProjection,
        "annual_power_generated": annualPowerGenerated,
        "carbon_savings": carbonSavings,
        "trees_planted": treesPlanted,
        "year": year,
        "bill_next_month": billNextMonth,
        "bill_last_month": billLastMonth,
        "power_generation_threshold": powerGenerationThreshold,
        "cost_savings": costSavings,
    };
}

class Datum {
    Datum({
        required this.powerConsumption,
        required this.powerGenerated,
        required this.toGrid,
        required this.fromGrid,
        required this.duration,
    });

    double powerConsumption;
    double powerGenerated;
    double toGrid;
    double fromGrid;
    String duration;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        powerConsumption: json["power_consumption"].toDouble(),
        powerGenerated: json["power_generated"].toDouble(),
        toGrid: json["to_grid"].toDouble(),
        fromGrid: json["from_grid"].toDouble(),
        duration: json["duration"],
    );

    Map<String, dynamic> toJson() => {
        "power_consumption": powerConsumption,
        "power_generated": powerGenerated,
        "to_grid": toGrid,
        "from_grid": fromGrid,
        "duration": duration,
    };
}
