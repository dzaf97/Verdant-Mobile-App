import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/widgets/alert_dialog.dart';
import 'package:http/http.dart' as http;

class LocationService extends GetxController {
  var serviceEnabled = false.obs;
  var latitude = 2.920924.obs;
  var longitude = 101.637253.obs;
  LocationPermission permission = LocationPermission.denied;

  Future retrieveLatLong() async {
    serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled.value) {
      warningDialog("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        warningDialog("Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      warningDialog(
          "Location permissions are permanently denied, please enable app location in settings.");
      return;
    }

    var responseLocation = await Geolocator.getCurrentPosition();
    latitude.value = responseLocation.latitude;
    longitude.value = responseLocation.longitude;
  }

  double calculateRadius(startLatitude, startLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, latitude.value, longitude.value);
  }

  Future<List<Placemark>> getAddress() async {
    List<Placemark> placemarks = [];
    try {
      placemarks =
          await placemarkFromCoordinates(latitude.value, longitude.value);
    } catch (e) {
      print(e);
    }
    return placemarks;
  }

  addressToLatLng({required String address}) async {
    var key = "WkJGGngkiWlHu0LYyMbZyT9Wp2Ri68Vf";
    var parseURL =
        Uri.parse("http://www.mapquestapi.com/geocoding/v1/address?key=$key");
    final response = await http.post(
      parseURL,
      body: json.encode({"location": address}),
    );

    var data = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {"error": false, "message": data["results"][0]["locations"][0]};
    } else {
      return {"error": true, "message": data["results"][0]["locations"][0]};
    }
  }
}
