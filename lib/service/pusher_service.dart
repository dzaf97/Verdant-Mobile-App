import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:verdant_solar/utils/constants.dart';

class PusherService extends GetxController {
  late PusherClient pusher;

  @override
  void onInit() {
    super.onInit();
    initPusher();
  }

  @override
  onClose() {
    super.onClose();

    if (Get.currentRoute == '/login') {
      pusher.unsubscribe("verdant-01");
      pusher.disconnect();
    }
  }

  initPusher() {
    pusher = PusherClient(
      KEY,
      PusherOptions(cluster: CLUSTER, encrypted: true),
    );
    pusher.connect();

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });
  }

  PusherClient getInstance() {
    return pusher;
  }
}
