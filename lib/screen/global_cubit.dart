import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalState(isLoading: true));
  final DatabaseHelper databaseHelper = DatabaseHelper();

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
}
