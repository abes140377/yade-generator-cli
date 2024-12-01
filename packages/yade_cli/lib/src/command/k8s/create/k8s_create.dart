import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/command/commands.dart';
import 'package:yade_cli/src/command/k8s/create/templates/k8s_create_bundle.dart';
import 'package:yade_cli/src/utils/args_util.dart';
import 'package:yade_cli/src/utils/log_util.dart';
import 'package:yade_cli/src/utils/path_util.dart';

class K8sCreateCommand extends YadeCommand {
  K8sCreateCommand({
    super.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addOption(
        'project_id',
        help: 'The id of the project this repository belongs to',
        mandatory: true,
      )
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
      );
  }

  final GeneratorBuilder _generator;

  @override
  final String description = 'Creates a Cluster repository.';

  @override
  final String name = 'create';

  @override
  Future<int> run() async {
    final projectId = getProjectIdArg(results);
    final applicationName = getApplicationNameArg(results);
    final organization = getOrganizationArg(results);
    final environment = getEnvironmentArg(results);
    const stages = 'sbox,labor,prod';
    final hostname = getHostnameArg(results);
    final ansibleCollections = getAnsibleCollectionsArg(results);
    final ansibleRoles = getAnsibleRoles(results);

    final collectionsGitignore = getCollectionsGitignore(ansibleCollections);

    final outputDirectory = join(
      userHome,
      'projects',
      '$projectId-yade',
      'src',
      '$applicationName-k8s-$environment',
    );

    final vars = <String, dynamic>{
      'projectId': projectId,
      'applicationName': applicationName,
      'organization': organization,
      'environment': environment,
      'stages': stages,
      'hostname': hostname,
      'ansibleCollections': ansibleCollections,
      'ansibleRoles': ansibleRoles,
      'collectionsGitignore': collectionsGitignore,
      'outputDirectory': outputDirectory,
    };

    logVars(logger: logger, vars: vars);

    final generator = await _generator(k8sCreateBundle);

    await generator.generate(
      DirectoryGeneratorTarget(Directory(outputDirectory)),
      vars: vars,
      logger: logger,
    );

    // logger
    //   ..info('')
    //   ..info('Initialize repository:');

    // await installAnsibleDependencies(
    //   logger: logger,
    //   outputDirectory: outputDirectory.absolute.path,
    // );
    //
    // await makeDoctorShExecutable(
    //   logger: logger,
    //   outputDirectory: outputDirectory.absolute.path,
    // );
    //
    // await initializeGitRepository(
    //   logger: logger,
    //   outputDirectory: outputDirectory.absolute.path,
    // );
    //
    // printUserInfo(
    //   logger: logger,
    //   type: 'K8s Cluster',
    //   applicationName: applicationName,
    //   outputDirectory: outputDirectory.absolute.path,
    // );

    return ExitCode.success.code;
  }
}
