part of 'global_cubit.dart';

class GlobalState {
  final bool isLoading;
  final bool isLoadingLogin;
  final UserModel? user;

  GlobalState({
    this.isLoading = false,
    this.isLoadingLogin = false,
    this.user,
  });

  GlobalState copyWith({
    bool? isLoading,
    bool? isLoadingLogin,
    UserModel? user,
  }) {
    return GlobalState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
    );
  }
}
