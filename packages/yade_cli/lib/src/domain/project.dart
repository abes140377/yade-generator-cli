import 'package:equatable/equatable.dart';
import 'package:yade_cli/src/domain/git_repository.dart';
import 'package:yade_cli/src/domain/software_asset.dart';

class Project extends Equatable {
  const Project({
    required this.id,
    required this.gitRepositories,
    required this.softwareAssets,
  });

  final String id;
  final List<GitRepository> gitRepositories;
  final List<SoftwareAsset> softwareAssets;

  @override
  List<Object> get props => [id, gitRepositories, softwareAssets];

  @override
  bool get stringify => true;
}
