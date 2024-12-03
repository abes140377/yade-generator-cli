import 'package:get_it/get_it.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/datasource/project_datasource.dart';
import 'package:yade_cli/src/datasource/project_datasource_local.dart';
import 'package:yade_cli/src/repository/project_repository.dart';
import 'package:yade_cli/src/service/project_service.dart';

final getIt = GetIt.instance;

void initInjection(Logger? logger) {
  getIt
    ..registerSingleton<Logger>(logger ?? Logger())
    ..registerSingleton<ProjectDatasource>(ProjectDatasourceLocal())
    ..registerSingleton<ProjectRepository>(
      ProjectRepository(getIt.get<ProjectDatasource>()),
    )
    ..registerSingleton<ProjectService>(
      ProjectService(getIt.get<ProjectRepository>(), getIt.get<Logger>()),
    );
}
