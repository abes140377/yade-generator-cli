// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:yade_cli/src/runtime_compatibility.dart';

void main() {
  group('YadeCompatibilityException', () {
    test('toString override is correct', () {
      const message = 'test message';
      expect(
        YadeCompatibilityException(message).toString(),
        equals(message),
      );
    });
  });

  group('isCompatibleWithYade', () {
    test('returns true when the yade version is compatible', () {
      final compatibleVersions = [
        VersionConstraint.parse('1.0.0'),
        VersionConstraint.parse('^1.0.0'),
        VersionConstraint.parse('>=1.0.0 <2.0.0'),
      ];
      for (final version in compatibleVersions) {
        expect(isCompatibleWithYade(version), isTrue);
      }
    });

    test('returns false when the yade version is incompatible', () {
      final incompatibleVersions = [
        VersionConstraint.parse('any'),
        VersionConstraint.parse('0.1.0'),
        VersionConstraint.parse('^0.1.0'),
        VersionConstraint.parse('>=0.1.0 <0.2.0'),
        VersionConstraint.parse('>=0.2.0 <=0.3.0'),
        VersionConstraint.parse('>=2.0.0 <3.0.0'),
      ];
      for (final version in incompatibleVersions) {
        expect(isCompatibleWithYade(version), isFalse);
      }
    });
  });

  group('ensureRuntimeCompatibility', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('throws when a pubspec.yaml does not exist', () {
      final expected = 'Expected to find a pubspec.yaml in ${tempDir.path}.';
      expect(
        () => ensureRuntimeCompatibility(tempDir),
        throwsA(
          isA<YadeCompatibilityException>().having(
            (e) => e.message,
            'message',
            expected,
          ),
        ),
      );
    });

    test(
        'throws when the pubspec.yaml does '
        'not contain a yade dependency', () {
      const expected =
          'Expected to find a dependency on "yade" in the pubspec.yaml';
      File(path.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync(
        '''
name: example
version: 0.1.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"
''',
      );
      expect(
        () => ensureRuntimeCompatibility(tempDir),
        throwsA(
          isA<YadeCompatibilityException>().having(
            (e) => e.message,
            'message',
            expected,
          ),
        ),
      );
    });

    test('throws when the version of yade is incompatible', () {
      const incompatibleVersion = '^99.99.99';
      const expected =
          '''The current version of "yade_cli" requires "yade" $compatibleYadeVersion.\nBecause the current version of "yade" is $incompatibleVersion, version solving failed.''';
      File(path.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync(
        '''
name: example
version: 0.1.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  yade: $incompatibleVersion
''',
      );
      expect(
        () => ensureRuntimeCompatibility(tempDir),
        throwsA(
          isA<YadeCompatibilityException>().having(
            (e) => e.message,
            'message',
            expected,
          ),
        ),
      );
    });

    test('completes when the version is compatible.', () {
      File(path.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync(
        '''
name: example
version: 0.1.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  yade: "$compatibleYadeVersion"
''',
      );
      expect(() => ensureRuntimeCompatibility(tempDir), returnsNormally);
    });
  });
}
