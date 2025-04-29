import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tomnenh/datas/datasource/remote_response.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';

import 'remote_data.dart';

class ImpRemoteDataSource implements RemoteDataSource {
  final http.Client client;

  ImpRemoteDataSource({required this.client});
  // final String domain = "http://127.0.0.1:8000/api/";
  // final String domain = "http://10.0.2.2:8000/api"; //Run on emulator
  final String domain =
      "http://103.253.146.193/api"; //Run on Physic device  //192.168.2.138 this get from your IP Local by cmd for macbook "ipconfig getifaddr en0"

  Future<String> getParams(Map? params) async {
    try {
      final UserModel? auth = await DatabaseHelper.instance.getUser();

      final Map param = {
        "token": auth?.token,
        "source": Platform.isIOS ? "ios" : "android",
      };

      var body = param;
      if (params != null) {
        body = {...param, ...params};
      }
      return json.encode(body);
    } catch (e) {
      return "";
    }
  }

  @override
  Future<ApiResponse> login({Map? params}) async {
    var url = Uri.parse("$domain/login-student");
    print("======================${"$domain/login-student"}");
    final result = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: await getParams(params),
    );
    print("=================${result.body}");

    final body = json.decode(result.body);
    return ApiResponse(
      success: body["success"] as bool,
      data: body['data'] as Map<String, dynamic>,
      msg: body["message"] ?? "",
    );
  }

  @override
  Future<ApiResponse> register({Map? params}) async {
    var url = Uri.parse("$domain/register-student");
    final result = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: await getParams(params),
    );
    print("========ddd=========${await getParams(params)}");

    final body = json.decode(result.body);
    print("=================${body["success"]}");
    return ApiResponse(
      success: body["success"] ?? false,
      data: body['data'],
      msg: body["message"] ?? "Error",
    );
  }

  @override
  Future<ApiResponse> logOutUser() async {
    final UserModel? auth = await DatabaseHelper.instance.getUser();
    var url = Uri.parse("$domain/logout");
    final result = await client.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${auth?.token}", // Add Bearer token here
      },
      body: await getParams({}),
    );

    final body = json.decode(result.body);
    return ApiResponse(
      success: body["success"] ?? false,
      data: body["data"] as List<dynamic>,
      msg: body["message"] ?? "Error",
    );
  }

  @override
  Future<ApiResponse> uploadFile({Map? params}) async {
    var url = Uri.parse("$domain/student/upload-model");

    // Extract file paths
    final filePath = params?["file"]?.files?.single?.path;
    final labelPath = params?["label"]?.files?.single?.path;

    if (filePath == null || labelPath == null) {
      return ApiResponse(
        success: false,
        msg: "Missing file or label file.",
        data: {},
      );
    }

    File fileTLife = File(filePath);
    File fileLabel = File(labelPath);

    var request = http.MultipartRequest('POST', url);
    final UserModel? auth = await DatabaseHelper.instance.getUser();

    request.headers['Authorization'] = 'Bearer ${auth?.token}';
    request.headers['Accept'] = 'application/json';

    request.files
        .add(await http.MultipartFile.fromPath('file', fileTLife.path));
    request.files
        .add(await http.MultipartFile.fromPath('label', fileLabel.path));

    print("Uploading files with token: ${fileTLife.path}, ${fileLabel.path}");

    var streamedResponse = await request.send();
    var result = await http.Response.fromStream(streamedResponse);

    final body = json.decode(result.body);
    print("===========${body["data"]}");
    return ApiResponse(
      success: body["success"] ?? false,
      data: body["data"] ?? {},
      msg: body["message"] ?? "Error",
    );
  }

  @override
  Future<ApiResponse> uploadImageStudent({Map? params}) async {
    var url = Uri.parse("$domain/student/upload-images");

    final List<XFile>? fileList = params?["images"];

    if (fileList == null || fileList.isEmpty) {
      return ApiResponse(
        success: false,
        msg: "Missing file(s).",
        data: {},
      );
    }

    var request = http.MultipartRequest('POST', url);
    final UserModel? auth = await DatabaseHelper.instance.getUser();

    request.headers['Authorization'] = 'Bearer ${auth?.token}';
    request.headers['Accept'] = 'application/json';

    // Upload multiple images
    for (var file in fileList) {
      request.files.add(
        await http.MultipartFile.fromPath('images[]', file.path),
      );
    }

    print("Uploading ${fileList.length} images");

    var streamedResponse = await request.send();
    var result = await http.Response.fromStream(streamedResponse);

    final body = json.decode(result.body);
    print("===========body${body}");

    return ApiResponse(
      success: body["success"] ?? false,
      data: body["data"] ?? List<dynamic>,
      msg: body["message"] ?? "Error",
    );
  }
}
