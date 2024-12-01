import 'package:dcli/dcli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/injection/injection.dart';
import 'package:yade_cli/src/service/project_service.dart';
import 'package:yade_cli/src/utils/path_util.dart';

///
class ProjectInitializeCommand extends YadeCommand {
  ///
  ProjectInitializeCommand({super.logger});

  @override
  final String description = 'Initialize the project.';

  @override
  final String name = 'init';

  @override
  Future<int> run() async {
    final project = await getIt<ProjectService>().getProject(id: projectId);

    // create src directory
    if (!exists(srcDirPath)) {
      createDir(srcDirPath);
    }

    for (final gitRepository in project.gitRepositories) {
      final repoPath = gitRepository.repoPath;

      if (exists(repoPath)) {
        print('Repo already exists. Skipp cloning.');
      } else {
        final repoPathParentPath = dirname(repoPath);

        if (!exists(repoPathParentPath)) {
          createDir(repoPathParentPath);
        }

        'git clone ${gitRepository.url} ${gitRepository.name}'
            .start(workingDirectory: repoPathParentPath);
      }
    }

    return ExitCode.success.code;
  }
}
