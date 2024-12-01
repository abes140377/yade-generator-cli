import 'package:settings_yaml/settings_yaml.dart';
import 'package:yade_cli/src/domain/git_repository.dart';
import 'package:yade_cli/src/utils/path_util.dart';
import 'package:yaml/yaml.dart';

class ProjectConfig {
  // Public getter to access the instance
  factory ProjectConfig() => _instance;

  // Private named constructor
  ProjectConfig._internal();

  // Private static variable to hold the single instance
  static final ProjectConfig _instance = ProjectConfig._internal();

  // Properties
  late final String id;
  late List<GitRepository> gitRepositories = [];

  ///
  ProjectConfig read({required String id}) {
    final settings = SettingsYaml.load(
      pathToSettings: '$userHome/projects/$id-yade/.yade/yade.yml',
    );

    final project = settings['project'] as Map<String, dynamic>;
    this.id = project['id'] as String;

    final repositories = project['repositories'] as List<dynamic>;

    for (final repository in repositories) {
      final typedRepository = repository as YamlMap;

      this.gitRepositories.add(
            GitRepository(
              url: typedRepository['url'] as String,
              name: typedRepository['name'] as String? ??
                  gitRepoName(repository['url'] as String),
              path: typedRepository['path'] as String?,
            ),
          );
    }

    return this;
  }

  void write({
    required String id,
    required List<GitRepository> gitRepositories,
  }) {
    final settings = SettingsYaml.load(
      pathToSettings: '$userHome/projects/$id-yade/.yade/yade.yml',
    );

    settings['project'] = {
      'id': id,
      'repositories': gitRepositories.map((e) {
        return {
          'url': e.url,
          'name': e.name,
          'path': e.path,
        };
      }).toList(),
    };

    settings.save();
  }

  @override
  String toString() {
    return 'ProjectConfig('
        'id: $id, '
        'repositories: $gitRepositories'
        ')';
  }
}
