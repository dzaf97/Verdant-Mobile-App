import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verdant_solar/model/add-user/get-power-plant.dart';
import 'package:verdant_solar/model/add-user/inverter-model.dart';
import 'package:verdant_solar/model/add-user/panel-model.dart';
import 'package:verdant_solar/model/add-user/states.dart';
import 'package:verdant_solar/model/add-user/string-model.dart';
import 'package:verdant_solar/model/role.dart';
import 'package:verdant_solar/screens/add-user.dart';
import 'package:verdant_solar/service/location_service.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';
import 'package:verdant_solar/widgets/button.dart';
import 'package:verdant_solar/widgets/input_field.dart';

class AddUserController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var location = Get.put(LocationService());
  var selectedTab = 2.obs;
  var title = "USER REGISTRATION".obs;
  var isEdit = false.obs;

  var currentStep = 0.obs;
  var hasPress = [true, false, false, false, false, false].obs;
  var hasDone = [false, false, false, false, false, false].obs;

  // CUSTOMER INFORMATION
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var userName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var levels = <DropModel>[DropModel(0, "")].obs;
  var selectedLevel = DropModel(0, "").obs;

  // BUILDING INFORMATION
  var address = TextEditingController();
  var postcode = TextEditingController();
  var householdSize = TextEditingController();
  var noOfRooms = TextEditingController();
  var buildUpArea = TextEditingController();
  var states = <DropModel>[DropModel(0, "Selangor")].obs;
  var selectedState = DropModel(0, "").obs;
  var locationName = "".obs;
  var isAddressChange = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  // INVERTER INFORMATION
  var inverterModel = <DropModel>[DropModel(0, "")].obs;
  var selectedInverterModel = DropModel(0, "").obs;
  var inverterBrand = TextEditingController();
  var inverterInstallDate = DateTime.now().obs;

  // SOLAR PANEL INFORMATION
  var panelModel = <DropModel>[DropModel(0, "")].obs;
  var selectedPanelModel = DropModel(0, "").obs;
  var panelBrand = TextEditingController();
  var stringModel = <DropModel>[DropModel(0, "")].obs;
  var selectedStringlModel = DropModel(0, "").obs;
  var stringBrand = TextEditingController();
  var elevation = TextEditingController();
  var orientation = TextEditingController();
  var numberofpanels = TextEditingController();
  var systemsize = TextEditingController();
  var productionoffset = TextEditingController();
  var strings = [].obs;
  var panelInstallDate = DateTime.now().obs;

  // EFFICIENCY INFORMATION
  var efficiencies = [].obs;
  var year = TextEditingController();
  var efficiency = TextEditingController();

  // TOTAL CUSTOMER INVESTMENT
  var initInvestmentCost = TextEditingController();
  var totalMaintenanceCost = TextEditingController();

  // PK FOR EDIT
  var userID = 0.obs;
  var buildingID = 0.obs;
  var plantID = 0.obs;
  var inverterInstallationID = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    selectedLevel.value = levels[0];
    selectedPanelModel.value = panelModel[0];
    selectedStringlModel.value = stringModel[0];
    selectedInverterModel.value = inverterModel[0];
    selectedState.value = states[0];
    // setLocation();
    await setRoles();
    await setState();
    await setInverterList();
    await setPanelList();
    await setStringList();

    if (Get.parameters['userid'] != null) {
      title.value = "EDIT USER";
      isEdit.value = true;
      var userid = Get.parameters['userid']!;
      userID.value = int.parse(userid);
      await getUserPlant(userID);
    } else {
      efficiencies.add({
        "EntryID": 0,
        "Year": 1,
        "Efficiency": 100,
        "PlantID": 0,
        'isDelete': false
      });
    }
  }

  getUserPlant(userid) async {
    var res = await network.get('/solar/api/v1/powerplant/$userid');
    if (res['error']) return;

    GetPowerPlant data = GetPowerPlant.fromJson(res);

    // SET USER
    firstName.text = data.message.user.firstName;
    lastName.text = data.message.user.lastName;
    userName.text = data.message.user.username;
    phone.text = data.message.user.phoneNo;
    email.text = data.message.user.email;

    for (var item in levels) {
      if (item.id == data.message.user.roleId) selectedLevel.value = item;
    }

    // SET BUILDING
    buildingID.value = data.message.building.buildingId;
    address.text = data.message.building.address;
    postcode.text = data.message.building.postcode;
    householdSize.text = data.message.building.householdSize.toString();
    noOfRooms.text = data.message.building.numberOfRooms.toString();
    buildUpArea.text = data.message.building.buildupArea.toString();
    location.latitude.value = data.message.building.latitude;
    location.longitude.value = data.message.building.longitude;
    latitude.value = data.message.building.latitude;
    longitude.value = data.message.building.longitude;
    locationName.value =
        "${data.message.building.latitude}, ${data.message.building.latitude}";
    // List<Placemark> existAddress = await location.getAddress();
    // for (var item in existAddress) {
    //   locationName.text = item.locality!;
    // }
    for (var item in states) {
      if (item.id == data.message.building.stateId) selectedState.value = item;
    }

    // SET INVERTER
    inverterInstallationID.value = data.message.inverter.inverterInstallationId;
    for (var item in inverterModel) {
      if (item.id == data.message.inverter.inverterId)
        selectedInverterModel.value = item;
      inverterBrand.text = item.placeholder!;
    }
    inverterInstallDate.value =
        DateTime.parse(data.message.inverter.installationDate);

    // SET STRING
    for (var item in data.message.panelstring) {
      Map<String, dynamic> stringData = {
        "StringInstallationID": item.stringInstallationId,
        "solarpanelid": item.solarPanelId,
        "stringmodelid": item.stringModelId,
        "elevation": item.elevation,
        "orientation": item.orientation,
        "numberofpanels": item.numberOfPanels,
        "installationdate": item.installationDate,
        "systemsize": item.systemSize,
        "productionoffset": item.productionOffset,
        "isDelete": false
      };
      strings.add(stringData);
    }

    // SET EFFICIENCY
    for (var item in data.message.efficiency) {
      print(item.year);
      Map<String, dynamic> efficiencyData = {
        "EntryID": item.entryId,
        "Year": item.year,
        "Efficiency": item.efficiency,
        "PlantID": item.plantId,
        "isDelete": false
      };
      efficiencies.add(efficiencyData);
    }

    // SET TOTAL CUSTOMER INVESTMENT
    plantID.value = data.message.powerplant.plantId;
    initInvestmentCost.text =
        data.message.powerplant.initialInvestmentCost.toString();
    totalMaintenanceCost.text =
        data.message.powerplant.maintenanceCost.toString();
  }

  // ------------------------- INTIALIZE FORM VALUE ------------------------- //

  // CURRENT LOCATION
  // setLocation() async {
  //   await location.retrieveLatLong();
  //   List<Placemark> address = await location.getAddress();
  //   for (var item in address) {
  //     locationName.text = item.locality!;
  //   }
  // }

  // STATE DROPDOWN VALUE
  setState() async {
    states.value = <DropModel>[];
    var res = await network.get('/solar/api/v1/setting/state');
    if (res['error']) return;
    States data = States.fromJson(res);

    for (var item in data.message) {
      states.add(DropModel(
        item.stateId,
        item.stateName,
      ));
    }
    selectedState.value = states[0];
  }

  pickState(value) {
    selectedState.value = value;
  }

  // USER ROLE DROPDOWN VALUE
  setRoles() async {
    levels.value = <DropModel>[];
    var res = await network.get('/sso/api/v1/management/roles');
    if (res['error']) return;

    Roles data = Roles.fromJson(res);

    for (var item in data.message) {
      levels.add(DropModel(
        item.roleId,
        item.roleName,
      ));
    }
    selectedLevel.value = levels[0];
  }

  pickRole(value) {
    selectedLevel.value = value;
  }

  // STRING MODEL DROPDOWN VALUE AND ITS BRAND
  setStringList() async {
    stringModel.value = <DropModel>[];
    var res = await network.get('/solar/api/v1/setting/strings');

    if (res['error']) return;

    StringModel data = StringModel.fromJson(res);
    print(res);

    for (var item in data.message) {
      print(item.brandName);

      stringModel.add(DropModel(
        item.id,
        item.modelName,
        placeholder: item.brandName,
      ));
    }
    selectedStringlModel.value = stringModel[0];
    stringBrand.text = selectedStringlModel.value.placeholder!;
  }

  pickString(value) {
    selectedStringlModel.value = value;
    stringBrand.text = selectedStringlModel.value.placeholder!;
  }

  // PANEL MODEL DROPDOWN VALUE AND ITS BRAND
  setPanelList() async {
    panelModel.value = <DropModel>[];
    var res = await network.get('/solar/api/v1/setting/solar-panels');

    if (res['error']) return;
    PanelModel data = PanelModel.fromJson(res);

    for (var item in data.message) {
      panelModel.add(DropModel(
        item.solarPanelId,
        item.modelName,
        placeholder: item.brandName,
      ));
    }
    selectedPanelModel.value = panelModel[0];
    panelBrand.text = selectedPanelModel.value.placeholder!;
  }

  pickPanel(value) {
    selectedPanelModel.value = value;
    panelBrand.text = selectedPanelModel.value.placeholder!;
  }

  // INVERTER MODEL DROPDOWN VALUE AND ITS BRAND
  setInverterList() async {
    inverterModel.value = <DropModel>[];
    var res = await network.get('/solar/api/v1/setting/inverters');
    if (res['error']) return;

    InverterModel data = InverterModel.fromJson(res);

    for (var item in data.message) {
      inverterModel
          .add(DropModel(item.id, item.modelName, placeholder: item.brandName));
    }
    selectedInverterModel.value = inverterModel[0];
    inverterBrand.text = selectedInverterModel.value.placeholder!;
  }

  pickInverter(value) {
    selectedInverterModel.value = value;
    inverterBrand.text = selectedInverterModel.value.placeholder!;
  }

  // ------------------------- POWER PLANT ------------------------- //
  addPowerPlant() async {
    var body = {
      "user": {
        "firstname": firstName.text,
        "lastname": lastName.text,
        "email": email.text,
        "phoneno": phone.text,
        "username": userName.text,
        "roleid": selectedLevel.value.id,
      },
      "building": {
        "address": address.text,
        "postcode": postcode.text,
        "householdsize": int.parse(householdSize.text),
        "numberofrooms": int.parse(noOfRooms.text),
        "builduparea": int.parse(buildUpArea.text),
        "latitude": latitude.value,
        "longitude": longitude.value,
        "stateid": selectedState.value.id
      },
      "powerplant": {
        "costofservice": int.parse(initInvestmentCost.text),
        "maintenancecost": int.parse(totalMaintenanceCost.text)
      },
      "efficiency": efficiencies,
      "inverter": {
        "inverterid": selectedInverterModel.value.id,
        "installationdate": '${inverterInstallDate.value.toIso8601String()}Z'
      },
      "panelstring": strings
    };
    print(json.encode(body));

    var res = await network.post('/solar/api/v1/powerplant', body: body);
    if (res['error']) return warningDialog('');

    Get.offAndToNamed('/user-management');
  }

  editPowerPlant() async {
    var body = {
      "user": {
        "UserID": userID.value,
        "FirstName": firstName.text,
        "LastName": lastName.text,
        "Email": email.text,
        "PhoneNo": phone.text,
        "Username": userName.text,
        "RoleID": selectedLevel.value.id,
      },
      "building": {
        "BuildingID": buildingID.value,
        "Address": address.text,
        "Postcode": postcode.text,
        "HouseholdSize": int.parse(householdSize.text),
        "NumberOfRooms": int.parse(noOfRooms.text),
        "BuildupArea": int.parse(buildUpArea.text),
        "StateID": selectedState.value.id,
        "Latitude": latitude.value,
        "Longitude": longitude.value,
      },
      "powerplant": {
        "PlantID": plantID.value,
        "InitialInvestmentCost": int.parse(initInvestmentCost.text),
        "MaintenanceCost": int.parse(totalMaintenanceCost.text)
      },
      "efficiency": efficiencies,
      "inverter": {
        "InverterInstallationID": inverterInstallationID.value,
        "InverterID": selectedInverterModel.value.id,
        "InstallationDate": inverterInstallDate.value.toIso8601String()
      },
      "panelstring": strings
    };
    print(json.encode(body));

    var res = await network.put(
      '/solar/api/v1/powerplant/${userID.value}',
      body: body,
    );

    if (res['error']) return warningDialog('');

    Get.offAndToNamed('/user-management');
  }

  Future<void> selectDate(
      BuildContext context, Rx<DateTime> selectedDate) async {
    if (GetPlatform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              Container(
                height: 150,
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate.value,
                  onDateTimeChanged: (val) {
                    selectedDate.value = val;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (GetPlatform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(1995, 8),
        lastDate: DateTime(2040),
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
      }
    }
  }

  // ------------------------- STRING TABLE FUNCTION ------------------------- //
  addString() {
    // CHECK FOR EMPTY STRING AS IT IS REQUIRED
    if (elevation.text == "" ||
        orientation.text == "" ||
        numberofpanels.text == "" ||
        systemsize.text == "" ||
        productionoffset.text == "") {
      warningDialog('Please fill in all form');
      return;
    }

    // JSON PAYLOAD FOR STRING DATA
    Map<String, dynamic> stringData = {
      "solarpanelid": selectedPanelModel.value.id,
      "stringmodelid": selectedStringlModel.value.id,
      "elevation": int.parse(elevation.text),
      "orientation": orientation.text,
      "numberofpanels": int.parse(numberofpanels.text),
      "installationdate": '${panelInstallDate.value.toIso8601String()}Z',
      "systemsize": double.parse(systemsize.text),
      "productionoffset": int.parse(productionoffset.text),
      "isDelete": true
    };

    // ADD JSON PAYLOAD TO STRING ARRAY
    strings.add(stringData);

    // RESET PERVIOUS STRING DETAIL
    elevation.text = "";
    orientation.text = "";
    numberofpanels.text = "";
    systemsize.text = "";
    productionoffset.text = "";
    Get.back();
  }

  updateString(index) {
    // CHECK FOR EMPTY STRING AS IT IS REQUIRED
    if (elevation.text == "" ||
        orientation.text == "" ||
        numberofpanels.text == "" ||
        systemsize.text == "" ||
        productionoffset.text == "") {
      warningDialog('Please fill in all form');
      return;
    }

    // JSON PAYLOAD FOR STRING DATA
    Map<String, dynamic> stringData = {
      "solarpanelid": selectedPanelModel.value.id,
      "stringmodelid": selectedStringlModel.value.id,
      "elevation": int.parse(elevation.text),
      "orientation": orientation.text,
      "numberofpanels": int.parse(numberofpanels.text),
      "installationdate": "2021-10-26T06:25:31.636Z",
      "systemsize": double.parse(systemsize.text),
      "productionoffset": int.parse(productionoffset.text),
      "isDelete": true,
    };

    // STORE EXISTING STRING INSTALLATION ID
    if (!strings[index]['isDelete']) {
      stringData['StringInstallationID'] =
          strings[index]['StringInstallationID'];
      stringData['isDelete'] = false;
    }

    // UPDATE JSON WITH NEW VALUE
    strings[index] = stringData;
    elevation.text = "";
    orientation.text = "";
    numberofpanels.text = "";
    systemsize.text = "";
    productionoffset.text = "";
    Get.back();
  }

  editString(index) {
    // INITIALIZE EXISTING VALUE TO FORM FIELD
    elevation.text = strings[index]['elevation'].toString();
    orientation.text = strings[index]['orientation'];
    numberofpanels.text = strings[index]['numberofpanels'].toString();
    systemsize.text = strings[index]['systemsize'].toString();
    productionoffset.text = strings[index]['productionoffset'].toString();
    stringModel.forEach((element) {
      if (element.id == strings[index]['stringmodelid'])
        selectedStringlModel.value = element;
    });
    panelModel.forEach((element) {
      if (element.id == strings[index]['solarpanelid'])
        selectedPanelModel.value = element;
    });

    // POPUP DIALOG FORM
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'String ${index + 1}',
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
                      value: selectedStringlModel,
                      items: stringModel,
                      callback: pickString,
                      isRequired: true,
                    ),
                  ),
                  Expanded(
                    child: FormTextField(
                      isRequired: true,
                      textLabel: "String Brand",
                      style: TextStyle(),
                      hide: false,
                      controller: stringBrand,
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
                      value: selectedPanelModel,
                      items: panelModel,
                      callback: pickPanel,
                      isRequired: true,
                    ),
                  ),
                  Expanded(
                    child: FormTextField(
                      isRequired: true,
                      textLabel: "Panel Brand",
                      style: TextStyle(),
                      hide: false,
                      controller: panelBrand,
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
                      controller: elevation,
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: FormTextField(
                      isRequired: true,
                      textLabel: "Orientation",
                      style: TextStyle(),
                      hide: false,
                      controller: orientation,
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
                      controller: numberofpanels,
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: FormTextField(
                      isRequired: true,
                      textLabel: "System Size",
                      style: TextStyle(),
                      hide: false,
                      controller: systemsize,
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
                      controller: productionoffset,
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: DatePickerForm(
                      function: selectDate,
                      selectedDate: panelInstallDate,
                      name: 'Installation Date',
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
                        onPressed: () => updateString(index),
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
      ),
      barrierDismissible: true,
    );
  }

  removeString(index) {
    strings.removeAt(index);
  }

  // ------------------------- EFFICIENCY TABLE FUNCTION ------------------------- //
  addEfficiency() {
    // CHECK FOR EMPTY STRING AS IT IS REQUIRED
    if (efficiency.text == "") return warningDialog('Please fill in all form');

    // JSON PAYLOAD FOR STRING DATA
    Map<String, dynamic> efficiencyData = {
      "EntryID": 0,
      "Year": efficiencies.last['Year'] + 1,
      "Efficiency": int.parse(efficiency.text),
      "PlantID": plantID.value,
      "isDelete": true
    };

    efficiencies.last['isDelete'] = false;

    // ADD JSON PAYLOAD TO EFFICIENCY ARRAY
    efficiencies.add(efficiencyData);
    efficiency.text = "";
    Get.back();
  }

  updateEfficiency(index) {
    // CHECK FOR EMPTY STRING AS IT IS REQUIRED
    if (efficiency.text == "") return warningDialog('Please fill in all form');

    // JSON PAYLOAD FOR STRING DATA
    Map<String, dynamic> efficiencyData = {
      "EntryID": 0,
      "Year": efficiencies[index]['Year'],
      "Efficiency": int.parse(efficiency.text),
      "PlantID": plantID.value,
      "isDelete": true
    };

    // ASSIGN EXISTING ENTRY ID
    if (!efficiencies[index]['isDelete']) {
      efficiencyData['EntryID'] = efficiencies[index]['EntryID'];
      efficiencyData['isDelete'] = false;
    }

    // UPDATE SELECTED EFFICIENCIES
    efficiencies[index] = efficiencyData;
    efficiency.text = "";
    Get.back();
  }

  editEfficiency(index) {
    efficiency.text = efficiencies[index]['Efficiency'].toString();

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Container(
          width: Get.width * 0.6,
          height: Get.height * 0.26,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Year ${efficiencies[index]['Year']}',
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
                  controller: efficiency,
                  enabled: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
                        onPressed: () => updateEfficiency(index),
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
      ),
      barrierDismissible: true,
    );
  }

  removeEfficiency(index) {
    efficiencies.removeAt(index);
    if (efficiencies.length != 1) {
      efficiencies.last['isDelete'] = true;
    }
  }

  onItemTapped(int index) {
    var lastRoute = box.read('last-route');

    switch (index) {
      case 0:
        Get.offNamed(lastRoute);
        break;
      case 1:
        Get.offNamed('/performance');
        break;
      case 2:
        break;
      default:
    }
  }
}

class DropModel {
  DropModel(this.id, this.name, {this.placeholder});

  final int id;
  final String name;
  String? placeholder;
}
