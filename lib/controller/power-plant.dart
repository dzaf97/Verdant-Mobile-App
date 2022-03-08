import 'package:verdant_solar/model/power-plant-overview.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PowerPlantController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 0.obs;

  var isAll = true.obs;
  var isIssue = false.obs;
  var isNormal = false.obs;

  var all = 0.obs;
  var issueDetected = 0.obs;
  var normal = 0.obs;

  var listPowerplant = [].obs;

  var showPowerPlant = [].obs;

  @override
  void onInit() {
    setPowerPlantList();
    super.onInit();
  }

  setPowerPlantList() async {
    var res =
        await network.get('/solar/api/v1/mobile/overview/powerplant/status');

    if (res['error']) return;
    PowerPlantOverview data = PowerPlantOverview.fromJson(res);

    // SET POWERPLANT TOTAL COUNT
    all.value = data.message.length;

    // STORE POWERPLAN
    for (Message item in data.message) {
      listPowerplant.add(item);

      // SET NORMAL TOTAL COUNT
      if (item.plantStatus == "Normal") normal.value++;
    }

    // SET ISSUE TOTAL COUNT (ALL COUNT - NORMAL COUNT)
    issueDetected.value = all.value - normal.value;

    setShowTab();
  }

  setShowTab() {
    showPowerPlant.value = [];
    if (isAll.value) {
      // STORE ALL AVAILABLE PLANT
      for (Message item in listPowerplant) {
        showPowerPlant.add(item);
      }
    } else if (isIssue.value) {
      // STORE ALL PLANT THAT HAVE ISSUE
      for (Message item in listPowerplant) {
        if (item.plantStatus != "Normal") {
          showPowerPlant.add(item);
        }
      }
    } else if (isNormal.value) {
      // STORE ALL PLANT THAT IS NORMAL
      for (Message item in listPowerplant) {
        if (item.plantStatus == "Normal") {
          showPowerPlant.add(item);
        }
      }
    }
  }
}
