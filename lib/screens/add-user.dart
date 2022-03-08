import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/add-user.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';
import 'package:verdant_solar/widgets/app_bar.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/drawer.dart';
import 'package:verdant_solar/widgets/input_field.dart';

class AddUser extends StatelessWidget {
  final controller = Get.put(AddUserController());
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: PrimaryDrawer(),
        appBar: MyAppBar(
          showBack: true,
          appBar: AppBar(),
          title: Obx(
            () => Text(
              controller.title.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "BebasNeue",
                letterSpacing: 4,
              ),
            ),
          ),
          route: () => Get.offNamed('/user-management'),
        ),
        backgroundColor: Color(kSecondaryColor),
        body: Container(
          height: Get.height,
          child: Obx(
            () {
              return Stepper(
                controlsBuilder: (BuildContext context,
                    {onStepContinue, onStepCancel}) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (controller.currentStep.value != 0)
                          ? Container(
                              width: Get.width * 0.25,
                              height: 35,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                onPressed: onStepCancel,
                                child: Text('Back'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(kPrimaryColor)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        width: Get.width * 0.25,
                        height: 35,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          onPressed: onStepContinue,
                          child: Text((controller.currentStep.value != 5)
                              ? 'Next'
                              : "Submit"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(kPrimaryColor)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                onStepContinue: () {
                  print(controller.currentStep.value);
                  switch (controller.currentStep.value) {
                    case 0:
                      // if (controller.name.text == "" ||
                      //     controller.password.text == "" ||
                      //     controller.phone.text == "" ||
                      //     controller.email.text == "") {
                      //   warningDialog('Please fill in all required fields!');
                      //   return;
                      // }
                      break;
                    case 1:
                      // if (controller.address.text == "" ||
                      //     controller.postcode.text == "" ||
                      //     controller.householdSize.text == "" ||
                      //     controller.buildUpArea.text == "") {
                      //   warningDialog('Please fill in all required fields!');
                      //   return;
                      // }
                      break;
                    case 2:
                      break;
                    case 3:
                      break;
                    case 4:
                      break;
                    default:
                  }
                  if (controller.currentStep.value != 5) {
                    var prevStep = controller.currentStep.value;
                    controller.currentStep.value++;
                    controller.hasPress[controller.currentStep.value] = true;
                    controller.hasDone[prevStep] = true;
                  } else {
                    print(controller.isEdit.value);
                    if (controller.isEdit.value) {
                      controller.editPowerPlant();
                    } else {
                      controller.addPowerPlant();
                    }
                  }
                },
                onStepCancel: () {
                  controller.currentStep.value--;
                },
                currentStep: controller.currentStep.value,
                onStepTapped: (pressStep) {
                  if (controller.hasPress[pressStep]) {
                    controller.currentStep.value = pressStep;
                  }
                },
                steps: [
                  Step(
                    state: (controller.hasDone[0])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 1",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 0),
                    subtitle: Text(
                      "Customer Information",
                      style: TextStyle(
                        color: Color(kPrimaryColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    content: CustomerInfo(controller: controller),
                  ),
                  Step(
                    state: (controller.hasDone[1])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 2",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 1),
                    subtitle: Text(
                      "Building Information",
                      style: TextStyle(
                        color: Color(kPrimaryColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    content: BuildingInfo(controller: controller),
                  ),
                  Step(
                    state: (controller.hasDone[2])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 3",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 2),
                    subtitle: Text(
                      "Inverter Information",
                      style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    content: InverterInfo(controller: controller),
                  ),
                  Step(
                    state: (controller.hasDone[3])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 4",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 3),
                    subtitle: Text(
                      "Solar Panel Information",
                      style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    content: SolarPanelInfo(controller: controller),
                  ),
                  Step(
                    state: (controller.hasDone[4])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 5",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 4),
                    subtitle: Text(
                      "Solar Panel Efficiency",
                      style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    content: SolarPanelEfficiency(controller: controller),
                  ),
                  Step(
                    state: (controller.hasDone[5])
                        ? StepState.complete
                        : StepState.editing,
                    title: Text(
                      "Step 6",
                      style: TextStyle(fontSize: 12),
                    ),
                    isActive: (controller.currentStep.value == 5),
                    subtitle: Text(
                      "Total Customer Investment",
                      style: TextStyle(
                          color: Color(kPrimaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    content: CustomerInvestment(controller: controller),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomerInvestment extends StatelessWidget {
  const CustomerInvestment({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormTextField(
          isRequired: true,
          textLabel: "Customer Initial Investment Cost (RM)",
          style: TextStyle(),
          hide: false,
          controller: controller.initInvestmentCost,
          enabled: true,
        ),
        FormTextField(
          isRequired: true,
          textLabel: "Total Customer Maintenance Cost (RM)",
          style: TextStyle(),
          hide: false,
          controller: controller.totalMaintenanceCost,
          enabled: true,
        ),
      ],
    );
  }
}

class SolarPanelEfficiency extends StatelessWidget {
  const SolarPanelEfficiency({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            var tableList = <TableRow>[
              TableRow(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                children: [
                  Text("YEAR"),
                  Text("EFFICIENCY"),
                  Text("EDIT"),
                  Text(""),
                ],
              ),
            ];

            for (var i = 0; i < controller.efficiencies.length; i++) {
              tableList.add(
                stringRow(
                  year: controller.efficiencies[i]['Year'],
                  efficiency: controller.efficiencies[i]['Efficiency'],
                  index: i,
                ),
              );
            }
            if (controller.efficiencies.length != 0) {
              return Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(0.3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(0.2),
                  3: FlexColumnWidth(0.2),
                },
                children: tableList,
              );
            } else {
              return Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(0.3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(0.2),
                      3: FlexColumnWidth(0.2),
                    },
                    children: tableList,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'NO EFFICIENCIES(S)',
                      style: TextStyle(
                        color: Color(kPrimaryColor),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Get.dialog(
              EfficiencyDialog(controller: controller),
              barrierDismissible: true,
            ),
            child: Text(
              '+ add year',
              style: TextStyle(
                color: Color(kPrimaryColor),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 60))
      ],
    );
  }

  stringRow({required year, required efficiency, required int index}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '$year',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '$efficiency%',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () => controller.editEfficiency(index),
            splashColor: Colors.transparent,
            child: Icon(
              Icons.edit,
              color: Color(kPrimaryColor),
              size: 20,
            ),
          ),
        ),
        (controller.efficiencies[index]['isDelete'])
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () => controller.removeEfficiency(index),
                  splashColor: Colors.transparent,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class SolarPanelInfo extends StatelessWidget {
  const SolarPanelInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            var tableList = <TableRow>[
              TableRow(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                children: [
                  Text("NO."),
                  Text("EDIT"),
                  Text(""),
                ],
              ),
            ];

            for (var i = 0; i < controller.strings.length; i++) {
              tableList.add(stringRow(index: i));
            }
            if (controller.strings.length != 0) {
              return Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(0.15),
                  2: FlexColumnWidth(0.15),
                },
                children: tableList,
              );
            } else {
              return Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(0.15),
                      2: FlexColumnWidth(0.15),
                    },
                    children: tableList,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'NO STRING(S)',
                      style: TextStyle(
                        color: Color(kPrimaryColor),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Get.dialog(
              PanelDialog(controller: controller),
              barrierDismissible: true,
            ),
            child: Text(
              '+ add string',
              style: TextStyle(
                color: Color(kPrimaryColor),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 60))
      ],
    );
  }

  stringRow({required int index}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'String ${index + 1}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () => controller.editString(index),
            splashColor: Colors.transparent,
            child: Icon(
              Icons.edit,
              color: Color(kPrimaryColor),
              size: 20,
            ),
          ),
        ),
        (controller.strings[index]['isDelete'])
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () => controller.removeString(index),
                  splashColor: Colors.transparent,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class EfficiencyDialog extends StatelessWidget {
  const EfficiencyDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width * 0.6,
        height: Get.height * 0.26,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Year ${controller.efficiencies.last['Year'] + 1}',
                style: TextStyle(
                  color: Color(kPrimaryColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Efficiency",
                style: TextStyle(),
                hide: false,
                controller: controller.efficiency,
                enabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Button(
                      onPressed: () => Get.back(),
                      radius: 20,
                      textLabel: "Cancel",
                      color: Color(kPrimaryColor),
                      textColor: Colors.white,
                      btnHeight: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: Button(
                      onPressed: () => controller.addEfficiency(),
                      radius: 20,
                      textLabel: "Submit",
                      color: Color(kPrimaryColor),
                      textColor: Colors.white,
                      btnHeight: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PanelDialog extends StatelessWidget {
  const PanelDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(20, 50, 20, 50),
      child: Container(
        width: context.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'String ${controller.strings.length + 1}',
                style: TextStyle(
                  color: Color(kPrimaryColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownForm(
                    name: "String Model",
                    value: controller.selectedStringlModel,
                    items: controller.stringModel,
                    callback: controller.pickString,
                    isRequired: true,
                  ),
                ),
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "String Brand",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.stringBrand,
                    enabled: false,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownForm(
                    name: "Panel Model",
                    value: controller.selectedPanelModel,
                    items: controller.panelModel,
                    callback: controller.pickPanel,
                    isRequired: true,
                  ),
                ),
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "Panel Brand",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.panelBrand,
                    enabled: false,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "Elevation",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.elevation,
                    enabled: true,
                  ),
                ),
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "Orientation",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.orientation,
                    enabled: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "No of Panels",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.numberofpanels,
                    enabled: true,
                  ),
                ),
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "System Size",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.systemsize,
                    enabled: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    isRequired: true,
                    textLabel: "Production Offset",
                    style: TextStyle(),
                    hide: false,
                    controller: controller.productionoffset,
                    enabled: true,
                  ),
                ),
                Expanded(
                  child: DatePickerForm(
                    function: controller.selectDate,
                    selectedDate: controller.panelInstallDate,
                    name: 'Installation Date',
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Button(
                      onPressed: () => Get.back(),
                      radius: 20,
                      textLabel: "Cancel",
                      color: Color(kPrimaryColor),
                      textColor: Colors.white,
                      btnHeight: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: Button(
                      onPressed: () => controller.addString(),
                      radius: 20,
                      textLabel: "Submit",
                      color: Color(kPrimaryColor),
                      textColor: Colors.white,
                      btnHeight: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InverterInfo extends StatelessWidget {
  const InverterInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownForm(
                name: "Inverter Model",
                value: controller.selectedInverterModel,
                items: controller.inverterModel,
                callback: controller.pickInverter,
                isRequired: true,
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Inverter Brand",
                style: TextStyle(),
                hide: false,
                controller: controller.inverterBrand,
                enabled: false,
              ),
            ),
          ],
        ),
        DatePickerForm(
          function: controller.selectDate,
          selectedDate: controller.inverterInstallDate,
          name: 'Installation Date',
        )
      ],
    );
  }
}

class BuildingInfo extends StatelessWidget {
  const BuildingInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormTextField(
          onChange: (text) {
            print(text);
            controller.isAddressChange.value = true;
          },
          isRequired: true,
          textLabel: "Address",
          style: TextStyle(),
          hide: false,
          controller: controller.address,
          enabled: true,
          maxLines: 3,
        ),
        Row(
          children: [
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Postcode",
                style: TextStyle(),
                hide: false,
                controller: controller.postcode,
                enabled: true,
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Household Size",
                style: TextStyle(),
                hide: false,
                controller: controller.householdSize,
                enabled: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "No of Rooms",
                style: TextStyle(),
                hide: false,
                controller: controller.noOfRooms,
                enabled: true,
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Build-up Area (sq ft)",
                style: TextStyle(),
                hide: false,
                controller: controller.buildUpArea,
                enabled: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DropdownForm(
                name: "State",
                value: controller.selectedState,
                items: controller.states,
                callback: controller.pickState,
                isRequired: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (controller.address.text == "")
                    return warningDialog('Pleaset enter address first!');

                  if (controller.isAddressChange.value) {
                    var res = await Get.find<APIService>()
                        .addressToLatLng(address: controller.address.text);
                    Get.toNamed('/map', arguments: res);
                  } else {
                    Get.toNamed('/map');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Pin Point Location",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: context.width,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.map,
                                color: Color(kPrimaryColor),
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.locationName.value,
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddUserController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "First Name",
                style: TextStyle(),
                hide: false,
                controller: controller.firstName,
                enabled: true,
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Last Name",
                style: TextStyle(),
                hide: false,
                controller: controller.lastName,
                enabled: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Email",
                style: TextStyle(),
                hide: false,
                controller: controller.email,
                enabled: true,
              ),
            ),
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Phone",
                style: TextStyle(),
                hide: false,
                controller: controller.phone,
                enabled: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormTextField(
                isRequired: true,
                textLabel: "Username",
                style: TextStyle(),
                hide: false,
                controller: controller.userName,
                enabled: true,
              ),
            ),
            Expanded(
              child: DropdownForm(
                name: 'Type of User',
                value: controller.selectedLevel,
                items: controller.levels,
                callback: controller.pickRole,
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DropdownForm extends StatelessWidget {
  const DropdownForm({
    Key? key,
    required this.name,
    required this.value,
    required this.items,
    required this.callback,
    required this.isRequired,
  }) : super(key: key);

  final String name;
  final Rx<DropModel> value;
  final bool isRequired;
  final RxList<DropModel> items;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.only(bottom: 6),
          width: context.width,
          child: Row(
            children: [
              Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(),
              ),
              (isRequired)
                  ? Text(
                      "*",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
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
              () => DropdownButton<DropModel>(
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(kPrimaryColor),
                  size: 30,
                ),
                underline: Container(color: Colors.transparent),
                value: value.value,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                onChanged: (value) => callback(value),
                items: items.map((value) {
                  return new DropdownMenuItem<DropModel>(
                    value: value,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        value.name,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DatePickerForm extends StatelessWidget {
  const DatePickerForm({
    Key? key,
    required this.function,
    required this.selectedDate,
    required this.name,
  }) : super(key: key);

  final Function function;
  final String name;
  final Rx<DateTime> selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 6),
            width: context.width,
            child: Row(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "*",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => function(context, selectedDate),
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.8), width: 1.5),
              ),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate.value.toString().split(" ")[0],
                    ),
                    Icon(
                      Icons.date_range,
                      color: Colors.grey.shade700,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
