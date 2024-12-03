import 'package:mason/mason.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/service/project_service.dart';
import 'package:yade_cli/src/utils/path_util.dart';

class ProjectInitializeCommand extends YadeCommand {
  ProjectInitializeCommand({required this.projectService, super.logger});

  final ProjectService projectService;

  @override
  final String description = 'Initialize the project.';

  @override
  final String name = 'init';

  @override
  Future<int> run() async {
    try {
      await projectService.projectInitialize(id: projectId);
    } on Exception catch (e) {
      logger.err(e.toString());

      return ExitCode.software.code;
    }

    return ExitCode.success.code;
  }
}
