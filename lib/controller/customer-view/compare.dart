import 'package:flutter/material.dart';
import 'package:verdant_solar/model/compare-cust.dart';
import 'package:verdant_solar/screens/customer-view/compare.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CompareController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 1.obs;
  var isLoading = false.obs;

  var intervals = ["Today", "Daily", "Monthly", "Yearly"];
  var selectedInterval = "Today".obs;

  var radiuses = ["3", "5", "8", "10", "25"];
  var selectedRadius = "3".obs;

  var customerNearMe = <Widget>[].obs;
  var storeCustomer;

  @override
  void onInit() {
    setInit();
    super.onInit();
  }

  setInit() async {
    // RETRIEVE QUERY PARAMETER
    var userID = box.read('user-id');
    String interval;
    if (selectedInterval.value == "Today") {
      interval = "current";
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network.get(
        '/solar/api/v1/performance/compare/$userID?radius=$selectedRadius&interval=$interval');
    if (!res['error']) {
      CompareCust data = CompareCust.fromJson(res);

      for (var item in data.message) {
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration:
                  (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2),
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              location: item.location,
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            multiple: item.data,
            interval: selectedInterval.value,
          ));
        }
      }
    }
  }

  setInterval(value) async {
    isLoading(true);
    selectedInterval.value = value;

    // RESET ARRAY
    customerNearMe.value = <Widget>[];

    // RETRIEVE QUERY PARAMETER
    var userID = box.read('user-id');
    String interval;
    if (selectedInterval.value == "Today") {
      interval = "current";
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network.get(
        '/solar/api/v1/performance/compare/$userID?radius=$selectedRadius&interval=$interval');
    print(res);
    if (!res['error']) {
      CompareCust data = CompareCust.fromJson(res);
      for (var item in data.message) {
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration:
                  (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2),
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              location: item.location,
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            interval: selectedInterval.value,
            multiple: item.data,
          ));
        }
      }
    }
    isLoading(false);
  }

  setRadius(value) async {
    selectedRadius.value = value;

    // RESET ARRAY
    customerNearMe.value = <Widget>[];

    // RETRIEVE QUERY PARAMETER
    var userID = box.read('user-id');
    String interval;
    if (selectedInterval.value == "Today") {
      interval = "current";
    } else {
      interval = selectedInterval.value.toLowerCase();
    }

    var res = await network.get(
        '/solar/api/v1/performance/compare/$userID?radius=$selectedRadius&interval=$interval');
    if (!res['error']) {
      CompareCust data = CompareCust.fromJson(res);
      for (var item in data.message) {
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration: (item.data[0].totalProduction != "")
                  ? (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2)
                  : "0",
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              location: item.location,
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            multiple: item.data,
            interval: selectedInterval.value,
          ));
        }
      }
    }
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
