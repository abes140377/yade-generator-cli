import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

String get userHome {
  if (Platform.isWindows) {
    // Windows: HOME oder USERPROFILE verwenden
    return Platform.environment['USERPROFILE'] ??
        Platform.environment['HOMEDRIVE']! + Platform.environment['HOMEPATH']!;
  } else if (Platform.isMacOS || Platform.isLinux) {
    // macOS/Linux: HOME verwenden
    return Platform.environment['HOME']!;
  } else {
    // Unbekannte Plattform
    throw UnsupportedError('Unsupported platform');
  }
}

String gitRepoName(String repoUrl, {bool withExtension = false}) {
  final parsedUrl = Uri.parse(repoUrl);
  final pathSegment = parsedUrl.pathSegments.last;

  final newFile = File(pathSegment);
  final name = basename(newFile.path);
  final nameWithoutExtension = basenameWithoutExtension(newFile.path);

  if (withExtension) {
    return name;
  } else {
    return nameWithoutExtension;
  }
}

String get projectId {
  return basename(pwd).substring(0, basename(pwd).lastIndexOf('-'));
}

String get srcDirPath {
  return join(pwd, 'src');
}
