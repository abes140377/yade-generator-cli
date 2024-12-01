import 'package:mason/mason.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/domain/git_repository.dart';
import 'package:yade_cli/src/injection/injection.dart';
import 'package:yade_cli/src/service/project_service.dart';
import 'package:yade_cli/src/utils/path_util.dart';

///
class RepositoryAddCommand extends YadeCommand {
  ///
  RepositoryAddCommand({super.logger}) {
    argParser
      ..addOption(
        'url',
        abbr: 'u',
        help: 'The git repository url',
        // mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The git repository name',
        // mandatory: true,
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'The git repository path',
        // mandatory: true,
      );
  }

  @override
  final String description = 'Add a git repository to the project.';

  @override
  final String name = 'add';

  @override
  Future<int> run() async {
    // print(argResults);
    // print(argResults?.arguments);
    // print(argResults?.options);
    //
    // print(results);
    // print(results.arguments);
    // print(results.options);

    print('projectId: $projectId');

    final project = await getIt<ProjectService>().getProject(id: projectId);
    print('project: $project');

    final urlArg = results['url'] as String?;
    final url = urlArg ?? logger.prompt('Git Repo URL:');

    final repoName = gitRepoName(url);

    final nameArg = results['name'] as String?;
    final name =
        nameArg ?? logger.prompt('Git Repo name:', defaultValue: repoName);

    final pathArg = results['path'] as String?;
    final path = pathArg ?? logger.prompt('Git Repo path:');

    print('url: $url');
    print('name: $name');
    print('path: $path');

    project.gitRepositories.add(
      GitRepository(
        url: url,
        name: name,
        path: path,
      ),
    );

    await getIt<ProjectService>().saveProject(project: project);

    return ExitCode.success.code;
  }
}
