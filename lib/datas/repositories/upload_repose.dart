import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tomnenh/constant/constants.dart';
import 'package:tomnenh/datas/datasource/remote_data.dart';
import 'package:tomnenh/datas/repositories/repo_response.dart';
import 'package:tomnenh/errors/exceptions.dart';
import 'package:tomnenh/errors/failures.dart';
import 'package:tomnenh/helper/database_helper.dart';

class UploadRepose {
  UploadRepose(this.source);

  final RemoteDataSource source;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<Either<Failure, RepoResponse<Map>>> uploadFile(Map params) async {
    try {
      final result = await source.uploadFile(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as Map<String, dynamic>;

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    } catch (e) {
      print("==============record${e}");
      return Left(NetworkFailure(errorInternetMessage));
    }
  }

  Future<Either<Failure, RepoResponse<List<dynamic>>>> uploadImageStudent(
      Map params) async {
    try {
      final result = await source.uploadImageStudent(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as List<dynamic>;

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    } catch (e) {
      print("==============record${e}");
      return Left(NetworkFailure(errorInternetMessage));
    }
  }

  Future<Either<Failure, RepoResponse<List<dynamic>>>> checkAttendance(
      Map params) async {
    try {
      final result = await source.checkAttendance(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as List<dynamic>;

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    } catch (e) {
      print("==============record${e}");
      return Left(NetworkFailure(errorInternetMessage));
    }
  }

  Future<Either<Failure, RepoResponse<Map<String, dynamic>>>>
      checkAttendanceStudent(Map params) async {
    try {
      final result = await source.checkAttendanceStudent(params: params);
      if (result.success != true) {
        return Left(ServerFailure(result.msg));
      }
      var record = result.data as Map<String, dynamic>;

      return Right(RepoResponse(
        msg: result.msg,
        records: record,
      ));
    } on ServerException {
      return Left(ServerFailure(errorMessage));
    } on SocketException {
      return Left(NetworkFailure(errorInternetMessage));
    } catch (e) {
      print("==============record${e}");
      return Left(NetworkFailure(errorInternetMessage));
    }
  }
}
