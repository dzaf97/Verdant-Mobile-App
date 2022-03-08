import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verdant_solar/model/customer-view/profile.dart';
import 'package:verdant_solar/model/customer-view/system-spec.dart';
import 'package:verdant_solar/service/camera_service.dart';
import 'package:verdant_solar/service/network_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:verdant_solar/utils/constants.dart';

class MyProfileController extends GetxController {
  var box = GetStorage();
  var network = Get.find<APIService>();
  var selectedTab = 2.obs;
  var carouselIndex = 0.obs;
  var camera = Get.put(CameraService());

  // MY PROFILE
  var name = "-".obs;
  var buildupArea = "-".obs;
  var noOfRooms = "0".obs;
  var householdSize = "0".obs;
  var images = [].obs;
  var editImage = {}.obs;

  // SYSTEM SPECIFICATIONS
  var systemSize = "0".obs;
  var installationDate = "-".obs;
  var panel = "-".obs;
  var inverter = "-".obs;

  @override
  void onInit() {
    super.onInit();
    setProfile();
    setSystemSpec();
  }

  setSystemSpec() async {
    final format = new DateFormat('dd MMMM yyyy');
    var userID = box.read('user-id');
    var res = await network.get('/solar/api/v1/profile/system/$userID');

    if (!res['error']) {
      SystemSpec data = SystemSpec.fromJson(res);
      systemSize.value = '${data.message.systemSize}';
      installationDate.value =
          '${format.format(DateTime.parse(data.message.installationDate))}';
      panel.value = '${data.message.solarModelName}';
      inverter.value = '${data.message.inverterModelName}';
    }
  }

  setProfile() async {
    images.value = [];
    var userID = box.read('user-id');
    var res = await network.get('/solar/api/v1/profile/$userID');

    if (!res['error']) {
      Profile data = Profile.fromJson(res);
      name.value =
          '${data.message.firstName.capitalizeFirst} ${data.message.lastName.capitalizeFirst}';
      buildupArea.value = '${data.message.buildupArea}';
      noOfRooms.value = '${data.message.numberOfRooms}';
      householdSize.value = '${data.message.householdSize}';

      if (data.message.profileImg.length == 0) {
        images.add({
          "ProfileImgPath":
              'https://verdant.s3.ap-southeast-1.amazonaws.com/profile-img/default-profile.png',
        });
      } else {
        for (var image in data.message.profileImg) {
          var imageData = {
            "ProfileImgPath": image.profileImgPath,
            "ProfileImgName": image.profileImgName,
          };
          images.add(imageData);
        }
      }
    }
  }

  addPhoto({source}) async {
    var image = await camera.getImage(source: source);
    if (image['error']) return;

    var username = box.read('username');
    var userID = box.read('user-id');
    var body = {"UserID": int.parse(userID), "Username": username};
    Map<String, String> file = {
      "field": "file",
      "filename": image["image"],
    };

    List<Map<String, String>> files = [];
    files.add(file);

    var res = await network.multipartFile(
      '/solar/api/v1/profile/profile-img',
      files,
      body: body,
    );
    print(res);
    await setProfile();
    Get.back();
  }

  deletePhoto(image) async {
    var file = image['ProfileImgName'];
    var body = {"Filename": file};
    var userID = box.read('selected-id');
    var res = await network.delete("/solar/api/v1/profile/profile-img/$userID",
        body: body);

    if (res['error']) return;

    await setProfile();
    Get.back();
  }

  askImageSource(isAdd) {
    Get.back();
    Get.defaultDialog(
      title: "Image Source",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () => addPhoto(
                  source: camera.camera,
                ),
                splashColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Color(kPrimaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
              Text(
                "Camera",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => addPhoto(
                  source: camera.gallery,
                ),
                splashColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Color(kPrimaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.image_rounded,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
              Text(
                "Gallery",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/cust-overview');
        break;
      case 1:
        Get.offNamed('/premium');
        break;
      case 2:
        break;
      default:
    }
  }
}
