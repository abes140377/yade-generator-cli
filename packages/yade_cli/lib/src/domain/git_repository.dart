import 'package:path/path.dart';
import 'package:yade_cli/src/utils/path_util.dart';

class GitRepository {
  GitRepository({
    required this.url,
    required this.name,
    this.path,
  });

  final String url;
  final String name;
  final String? path;

  String get repoPath => join(srcDirPath, path ?? '', name);

  @override
  String toString() {
    return 'ProjectRepository(url: $url, name: $name, path: $path)';
  }
}
