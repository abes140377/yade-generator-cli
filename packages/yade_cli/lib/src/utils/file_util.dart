import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/utils/path_util.dart';

void createZshrcdAlias(String projectId) {
  final zshrcd = join(userHome, 'zshrc.d');

  // create a directory
  if (!exists(zshrcd)) {
    createDir(zshrcd);
  }

  '$zshrcd/yade-example-aliases.zsh'.write(
    'alias yade-init-$projectId="cd ~/projects/$projectId-yade && . ./console"',
  );
}
