import 'package:mason/mason.dart';

void printUserInfo({
  required Logger logger,
  required String type,
  required String applicationName,
  required String outputDirectory,
}) {
  logger.info('');
  logger
      .progress('The $type repository for application $applicationName '
          'has been created successfully\n'
          '  Path: $outputDirectory')
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
      '  4. Run the following command to activate the pyenv environment:',
    )
    ..info('     source .venv/bin/activate')
    ..info('')
    ..info("Note: The '.env.private' file should contain sensitive information "
        'such as credentials and should NOT be committed to version control')
    ..info('')
    ..info("🚀 You are ready to spin up your vm's.")
    ..info('')
    ..info('Tip: You can run the follwing command to start the sbox vm:')
    ..info('  task $applicationName:install:sbox');
}

void logVars({
  required Logger logger,
  required Map<String, dynamic> vars,
}) {
  logger.info('Available variables:');
  vars.forEach((key, value) {
    logger.info('  $key: $value');
  });
  logger.info('');
}
