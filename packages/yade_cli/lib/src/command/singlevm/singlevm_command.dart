import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/command/singlevm/create/singlevm_create.dart';

///
class VmCommand extends Command<int> {
  ///
  VmCommand({Logger? logger}) {
    addSubcommand(SinglevmCreateCommand(logger: logger));
  }

  @override
  final String name = 'singlevm';
  @override
  final String description = 'Yade VM commands.';
}
