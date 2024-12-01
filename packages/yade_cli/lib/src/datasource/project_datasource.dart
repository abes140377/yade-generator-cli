import 'package:yade_cli/src/domain/project.dart';

abstract class ProjectDatasource {
  Future<Project> getProject({required String id});

  Future<void> saveProject({required Project project});
}
