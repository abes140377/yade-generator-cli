import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/commands/commands.dart';
import 'package:yade_cli/src/commands/create/templates/create_iac_repo_bundle.dart';

// A valid Dart identifier that can be used for a package, i.e. no
// capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final RegExp _identifierRegExp = RegExp('[a-z_][a-z0-9_]*');

/// {@template create_command}
/// `yade create` command which creates a new application.`.
/// {@endtemplate}
class CreateCommand extends YadeCommand {
  /// {@macro create_command}
  CreateCommand({
    super.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOption(
      'environment',
      help: 'The name of the environment',
      mandatory: true,
    );

    argParser.addOption(
      'stages',
      help: 'The stages',
      mandatory: true,
    );
  }

  final GeneratorBuilder _generator;

  @override
  final String description =
      'Creates a new YADE Infrastructure As Code repository.';

  @override
  final String name = 'create';

  @override
  Future<int> run() async {
    final applicationName = _applicationName;
    final environment = _environment;
    final stages = _stages;

    final outputDirectory = Directory('$applicationName-$environment');

    print('applicationName: $applicationName');
    print('environment: $environment');
    print('outputDirectory: ${outputDirectory.path}');

    final generator = await _generator(createIacRepoBundle);
    final generateProgress = logger
        .progress('Creating IAC Repository for application $applicationName');

    final vars = <String, dynamic>{
      'name': applicationName,
      'environment': environment,
      'stages': stages,
      'output_directory': outputDirectory.absolute.path,
      'has_parameters': true,
    };

    logger.detail('[codegen] running generate...');
    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
    );
    generateProgress.complete();

    logger.detail('[codegen] complete.');

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

  List<String> get _stages {
    final stagesStr = results['stages'] as String;

    return stagesStr.split(',');
  }

  // Directory get _outputDirectory {
  //   final rest = results.rest;
  //   final environment = results['environment'] as String?;
  //
  //   return Directory('${rest.first}-$environment');
  // }
}
