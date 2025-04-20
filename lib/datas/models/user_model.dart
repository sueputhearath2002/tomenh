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
            json['student'] != null && json['student'] is Map<String, dynamic>
                ? Student.fromJson(json['student'])
                : null,
        role: json["role"] is List
            ? List<String>.from(json["role"])
            : [json["role"].toString()],
        permissions: json["permissions"] is List
            ? List<String>.from(json["permissions"])
            : [],
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

  // Factory constructor to handle raw JSON input
  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  // Convert the object to a JSON string
  String toRawJson() => json.encode(toJson());

  // Factory constructor from a Map<String, dynamic> (used by fromJson)
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json["name"] ?? "", // Default to empty string if missing
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        photo:
            json["photo"]?.toString() ?? "", // Safe null check with toString()
        id: json["id"]?.toString() ?? "", // Ensuring id is always a string
      );

  // Convert the object to a Map<String, dynamic> for JSON encoding
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "photo": photo,
        "id": id,
      };
}
