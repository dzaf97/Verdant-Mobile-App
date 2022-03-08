import 'package:flutter/material.dart';
import 'package:verdant_solar/model/user-list.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 2.obs;
  var title = "USER MANAGEMENT".obs;
  var searchText = TextEditingController();
  var typeText = "".obs;

  var levels = ["All"].obs;
  var selectedLevel = "All".obs;

  var user = <Message>[].obs;
  var storeAll = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    setUserList();
    searchUser();
    // ASSIGN RXSTRING TO LISTEN TO TEXT EDIT CONTROLLER
    searchText.addListener(() {
      typeText.value = searchText.text;
    });
  }

  setUserList() async {
    var res = await network.get('/solar/api/v1/powerplant/');
    if (!res['error']) {
      UserList data = UserList.fromJson(res);
      for (var item in data.message) {
        levels.add(item.userType);
        user.add(item);
        storeAll.add(item);
      }
      levels.value = levels.toSet().toList();
    }
  }

  setLevel(value) {
    user.value = <Message>[];
    selectedLevel.value = value;

    for (var item in storeAll) {
      if (selectedLevel.value == "All") {
        user.add(item);
      }
      if (selectedLevel.value == item.userType) {
        user.add(item);
      }
    }
  }

  searchUser() {
    debounce(typeText, (search) {
      user.value = <Message>[];
      for (var item in storeAll) {
        if (item.fullName
            .toLowerCase()
            .contains(search.toString().toLowerCase())) {
          user.add(item);
        }
      }
    }, time: Duration(milliseconds: 500));
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
