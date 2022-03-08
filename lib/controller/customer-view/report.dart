import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:verdant_solar/model/customer-view/report.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';

class ReportController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 1.obs;
  var visible = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  var datePickerController = DateRangePickerController().obs;
  var startDate = "".obs;
  var endDate = "".obs;

  generateReport(bool isAdmin) async {
    visible.value = true;

    // INITIALIZE PDF SETTINGS
    final pdf = pw.Document();
    var ttf = await fontFromAssetBundle('assets/fonts/Calibri_Regular.ttf');
    final verdant =
        await imageFromAssetBundle('assets/images/verdant-logo.png');

    if (datePickerController.value.selectedRange == null)
      return warningDialog('Please select date range!');

    var res;
    if (isAdmin) {
      String userID = box.read('selected-id');
      res = await network.get(
          '/solar/api/v1/report/$userID?start_date=$startDate&end_date=$endDate');
    } else {
      res = await network
          .get('/solar/api/v1/report?start_date=$startDate&end_date=$endDate');
    }

    Report data;

    if (res['error']) return warningDialog(res['message']);
    data = Report.fromJson(res);

    String name = data.message.fullName;

    var splitAddress = data.message.address.split(' ');
    String formatAddress = "";

    for (var i = 0; i < splitAddress.length; i++) {
      if (i % 3 == 0 && i != 0) {
        formatAddress = formatAddress + splitAddress[i] + "\n";
      } else {
        formatAddress = formatAddress + splitAddress[i] + " ";
      }
    }

    // TARIFF
    List<pw.Widget> tariffs = [];
    var tariff = data.message.tariff;
    for (var i = 0; i < tariff.length; i++) {
      if (i == 0) {
        tariffs.add(
          tariffData(
            topMargin: 10.0,
            ttf: ttf,
            tariffBlock:
                "First ${tariff[i].categoryEnd} kWh (${tariff[i].categoryStart} - ${tariff[i].categoryEnd} kWh) per month",
            unit: "${tariff[i].importUnitKwh}",
            price: "${tariff[i].rate}",
            total: "${tariff[i].importCost}",
          ),
        );
      } else if (i == tariff.length - 1) {
        tariffs.add(
          tariffData(
            topMargin: 0.0,
            ttf: ttf,
            tariffBlock:
                "For the next kWh (${tariff[i].categoryStart} onwards) per month",
            unit: "${tariff[i].importUnitKwh}",
            price: "${tariff[i].rate}",
            total: "${tariff[i].importCost}",
          ),
        );
      } else {
        tariffs.add(
          tariffData(
            topMargin: 0.0,
            ttf: ttf,
            tariffBlock:
                "First ${tariff[i].categoryEnd} kWh (${tariff[i].categoryStart} - ${tariff[i].categoryEnd} kWh) per month",
            unit: "${tariff[i].importUnitKwh}",
            price: "${tariff[i].rate}",
            total: "${tariff[i].importCost}",
          ),
        );
      }
    }

    tariffs.add(
      tariffData(
        topMargin: 10.0,
        ttf: ttf,
        tariffBlock: "The minimum monthly charge is RM3.00",
        unit: "",
        price: "3.00",
        total: "",
      ),
    );

    tariffs.add(
      tariffData(
        topMargin: 10.0,
        ttf: ttf,
        tariffBlock: "Total Import",
        unit: "${data.message.billBreakdown.importUnit}",
        price: "Total Import (RM)",
        total: "${data.message.billBreakdown.importCost}",
      ),
    );

    // EXPORT TARIFF
    List<pw.Widget> exportTariffs = [];
    var tarifexportTariffsf = data.message.tariff;
    for (var i = 0; i < tarifexportTariffsf.length; i++) {
      (i != 0)
          ? exportTariffs.add(
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock: "${tariff[i].categoryStart}",
                unit: "${tariff[i].exportUnitKwh}",
                price: "${tariff[i].rate}",
                total: "${tariff[i].exportCost}",
              ),
            )
          : exportTariffs.add(
              tariffData(
                topMargin: 10.0,
                ttf: ttf,
                tariffBlock: "${tariff[i].categoryStart}",
                unit: "${tariff[i].exportUnitKwh}",
                price: "${tariff[i].rate}",
                total: "${tariff[i].exportCost}",
              ),
            );
    }

    exportTariffs.add(
      tariffData(
        topMargin: 10.0,
        ttf: ttf,
        tariffBlock: "Total Export (kWh)",
        unit: "${data.message.billBreakdown.exportUnit}",
        price: "Total Export (RM)",
        total: "${data.message.billBreakdown.exportCost}",
      ),
    );

    // TOTAL MONTHLY TNB BILL SAVINGS (5 PAST MONTH)
    var months = [];
    for (var item in data.message.billSaving) {
      months.add({"Month": item.month, "TNBBill": item.tnbBill.toPrecision(2)});
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData(
            iconTheme: pw.IconThemeData(color: PdfColor.fromHex("248a75"))),
        margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                margin: pw.EdgeInsets.fromLTRB(30, 40, 0, 25),
                child: pw.Text(
                  "SOLAR PERFORMANCE REPORT",
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 9,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: pw.Text(
                            name,
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 16,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ),
                        pw.Container(
                          margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: pw.Text(
                            formatAddress,
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 16,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(0, 5, 30, 20),
                      child: pw.Image(verdant),
                    ),
                  )
                ],
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 20),
                width: PdfPageFormat.a4.width,
                height: 21,
                child: pw.Row(
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: pw.Text(
                        "Bill Date",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: pw.Text(
                        data.message.dateRange,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 10),
                width: PdfPageFormat.a4.width,
                height: 21,
                color: PdfColor.fromHex("248a75"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 10,
                      child: pw.Container(
                        margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: pw.Text(
                          "TNB Residential Tariff (Traiff Block)",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        child: pw.Text(
                          "Unit (kWh)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        child: pw.Text(
                          "Price / kWh (RM)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        child: pw.Text(
                          "Total (RM)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Column(children: tariffs),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 10),
                width: PdfPageFormat.a4.width,
                height: 21,
                color: PdfColor.fromHex("248a75"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 10,
                      child: pw.Container(
                        margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: pw.Text(
                          "Export Tariff Block (kWh)",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        child: pw.Text(
                          "Prorate Block (kWh)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        child: pw.Text(
                          "Rate (RM)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        child: pw.Text(
                          "Amount (RM)",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Column(children: exportTariffs),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 10),
                width: PdfPageFormat.a4.width,
                height: 21,
                color: PdfColor.fromHex("248a75"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 10,
                      child: pw.Container(
                        margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: pw.Text(
                          "Description",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        child: pw.Text(
                          "ST Exempt",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        child: pw.Text(
                          "ST Applied",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        child: pw.Text(
                          "Total",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              tariffData(
                topMargin: 10.0,
                ttf: ttf,
                tariffBlock: "Consumption (kWh import)",
                unit: "${data.message.billBreakdown.consumptionKwhstExempt}",
                price: "${data.message.billBreakdown.consumptionKwhstApplied}",
                total:
                    "${data.message.billBreakdown.consumptionKwhstExempt + data.message.billBreakdown.consumptionKwhstApplied}",
              ),
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock: "Consumption (RM)",
                unit: "${data.message.billBreakdown.consumptionRmstExempt}",
                price: "${data.message.billBreakdown.consumptionRmstApplied}",
                total:
                    "${data.message.billBreakdown.consumptionRmstExempt + data.message.billBreakdown.consumptionRmstApplied}",
              ),
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock: "Current Month Consumption (RM)",
                unit: "${data.message.billBreakdown.consumptionRmstExempt}",
                price: "${data.message.billBreakdown.consumptionRmstApplied}",
                total:
                    "${data.message.billBreakdown.consumptionRmstExempt + data.message.billBreakdown.consumptionRmstApplied}",
              ),
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock: "Service Tax (6%)",
                unit: "",
                price: "",
                total: "${data.message.billBreakdown.serviceTaxTotal}",
              ),
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock: "KWTBB (1.6%)",
                unit: "",
                price: "",
                total: "${data.message.billBreakdown.kwtbb}",
              ),
              tariffData(
                topMargin: 10.0,
                ttf: ttf,
                tariffBlock: "Current Change (Import)",
                unit: "",
                price: "",
                total: "${data.message.billBreakdown.currentCharge}",
              ),
              tariffData(
                topMargin: 0.0,
                ttf: ttf,
                tariffBlock:
                    "kWh Export : ${data.message.billBreakdown.exportUnit} (RM)",
                unit: "${data.message.billBreakdown.exportCost}-",
                price: "",
                total: "${data.message.billBreakdown.exportCost}-",
              ),
              tariffData(
                topMargin: 10.0,
                ttf: ttf,
                tariffBlock: "Current Change (RM)",
                unit: "",
                price: "",
                total: "${data.message.billBreakdown.exportCost}-",
              ),
              tariffData(
                topMargin: 10.0,
                ttf: ttf,
                tariffBlock: "Grand Total (RM)",
                unit: "",
                price: "",
                total: "${data.message.billBreakdown.grandTotal}",
              ),
            ],
          );
        },
      ),
    );

    List<pw.Widget> secondPage = [
      header(
        title: "Total Monthly TNB Bills Savings",
        topMargin: 20.0,
        ttf: ttf,
      ),
      totalMonthlyTNBBillSavings(ttf: ttf, months: months),
      header(
        title: "ROI to date",
        topMargin: 10.0,
        ttf: ttf,
      ),
      dataRow(
        title: "System Price",
        subTitle: ": RM ${data.message.roiToDate.systemPrice}",
        topMargin: 10.0,
        ttf: ttf,
      ),
      dataRow(
        title: "ROI to date",
        subTitle:
            ": RM ${data.message.roiToDate.roi.toPrecision(2)} (${data.message.roiToDate.roiPercentage.toPrecision(2)}%)",
        topMargin: 0.0,
        ttf: ttf,
      ),
      header(
        title: "Co2 Savings",
        topMargin: 10.0,
        ttf: ttf,
      ),
      dataRow(
        title: "Total Production (kWh) X (694/1000) kgCo2",
        subTitle: ": ${data.message.carbonSaving.carbon.toPrecision(2)}kg",
        topMargin: 10.0,
        ttf: ttf,
      ),
      dataRow(
        title: "10000kWh = 694kgCo2",
        subTitle: "",
        topMargin: 10.0,
        ttf: ttf,
      ),
      header(
        title: "Annual Power Generation",
        topMargin: 10.0,
        ttf: ttf,
      ),
    ];

    // for (var i = 2; i < 9; i++) {
    //   data.message.annualPowerGeneration.add(AnnualPowerGeneration(
    //     numberOfYears: 1,
    //     systemSize: "173.10",
    //     dailyProjectedProduction: "605.85",
    //     efficiency: "100",
    //     year: "$i",
    //   ));
    // }

    for (var i = 0; i < data.message.annualPowerGeneration.length; i++) {
      if (i == 7) break;
      secondPage.add(
        annualPower(
          year: data.message.annualPowerGeneration[i].year,
          projectedPerformance:
              data.message.annualPowerGeneration[i].efficiency,
          systemSize: data.message.annualPowerGeneration[i].systemSize,
          dailyProduction:
              data.message.annualPowerGeneration[i].dailyProjectedProduction,
          topMargin: 10.0,
          ttf: ttf,
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
        build: (pw.Context context) {
          return pw.Column(
            children: secondPage,
          );
        },
      ),
    );

    if (data.message.annualPowerGeneration.length > 7) {
      int initLength = 0; // MAXIMUM ANNUAL POWER GENERATION DATA PER PAGE
      data.message.annualPowerGeneration = data.message.annualPowerGeneration
          .sublist(7); // REMOVE DATA THAT ALREADY INSERT IN SECOND PAGE

      for (var i = 0; i < data.message.annualPowerGeneration.length;) {
        if (i % 12 == 0) {
          initLength += 12;
          List<pw.Widget> page = [
            header(
              title: "Annual Power Generation",
              topMargin: 10.0,
              ttf: ttf,
            ),
          ];

          // STORING ONLY 12 DATA PER PAGE
          for (i = i; i < initLength; i++) {
            try {
              page.add(
                annualPower(
                  year: data.message.annualPowerGeneration[i].year,
                  projectedPerformance:
                      data.message.annualPowerGeneration[i].efficiency,
                  systemSize: data.message.annualPowerGeneration[i].systemSize,
                  dailyProduction: data.message.annualPowerGeneration[i]
                      .dailyProjectedProduction,
                  topMargin: 10.0,
                  ttf: ttf,
                ),
              );
            } catch (e) {
              break;
            }
          }

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
              build: (pw.Context context) {
                return pw.Column(
                  children: page,
                );
              },
            ),
          );
        }
      }
    }

    Timer(Duration(milliseconds: 5000), () {
      visible.value = false;
    });

    Get.dialog(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 80, 20, 10),
            height: Get.height * 0.7,
            child: SafeArea(
              child: Theme(
                data: ThemeData(primaryColor: Color(kPrimaryColor)),
                child: PdfPreview(
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  initialPageFormat: PdfPageFormat.a4,
                  build: (format) => pdf.save(),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedOpacity(
              opacity: visible.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: Get.height * 0.05,
                width: Get.width * 0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Tap then Pinch to Zoom',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  totalMonthlyTNBBillSavings({ttf, months}) {
    var monthWidgets = <pw.Widget>[
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Container(
              width: PdfPageFormat.a4.width * 0.07,
              margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: pw.Text(
                "Month",
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
            pw.Container(
              width: PdfPageFormat.a4.width * 0.4,
              margin: pw.EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: pw.Text(
                "Monthly TNB Bills savings after tax (RM)",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    for (var item in months) {
      monthWidgets.add(
        pw.Container(
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: PdfPageFormat.a4.width * 0.1,
                margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: pw.Text(
                  item["Month"],
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 14,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.Container(
                width: PdfPageFormat.a4.width * 0.3,
                margin: pw.EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: pw.Text(
                  item["TNBBill"].toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 14,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return pw.Container(
      margin: pw.EdgeInsets.only(top: 20),
      width: PdfPageFormat.a4.width,
      child: pw.Column(children: monthWidgets),
    );
  }

  dataRow({ttf, topMargin, title, subTitle}) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: topMargin),
      width: PdfPageFormat.a4.width,
      height: 20,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Container(
              margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              child: pw.Text(
                subTitle,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  annualPower(
      {ttf,
      topMargin,
      year,
      projectedPerformance,
      systemSize,
      dailyProduction}) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: topMargin),
      width: PdfPageFormat.a4.width,
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: pw.Text(
                    year,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: pw.Text(
                    "Projected Performance",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 4,
                child: pw.Container(
                  child: pw.Text(
                    ": $projectedPerformance%",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: pw.Text(
                    "System size (kWp)",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 4,
                child: pw.Container(
                  child: pw.Text(
                    ": $systemSize",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: pw.Text(
                    "Daily projected production (kWh)",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 4,
                child: pw.Container(
                  child: pw.Text(
                    ": $dailyProduction",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 14,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  header({ttf, topMargin, title}) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: topMargin),
      width: PdfPageFormat.a4.width,
      height: 21,
      color: PdfColor.fromHex("248a75"),
      child: pw.Container(
        alignment: pw.Alignment.centerLeft,
        margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: pw.Text(
          title,
          style: pw.TextStyle(
            font: ttf,
            fontSize: 14,
            color: PdfColors.white,
          ),
        ),
      ),
    );
  }

  tariffData({ttf, topMargin, tariffBlock, unit, price, total}) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: topMargin),
      width: PdfPageFormat.a4.width,
      height: 20,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 10,
            child: pw.Container(
              margin: pw.EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: pw.Text(
                tariffBlock,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              child: pw.Text(
                unit,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              child: pw.Text(
                price,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              child: pw.Text(
                total,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/cust-overview');
        break;
      case 1:
        break;
      case 2:
        Get.offNamed('/my-profile');
        break;
      default:
    }
  }
}
