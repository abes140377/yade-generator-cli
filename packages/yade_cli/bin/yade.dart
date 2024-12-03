import 'dart:io';

import 'package:yade_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  // Run the command
  final exitCode = await YadeCommandRunner().run(args);
  await Future.wait<void>([stdout.close(), stderr.close()]);
  exit(exitCode);
}
