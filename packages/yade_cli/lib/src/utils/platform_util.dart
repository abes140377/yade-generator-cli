import 'dart:io';

String get uname {
  if (Platform.isLinux) {
    return 'linux';
  } else if (Platform.isMacOS) {
    return 'darwin';
  } else {
    throw Exception('Unsupported platform');
  }
}
