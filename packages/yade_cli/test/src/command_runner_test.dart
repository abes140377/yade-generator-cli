// ignore_for_file: no_adjacent_strings_in_list
import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:yade_cli/src/command_runner.dart';
import 'package:yade_cli/src/version.dart';

import '../helpers/helpers.dart';

class _MockLogger extends Mock implements Logger {}

class _MockPubUpdater extends Mock implements PubUpdater {}

class _MockProcessSignal extends Mock implements ProcessSignal {}

class _MockStdin extends Mock implements Stdin {}

const expectedUsage = [
  'A fast, minimalistic backend framework for Dart.\n'
      '\n'
      'Usage: yade <command> [arguments]\n'
      '\n'
      'Global options:\n'
      '-h, --help       Print this usage information.\n'
      '    --version    Print the current version.\n'
      '    --verbose    Output additional logs.\n'
      '\n'
      'Available commands:\n'
      '  create-cluster   Creates a new Cluster repository.\n'
      '  create-single    Creates a new Single VM repository.\n'
      '  update      Update the YADE CLI.\n'
      '\n'
      'Run "yade help <command>" for more information about a command.'
];

const latestVersion = '0.0.0';
final changelogLink = lightCyan.wrap(
  styleUnderlined.wrap(
    link(
      uri: Uri.parse(
        'https://github.com/verygoodopensource/yade/releases/tag/yade_cli-v$latestVersion',
      ),
    ),
  ),
);
final updateMessage = '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
${lightYellow.wrap('Changelog:')} $changelogLink
Run ${lightCyan.wrap('$executableName update')} to update''';

void main() {
  group('YadeCommandRunner', () {
    late Logger logger;
    late PubUpdater pubUpdater;
    late YadeCommandRunner commandRunner;
    late ProcessSignal sigint;

    setUp(() {
      logger = _MockLogger();
      pubUpdater = _MockPubUpdater();
      sigint = _MockProcessSignal();

      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      when(() => sigint.watch()).thenAnswer((_) => const Stream.empty());

      commandRunner = YadeCommandRunner(
        logger: logger,
        stdin: _MockStdin(),
      );
    });

    test('can be instantiated without any explicit parameters', () {
      final commandRunner = YadeCommandRunner();
      expect(commandRunner, isNotNull);
    });

    group('run', () {
      test('shows usage when invalid option is passed', () async {
        final exitCode = await commandRunner.run(['--invalid-option']);
        expect(exitCode, ExitCode.usage.code);
        verify(
          () => logger.err(
            any(
              that: predicate<String>((message) {
                final containsError = message.contains(
                  'Could not find an option named "invalid-option".',
                );
                final containsUsage = message.contains(
                  'Usage: yade <command> [arguments]',
                );
                return containsError && containsUsage;
              }),
            ),
          ),
        ).called(1);
      });

      test('checks for updates on sigint', () async {
        final exitCalls = <int>[];
        commandRunner = YadeCommandRunner(
          logger: logger,
          stdin: _MockStdin(),
        );
        when(() => sigint.watch()).thenAnswer((_) => Stream.value(sigint));
        await commandRunner.run(['--version']);
        expect(exitCalls, equals([0]));
        verify(() => pubUpdater.getLatestVersion(any())).called(2);
      });

      test('prompts for update when newer version exists', () async {
        when(
          () => pubUpdater.getLatestVersion(any()),
        ).thenAnswer((_) async => latestVersion);
        final result = await commandRunner.run(['--version']);
        expect(result, equals(ExitCode.success.code));
        verify(() => logger.info(updateMessage)).called(1);
      });

      test('handles pub update errors gracefully', () async {
        when(
          () => pubUpdater.getLatestVersion(any()),
        ).thenThrow(Exception('oops'));

        final result = await commandRunner.run(['--version']);
        expect(result, equals(ExitCode.success.code));
        verifyNever(() => logger.info(updateMessage));
      });

      test('handles Exception', () async {
        final exception = Exception('oops!');
        var isFirstInvocation = true;
        when(() => logger.info(any())).thenAnswer((_) {
          if (isFirstInvocation) {
            isFirstInvocation = false;
            throw exception;
          }
        });
        final result = await commandRunner.run(['--version']);
        expect(result, equals(ExitCode.software.code));
        verify(() => logger.err('$exception')).called(1);
      });

      test(
        'handles no command',
        overridePrint((printLogs) async {
          final result = await commandRunner.run([]);
          expect(printLogs, equals(expectedUsage));
          expect(result, equals(ExitCode.success.code));
        }),
      );

      test(
        'does not show update message when the shell calls the '
        'completion command',
        () async {
          when(
            () => pubUpdater.getLatestVersion(any()),
          ).thenAnswer((_) async => latestVersion);

          final result = await commandRunner.run(['completion']);
          expect(result, equals(ExitCode.success.code));
          verifyNever(() => logger.info(updateMessage));
        },
      );

      group('--help', () {
        test(
          'outputs usage',
          overridePrint((printLogs) async {
            final result = await commandRunner.run(['--help']);
            expect(printLogs, equals(expectedUsage));
            expect(result, equals(ExitCode.success.code));

            printLogs.clear();

            final resultAbbr = await commandRunner.run(['-h']);
            expect(printLogs, equals(expectedUsage));
            expect(resultAbbr, equals(ExitCode.success.code));
          }),
        );
      });

      group('--verbose', () {
        test(
          'sets correct log level.',
          overridePrint((printLogs) async {
            await commandRunner.run(['--verbose']);
            verify(() => logger.level = Level.verbose).called(1);
          }),
        );

        test(
          'outputs correct meta info',
          overridePrint((printLogs) async {
            await commandRunner.run(['--verbose']);
            verify(
              () => logger.detail('[meta] yade_cli $packageVersion'),
            ).called(1);
          }),
        );
      });

      group('--version', () {
        test('outputs current version', () async {
          final result = await commandRunner.run(['--version']);
          expect(result, equals(ExitCode.success.code));
          verify(() => logger.info(packageVersion)).called(1);
        });
      });
    });
  });
}
