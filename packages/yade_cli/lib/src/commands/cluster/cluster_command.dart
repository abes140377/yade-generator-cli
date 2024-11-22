import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:yade_cli/src/commands/cluster/create/cluster_create.dart';

///
class ClusterCommand extends Command<int> {
  ///
  ClusterCommand({Logger? logger}) {
    addSubcommand(ClusterCreateCommand(logger: logger));
  }

  @override
  final String name = 'cluster';
  @override
  final String description = 'Yade cluster commands.';
}
