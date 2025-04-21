part of 'upload_cubit.dart';

class UploadState {
  final bool isLoading;
  final bool isLoadingUpload;
  final UserModel? user;

  UploadState({
    this.isLoading = false,
    this.user,
    this.isLoadingUpload = false,
  });

  UploadState copyWith({
    bool? isLoading,
    bool? isLoadingUpload,
    UserModel? user,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingUpload: isLoadingUpload ?? this.isLoadingUpload,
    );
  }
}
