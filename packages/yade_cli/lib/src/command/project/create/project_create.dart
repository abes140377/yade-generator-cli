// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/command/commands.dart';
import 'package:yade_cli/src/command/project/create/templates/project_create_bundle.dart';
import 'package:yade_cli/src/injection/injection.dart';
import 'package:yade_cli/src/service/project_service.dart';
import 'package:yade_cli/src/utils/path_util.dart';

///
class ProjectCreateCommand extends YadeCommand {
  ///
  ProjectCreateCommand({
    super.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOption(
      'projectId',
      help: 'The id of the project',
      mandatory: true,
    );
  }

  final GeneratorBuilder _generator;

  @override
  final String description = 'Creates a project environment.';

  @override
  final String name = 'create';

  @override
  Future<int> run() async {
    final projectId = _projectId;
    // final organization = _organization;

    final outputDirectory = Directory('$userHome/projects/$projectId-yade');

    logger
      ..info('Available variables:')
      ..info('  projectId: $projectId')
      // ..info('  organization: $organization')
      ..info('');

    final generator = await _generator(projectCreateBundle);

    final vars = <String, dynamic>{
      'projectId': projectId,
      // 'organization': organization,
      'outputDirectory': outputDirectory.absolute.path,
    };

    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      fileConflictResolution: FileConflictResolution.overwrite,
      vars: vars,
      logger: logger,
    );

    logger
      ..info('Initialize project:')
      ..info('');

    createZshrcdAlias();

    final project = await getIt<ProjectService>().getProject(id: projectId);
    print('project: $project');

    logger
        .progress('The project environment for the $projectId '
            'has been successfully created\n'
            '  Path: ${outputDirectory.absolute.path}')
        .complete();

    logger
      ..info('')
      ..info('Important next steps:');

    return ExitCode.success.code;
  }

  void createZshrcdAlias() {
    final zshrcd = p.join(userHome, 'zshrc.d');

    // create a directory
    if (!exists(zshrcd)) {
      createDir(zshrcd);
    }

    '$zshrcd/yade-example-aliases.zsh'.write(
      'alias yade-init-example="cd ~/projects/example-yade && . ./console"',
    );
  }

  ///
  String get _projectId {
    final rest = results.rest;

    return rest.first;
  }

// String get _organization {
//   final organization = results['organization'] as String;

//   return organization;
// }
}
