import 'dart:convert';

import 'package:verdant_solar/utils/constants.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class APIService extends GetxController {
  final url = URL;
  var header = {"Authorization": ""}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  get(String endpoint) async {
    var parseURL = Uri.parse("$url$endpoint");
    final response = await http.get(
      parseURL,
      headers: header,
    );

    try {
      return json.decode(response.body);
    } catch (e) {
      return erroResponse(
        response.statusCode,
        e.toString(),
      );
    }
  }

  post(String endpoint, {body}) async {
    var parseURL = Uri.parse("$url$endpoint");
    final response = await http.post(
      parseURL,
      body: json.encode(body),
      headers: header,
    );

    try {
      return json.decode(response.body);
    } catch (e) {
      return erroResponse(
        response.statusCode,
        e.toString(),
      );
    }
  }

  put(String endpoint, {body}) async {
    var parseURL = Uri.parse("$url$endpoint");
    final response = await http.put(
      parseURL,
      body: json.encode(body),
      headers: header,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      return erroResponse(
        response.statusCode,
        response.reasonPhrase.toString(),
      );
    }
  }

  delete(String endpoint, {body}) async {
    var parseURL = Uri.parse("$url$endpoint");
    final response = await http.delete(
      parseURL,
      body: json.encode(body),
      headers: header,
    );

    try {
      return json.decode(response.body);
    } catch (e) {
      return erroResponse(
        response.statusCode,
        e.toString(),
      );
    }
  }

  multipartFile(endpoint, List<Map<String, String>> files, {body}) async {
    var parseURL = Uri.parse("$url$endpoint");
    var request = new http.MultipartRequest("POST", parseURL);
    request.headers.addAll(header);

    for (var file in files) {
      if (file['filename'] != "") {
        request.files.add(
          await http.MultipartFile.fromPath(file['field']!, file['filename']!),
        );
      }
    }
    request.fields['body'] = json.encode(body);

    var response = await request.send();
    if (response.statusCode >= 200) {
      final decoded = await response.stream.bytesToString();
      return json.decode(decoded);
    }
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

  Map parseToken({required String token}) {
    Codec<dynamic, dynamic> stringToBase64 = utf8.fuse(base64);
    var normalize = base64.normalize(token.split(".")[1]);
    var decoded = stringToBase64.decode(normalize);
    return json.decode(decoded);
  }

  IOWebSocketChannel createChannel(endpoint) {
    return IOWebSocketChannel.connect('$SOCKET$endpoint');
  }

  Map<String, dynamic> erroResponse(int statusCode, String statusMessage) =>
      {"error": true, "message": "${statusCode.toString()} $statusMessage"};
}
