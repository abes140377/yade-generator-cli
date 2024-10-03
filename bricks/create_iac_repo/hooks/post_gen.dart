import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

const sleepDuration = 300;

Future<void> run(HookContext context) async {
  final projectDirectory = path.canonicalize(
    context.vars['outputDirectory'] as String? ?? Directory.current.path,
  );
  final applicationName = context.vars['applicationName'] as String;
  final hostname = context.vars['hostname'] as String;
  final organization = context.vars['organization'] as String;

  context.logger.info('');
  context.logger.info('Generating additional files:');

  // 2-ansible/inventory/hosts_sandbox.yml
  final sandboxInventoryProgress = context.logger.progress('hosts_sandbox.yml '
      'created successfully.');
  await Future<dynamic>.delayed(const Duration(milliseconds: sleepDuration));

  final hostsSandbox =
      File('$projectDirectory/2-ansible/inventory/hosts_sandbox.yml');

  final hostsSandboxContent = getHosts(
    applicationName: applicationName,
    organization: organization,
    hostname: hostname,
    stage: 'sandbox',
  );
  hostsSandbox.writeAsStringSync(hostsSandboxContent);

  sandboxInventoryProgress.complete();

  // 2-ansible/inventory/hosts_labor.yml
  final laborIventoryProgress = context.logger.progress('hosts_labor.yml '
      'created successfully.');
  await Future<dynamic>.delayed(const Duration(milliseconds: sleepDuration));

  final hostsLabor =
      File('$projectDirectory/2-ansible/inventory/hosts_labor.yml');
  final hostsLaborContent = getHosts(
    applicationName: applicationName,
    organization: organization,
    hostname: hostname,
    stage: 'labor',
  );
  hostsLabor.writeAsStringSync(hostsLaborContent);

  laborIventoryProgress.complete();

  // 2-ansible/inventory/hosts_prod.yml
  final prodIventoryProgress = context.logger.progress('hosts_labor.yml '
      'created successfully.');
  await Future<dynamic>.delayed(const Duration(milliseconds: sleepDuration));

  final hostsProduction =
      File('$projectDirectory/2-ansible/inventory/hosts_prod.yml');
  final hostsProductionContent = getHosts(
    applicationName: applicationName,
    organization: organization,
    hostname: hostname,
    stage: 'prod',
  );
  hostsProduction.writeAsStringSync(hostsProductionContent);

  prodIventoryProgress.complete();

  // Taskfile
  final taskfileProgress = context.logger.progress('Taskfile.yml '
      'created successfully.');
  await Future<dynamic>.delayed(const Duration(milliseconds: sleepDuration));

  final taskfile = File('$projectDirectory/Taskfile.yml');

  final taskfileContent = getTaskfileContent(
    applicationName: applicationName,
    hostname: hostname,
  );
  taskfile.writeAsStringSync(taskfileContent);

  taskfileProgress.complete();

  context.logger.info('');
  context.logger.info('Initialize project:');

  // Install ansible dependencies
  final progress = context.logger.progress('Installing ansible dependencies');
  await Process.run(
    'task',
    ['install:deps'],
    runInShell: true,
    workingDirectory: projectDirectory,
  );
  progress.complete();

  // Initialize git repository
  final gitProgress = context.logger.progress('Initializing git repository');
  await Process.run(
    'git',
    ['init'],
    runInShell: true,
    workingDirectory: projectDirectory,
  );
  await Process.run(
    'git',
    ['add', '.'],
    runInShell: true,
    workingDirectory: projectDirectory,
  );
  await Process.run(
    'git',
    ['commit', '-m', '"Initial commit"'],
    runInShell: true,
    workingDirectory: projectDirectory,
  );
  gitProgress.complete();
}

///
String getHosts({
  required String applicationName,
  required String organization,
  required String hostname,
  required String stage,
}) {
  final suffix = stage == 'sandbox'
      ? 's'
      : stage == 'labor'
          ? 'l'
          : 'p';

  return '''
---
all:
  hosts:
    $applicationName-$organization-$stage:
      ansible_host: $hostname$suffix.vm.cas.kvnbw.net
      ansible_port: 22022
      ansible_user: ansible
      ansible_ssh_private_key_file: ../ssh/$hostname${suffix}_ansible_ed25519
      ansible_python_interpreter: /usr/bin/python3
  children:
    ${applicationName}_servers:
      hosts:
        $applicationName-$organization-$stage:
''';
}

