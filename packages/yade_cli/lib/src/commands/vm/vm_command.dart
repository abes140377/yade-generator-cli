import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/commands/vm/create/vm_create.dart';

///
class VmCommand extends Command<int> {
  ///
  VmCommand({Logger? logger}) {
    addSubcommand(VmCreateCommand(logger: logger));
  }

  @override
  final String name = 'vm';
  @override
  final String description = 'Yade VM commands.';
}
