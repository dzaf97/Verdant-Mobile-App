import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PremiumController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 1.obs;
  var userRole = "0".obs;

  @override
  void onInit() {
    super.onInit();
    userRole.value = box.read('role');
    
  }



  onItemTapped(int index) {
    // selectedTab.value = index;

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
