// ignore_for_file: avoid_print

import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/commands/commands.dart';
import 'package:yade_cli/src/commands/create/templates/create_iac_repo_bundle.dart';

/// {@template create_command}
/// `yade create` command which creates a new application.`.
/// {@endtemplate}
class CreateCommand extends YadeCommand {
  /// {@macro create_command}
  CreateCommand({
    super.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addOption(
        'organization',
        help: 'The name of the organization',
        mandatory: true,
      )
      ..addOption(
        'environment',
        help: 'The name of the environment',
        mandatory: true,
      )
      ..addOption(
        'hostname',
        help: 'The hostname',
        mandatory: true,
      )
      ..addOption(
        'ansible_collections',
        help: 'The ansible collections to use. E.g.: '
            'adfinis.gitlab:1.0.1,community.general:9.4.0',
        mandatory: true,
      );
  }

  final GeneratorBuilder _generator;

  @override
  final String description = 'Creates a new Infrastructure As Code repository.';

  @override
  final String name = 'create';

  @override
  Future<int> run() async {
    final applicationName = _applicationName;
    final organization = _organization;
    final environment = _environment;
    const stages = 'sandbox,labor,production';
    final hostname = _hostname;
    final ansibleCollections = _ansibleCollections;

    final outputDirectory =
        Directory('$organization-$applicationName-$environment');

    // logger
    //   ..info('Available variables:')
    //   ..info('  applicationName: $applicationName')
    //   ..info('  organization: $organization')
    //   ..info('  environment: $environment')
    //   ..info('  stages: $stages')
    //   ..info('  hostname: $hostname')
    //   ..info('  outputDirectory: ${outputDirectory.path}')
    //   ..info('  ansibleCollections: $ansibleCollections')
    //   ..info('');

    final generator = await _generator(createIacRepoBundle);

    final vars = <String, dynamic>{
      'applicationName': applicationName,
      'organization': organization,
      'environment': environment,
      'stages': stages,
      'hostname': hostname,
      'ansibleCollections': ansibleCollections,
      'outputDirectory': outputDirectory.absolute.path,
    };

    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
      logger: logger,
    );

    await generator.hooks.postGen(vars: vars, workingDirectory: cwd.path);

    logger.info('');
    logger
        .progress('The IAC Repository for application $applicationName '
            'has been successfully created\n'
            '  Path: ${outputDirectory.absolute.path}')
        .complete();

    logger
      ..info('')
      ..info('Important next steps:')
      ..info(
          "  1. Open the '.env.private.example' file in the project directory.")
      ..info('  2. Adjust the values in the file to match your environment.')
      ..info("  3. Save the file as '.env.private'.")
      ..info('')
      ..info(
          "Note: The '.env.private' file should contain sensitive information "
          'such as credentials and should NOT be committed to version control')
      ..info('')
      ..info('🚀 You are ready to spin up your first vm.')
      ..info('')
      ..info('Tip: You can run the follwing command to start the sandbox vm:')
      ..info('  task example:install:sandbox');

    return ExitCode.success.code;
  }

  /// Gets the project name.
  ///
  /// Uses the current directory path name
  /// if the `--project-name` option is not explicitly specified.
  String get _applicationName {
    final rest = results.rest;

    return rest.first;
  }

  String get _organization {
    final organization = results['organization'] as String;

    return organization;
  }

  String get _environment {
    final environment = results['environment'] as String;

    return environment;
  }

  String get _hostname {
    final hostname = results['hostname'] as String;

    return hostname;
  }

  List<Map<String, String>> get _ansibleCollections {
    final ansibleCollectionsStr = results['ansible_collections'] as String;

    // Split the string by comma and then by colon and create a List of Map
    final ansibleCollections = ansibleCollectionsStr
        .split(',')
        .map((e) => e.split(':'))
        .map(
          (e) => {
            'name': e[0],
            'version': e[1],
          },
        )
        .toList();

    return ansibleCollections;
  }
}
