import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/command/commands.dart';
import 'package:yade_cli/src/command/project/create/templates/project_create_bundle.dart';
import 'package:yade_cli/src/utils/args_util.dart';
import 'package:yade_cli/src/utils/file_util.dart';
import 'package:yade_cli/src/utils/path_util.dart';

class ProjectCreateCommand extends YadeCommand {
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
    final projectId = getProjectIdArg(results);

    final outputDirectory = join(userHome, 'projects', '$projectId-yade');

    logger
      ..info('Available variables:')
      ..info('  projectId: $projectId')
      ..info('');

    final generator = await _generator(projectCreateBundle);

    final vars = <String, dynamic>{
      'projectId': projectId,
      'outputDirectory': outputDirectory,
    };

    await generator.generate(
      DirectoryGeneratorTarget(Directory(outputDirectory)),
      fileConflictResolution: FileConflictResolution.overwrite,
      vars: vars,
      logger: logger,
    );

    logger
      ..info('Initialize project:')
      ..info('');

    createZshrcdAlias(projectId);

    logger
        .progress('The project environment for the $projectId '
            'has been successfully created\n'
            '  Path: $outputDirectory')
        .complete();

    logger
      ..info('')
      ..info('Important next steps:');

    return ExitCode.success.code;
  }
}
