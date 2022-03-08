import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/controller/power-plant.dart';
import 'package:verdant_solar/model/power-plant-overview.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';

class PowerPlant extends StatelessWidget {
  final controller = Get.put(PowerPlantController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: MyAppBar(
          showBack: false,
          appBar: AppBar(),
          title: Text(
            "LIST OF POWER PLANT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "BebasNeue",
              letterSpacing: 4,
            ),
          ),
          route: () {},
        ),
        backgroundColor: Color(kSecondaryColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 17,
                    left: Get.width * 0.1,
                    child: Container(
                      width: Get.width * 0.25,
                      height: 40,
                      child: Obx(
                        () => Button(
                          onPressed: () {
                            if (!controller.isAll.value) {
                              controller.isAll.value = !controller.isAll.value;
                              controller.isIssue.value = false;
                              controller.isNormal.value = false;
                            }
                            controller.setShowTab();
                          },
                          textLabel: "All (${controller.all})",
                          color: (controller.isAll.value)
                              ? Color(kPrimaryColor)
                              : Colors.grey.shade400,
                          textColor: (controller.isAll.value)
                              ? Colors.white
                              : Colors.black,
                          btnHeight: 12,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 17,
                    left: Get.width * 0.375,
                    child: Container(
                      width: Get.width * 0.25,
                      height: 40,
                      child: Obx(
                        () => Button(
                          onPressed: () {
                            if (!controller.isIssue.value) {
                              controller.isIssue.value =
                                  !controller.isIssue.value;
                              controller.isAll.value = false;
                              controller.isNormal.value = false;
                            }
                            controller.setShowTab();
                          },
                          textLabel:
                              "Issue detected (${controller.issueDetected})",
                          color: (controller.isIssue.value)
                              ? Color(kPrimaryColor)
                              : Colors.grey.shade400,
                          textColor: (controller.isIssue.value)
                              ? Colors.white
                              : Colors.black,
                          btnHeight: 12,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 17,
                    left: Get.width * 0.65,
                    child: Container(
                        width: Get.width * 0.25,
                        height: 40,
                        child: Obx(
                          () => Button(
                            onPressed: () {
                              if (!controller.isNormal.value) {
                                controller.isNormal.value =
                                    !controller.isNormal.value;
                                controller.isAll.value = false;
                                controller.isIssue.value = false;
                              }
                              controller.setShowTab();
                            },
                            textLabel: "Normal (${controller.normal})",
                            color: (controller.isNormal.value)
                                ? Color(kPrimaryColor)
                                : Colors.grey.shade400,
                            textColor: (controller.isNormal.value)
                                ? Colors.white
                                : Colors.black,
                            btnHeight: 12,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    height: Get.height * 0.78,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            height: Get.height * 0.76,
                            width: Get.width * 1.1,
                            child: Obx(
                              () {
                                List<Widget> powerPlants = [TileHeader()];
                                for (Message item in controller.showPowerPlant) {
                                  powerPlants.add(PowerPlantTile(
                                    userID: item.userId.toString(),
                                    customerName: item.fullName,
                                    plantStatus: item.plantStatus,
                                    plantHealth: item.plantHealth,
                                    dsy: item.dsykwhkwp,
                                    overvoltage: item.overvoltage,
                                    undervoltage: item.undervoltage,
                                    projectionGeneration:
                                        item.projectedGeneration,
                                    efficiency: item.efficiency,
                                    gridConn: item.gridConnection,
                                    networkConn: item.networkConnection,
                                    inverterConn: item.solarInverterConnection,
                                    powerMeterConn: item.powerMeterConnection,
                                    warrantyExp: item.warrantyExpiry,
                                  ));
                                }
        
                                return ListView(
                                  children: powerPlants,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TileHeader extends StatelessWidget {
  const TileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: ListTileTheme(
        horizontalTitleGap: 0,
        dense: true,
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          trailing: Icon(
            Icons.arrow_upward,
            color: Colors.transparent,
          ),
          title: Row(
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  'Customer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  'Plant Status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  'Plant Health',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'DSY/kWp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(kPrimaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PowerPlantTile extends StatelessWidget {
  const PowerPlantTile({
    Key? key,
    required this.customerName,
    required this.userID,
    required this.plantStatus,
    required this.plantHealth,
    required this.dsy,
    required this.overvoltage,
    required this.undervoltage,
    required this.projectionGeneration,
    required this.efficiency,
    required this.gridConn,
    required this.networkConn,
    required this.inverterConn,
    required this.powerMeterConn,
    required this.warrantyExp,
  }) : super(key: key);

  final String customerName;
  final String userID;
  final String plantStatus;
  final String plantHealth;
  final String dsy;
  final String overvoltage;
  final String undervoltage;
  final String projectionGeneration;
  final String efficiency;
  final String gridConn;
  final String networkConn;
  final String inverterConn;
  final String powerMeterConn;
  final String warrantyExp;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: ListTileTheme(
        dense: true,
        horizontalTitleGap: 0,
        child: ExpansionTile(
          iconColor: Colors.transparent,
          collapsedIconColor:Colors.transparent,
          tilePadding: EdgeInsets.all(0),
          childrenPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  customerName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  plantStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: (plantStatus == "Normal")
                        ? Color(kPrimaryColor)
                        : Color(0xfff6ab28),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  plantHealth,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  dsy,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overvoltage',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Undervoltage',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Projection Generation',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Efficiency',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Grid Connection',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Network Connection',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Solar Inverter Connection',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Power Meter Connection',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Warranty Expiry',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 25,
                      width: 100,
                      child: Button(
                        onPressed: () {
                          var box = GetStorage();
                          box.write('selected-id', userID);
                          box.write('selected-name', customerName);
                          Get.toNamed('/overview');
                        },
                        textLabel: "See Details >>",
                        color: Color(kPrimaryColor),
                        textColor: Colors.white,
                        btnHeight: 1,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        radius: 20,
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 15)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ': $undervoltage',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $overvoltage',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $projectionGeneration',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $efficiency',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $gridConn',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $networkConn',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $inverterConn',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $powerMeterConn',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      ': $warrantyExp',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 25,
                      width: 80,
                      child: Container(),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