String getTaskfileContent({
  required String applicationName,
  required String hostname,
}) {
  return """
# https://taskfile.dev

version: '3'

dotenv: ['.env', '.env.private']

silent: true

vars:
  ${applicationName.toUpperCase()}_VM_NAME_SANDBOX: '${hostname}s'
  ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX: '${hostname}s.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_SANDBOX: 'cas/vms/mgm/sbox/'

  ${applicationName.toUpperCase()}_VM_NAME_LABOR: '${hostname}l'
  ${applicationName.toUpperCase()}_VM_FQDN_LABOR: '${hostname}l.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_LABOR: 'cas/vms/mgm/labor/'

  ${applicationName.toUpperCase()}_VM_NAME_PROD: '${hostname}p'
  ${applicationName.toUpperCase()}_VM_FQDN_PROD: '${hostname}p.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_PROD: 'cas/vms/mgm/prod/'

includes:
  libs:
    taskfile: .taskfile/Included.yml
    flatten: true
    internal: true

tasks:
  default:
    desc: "Print var's"
    cmds:
      - echo ""
      - echo "Environment:"
      - echo "  VAULT_ADDR - \$VAULT_ADDR"
      - echo "  VAULT_TOKEN - \$VAULT_TOKEN"
      - echo "  VAULT_SKIP_VERIFY - \$VAULT_SKIP_VERIFY"
      - echo ""
      - echo "  TF_VAR_vault_provider_token - \$TF_VAR_vault_provider_token"
      - echo ""
      - echo "Variables:"
      - echo "  ${applicationName.toUpperCase()}_VM_NAME_SANDBOX - {{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX - {{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}"
      - echo "  VAULT_MOUNT_PATH_SANDBOX - {{.VAULT_MOUNT_PATH_SANDBOX}}"
      - echo ""
      - echo "  ${applicationName.toUpperCase()}_VM_NAME_LABOR - {{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_LABOR - {{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}"
      - echo "  VAULT_MOUNT_PATH_LABOR - {{.VAULT_MOUNT_PATH_LABOR}}"
      - echo ""
      - echo "  ${applicationName.toUpperCase()}_VM_NAME_PROD - {{.${applicationName.toUpperCase()}_VM_NAME_PROD}}"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_PROD - {{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}"
      - echo "  VAULT_MOUNT_PATH_PROD - {{.VAULT_MOUNT_PATH_PROD}}"

  install:deps:
    desc: "Install python and ansible dependencies"
    cmds:
      - pip install -r requirements.txt
      - cd 2-ansible && ansible-galaxy install -r requirements.yml --force

  # ===============
  # === SANDBOX ===
  # ===============
  $applicationName:install:sandbox:
    desc: "Install $applicationName in the Sandbox Environment"
    cmds:
      - task: terraform:init
        vars:
          STAGE: sandbox
      - task: terraform:plan
        vars:
          STAGE: sandbox
      - task: terraform:apply
        vars:
          STAGE: sandbox
      - task: vault:get:private_key
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
          MOUNT_PATH: '{{.VAULT_MOUNT_PATH_SANDBOX}}'
      - task: ssh:test:connectivity
        vars:
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
          KEY: ./ssh/{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}_ansible_ed25519
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
          STAGE: 'sandbox'
      - task: ansible:playbook:site
        vars:
          STAGE: 'sandbox'

  $applicationName:uninstall:sandbox:
    desc: "Uninstall $applicationName in the Sandbox Environment"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: sandbox

  $applicationName:reinstall:sandbox:
    desc: "Re-Install $applicationName in the Sandbox Environment"
    cmds:
      - task: $applicationName:uninstall:sandbox
      - task: $applicationName:install:sandbox
    silent: true

  $applicationName:connect:sandbox:
    desc: "Connect to the Sandbox VM via SSH"
    cmds:
      - task: ssh:connect
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'

  # =============
  # === LABOR ===
  # =============
  $applicationName:install:labor:
    desc: "Install $applicationName in the Labor Environment"
    cmds:
      - task: terraform:init
        vars:
          STAGE: labor
      - task: terraform:plan
        vars:
          STAGE: labor
      - task: terraform:apply
        vars:
          STAGE: labor
      - task: vault:get:private_key
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
          MOUNT_PATH: '{{.VAULT_MOUNT_PATH_LABOR}}'
      - task: ssh:test:connectivity
        vars:
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
          KEY: ./ssh/{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}_ansible_ed25519
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
          STAGE: 'labor'
      - task: ansible:playbook:site
        vars:
          STAGE: 'labor'

  $applicationName:uninstall:labor:
    desc: "Uninstall $applicationName in the Labor Environment"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: labor

  $applicationName:reinstall:labor:
    desc: "Re-Install $applicationName in the Labor Environment"
    cmds:
      - task: $applicationName:uninstall:labor
      - task: $applicationName:install:labor
    silent: true

  $applicationName:connect:labor:
    desc: "Connect to the Labor VM via SSH"
    cmds:
      - task: ssh:connect
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'

  # ============
  # === PROD ===
  # ============
  $applicationName:install:prod:
    desc: "Install $applicationName in the Prod Environment"
    cmds:
      - task: terraform:init
        vars:
          STAGE: prod
      - task: terraform:plan
        vars:
          STAGE: prod
      - task: terraform:apply
        vars:
          STAGE: prod
      - task: vault:get:private_key
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PROD}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'
          MOUNT_PATH: '{{.VAULT_MOUNT_PATH_PROD}}'
      - task: ssh:test:connectivity
        vars:
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'
          KEY: ./ssh/{{.${applicationName.toUpperCase()}_VM_NAME_PROD}}_ansible_ed25519
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'
          STAGE: 'prod'
      - task: ansible:playbook:site
        vars:
          STAGE: 'prod'

  $applicationName:uninstall:prod:
    desc: "Uninstall $applicationName in the Prod Environment"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: prod

  $applicationName:reinstall:prod:
    desc: "Re-Install $applicationName in the Prod Environment"
    cmds:
      - task: $applicationName:uninstall:prod
      - task: $applicationName:install:prod
    silent: true

  $applicationName:connect:prod:
    desc: "Connect to the Prod VM via SSH"
    cmds:
      - task: ssh:connect
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PROD}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'

""";
}
