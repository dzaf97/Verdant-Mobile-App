import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/map.dart';
import 'package:verdant_solar/utils/constants.dart';

class MapLatLng extends StatelessWidget {
  final controller = Get.put(MapLatLngController());
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(kPrimaryColor),
        title: Obx(
          () => Container(
            child: Text(
              "${controller.locationNameAppBar.value}",
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
        // leading: Theme(
        //   data: ThemeData(
        //       splashColor: Colors.transparent,
        //       highlightColor: Colors.transparent),
        //   child: IconButton(
        //     onPressed: () => Get.offAndToNamed('/add-user'),
        //     icon: Icon(
        //       Icons.arrow_back_ios_new_outlined,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ),
      body: Obx(
        () {
          return FlutterMap(
            options: MapOptions(
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              onPositionChanged: (position, isChange) =>
                  controller.setLatLngAddress(position, isChange),
              center: controller.marker.value,
              zoom: 10.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: controller.marker.value,
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.location_on,
                        color: Color(kPrimaryColor),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
