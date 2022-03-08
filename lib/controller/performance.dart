import 'package:flutter/material.dart';
import 'package:verdant_solar/model/compare-cust.dart';
import 'package:verdant_solar/screens/performance.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PerformanceController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 1.obs;

  var intervals = ["Today", "Daily", "Monthly", "Yearly"];
  var selectedInterval = "Today".obs;

  var radiuses = ["3", "5", "8", "10", "25"];
  var selectedRadius = "3".obs;

  var customerNearMe = <Widget>[].obs;
  var storeCustomer = [];

  var searchController = TextEditingController();
  var search = "".obs;

  @override
  void onInit() {
    super.onInit();
    setInit();
    searchCustomer();

    searchController.addListener(() {
      search.value = searchController.text;
    });
  }

  setInit() async {
    // RETRIEVE QUERY PARAMETER
    var userID = box.read('selected-id');
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
        storeCustomer.add(item);
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration: (item.data[0].totalProduction != "")
                  ? (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2)
                  : "",
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              customerName: item.customer,
              dsy: item.data[0].dsykwhkwp.toStringAsFixed(2),
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            customer: item.customer,
            systemSize: double.parse(item.systemSize).toStringAsFixed(2),
            multiple: item.data,
            interval: selectedInterval.value,
          ));
        }
      }
    }
  }

  setInterval(value) async {
    storeCustomer = [];
    selectedInterval.value = value;

    // RESET ARRAY
    customerNearMe.value = <Widget>[];

    // RETRIEVE QUERY PARAMETER
    var userID = box.read('selected-id');
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
        storeCustomer.add(item);
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration:
                  (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2),
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              customerName: item.customer,
              dsy: item.data[0].dsykwhkwp.toStringAsFixed(2),
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            customer: item.customer,
            systemSize: double.parse(item.systemSize).toStringAsFixed(2),
            interval: selectedInterval.value,
            multiple: item.data,
          ));
        }
      }
    }
  }

  setRadius(value) async {
    storeCustomer = [];
    selectedRadius.value = value;

    // RESET ARRAY
    customerNearMe.value = <Widget>[];

    // RETRIEVE QUERY PARAMETER
    var userID = box.read('selected-id');
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
        storeCustomer.add(item);
        if (interval == "current") {
          customerNearMe.add(
            CompareTile(
              solarGeneration: (item.data[0].totalProduction != "")
                  ? (double.parse(item.data[0].totalProduction) * 1000)
                      .toStringAsFixed(2)
                  : "0",
              systemSize: double.parse(item.systemSize).toStringAsFixed(2),
              customerName: item.customer,
              dsy: item.data[0].dsykwhkwp.toStringAsFixed(2),
            ),
          );
        } else {
          customerNearMe.add(MultipleCompareTile(
            customer: item.customer,
            systemSize: double.parse(item.systemSize).toStringAsFixed(2),
            multiple: item.data,
            interval: selectedInterval.value,
          ));
        }
      }
    }
  }

  searchCustomer() {
    debounce(
      search,
      (text) {
        print(text);
        // RESET ARRAY
        customerNearMe.value = <Widget>[];

        String interval;
        if (selectedInterval.value == "Today") {
          interval = "current";
        } else {
          interval = selectedInterval.value.toLowerCase();
        }

        for (Message item in storeCustomer) {
          if (interval == "current") {
            if (item.customer
                .toLowerCase()
                .contains(search.toString().toLowerCase()))
              customerNearMe.add(
                CompareTile(
                  solarGeneration: (item.data[0].totalProduction != "")
                      ? (double.parse(item.data[0].totalProduction) * 1000)
                          .toStringAsFixed(2)
                      : "0",
                  systemSize: double.parse(item.systemSize).toStringAsFixed(2),
                  customerName: item.customer,
                  dsy: item.data[0].dsykwhkwp.toStringAsFixed(2),
                ),
              );
          } else {
            if (item.customer
                .toLowerCase()
                .contains(search.toString().toLowerCase()))
              customerNearMe.add(
                MultipleCompareTile(
                  customer: item.customer,
                  systemSize: item.systemSize,
                  multiple: item.data,
                  interval: selectedInterval.value,
                ),
              );
          }
        }
      },
    );
  }

  onItemTapped(int index) {
    // selectedTab.value = index;
    var lastRoute = box.read('last-route');

    switch (index) {
      case 0:
        Get.offNamed(lastRoute);
        break;
      case 1:
        break;
      case 2:
        Get.offNamed('/user-management');
        break;
      default:
    }
  }
}
