import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tomnenh/datas/datasource/remote_data.dart';
import 'package:tomnenh/datas/datasource/remote_data_source.dart';
import 'package:tomnenh/datas/repositories/auth_repos.dart';
import 'package:tomnenh/datas/repositories/upload_repose.dart';

final locator = GetIt.I;

Future<void> initLocator() async {
  //MOCKUP DATE REGISTER

  //REPOSITORY
  locator.registerLazySingleton<AuthRepos>(() => AuthRepos(locator()));
  locator.registerLazySingleton<UploadRepose>(() => UploadRepose(locator()));
  locator.registerLazySingleton<RemoteDataSource>(
    () => ImpRemoteDataSource(
      client: locator(),
    ),
  );

  //EXTERNAL
  locator.registerLazySingleton(() => http.Client());
}
