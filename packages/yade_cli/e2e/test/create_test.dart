import 'dart:io';

import 'package:test/test.dart';

import 'helpers/helpers.dart';

/// Objectives:
///
/// * Generate a new YADE project via `yade create`
/// * Ensure the code is formatted (`dart format .`)
/// * Ensure the code has no warnings/errors (`dart analyze .`)
/// * Ensure the tests pass (`dart test`)
void main() {
  group('yade create', () {
    const projectName = 'example';
    final tempDirectory = Directory.systemTemp.createTempSync();

    setUpAll(() async {
      await iacRepoCreate(projectName: projectName, directory: tempDirectory);
    });

    tearDownAll(() async {
      await tempDirectory.delete(recursive: true);
    });
  });
}
