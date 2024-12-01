import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/command/project/repository/add/repository_add.dart';

///
class RepositoryCommand extends Command<int> {
  ///
  RepositoryCommand({Logger? logger}) {
    addSubcommand(RepositoryAddCommand(logger: logger));
  }

  @override
  final String name = 'repository';
  @override
  final String description = 'Yade project repository commands.';
}
