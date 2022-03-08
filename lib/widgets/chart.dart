import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:verdant_solar/controller/overview.dart';
import 'package:verdant_solar/utils/constants.dart';

class GridBarChart extends StatelessWidget {
  const GridBarChart({
    Key? key,
    required this.toGrid,
    required this.fromGrid,
  }) : super(key: key);

  final RxList<Grid> toGrid;
  final RxList<Grid> fromGrid;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(toGrid.length != 0);
      return SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.x: point.y kWh',
        ),
        series: <ChartSeries>[
          ColumnSeries<Grid, String>(
            name: "To Grid",
            width: 0.4,
            color: Color(kPrimaryColor),
            dataSource: toGrid,
            xValueMapper: (Grid toGrid, _) => toGrid.hour,
            yValueMapper: (Grid toGrid, _) => toGrid.data,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          ColumnSeries<Grid, String>(
            name: "From Grid",
            color: Color(0xfff6b642),
            width: 0.4,
            dataSource: fromGrid,
            xValueMapper: (Grid fromGrid, _) => fromGrid.hour,
            yValueMapper: (Grid fromGrid, _) => fromGrid.data,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )
        ],
      );
    });
  }
}

class CombineBarChart extends StatelessWidget {
  const CombineBarChart({
    Key? key,
    required this.data,
    required this.data2,
  }) : super(key: key);

  final RxList<PowerConsumption> data;
  final RxList<SolarGeneration> data2;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(data.length);
      return SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.x: point.y kWh',
        ),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<SolarGeneration, String>(
            name: "Solar Generation",
            width: 0.4,
            color: Color(kPrimaryColor),
            dataSource: data2,
            xValueMapper: (SolarGeneration data2, _) => data2.hour,
            yValueMapper: (SolarGeneration data2, _) => data2.data,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          ColumnSeries<PowerConsumption, String>(
            name: "Energy Consumption",
            color: Color(0xfff6b642),
            width: 0.4,
            dataSource: data,
            xValueMapper: (PowerConsumption data, _) => data.hour,
            yValueMapper: (PowerConsumption data, _) => data.data,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )
        ],
      );
    });
  }
}

class PowerBarChart extends StatelessWidget {
  const PowerBarChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RxList<PowerConsumption> data;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(data.length);
      return SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.x: point.y kWh',
        ),
        series: <ChartSeries>[
          ColumnSeries<PowerConsumption, String>(
            name: "Energy Consumption",
            width: 0.2,
            color: Color(0xfff6b642),
            dataSource: data,
            xValueMapper: (PowerConsumption data, _) => data.hour,
            yValueMapper: (PowerConsumption data, _) => data.data,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ],
      );
    });
  }
}

class SolarBarChart extends StatelessWidget {
  const SolarBarChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RxList<SolarGeneration> data;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        print(data.length);
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            canShowMarker: true,
            format: 'point.x: point.y kWh',
          ),
          series: <ChartSeries>[
            ColumnSeries<SolarGeneration, String>(
              name: "Solar Generation",
              width: 0.2,
              color: Color(kPrimaryColor),
              dataSource: data,
              xValueMapper: (SolarGeneration data, _) => data.hour,
              yValueMapper: (SolarGeneration data, _) => data.data,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ],
        );
      },
    );
  }
}

class SolarGraph extends StatelessWidget {
  const SolarGraph({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RxList<SolarGeneration> data;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.length != 0) {
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            canShowMarker: true,
            format: 'point.x: point.y kW',
          ),
          series: <ChartSeries>[
            LineSeries<SolarGeneration, String>(
              name: "Solar Generation",
              color: Color(kPrimaryColor),
              dataSource: data,
              xValueMapper: (SolarGeneration data, _) => data.hour,
              yValueMapper: (SolarGeneration data, _) => data.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(kPrimaryColor)),
            ),
          ],
        );
      } else {
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          primaryXAxis: CategoryAxis(),
          enableAxisAnimation: true,
          tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              format: 'point.x: point.y kW'),
          series: <ChartSeries>[
            LineSeries<SolarGeneration, String>(
              name: "Solar Generation",
              color: Color(kPrimaryColor),
              dataSource: data,
              xValueMapper: (SolarGeneration data, _) => data.hour,
              yValueMapper: (SolarGeneration data, _) => data.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(kPrimaryColor)),
            ),
          ],
        );
      }
    });
  }
}

