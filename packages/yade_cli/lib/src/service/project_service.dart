import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/domain/project.dart';
import 'package:yade_cli/src/repository/project_repository.dart';
import 'package:yade_cli/src/utils/archive_util.dart';
import 'package:yade_cli/src/utils/path_util.dart';
import 'package:yade_cli/src/utils/platform_util.dart';
import 'package:yade_cli/src/utils/template_string.dart';

class ProjectService {
  ProjectService(this._projectRepository, this._logger);

  final ProjectRepository _projectRepository;
  final Logger _logger;

  ///
  Future<Project> getProject({required String id}) async {
    return _projectRepository.getProject(id: id);
  }

  ///
  Future<void> saveProject({required Project project}) async {
    return _projectRepository.saveProject(project: project);
  }

  ///
  Future<void> addGitRepository({required Project project}) async {
    return _projectRepository.saveProject(project: project);
  }

  ///
  Future<void> projectInitialize({required String id}) async {
    final project = await getProject(id: id);

    _initGitRepositories(project);

    _initSoftwareAssets(project);
  }

  ///
  void _initSoftwareAssets(Project project) {
    _logger.info('software assets: ${project.softwareAssets}');

    for (final softwareAsset in project.softwareAssets) {
      final softwareInstallPath = join(softwareDirPath, softwareAsset.name);

      final templateUrl = TemplateString(softwareAsset.url);
      final params = <String, dynamic>{
        'uname': uname,
      };
      final parsedUrl = templateUrl.format(params);

      if (!exists(softwareInstallPath)) {
        createDir(softwareInstallPath);
      }

      final archiveType = ArchiveType.fromPath(softwareAsset.url);

      'wget -q -O ${softwareAsset.name}.${archiveType.extension} $parsedUrl'
          .start(workingDirectory: softwareInstallPath);

      // TODO(freund): Add support for other archive types
      extract(
        join(
          softwareInstallPath,
          '${softwareAsset.name}.${archiveType.extension}',
        ),
        softwareInstallPath,
      );

      // create a file with the following content
      final content = '''
export ASSET_HOME=\${YADE_PROJECT_SOFTWARE}/${softwareAsset.name}-${softwareAsset.version}
export PATH="\${ASSET_HOME}:\$PATH"
''';

      final filePath =
          join(softwareDirPath, 'set-env-${softwareAsset.name}.sh');

      try {
        File(filePath).writeAsStringSync(content);
      } catch (e) {
        _logger.err('Failed to create set-env-${softwareAsset.name}.sh: $e');
      }

      delete(
        join(
          softwareInstallPath,
          '${softwareAsset.name}.${archiveType.extension}',
        ),
      );
    }
  }

  ///
  void _initGitRepositories(Project project) {
    if (!exists(srcDirPath)) {
      createDir(srcDirPath);
    }

    for (final gitRepository in project.gitRepositories) {
      final repoPath = gitRepository.repoPath;

      if (exists(repoPath)) {
        _logger.info('Repo already exists. Skipp cloning.');
      } else {
        final repoPathParentPath = dirname(repoPath);

        if (!exists(repoPathParentPath)) {
          createDir(repoPathParentPath);
        }

        'git clone ${gitRepository.url} ${gitRepository.name}'
            .start(workingDirectory: repoPathParentPath);
      }
    }
  }
}
