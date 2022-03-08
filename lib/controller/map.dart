import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:verdant_solar/controller/add-user.dart';
import 'package:verdant_solar/service/location_service.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MapLatLngController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var user = Get.find<AddUserController>();
  final location = Get.put(LocationService());

  var locationNameAppBar = "".obs;
  var marker = LatLng(3.1434379, 101.5970591).obs;
  MapController mapController = MapController();
  // StreamSubscription? subscription;

  @override
  void onInit() async {
    super.onInit();


    locationNameAppBar.value = user.address.text;
    if (user.isAddressChange.value) {
      var res = Get.arguments;

      if (!res['error']) {
        double lat = res['message']['latLng']['lat'];
        double long = res['message']['latLng']['lng'];
        if (lat == 39.390897 && long == -99.066067) {
          lat = 3.1434379;
          long = 101.5970591;
        }
        print("$lat, $long");
        marker.value = LatLng(lat, long);
        user.latitude.value = lat;
        user.longitude.value = long;
      }
      user.isAddressChange.value = false;
    } else {
      double lat = user.latitude.value;
      double long = user.longitude.value;
      marker.value = LatLng(lat, long);
    }
  }

  @override
  void onClose() {
    // subscription!.cancel();
    super.onClose();
    user.locationName.value =
        "${marker.value.latitude.toStringAsFixed(5)}, ${marker.value.longitude.toStringAsFixed(5)}";
  }

  // mapStream() {
  //   mapController!.onReady.then(
  //     (_) {
  //       subscription =
  //           mapController!.mapEventStream.listen((MapEvent mapEvent) async {
  //         if (mapEvent is MapEventMoveEnd) {
  //           user.latitude.value = marker.value.latitude;
  //           user.longitude.value = marker.value.longitude;
  //         }
  //       });
  //     },
  //   );
  // }

  setLatLngAddress(MapPosition position, bool isChange) {
    double lat = position.center!.latitude;
    double long = position.center!.longitude;
    if (isChange) {
      marker.value = LatLng(lat, long);
      user.latitude.value = lat;
      user.longitude.value = long;
    }
  }
}
