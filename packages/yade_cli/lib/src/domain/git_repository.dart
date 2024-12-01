import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/utils/path_util.dart';

class GitRepository extends Equatable {
  const GitRepository({
    required this.url,
    required this.name,
    this.path,
  });

  final String url;
  final String name;
  final String? path;

  String get repoPath => join(srcDirPath, path ?? '', name);

  @override
  List<Object?> get props => [url, name, path];

  @override
  bool get stringify => true;
}
