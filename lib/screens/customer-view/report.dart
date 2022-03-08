import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:verdant_solar/controller/customer-view/report.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class Report extends StatelessWidget {
  final controller = Get.put(ReportController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: PreferredSize(
          preferredSize: Size(Get.width, Get.height * 0.25),
          child: Stack(
            children: [
              Container(
                width: Get.width,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    'assets/images/Verdant Banner BG.png',
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "SOLAR PERFORMANCE REPORT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              AppBar(
                leading: Theme(
                  data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 40),
                width: Get.width * 0.93,
                height: Get.height * 0.18,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Generate and download your solar\nperformance report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: DropdownInterval(
                                datePickerController:
                                    controller.datePickerController,
                                startDate: controller.startDate,
                                endDate: controller.endDate,
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 130,
                              child: Button(
                                radius: 20,
                                onPressed: () => controller.generateReport(false),
                                textLabel: "Generate Report",
                                color: Color(kPrimaryColor),
                                textColor: Colors.white,
                                btnHeight: 1,
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: Color(kSecondaryColor),
            selectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.home_outlined,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: Color(kPrimaryColor),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.attach_money,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.attach_money,
                  color: Color(kPrimaryColor),
                ),
                label: 'Premium',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outlined,
                  color: Color(0xff787878),
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: Color(kPrimaryColor),
                ),
                label: 'My Profile',
              ),
            ],
            currentIndex: controller.selectedTab.value,
            onTap: (index) {
              controller.onItemTapped(index);
            },
            unselectedItemColor: Colors.black,
            selectedItemColor: Color(kPrimaryColor),
          ),
        ),
      ),
    );
  }
}

class DropdownInterval extends StatelessWidget {
  const DropdownInterval({
    Key? key,
    required this.datePickerController,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  final Rx<DateRangePickerController> datePickerController;
  final RxString startDate;
  final RxString endDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.dialog(Container(
        margin: EdgeInsets.fromLTRB(20, 200, 20, 200),
        color: Colors.white,
        child: SfDateRangePicker(
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value.endDate != null) {
              PickerDateRange range = args.value;
              Duration totalDays = range.endDate!.difference(range.startDate!);
              if (totalDays.inDays <= 31) {
                startDate.value = args.value.startDate.toString().split(' ')[0];
                endDate.value = args.value.endDate.toString().split(' ')[0];
                Get.back();
              } else {
                warningDialog('Selected range is more than 30 days!');
              }
            }
          },
          confirmText: "Confirm",
          controller: datePickerController.value,
          selectionMode: DateRangePickerSelectionMode.range,
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(color: Color(kPrimaryColor), fontSize: 16)),
          rangeTextStyle: TextStyle(color: Colors.white),
          startRangeSelectionColor: Color(kPrimaryColor),
          endRangeSelectionColor: Color(kPrimaryColor),
          rangeSelectionColor: Color(kPrimaryColor).withOpacity(0.5),
          showNavigationArrow: true,
          // todayHighlightColor: Color(0xfff6b642),
        ),
      )),
      child: Container(
        width: Get.width * 0.45,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.black26, width: 1.5),
        ),
        child: Theme(
          data: ThemeData(
            canvasColor: Colors.white,
          ),
          child: Obx(
            () {
              List<Widget> dates = [];

              if (startDate.value != "") {
                dates.add(Text(startDate.value));
                dates.add(Text(' - '));
                dates.add(Text(endDate.value));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: dates,
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Text('Select Date'),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey.shade600,
                      size: 20,
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