class PowerGraph extends StatelessWidget {
  const PowerGraph({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RxList<PowerConsumption> data;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (data.length != 0) {
          return SfCartesianChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.top,
            ),
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                format: 'point.x: point.y kW'),
            series: <ChartSeries>[
              LineSeries<PowerConsumption, String>(
                name: "Power Consumption",
                color: Color(0xfff6b642),
                dataSource: data,
                xValueMapper: (PowerConsumption data, _) => data.hour,
                yValueMapper: (PowerConsumption data, _) => data.data,
                markerSettings: MarkerSettings(
                    isVisible: true,
                    width: 5,
                    height: 5,
                    color: Color(0xfff6b642)),
              ),
            ],
          );
        } else {
          return SfCartesianChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.top,
            ),
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                format: 'point.x: point.y kW'),
            series: <ChartSeries>[
              LineSeries<PowerConsumption, String>(
                name: "Power Consumption",
                color: Color(0xfff6b642),
                dataSource: data,
                xValueMapper: (PowerConsumption data, _) => data.hour,
                yValueMapper: (PowerConsumption data, _) => data.data,
                markerSettings: MarkerSettings(
                    isVisible: true,
                    width: 5,
                    height: 5,
                    color: Color(0xfff6b642)),
              ),
            ],
          );
        }
      },
    );
  }
}

class GridGraph extends StatelessWidget {
  const GridGraph({
    Key? key,
    required this.toGrid,
    required this.fromGrid,
  }) : super(key: key);

  final RxList<Grid> toGrid;
  final RxList<Grid> fromGrid;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(toGrid);
      return SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.x: point.y kW',
        ),
        series: <ChartSeries>[
          LineSeries<Grid, String>(
            name: "From Grid",
            color: Color(0xfff6b642),
            dataSource: toGrid,
            xValueMapper: (Grid toGrid, _) => toGrid.hour,
            yValueMapper: (Grid toGrid, _) => toGrid.data,
            markerSettings: MarkerSettings(
                isVisible: true, width: 5, height: 5, color: Color(0xfff6b642)),
          ),
          LineSeries<Grid, String>(
            name: "To Grid",
            color: Color(kPrimaryColor),
            dataSource: fromGrid,
            xValueMapper: (Grid fromGrid, _) => fromGrid.hour,
            yValueMapper: (Grid fromGrid, _) => fromGrid.data,
            markerSettings: MarkerSettings(
                isVisible: true,
                width: 5,
                height: 5,
                color: Color(kPrimaryColor)),
          ),
        ],
      );
    });
  }
}

class CombineGraph extends StatelessWidget {
  const CombineGraph({
    Key? key,
    required this.data,
    required this.data2,
  }) : super(key: key);

  final RxList<PowerConsumption> data;
  final RxList<SolarGeneration> data2;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.length != 0) {
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              header: "Power Consumption",
              format: 'point.x: point.y kW'),
          series: <ChartSeries>[
            LineSeries<PowerConsumption, String>(
              name: "Power Consumption",
              color: Color(0xfff6b642),
              dataSource: data,
              xValueMapper: (PowerConsumption data, _) => data.hour,
              yValueMapper: (PowerConsumption data, _) => data.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(0xfff6b642)),
            ),
            LineSeries<SolarGeneration, String>(
              name: "Solar Generation",
              color: Color(kPrimaryColor),
              dataSource: data2,
              xValueMapper: (SolarGeneration data2, _) => data2.hour,
              yValueMapper: (SolarGeneration data2, _) => data2.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(kPrimaryColor)),
            ),
          ],
        );
      } else {
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              header: "Power Consumption",
              format: 'point.x: point.y kW'),
          series: <ChartSeries>[
            LineSeries<PowerConsumption, String>(
              name: "Power Consumption",
              color: Color(0xfff6b642),
              dataSource: data,
              xValueMapper: (PowerConsumption data, _) => data.hour,
              yValueMapper: (PowerConsumption data, _) => data.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(0xfff6b642)),
            ),
            LineSeries<SolarGeneration, String>(
              name: "Solar Generation",
              color: Color(kPrimaryColor),
              dataSource: data2,
              xValueMapper: (SolarGeneration data2, _) => data2.hour,
              yValueMapper: (SolarGeneration data2, _) => data2.data,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 5,
                  height: 5,
                  color: Color(kPrimaryColor)),
            ),
          ],
        );
      }
    });
  }
}

class ROIGraph extends StatelessWidget {
  const ROIGraph({
    Key? key,
    required this.data,
    required this.roiPercent,
  }) : super(key: key);

