// ignore_for_file: avoid_print

import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/commands/commands.dart';
import 'package:yade_cli/src/commands/create_single_vms/templates/create_single_vms_bundle.dart';

/// {@template create_command}
/// `yade create` command which creates a new application.`.
/// {@endtemplate}
class CreateSingleVmsCommand extends YadeCommand {
  /// {@macro create_command}
  CreateSingleVmsCommand({
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
            'community.docker:3.12.1,community.general:9.4.0',
        mandatory: true,
      )
      ..addOption(
        'ansible_roles',
        help: 'The ansible roles to use. E.g.: '
            'community.docker:3.12.1,community.general:9.4.0',
        // mandatory: false,
      );
  }

  final GeneratorBuilder _generator;

  @override
  final String description = 'Creates a new Single VM repository.';

  @override
  final String name = 'create-single';

  @override
  Future<int> run() async {
    final applicationName = _applicationName;
    final organization = _organization;
    final environment = _environment;
    const stages = 'sbox,labor,prod';
    final hostname = _hostname;
    final ansibleCollections = _ansibleCollections;
    final ansibleRoles = _ansibleRoles;

    // create gitignore wildcard entries for 3rd party collections
    var collectionsGitignore = <String>[];
    for (final collection in ansibleCollections) {
      final collectionName = collection['name']!;
      final entry =
          '${collectionName.substring(0, collectionName.lastIndexOf('.'))}*';

      collectionsGitignore.add(entry);
    }

    collectionsGitignore = collectionsGitignore.toSet().toList();

    final outputDirectory =
        Directory('$organization-$applicationName-$environment');

    // logger
    //   ..info('Available variables:')
    //   ..info('  applicationName: $applicationName')
    //   ..info('  organization: $organization')
    //   ..info('  environment: $environment')
    //   ..info('  stages: $stages')
    //   ..info('  hostname: $hostname')
    //   ..info('  ansibleCollections: $ansibleCollections')
    //   ..info('  ansibleRoles: $ansibleRoles')
    //   ..info('  collectionsGitignore: $collectionsGitignore')
    //   ..info('  outputDirectory: ${outputDirectory.path}')
    //   ..info('');

    final generator = await _generator(createSingleVmsBundle);

    final vars = <String, dynamic>{
      'applicationName': applicationName,
      'organization': organization,
      'environment': environment,
      'stages': stages,
      'hostname': hostname,
      'ansibleCollections': ansibleCollections,
      'collectionsGitignore': collectionsGitignore,
      'ansibleRoles': ansibleRoles,
      'outputDirectory': outputDirectory.absolute.path,
    };

    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
      logger: logger,
    );

    logger.info('');
    logger.info('Initialize project:');

    // Install ansible dependencies
    final progress = logger.progress('Installing ansible dependencies');
    await Process.run(
      'task',
      ['install:deps'],
      runInShell: true,
      workingDirectory: outputDirectory.absolute.path,
    );
    progress.complete();

    // make doctor.sh executable
    final chmodProgress = logger.progress('Make ./doctor.sh executable');
    await Process.run(
      'chmod',
      ['+x', 'doctor.sh'],
      runInShell: true,
      workingDirectory: outputDirectory.absolute.path,
    );
    chmodProgress.complete();

    // Initialize git repository
    final gitProgress = logger.progress('Initializing git repository');
    await Process.run(
      'git',
      ['init'],
      runInShell: true,
      workingDirectory: outputDirectory.absolute.path,
    );
    gitProgress.complete();

    // Print user info
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
        "  1. Open the '.env.private.example' file in the project directory.",
      )
      ..info('  2. Adjust the values in the file to match your environment.')
      ..info("  3. Save the file as '.env.private'.")
      ..info(
          '  4. Run the following command to activate the pyenv environment:')
      ..info('     source .venv/bin/activate')
      ..info('')
      ..info(
          "Note: The '.env.private' file should contain sensitive information "
          'such as credentials and should NOT be committed to version control')
      ..info('')
      ..info('⚠ To use the')
      ..info('')
      ..info("🚀 You are ready to spin up your vm's.")
      ..info('')
      ..info('Tip: You can run the follwing command to start the sbox vm:')
      ..info('  task $applicationName:install:sbox');

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

  List<Map<String, String>> get _ansibleRoles {
    final ansibleRolesStr = results['ansible_roles'] as String?;

    // Split the string by comma and then by colon and create a List of Map
    final ansibleRoles = ansibleRolesStr != null
        ? ansibleRolesStr
            .split(',')
            .map((e) => e.split(':'))
            .map(
              (e) => {
                'name': e[0],
                'version': e[1],
              },
            )
            .toList()
        : <Map<String, String>>[];

    return ansibleRoles;
  }
}
