import 'dart:io';

import 'run_process.dart';

Future<void> iacRepoCreate({
  required String projectName,
  required Directory directory,
}) async {
  await runProcess(
    'yade',
    ['create', projectName],
    workingDirectory: directory.path,
    runInShell: true,
  );
}
