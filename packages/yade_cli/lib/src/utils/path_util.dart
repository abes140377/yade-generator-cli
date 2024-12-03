import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

String get userHome {
  if (Platform.isWindows) {
    return Platform.environment['USERPROFILE'] ??
        Platform.environment['HOMEDRIVE']! + Platform.environment['HOMEPATH']!;
  } else if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['HOME']!;
  } else {
    throw UnsupportedError('Only supports Windows, MacOS, and Linux');
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

String get softwareDirPath {
  return join(pwd, 'software');
}
