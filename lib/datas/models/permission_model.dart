import 'dart:convert';

List<String> permissionModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String permissionModelToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
