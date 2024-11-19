// ignore_for_file: avoid_print

import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/commands/commands.dart';
import 'package:yade_cli/src/commands/project/create/templates/create_project_bundle.dart';

///
class ProjectCreateCommand extends YadeCommand {
  ///
  ProjectCreateCommand({
    super.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOption(
      'projectName',
      help: 'The name of the project',
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
    final projectName = _projectName;
    // final organization = _organization;

    final outputDirectory = Directory('$projectName-yade');

    logger
      ..info('Available variables:')
      ..info('  projectName: $projectName')
      // ..info('  organization: $organization')
      ..info('');

    final generator = await _generator(createProjectBundle);

    final vars = <String, dynamic>{
      'projectName': projectName,
      // 'organization': organization,
      'outputDirectory': outputDirectory.absolute.path,
    };

    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
      logger: logger,
    );

    logger
      ..info('')
      ..info('Initialize project:')

      // Print user info
      ..info('');
    logger
        .progress('The project environment for the $projectName '
            'has been successfully created\n'
            '  Path: ${outputDirectory.absolute.path}')
        .complete();

    logger
      ..info('')
      ..info('Important next steps:');

    return ExitCode.success.code;
  }

  ///
  String get _projectName {
    final rest = results.rest;

    return rest.first;
  }

  // String get _organization {
  //   final organization = results['organization'] as String;

  //   return organization;
  // }
}
