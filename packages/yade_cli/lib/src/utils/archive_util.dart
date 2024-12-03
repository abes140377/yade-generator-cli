import 'package:dcli/dcli.dart';

enum ArchiveType {
  zip,
  tarGz;

  static ArchiveType fromPath(String path) {
    if (path.endsWith('.zip')) {
      return ArchiveType.zip;
    } else if (path.endsWith('.tar.gz')) {
      return ArchiveType.tarGz;
    } else {
      throw Exception('Unsupported archive type');
    }
  }

  String get extension {
    switch (this) {
      case ArchiveType.zip:
        return 'zip';
      case ArchiveType.tarGz:
        return 'tar.gz';
    }
  }
}

void extract(String archivePath, String destination) {
  if (archivePath.endsWith('.zip')) {
    'unzip -q $archivePath'.start(workingDirectory: destination);
  } else if (archivePath.endsWith('.tar.gz')) {
    'tar -xzf $archivePath'.start(workingDirectory: destination);
  } else {
    throw Exception('Unsupported archive type');
  }
}
