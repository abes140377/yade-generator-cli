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
class YadeCompatibilityException implements Exception {
  /// {@macro yade_compatibility_exception}
  const YadeCompatibilityException(this.message);

  /// The exception message.
  final String message;

  @override
  String toString() => message;
}

/// The version range of package:yade
/// supported by the current version of package:yade_cli.
const compatibleYadeVersion = '>=1.0.0 <2.0.0';

/// Whether current version of package:yade_cli is compatible
/// with the provided [version] of package:yade.
bool isCompatibleWithYade(VersionConstraint version) {
  return VersionConstraint.parse(compatibleYadeVersion).allowsAll(version);
}

/// Ensures that the current version of `package:yade_cli` is compatible
/// with the version of `package:yade` used in the [cwd].
void ensureRuntimeCompatibility(Directory cwd) {
  final pubspecFile = File(path.join(cwd.path, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    throw YadeCompatibilityException(
      'Expected to find a pubspec.yaml in ${cwd.path}.',
    );
  }

  final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  final dependencyEntry = pubspec.dependencies.entries.where(
    (e) => e.key == 'yade',
  );

  if (dependencyEntry.isEmpty) {
    throw const YadeCompatibilityException(
      'Expected to find a dependency on "yade" in the pubspec.yaml',
    );
  }

  final dependency = dependencyEntry.first.value;
  if (dependency is HostedDependency) {
    if (!isCompatibleWithYade(dependency.version)) {
      throw YadeCompatibilityException(
        '''The current version of "yade_cli" requires "yade" $compatibleYadeVersion.\nBecause the current version of "yade" is ${dependency.version}, version solving failed.''',
      );
    }
  }
}
