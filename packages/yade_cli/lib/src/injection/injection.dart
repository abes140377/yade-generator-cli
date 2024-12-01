import 'package:get_it/get_it.dart';
import 'package:yade_cli/src/datasource/project_datasource.dart';
import 'package:yade_cli/src/datasource/project_datasource_local.dart';
import 'package:yade_cli/src/repository/project_repository.dart';
import 'package:yade_cli/src/service/project_service.dart';

final getIt = GetIt.instance;

void initInjection() {
  getIt
    ..registerSingleton<ProjectDatasource>(ProjectDatasourceLocal())
    ..registerSingleton<ProjectRepository>(ProjectRepository(getIt()))
    ..registerSingleton<ProjectService>(ProjectService(getIt()));
}
