import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tomnenh/datas/datasource/remote_response.dart';

import 'remote_data.dart';

class ImpRemoteDataSource implements RemoteDataSource {
  final http.Client client;

  ImpRemoteDataSource({required this.client});
  // final String domain = "http://127.0.0.1:8000/api/";
  final String domain = "http://10.0.2.2:8000/api"; //Run on emulator
  // final String domain =
  //     "http://192.168.2.138:8000/api"; //Run on Physic device  //192.168.2.138 this get from your IP Local by cmd for macbook "ipconfig getifaddr en0"

  Future<String> getParams(Map? params) async {
    try {
      // final auth = await Auth.instance.user;

      final Map param = {
        // "token": auth?.token,
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
    final result = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: await getParams(params),
    );
    print("=================${result.statusCode}");

    // if (result.statusCode != 200) {
    //   throw ServerException();
    // }

    final body = json.decode(result.body);
    print("=================${body["success"]}");
    return ApiResponse(
      success: body["success"] ?? false,
      data: body['data'] as Map<String, dynamic>,
      msg: body["message"] ?? "Error",
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
}
