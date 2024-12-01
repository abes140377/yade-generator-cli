import 'package:equatable/equatable.dart';
import 'package:yade_cli/src/domain/git_repository.dart';

class Project extends Equatable {
  const Project({
    required this.id,
    required this.gitRepositories,
  });

  final String id;
  final List<GitRepository> gitRepositories;

  @override
  List<Object> get props => [id, gitRepositories];

  @override
  bool get stringify => true;
}
