
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    Profile({
        required this.error,
        required this.message,
    });

    bool error;
    Message message;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        error: json["error"],
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message.toJson(),
    };
}

class Message {
    Message({
        required this.firstName,
        required this.lastName,
        required this.buildupArea,
        required this.numberOfRooms,
        required this.householdSize,
        required this.profileImg,
    });

    String firstName;
    String lastName;
    int buildupArea;
    int numberOfRooms;
    int householdSize;
    List<ProfileImg> profileImg;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        buildupArea: json["BuildupArea"],
        numberOfRooms: json["NumberOfRooms"],
        householdSize: json["HouseholdSize"],
        profileImg: List<ProfileImg>.from(json["ProfileImg"].map((x) => ProfileImg.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "BuildupArea": buildupArea,
        "NumberOfRooms": numberOfRooms,
        "HouseholdSize": householdSize,
        "ProfileImg": List<dynamic>.from(profileImg.map((x) => x.toJson())),
    };
}

class ProfileImg {
    ProfileImg({
        required this.profileImgPath,
        required this.profileImgName,
    });

    String profileImgPath;
    String profileImgName;

    factory ProfileImg.fromJson(Map<String, dynamic> json) => ProfileImg(
        profileImgPath: json["ProfileImgPath"],
        profileImgName: json["ProfileImgName"],
    );

    Map<String, dynamic> toJson() => {
        "ProfileImgPath": profileImgPath,
        "ProfileImgName": profileImgName,
    };
}
