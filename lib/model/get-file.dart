import 'dart:convert';

GetFile getFileFromJson(String str) => GetFile.fromJson(json.decode(str));

String getFileToJson(GetFile data) => json.encode(data.toJson());

class GetFile {
    GetFile({
        required this.error,
        required this.message,
    });

    final bool error;
    final List<Message> message;

    factory GetFile.fromJson(Map<String, dynamic> json) => GetFile(
        error: json["error"],
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
    };
}

class Message {
    Message({
        required this.fileName,
        required this.fileSize,
        required this.filePath,
    });

    final String fileName;
    final String fileSize;
    final String filePath;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        fileName: json["FileName"],
        fileSize: json["FileSize"],
        filePath: json["FilePath"],
    );

    Map<String, dynamic> toJson() => {
        "FileName": fileName,
        "FileSize": fileSize,
        "FilePath": filePath,
    };
}
