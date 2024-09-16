import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';

/// Type definition for [ensureRuntimeCompatibility].
typedef RuntimeCompatibilityCallback = void Function(Directory cwd);

/// {@template yade_compatibility_exception}
/// An exception thrown when the current version of yade_cli
/// is incompatible with the yade runtime being used.
/// {@endtemplate}
class DartFrogCompatibilityException implements Exception {
  /// {@macro yade_compatibility_exception}
  const DartFrogCompatibilityException(this.message);

  /// The exception message.
  final String message;

  @override
  String toString() => message;
}

/// The version range of package:yade
/// supported by the current version of package:yade_cli.
const compatibleDartFrogVersion = '>=1.0.0 <2.0.0';

/// Whether current version of package:yade_cli is compatible
/// with the provided [version] of package:yade.
bool isCompatibleWithDartFrog(VersionConstraint version) {
  return VersionConstraint.parse(compatibleDartFrogVersion).allowsAll(version);
}

/// Ensures that the current version of `package:yade_cli` is compatible
/// with the version of `package:yade` used in the [cwd].
void ensureRuntimeCompatibility(Directory cwd) {
  final pubspecFile = File(path.join(cwd.path, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    throw DartFrogCompatibilityException(
      'Expected to find a pubspec.yaml in ${cwd.path}.',
    );
  }

  final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  final dependencyEntry = pubspec.dependencies.entries.where(
    (e) => e.key == 'yade',
  );

  if (dependencyEntry.isEmpty) {
    throw const DartFrogCompatibilityException(
      'Expected to find a dependency on "yade" in the pubspec.yaml',
    );
  }

  final dependency = dependencyEntry.first.value;
  if (dependency is HostedDependency) {
    if (!isCompatibleWithDartFrog(dependency.version)) {
      throw DartFrogCompatibilityException(
        '''The current version of "yade_cli" requires "yade" $compatibleDartFrogVersion.\nBecause the current version of "yade" is ${dependency.version}, version solving failed.''',
      );
    }
  }
}
