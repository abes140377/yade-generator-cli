// ignore_for_file: no_adjacent_strings_in_list

import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:yade_cli/src/command_runner.dart';
import 'package:yade_cli/src/commands/update/update.dart';
import 'package:yade_cli/src/version.dart';

import '../../../helpers/helpers.dart';

class _MockLogger extends Mock implements Logger {}

class _MockPubUpdater extends Mock implements PubUpdater {}

class _MockProgress extends Mock implements Progress {}

class _MockArgResults extends Mock implements ArgResults {}

class _MockProcessSignal extends Mock implements ProcessSignal {}

class _MockStdin extends Mock implements Stdin {}

const expectedUsage = [
  'Update the YADE CLI.\n'
      '\n'
      'Usage: yade update\n'
      '-h, --help           Print this usage information.\n'
      '    --verify-only    Check if an update is available, without '
      'committing to update.\n'
      '\n'
      'Run "yade help" to see global options.'
];

void main() {
  const latestVersion = '0.0.0';

  group('yade update', () {
    const processId = 42;
    final processResult = ProcessResult(processId, 0, '', '');

    late Logger logger;
    late PubUpdater pubUpdater;
    late UpdateCommand command;
    late ArgResults argResults;
    late YadeCommandRunner commandRunner;

    setUp(() {
      logger = _MockLogger();
      pubUpdater = _MockPubUpdater();
      argResults = _MockArgResults();

      when(() => logger.progress(any())).thenReturn(_MockProgress());
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);
      when(
        () => pubUpdater.update(
          packageName: packageName,
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).thenAnswer((_) => Future.value(processResult));

      when(() => argResults['verify-only']).thenReturn(false);

      command = UpdateCommand(logger: logger, pubUpdater: pubUpdater)
        ..testArgResults = argResults;

      final sigint = _MockProcessSignal();
      when(sigint.watch).thenAnswer((_) => const Stream.empty());

      commandRunner = YadeCommandRunner(
        logger: logger,
        pubUpdater: _MockPubUpdater(),
        exit: (_) {},
        sigint: sigint,
        stdin: _MockStdin(),
      );
    });

    test(
      'usage shows help text',
      overridePrint((printLogs) async {
        final result = await commandRunner.run(['update', '--help']);

        expect(result, equals(ExitCode.success.code));
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('handles pub latest version query errors', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenThrow(Exception('oops'));
      final result = await command.run();
      expect(result, equals(ExitCode.software.code));
      verify(() => logger.progress('Checking for updates')).called(1);
      verify(() => logger.err('Exception: oops'));
      verifyNever(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      );
    });

    group('--verify-only', () {
      test(
        'logs latest available version',
        () async {
          when(
            () => pubUpdater.getLatestVersion(any()),
          ).thenAnswer((_) async => latestVersion);
          when(() => argResults['verify-only']).thenReturn(true);

          final result = await command.run();

          expect(result, equals(ExitCode.success.code));
          verify(
            () => logger.info('A new version of $packageName is available.\n'),
          ).called(1);
          verify(
            () => logger.info(
              styleBold.wrap('The latest version: $latestVersion'),
            ),
          ).called(1);
          verify(
            () => logger.info('Your current version: $packageVersion\n'),
          ).called(1);
          verify(
            () => logger.info('To update now, run "$executableName update".'),
          ).called(1);
        },
      );

      test(
        'does not update',
        () async {
          when(
            () => pubUpdater.getLatestVersion(any()),
          ).thenAnswer((_) async => latestVersion);
          when(() => argResults['verify-only']).thenReturn(true);

          final result = await command.run();

          expect(result, equals(ExitCode.success.code));
          verifyNever(
            () => pubUpdater.update(
              packageName: any(named: 'packageName'),
              versionConstraint: any(named: 'versionConstraint'),
            ),
          );
        },
      );
    });

    test('handles pub update errors', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => latestVersion);
      when(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).thenThrow(Exception('oops'));
      final result = await command.run();
      expect(result, equals(ExitCode.software.code));
      verify(() => logger.progress('Checking for updates')).called(1);
      verify(() => logger.err('Exception: oops'));
      verify(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).called(1);
    });

    test('handles pub update process errors', () async {
      const error = 'Oh no! Installing this is not possible right now!';

      final processResult = ProcessResult(processId, 1, '', error);

      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => latestVersion);
      when(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).thenAnswer((_) => Future.value(processResult));

      final result = await command.run();
      expect(result, equals(ExitCode.software.code));
      verify(() => logger.progress('Checking for updates')).called(1);
      verify(() => logger.err('Error updating YADE CLI: $error'));
      verify(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).called(1);
    });

    test('updates when newer version exists', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => latestVersion);
      when(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      ).thenAnswer((_) => Future.value(processResult));

      when(() => logger.progress(any())).thenReturn(_MockProgress());
      final result = await command.run();
      expect(result, equals(ExitCode.success.code));
      verify(() => logger.progress('Checking for updates')).called(1);
      verify(() => logger.progress('Updating to $latestVersion')).called(1);
      verify(
        () => pubUpdater.update(
          packageName: packageName,
          versionConstraint: latestVersion,
        ),
      ).called(1);
    });

    test('does not update when already on latest version', () async {
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);
      when(() => logger.progress(any())).thenReturn(_MockProgress());
      final result = await command.run();
      expect(result, equals(ExitCode.success.code));
      verify(
        () => logger.info('$packageName is already at the latest version.'),
      ).called(1);
      verifyNever(() => logger.progress('Updating to $latestVersion'));
      verifyNever(
        () => pubUpdater.update(
          packageName: any(named: 'packageName'),
          versionConstraint: any(named: 'versionConstraint'),
        ),
      );
    });
  });
}
