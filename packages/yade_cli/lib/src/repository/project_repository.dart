import 'package:yade_cli/src/datasource/project_datasource.dart';
import 'package:yade_cli/src/domain/project.dart';

class ProjectRepository {
  ProjectRepository(this._projectDatasource);

  final ProjectDatasource _projectDatasource;

  Future<Project> getProject({required String id}) async {
    return _projectDatasource.getProject(id: id);
  }

  Future<void> saveProject({required Project project}) async {
    return _projectDatasource.saveProject(project: project);
  }
}
