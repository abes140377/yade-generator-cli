// Install ansible dependencies
import 'dart:io';

import 'package:mason/mason.dart';

/// Install ansible dependencies
Future<void> installAnsibleDependencies({
  required Logger logger,
  required String outputDirectory,
}) async {
  final progress = logger.progress('Installing ansible dependencies');

  await Process.run(
    'task',
    ['install:deps'],
    runInShell: true,
    workingDirectory: outputDirectory,
  );

  progress.complete();
}

/// make doctor.sh executable
Future<void> makeDoctorShExecutable({
  required Logger logger,
  required String outputDirectory,
}) async {
  final progress = logger.progress('Make ./doctor.sh executable');

  await Process.run(
    'chmod',
    ['+x', 'doctor.sh'],
    runInShell: true,
    workingDirectory: outputDirectory,
  );

  progress.complete();
}

/// Initialize git repository
Future<void> initializeGitRepository({
  required String outputDirectory,
  required Logger logger,
}) async {
  final progress = logger.progress('Initializing git repository');

  await Process.run(
    'git',
    ['init'],
    runInShell: true,
    workingDirectory: outputDirectory,
  );

  progress.complete();
}
