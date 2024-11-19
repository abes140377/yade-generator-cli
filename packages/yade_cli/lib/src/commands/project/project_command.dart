import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/commands/project/create/project_create.dart';

///
class ProjectCommand extends Command<int> {
  ///
  ProjectCommand({Logger? logger}) {
    addSubcommand(ProjectCreateCommand(logger: logger));
  }

  @override
  final String name = 'project';
  @override
  final String description = 'Yade project commands.';
}
