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
            'adfinis.gitlab:1.0.1,community.general',
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
    final environment = _environment;
    const stages = 'sandbox,labor,production';
    final hostname = _hostname;
    final ansibleCollections = _ansibleCollections;

    final outputDirectory = Directory('$applicationName-$environment');

    // print('applicationName: $applicationName');
    // print('environment: $environment');
    // print('outputDirectory: ${outputDirectory.path}');
    // print('hostname: $hostname');
    // print('ansibleCollections: $ansibleCollections');

    final generator = await _generator(createIacRepoBundle);

    final generateProgress =
        logger.progress('IAC Repository for application $applicationName '
            'created successfully.');

    final vars = <String, dynamic>{
      'applicationName': applicationName,
      'environment': environment,
      'stages': stages,
      'hostname': hostname,
      'ansibleCollections': ansibleCollections,
      'output_directory': outputDirectory.absolute.path,
      'has_parameters': true,
    };

    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
    );
    generateProgress.complete();

    // final postGenProgress = logger.progress('Executing Post Generation Steps');

    await generator.hooks.postGen(vars: vars, workingDirectory: cwd.path);

    // postGenProgress.complete();

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
