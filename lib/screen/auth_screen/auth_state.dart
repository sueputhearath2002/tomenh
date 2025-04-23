part of 'auth_cubit.dart';

class AuthState {
  final bool isLoading;
  final bool isLoadingLogin;
  final UserModel? user;

  AuthState({
    this.isLoading = false,
    this.isLoadingLogin = false,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoadingLogin,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
    );
  }
}
