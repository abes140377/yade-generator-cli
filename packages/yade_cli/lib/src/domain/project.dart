import 'package:yade_cli/src/domain/git_repository.dart';

class Project {
  Project({
    required this.id,
    required this.gitRepositories,
  });

  final String id;
  final List<GitRepository> gitRepositories;

  Project copyWith({
    String? id,
    List<GitRepository>? gitRepositories,
  }) {
    return Project(
      id: id ?? this.id,
      gitRepositories: gitRepositories ?? this.gitRepositories,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.id == id &&
        other.gitRepositories == gitRepositories;
  }

  @override
  int get hashCode => id.hashCode ^ gitRepositories.hashCode;

  @override
  String toString() => 'Project(id: $id, gitRepositories: $gitRepositories)';
}
