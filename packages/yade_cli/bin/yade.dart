import 'dart:io';

import 'package:yade_cli/src/command_runner.dart';
import 'package:yade_cli/src/injection/injection.dart';

Future<void> main(List<String> args) async {
  // Initialize the injection
  initInjection();

  // Run the command
  final exitCode = await YadeCommandRunner().run(args);
  await Future.wait<void>([stdout.close(), stderr.close()]);
  exit(exitCode);
}
