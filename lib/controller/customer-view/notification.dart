import 'package:verdant_solar/model/customer-view/notification.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();

  var notifications = [].obs;

  @override
  void onInit() {
    super.onInit();
    getNotification();
  }

  getNotification() async {
    var res = await network.get('/solar/api/v1/mobile/notification');
    if (res['error']) return;

    Notification data = Notification.fromJson(res);
    for (var item in data.message) {
      notifications.add(item);
    }
  }
}
