import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:yade_cli/src/command/commands.dart';
import 'package:yade_cli/src/command/grp/grp_command.dart';
import 'package:yade_cli/src/command/k8s/k8s_command.dart';
import 'package:yade_cli/src/command/project/project_command.dart';
import 'package:yade_cli/src/injection/injection.dart';
import 'package:yade_cli/src/version.dart';

/// Typedef for [io.exit].
typedef Exit = dynamic Function(int exitCode);

/// The package name.
const packageName = 'yade_cli';

/// The executable name.
const executableName = 'yade';

/// The executable description.
const executableDescription =
    'The YADE - Yet Another Development Environment CLI.';

class YadeCommandRunner extends CompletionCommandRunner<int> {
  YadeCommandRunner({
    Logger? logger,
    io.Stdin? stdin,
  })  : _logger = logger ?? Logger(),
        stdin = stdin ?? io.stdin,
        super(executableName, executableDescription) {
    //
    // Initialize the injection
    initInjection(logger);

    argParser.addFlags();

    addCommand(ProjectCommand(logger: _logger));
    addCommand(K8sCommand(logger: _logger));
    addCommand(GrpCommand(logger: _logger));
    addCommand(UpdateCommand(logger: _logger));
  }

  final Logger _logger;

  /// The [io.Stdin] instance to be used by the commands.
  final io.Stdin stdin;

  @override
  Future<int> run(Iterable<String> args) async {
    late final ArgResults argResults;

    try {
      argResults = parse(args);
    } on UsageException catch (error) {
      _logger.err('$error');
      return ExitCode.usage.code;
    }

    late final int exitCode;
    try {
      _logger.info(_getAsciiArtContent());
      exitCode = await runCommand(argResults) ?? ExitCode.success.code;
      _logger.info('');
    } catch (error) {
      _logger.err('$error');
      exitCode = ExitCode.software.code;
    }

    return exitCode;
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }
    if (topLevelResults['version'] == true) {
      _logger.info(packageVersion);
      return ExitCode.success.code;
    }
    if (topLevelResults['verbose'] == true) {
      _logger.level = Level.verbose;
    }

    _logger.detail('[meta] $packageName $packageVersion');
    return super.runCommand(topLevelResults);
  }
}

///
String _getAsciiArtContent() {
  return r'''
__  _____    ____  ______   ________    ____
\ \/ /   |  / __ \/ ____/  / ____/ /   /  _/
 \  / /| | / / / / __/    / /   / /    / /  
 / / ___ |/ /_/ / /___   / /___/ /____/ /   
/_/_/  |_/_____/_____/   \____/_____/___/   
Yet Another Development Environment CLI
  ''';
}

extension on ArgParser {
  void addFlags() {
    addFlag(
      'version',
      negatable: false,
      help: 'Print the current version.',
    );
    addFlag(
      'verbose',
      negatable: false,
      help: 'Output additional logs.',
    );
  }
}
