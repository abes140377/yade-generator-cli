import 'dart:io';

import 'package:yade_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final exitCode = await DartFrogCommandRunner().run(args);
  await Future.wait<void>([stdout.close(), stderr.close()]);
  exit(exitCode);
}
