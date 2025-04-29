import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/datas/repositories/auth_repos.dart';
import 'package:tomnenh/helper/helper.dart';
import 'package:tomnenh/injection.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(isLoading: true));

  final AuthRepos authRepos = locator<AuthRepos>();

  Future<bool> login(Map<String, dynamic> data) async {
    try {
      emit(state.copyWith(isLoadingLogin: true));
      bool success = false;

      await authRepos.login(data).then((response) {
        response.fold(
          (l) {
            print("===============error=======${l.message}");
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            emit(state.copyWith(isLoadingLogin: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingLogin: false));
      return success;
    } catch (e) {
      print("===============error=======${e.toString()}");
      emit(state.copyWith(isLoadingLogin: false));
      return false;
    }
  }

  Future<void> getUserData() async {
    final UserModel? data = await authRepos.getUserInfo();
    emit(state.copyWith(user: data));
  }

  Future<bool> logOutUser() async {
    try {
      emit(state.copyWith(isLoadingLogin: true));
      bool success = false;

      await authRepos.logOutUser().then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            emit(state.copyWith(isLoadingLogin: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingLogin: false));
      return success;
    } catch (e) {
      emit(state.copyWith(isLoadingLogin: false));
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      emit(state.copyWith(isLoadingLogin: true));
      bool success = false;

      await authRepos.register(data).then((response) {
        response.fold(
          (l) {
            Helper.showMessage(msg: l.message);
            success = false;
          },
          (r) {
            emit(state.copyWith(isLoadingLogin: false));
            success = true;
          },
        );
      });

      emit(state.copyWith(isLoadingLogin: false));
      return success;
    } catch (e) {
      emit(state.copyWith(isLoadingLogin: false));
      return false;
    }
  }
}
