part of 'auth_cubit.dart';

class AuthState {
  final bool isLoading;
  final bool isLoadingLogin;

  AuthState({
    this.isLoading = false,
    this.isLoadingLogin = false,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoadingLogin,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
    );
  }
}
