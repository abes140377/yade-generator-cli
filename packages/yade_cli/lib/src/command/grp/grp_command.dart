import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/command/grp/create/grp_create.dart';

class GrpCommand extends Command<int> {
  GrpCommand({Logger? logger}) {
    addSubcommand(GrpCreateCommand(logger: logger));
  }

  @override
  final String name = 'grp';
  @override
  final String description = 'Yade VM group commands.';
}
