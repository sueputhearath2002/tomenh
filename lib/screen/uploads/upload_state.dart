part of 'upload_cubit.dart';

class UploadState {
  final bool isLoading;
  final bool isLoadingUpload;
  final UserModel? user;
  final List<Student>? students;
  final int? totalStudent;
  final int? totalAbsent;

  UploadState({
    this.isLoading = false,
    this.user,
    this.students,
    this.totalStudent,
    this.totalAbsent,
    this.isLoadingUpload = false,
  });

  UploadState copyWith({
    bool? isLoading,
    bool? isLoadingUpload,
    UserModel? user,
    int? totalStudent,
    List<Student>? students,
    int? totalAbsent,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      students: students ?? this.students,
      totalStudent: totalStudent ?? this.totalStudent,
      totalAbsent: totalAbsent ?? this.totalAbsent,
      isLoadingUpload: isLoadingUpload ?? this.isLoadingUpload,
    );
  }
}