  final RxList<PieChartData> data;
  final RxString roiPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      padding: EdgeInsets.symmetric(vertical: 20),
      height: Get.height * 0.3,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: Get.width * 0.5,
            child: SafeArea(
              child: Obx(() {
                print(data.length);
                var formatter = NumberFormat('#,##,000');

                return SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Container(
                        child: Obx(
                          () => Text(
                            'Investment of\nRM${formatter.format(data[1].value.toInt())}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(kPrimaryColor),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                  series: <CircularSeries>[
                    DoughnutSeries<PieChartData, String>(
                      dataSource: data,
                      pointColorMapper: (PieChartData data, _) => data.color,
                      xValueMapper: (PieChartData data, _) => data.title,
                      yValueMapper: (PieChartData data, _) => data.value,
                      innerRadius: '85%',
                      strokeColor: Colors.black26,
                      strokeWidth: 1.5,
                      radius: "80",
                    )
                  ],
                );
              }),
            ),
          ),
          Obx(
            () => RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${roiPercent.value}",
                    style: TextStyle(color: Color(kPrimaryColor), fontSize: 16),
                  ),
                  TextSpan(
                    text: "  ROI to Date",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}

class AnnualPowerBarChart extends StatelessWidget {
  const AnnualPowerBarChart({
    Key? key,
    required this.data,
    required this.estimateProjection,
    required this.year,
  }) : super(key: key);

  final RxList<PowerConsumption> data;
  final RxInt estimateProjection;
  final RxString year;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: Get.width * 0.47,
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.22,
                  child: SafeArea(
                    child: Obx(
                      () {
                        var percent70 = estimateProjection.value * 0.7;
                        return SfCartesianChart(
                          backgroundColor: Colors.white,
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: CategoryAxis(
                            interval: (estimateProjection.value / 20),
                            plotBands: <PlotBand>[
                              PlotBand(
                                verticalTextPadding: "2%",
                                text: '(70%)',
                                shouldRenderAboveSeries: true,
                                dashArray: [3, 3],
                                textAngle: 0,
                                start: percent70,
                                end: percent70,
                                textStyle: TextStyle(
                                  color: Color(kPrimaryColor),
                                  fontSize: 10,
                                ),
                                horizontalTextAlignment: TextAnchor.middle,
                                borderColor: Color(kPrimaryColor),
                                borderWidth: 2,
                              ),
                              PlotBand(
                                verticalTextPadding: "2%",
                                text: 'Est. projection',
                                horizontalTextAlignment: TextAnchor.middle,
                                dashArray: [3, 3],
                                textAngle: 0,
                                start: estimateProjection.value,
                                end: estimateProjection.value,
                                textStyle: TextStyle(
                                  color: Color(kPrimaryColor),
                                  fontSize: 10,
                                ),
                                borderColor: Color(kPrimaryColor),
                                borderWidth: 2,
                              )
                            ],
                            maximum: estimateProjection.value +
                                (estimateProjection.value / 10),
                          ),
                          series: <ChartSeries>[
                            ColumnSeries<PowerConsumption, String>(
                              name: "Power Generation",
                              width: 0.8,
                              color: Color(0xfff6b642),
                              dataSource: data,
                              yAxisName: "sad",
                              xValueMapper: (PowerConsumption data, _) =>
                                  data.hour,
                              yValueMapper: (PowerConsumption data, _) =>
                                  data.data,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                AnnualBarLegend()
              ],
            ),
          ),
          Container(
            width: Get.width * 0.42,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "ANNUAL POWER GENERATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Year",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Total Projection",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            ": $year",
                            style: TextStyle(
                              color: Color(kPrimaryColor),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          (data.length != 0) ? ": ${data[0].data}" : ": 0",
                          style: TextStyle(
                            color: Color(kPrimaryColor),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}

class AnnualBarLegend extends StatelessWidget {
  const AnnualBarLegend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 9,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                      color: Color(0xfff6b642),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("     "),
                ),
                Container(
                  child: Text(
                    " Power Generation\n",
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.circle,
                    color: Color(kPrimaryColor),
                    size: 3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.circle,
                    color: Color(kPrimaryColor),
                    size: 3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.circle,
                    color: Color(kPrimaryColor),
                    size: 3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.circle,
                    color: Color(kPrimaryColor),
                    size: 3,
                  ),
                ),
                Container(
                  child: Text(
                    " Maintenance Cost\n Threshold",
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
