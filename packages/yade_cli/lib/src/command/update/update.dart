import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mason/mason.dart' hide packageVersion;
import 'package:yade_cli/src/command.dart';
import 'package:yade_cli/src/version.dart';

/// {@template update_command}
/// `yade update` command which updates the yade_cli.
/// {@endtemplate}
class UpdateCommand extends YadeCommand {
  /// {@macro update_command}
  UpdateCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addFlag(
      'verify-only',
      help: 'Check if an update is available, without committing to update.',
      negatable: false,
    );
  }

  final Logger _logger;

  @override
  String get description => 'Update the YADE CLI.';

  @override
  String get name => 'update';

  @override
  final String invocation = 'yade update';

  @override
  Future<int> run() async {
    final verifyOnly = results['verify-only'] as bool;

    final updateCheckProgress = _logger.progress('Checking for updates');

    var latestVersion = '0.0.0';
    try {
      final uri = Uri.parse(
        'https://api.github.com/repos/abes140377/yade-generator-cli/releases/latest',
      );
      final response = await http.get(uri);
      final responseJson = json.decode(response.body) as Map<String, dynamic>;

      latestVersion = responseJson['tag_name'] as String;
    } catch (error) {
      updateCheckProgress.fail();
      _logger.err('$error');

      return ExitCode.software.code;
    }

    updateCheckProgress.complete('Checked for updates');

    final isUpToDate = packageVersion == latestVersion;
    if (isUpToDate) {
      _logger
        ..info('')
        ..info(
          '${green.wrap('The yade CLI is already at the latest version!')}',
        );

      return ExitCode.success.code;
    } else if (verifyOnly) {
      _logger
        ..info('A new version of the yade CLI is available.\n')
        ..info(styleBold.wrap('The latest version: $latestVersion'))
        ..info('Your current version: $packageVersion\n')
        ..info('To update now, you can re-run the installer with the following '
            'command:\n')
        ..info('${lightYellow.wrap('Update available!')} '
            '${lightCyan.wrap(packageVersion)} '
            '\u2192 ${lightCyan.wrap(latestVersion)}')
        ..info(
          '  curl -sS https://raw.githubusercontent.com/abes140377/yade-generator-cli/refs/heads/main/scripts/install.sh | sudo bash',
        );

      return ExitCode.success.code;
    }

    return ExitCode.success.code;
  }
}
