import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tomnenh/constant/constants.dart';
import 'package:tomnenh/datas/datasource/remote_data.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/datas/repositories/repo_response.dart';
import 'package:tomnenh/errors/exceptions.dart';
import 'package:tomnenh/errors/failures.dart';
import 'package:tomnenh/helper/database_helper.dart';

class AuthRepos {
  AuthRepos(this.source);

  final RemoteDataSource source;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<Either<Failure, RepoResponse<Map>>> login(Map params) async {
    try {
      final result = await source.login(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as Map<String, dynamic>;

      // final studentJson = record["records"] as Map<String, dynamic>;
      final user = UserModel.fromJson(record);
      final student = user.student;
      final token = user.token ?? "";
      final role = user.role?.first ?? "";
      final permission = user.permissions ?? [];
      await databaseHelper.insertUser({
        "name": student?.name,
        "email": student?.email,
        "photo": student?.photo,
        "token": token,
        "role": role,
      });
      await databaseHelper.insertPermissions(permission);

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    } catch (e) {
      return Left(NetworkFailure(errorInternetMessage));
    }
  }

  Future<Either<Failure, RepoResponse<Map>>> register(Map params) async {
    try {
      final result = await source.register(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as Map;
      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    }
  }

  Future<UserModel?> getUserInfo() async {
    final user = databaseHelper.getUser();
    return user;
  }

  Future<Either<Failure, RepoResponse<List<dynamic>>>> logOutUser() async {
    try {
      final result = await source.logOutUser();
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as List<dynamic>;
      await databaseHelper.deleteUser(databaseHelper.currentUser?.token ?? "");

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    }
  }
}
