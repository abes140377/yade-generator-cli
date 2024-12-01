import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/command/project/create/project_create.dart';
import 'package:yade_cli/src/command/project/initialize/project_initialize.dart';
import 'package:yade_cli/src/command/project/repository/repository_command.dart';

///
class ProjectCommand extends Command<int> {
  ///
  ProjectCommand({Logger? logger}) {
    addSubcommand(ProjectCreateCommand(logger: logger));
    addSubcommand(ProjectInitializeCommand(logger: logger));
    addSubcommand(RepositoryCommand(logger: logger));
  }

  @override
  final String name = 'project';
  @override
  final String description = 'Yade project commands.';
}
