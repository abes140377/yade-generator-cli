import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/command/k8s/create/k8s_create.dart';

class K8sCommand extends Command<int> {
  K8sCommand({Logger? logger}) {
    addSubcommand(K8sCreateCommand(logger: logger));
  }

  @override
  final String name = 'k8s';
  @override
  final String description = 'Yade k8s cluster commands.';
}
