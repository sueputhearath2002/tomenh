import 'dart:convert';

class UserModel {
  final String? token;
  final Student? student;
  final List<String>? role;
  final List<String>? permissions;

  UserModel({
    this.token,
    this.student,
    this.role,
    this.permissions,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"] ?? "",
        student:
            json["student"] == null ? null : Student.fromJson(json["student"]),
        role: json["role"] == null
            ? []
            : List<String>.from(json["role"]!.map((x) => x)),
        permissions: json["permissions"] == null
            ? []
            : List<String>.from(json["permissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "student": student?.toJson(),
        "role": role == null ? [] : List<dynamic>.from(role!.map((x) => x)),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x)),
      };
}

class Student {
  final String? name;
  final String? email;
  final String? password;
  final String? photo;
  final String? id;

  Student({
    this.name,
    this.email,
    this.password,
    this.photo,
    this.id,
  });

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        photo: json["photo"] ?? "",
        id: json["id"].toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "photo": photo,
        "id": id,
      };
}
