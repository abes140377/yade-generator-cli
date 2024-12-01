import 'package:yade_cli/src/config/project_config.dart';
import 'package:yade_cli/src/datasource/project_datasource.dart';
import 'package:yade_cli/src/domain/project.dart';

class ProjectDatasourceLocal extends ProjectDatasource {
  @override
  Future<Project> getProject({required String id}) async {
    final projectConfig = ProjectConfig().read(id: id);

    return Project(
      id: projectConfig.id,
      gitRepositories: projectConfig.gitRepositories,
    );
  }

  @override
  Future<void> saveProject({required Project project}) async {
    ProjectConfig()
        .write(id: project.id, gitRepositories: project.gitRepositories);
  }
}
