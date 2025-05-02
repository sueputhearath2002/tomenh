import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/datas/repositories/upload_repose.dart';
import 'package:tomnenh/helper/database_helper.dart';
import 'package:tomnenh/helper/helper.dart';
import 'package:tomnenh/injection.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadState(isLoading: true));
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final UploadRepose upload = locator<UploadRepose>();

  Future<void> getInfo() async {
    try {
      UserModel? userData = await databaseHelper.getUser();
      print("==========user fetched=========${userData?.student}");
      emit(state.copyWith(user: userData));
    } catch (e) {
      print("Error fetching user: $e");
      // You can emit an error state or log this to analytics
    }
  }

  Future<bool> uploadFile(Map<String, dynamic> data) async {
    try {
      emit(state.copyWith(isLoadingUpload: true));
      bool success = false;

      await upload.uploadFile(data).then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            Helper.downloadFile("${r.records['model']}",
                // r.records['model'].toString().split('/').last,
                isModel: true);

            Helper.downloadFile("${r.records['label']}", isModel: false
                // r.records['label'].toString().split('/').last,
                );

            emit(state.copyWith(isLoadingUpload: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingUpload: false));
      return success;
    } catch (e) {
      emit(state.copyWith(isLoadingUpload: false));
      return false;
    }
  }

  Future<bool> uploadImageStudent(Map<String, dynamic> data) async {
    try {
      emit(state.copyWith(isLoadingUpload: true));
      bool success = false;

      await upload.uploadImageStudent(data).then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            print(r.records);
            emit(state.copyWith(isLoadingUpload: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingUpload: false));
      return success;
    } catch (e) {
      emit(state.copyWith(isLoadingUpload: false));
      return false;
    }
  }

  Future<bool> checkAttendance(List<String> data) async {
    try {
      emit(state.copyWith(isLoadingUpload: true));
      bool success = false;

      await upload.checkAttendance({"students": data}).then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            emit(state.copyWith(isLoadingUpload: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingUpload: false));
      return success;
    } catch (e) {
      emit(state.copyWith(isLoadingUpload: false));
      return false;
    }
  }

  Future<bool> checkAttendanceStudent(String date) async {
    try {
      emit(state.copyWith(isLoadingUpload: true));
      bool success = false;

      await upload.checkAttendanceStudent({"date": date}).then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            final records = r.records;
            final students = records["students"] as List<dynamic>;
            final List<Student> recordsList = [];
            for (var a in students) {
              recordsList.add(Student.fromJson(a));
            }

            print("====================reiii${records["students"]}");
            emit(state.copyWith(
              isLoadingUpload: false,
              students: recordsList,
              totalAbsent: records["count"] ?? 0,
              totalStudent: records["total"] ?? 0,
            ));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingUpload: false));
      return success;
    } catch (e) {
      print("=================error=====${e.toString()}");
      emit(state.copyWith(isLoadingUpload: false));
      return false;
    }
  }

  Future<bool> filterAttendanceMonthStudentByAdmin(String month) async {
    print("==================sdfasdf=================${month}");
    try {
      emit(state.copyWith(isLoadingUpload: true));
      bool success = false;

      await upload.filterAttendanceMonthStudentByAdmin({"month": month}).then(
          (response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            final records = r.records;
            final students = records["students"] as List<dynamic>;
            final List<Student> recordsList = [];
            for (var a in students) {
              recordsList.add(Student.fromJson(a));
            }

            print("====================reiii${records["students"]}");
            emit(state.copyWith(
              isLoadingUpload: false,
              students: recordsList,
              totalAbsent: records["count"] ?? 0,
              totalStudent: records["total"] ?? 0,
            ));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingUpload: false));
      return success;
    } catch (e) {
      print("=================error=====${e.toString()}");
      emit(state.copyWith(isLoadingUpload: false));
      return false;
    }
  }
}
