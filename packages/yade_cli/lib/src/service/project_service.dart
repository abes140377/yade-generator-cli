import 'package:yade_cli/src/domain/project.dart';
import 'package:yade_cli/src/repository/project_repository.dart';

class ProjectService {
  ProjectService(this._projectRepository);

  final ProjectRepository _projectRepository;

  Future<Project> getProject({required String id}) async {
    return _projectRepository.getProject(id: id);
  }

  Future<void> saveProject({required Project project}) async {
    return _projectRepository.saveProject(project: project);
  }

  Future<void> addGitRepository({required Project project}) async {
    return _projectRepository.saveProject(project: project);
  }
}
