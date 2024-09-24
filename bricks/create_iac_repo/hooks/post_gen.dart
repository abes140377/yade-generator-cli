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

  // 2-ansible/inventory/hosts_sandbox.yml
  final sandboxInventoryProgress = context.logger.progress('hosts_sandbox.yml '
      'created successfully.');
  await Future.delayed(const Duration(milliseconds: sleepDuration));

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
  await Future.delayed(const Duration(milliseconds: sleepDuration));

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
  await Future.delayed(const Duration(milliseconds: sleepDuration));

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
  await Future.delayed(const Duration(milliseconds: sleepDuration));

  final taskfile = File('$projectDirectory/Taskfile.yml');

  final taskfileContent = getTaskfileContent(
    applicationName: applicationName,
    hostname: hostname,
  );
  taskfile.writeAsStringSync(taskfileContent);

  taskfileProgress.complete();
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
    desc: "Install applicationName on the Sandbox VM"
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
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
          STAGE: 'sandbox'
      - task: ansible:playbook:site
        vars:
          STAGE: 'sandbox'

  $applicationName:uninstall:sandbox:
    desc: "Top Level Task to Uninstall $applicationName Sandbox"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: sandbox

  $applicationName:reinstall:sandbox:
    desc: "Top Level Task to Re-Install $applicationName Labor"
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
    desc: "Install $applicationName on the Labor VM"
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
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
          STAGE: 'labor'
      - task: ansible:playbook:site
        vars:
          STAGE: 'labor'

  $applicationName:uninstall:labor:
    desc: "Top Level Task to Uninstall $applicationName Sandbox"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: labor

  $applicationName:reinstall:labor:
    desc: "Top Level Task to Re-Install $applicationName Labor"
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
    desc: "Install $applicationName on the Prod VM"
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
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PROD}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'
      - task: ansible:test:connectivity
        vars:
          HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'
          STAGE: 'prod'
      - task: ansible:playbook:site
        vars:
          STAGE: 'prod'

  $applicationName:uninstall:prod:
    desc: "Top Level Task to Uninstall $applicationName Sandbox"
    cmds:
      - task: terraform:destroy
        vars:
            STAGE: prod

  $applicationName:reinstall:prod:
    desc: "Top Level Task to Re-Install $applicationName Labor"
    cmds:
      - task: $applicationName:uninstall:prod
      - task: $applicationName:install:prod
    silent: true

  $applicationName:connect:prod:
    desc: "Connect to the Labor VM via SSH"
    cmds:
      - task: ssh:connect
        vars:
          VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PROD}}'
          VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PROD}}'

""";
}

///
// String getTaskfileContent({
//   required String applicationName,
//   required String hostname,
// }) {
//   return """
// # https://taskfile.dev
//
// version: '3'
//
// dotenv: ['.env', '.env_private']
//
// vars:
//   ${applicationName.toUpperCase()}_MGM_DIR: '.'
//   ${applicationName.toUpperCase()}_MGM_TERRAFORM_DIR: './1-terraform'
//   ${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR: './2-ansible'
//
//   ${applicationName.toUpperCase()}_VM_NAME_SANDBOX: '${hostname}s'
//   ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX: '$applicationName-mgm.sbox.cas.kvnbw.net'
//   # ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX: '${hostname}s.vm.cas.kvnbw.net'
//   ${applicationName.toUpperCase()}_VM_IP_SANDBOX: ''
//   VAULT_MOUNT_PATH_SANDBOX: 'cas/vms/mgm/sbox/'
//
//   ${applicationName.toUpperCase()}_VM_NAME_LABOR: '${hostname}l'
//   ${applicationName.toUpperCase()}_VM_FQDN_LABOR: '$applicationName-mgm.labor.cas.kvnbw.net'
//   # ${applicationName.toUpperCase()}_VM_FQDN_LABOR: '${hostname}l.vm.cas.kvnbw.net'
//   ${applicationName.toUpperCase()}_VM_IP_LABOR: ''
//   VAULT_MOUNT_PATH_LABOR: 'cas/vms/mgm/labor/'
//
//   ${applicationName.toUpperCase()}_VM_NAME_PRODUCTION: '${hostname}p'
//   ${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION: '$applicationName.prod.cas.kvnbw.net'
//   # ${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION: '${hostname}p.vm.cas.kvnbw.net'
//   ${applicationName.toUpperCase()}_VM_IP_PRODUCTION: ''
//   VAULT_MOUNT_PATH_PRODUCTION: 'cas/vms/mgm/prod/'
//
//   TERRAFORM_DOCS_VERSION: 'v0.18.0'
//
// tasks:
//   default:
//     desc: "Print some usefull information"
//     cmds:
//       - echo "Hosts:"
//       - echo "  ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX      - {{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}"
//       - echo "  ${applicationName.toUpperCase()}_VM_FQDN_LABOR        - {{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}"
//       - echo "  ${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION   - {{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}"
//       - echo "Vault:"
//       - echo "  VAULT_ADDR                  - \$VAULT_ADDR"
//       - echo "  VAULT_TOKEN                 - \$VAULT_TOKEN"
//       - echo "  VAULT_SKIP_VERIFY           - \$VAULT_SKIP_VERIFY"
//       - echo "Terraform Vars:"
//       - echo "  TF_VAR_vault_provider_token - \$TF_VAR_vault_provider_token"
//       - echo ""
//     silent: true
//
//   core:setup:
//     desc: "Top Level Task to Setup Core"
//     cmds:
//       - pwd
//       - task: _python:instal:deps
//       - task: _ansible:instal:deps
//       # only used to link local collection during development
//       # - task: _ansible:link:deps
//       - touch {{.${applicationName.toUpperCase()}_MGM_DIR}}/.yade_setup_done
//     # only run if .yade_setup_done does not exist
//     status:
//       - test -f {{.${applicationName.toUpperCase()}_MGM_DIR}}/.yade_setup_done
//     silent: true
//
//   # ======================
//   # === ${applicationName.toUpperCase()} SANDBOX ===
//   # ======================
//
//   $applicationName:install:sandbox:
//     desc: "Top Level Task to Install $applicationName Sandbox"
//     deps: [core:setup]
//     cmds:
//       - task: terraform:init:sandbox
//       - task: terraform:plan:sandbox
//       - task: terraform:apply:sandbox
//       - task: vault:get:private_key:sandbox
//       # - echo "Sleeping for 60 seconds to wait for the VM to be ready"
//       # - sleep 60
//       - task: ssh:test:sandbox
//       - task: ansible:test:sandbox
//       # - task: ansible:playbook:site:sandbox
//     silent: true
//
//   $applicationName:uninstall:sandbox:
//     desc: "Top Level Task to Uninstall $applicationName Sandbox"
//     cmds:
//       - task: terraform:destroy:sandbox
//     silent: true
//
//   $applicationName:reinstall:sandbox:
//     desc: "Top Level Task to Re-Install $applicationName Sandbox"
//     cmds:
//       - task: $applicationName:uninstall:sandbox
//       - task: $applicationName:install:sandbox
//     silent: true
//
//   # ====================
//   # === ${applicationName.toUpperCase()} LABOR ===
//   # ====================
//
//   $applicationName:install:labor:
//     desc: "Top Level Task to Install $applicationName Labor"
//     deps: [core:setup]
//     cmds:
//       - task: terraform:init:labor
//       - task: terraform:plan:labor
//       - task: terraform:apply:labor
//       - task: vault:get:private_key:labor
//       # - echo "Sleeping for 60 seconds to wait for the VM to be ready"
//       # - sleep 60
//       - task: ssh:test:labor
//       - task: ansible:test:labor
//       # - task: ansible:playbook:site:labor
//     silent: true
//
//   $applicationName:uninstall:labor:
//     desc: "Top Level Task to Uninstall $applicationName Labor"
//     cmds:
//       - task: terraform:destroy:labor
//     silent: true
//
//   $applicationName:reinstall:labor:
//     desc: "Top Level Task to Re-Install $applicationName Labor"
//     cmds:
//       - task: $applicationName:uninstall:labor
//       - task: $applicationName:install:labor
//     silent: true
//
//   # =========================
//   # === ${applicationName.toUpperCase()} PRODUCTION ===
//   # =========================
//
//   $applicationName:install:production:
//     desc: "Top Level Task to Install $applicationName Production"
//     deps: [core:setup]
//     cmds:
//       - task: terraform:init:production
//       - task: terraform:plan:production
//       - task: terraform:apply:production
//       - task: vault:get:private_key:production
//       # - echo "Sleeping for 60 seconds to wait for the VM to be ready"
//       # - sleep 60
//       - task: ssh:test:production
//       - task: ansible:test:production
//       # - task: ansible:playbook:site:production
//     silent: true
//
//   $applicationName:uninstall:production:
//     desc: "Top Level Task to Uninstall $applicationName Production"
//     cmds:
//       - task: terraform:destroy:production
//     silent: true
//
//   $applicationName:reinstall:production:
//     desc: "Top Level Task to Re-Install $applicationName Production"
//     cmds:
//       - task: $applicationName:uninstall:production
//       - task: $applicationName:install:production
//     silent: true
//
//   # -------------
//   # --- VAULT ---
//   # -------------
//
//   vault:get:private_key:sandbox:
//     desc: "Read private key for the Sandbox VM from vault and store it in the playbook directory to be used by ansible"
//     cmds:
//       - task: _vault:get:private_key
//         vars: { VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}', VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}', MOUNT_PATH: '{{.VAULT_MOUNT_PATH_SANDBOX}}' }
//
//   vault:get:private_key:labor:
//     desc: "Read private key for the Labor VM from vault and store it in the playbook directory to be used by ansible"
//     cmds:
//       - task: _vault:get:private_key
//         vars: { VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}', VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}', MOUNT_PATH: '{{.VAULT_MOUNT_PATH_LABOR}}' }
//
//   vault:get:private_key:production:
//     desc: "Read private key for the Production VM from vault and store it in the playbook directory to be used by ansible"
//     cmds:
//       - task: _vault:get:private_key
//         vars: { VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PRODUCTION}}', VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}', MOUNT_PATH: '{{.VAULT_MOUNT_PATH_PRODUCTION}}' }
//
//   _vault:get:private_key:
//     desc: "Read private key for a VM from vault and store it in the playbook directory to be used by ansible"
//     vars:
//       VM_NAME: '{{default "" .VM_NAME}}'
//       VM_FQDN: '{{default "" .VM_FQDN}}'
//       MOUNT_PATH: '{{default "" .MOUNT_PATH}}'
//     cmds:
//       - mkdir -p {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh
//       # download from vault
//       - vault kv get -field=openssh_private -mount={{.MOUNT_PATH}} {{.VM_NAME}}/ssh_ansible > {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519
//       # make executable
//       - chmod 600 {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519
//       # remove from known_hosts
//       - ssh-keygen -f "{{.HOME}}/.ssh/known_hosts" -R "[{{.VM_FQDN}}]:22022"
//     requires:
//       vars: [ VM_NAME, VM_FQDN, MOUNT_PATH ]
//     silent: true
//
//   # -----------
//   # --- SSH ---
//   # -----------
//
//   # test
//   ssh:test:sandbox:
//     desc: "Test SSH Connectivity to the Sandbox VM"
//     cmds:
//       - task: _ssh:test
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_SANDBOX}}'
//     silent: true
//
//   ssh:test:labor:
//     desc: "Test SSH Connectivity to the Labor VM"
//     cmds:
//       - task: _ssh:test
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_LABOR}}'
//     silent: true
//
//   ssh:test:production:
//     desc: "Test SSH Connectivity to the Production VM"
//     cmds:
//       - task: _ssh:test
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PRODUCTION}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_PRODUCTION}}'
//     silent: true
//
//   _ssh:test:
//     desc: "Test SSH Connectivity to a VM"
//     vars:
//       VM_NAME: '{{default "" .VM_NAME}}'
//       VM_FQDN: '{{default "" .VM_FQDN}}'
//       VM_IP: '{{default "" .VM_IP}}'
//     cmds:
//       - ssh -o StrictHostKeyChecking=no -p 22022 -i {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519 ansible@{{.VM_IP}} "date"
//       # - ssh -o StrictHostKeyChecking=no -p 22022 -i {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519 ansible@{{.VM_FQDN}} "date"
//     silent: true
//
//   # connect
//   ssh:connect:sandbox:
//     desc: "Connect to the Sandbox VM via SSH"
//     cmds:
//       - task: _ssh:connect
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_SANDBOX}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_SANDBOX}}'
//     silent: true
//
//   ssh:connect:labor:
//     desc: "Connect to the Labor VM via SSH"
//     cmds:
//       - task: _ssh:connect
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_LABOR}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_LABOR}}'
//     silent: true
//
//   ssh:connect:production:
//     desc: "Connect to the Production VM via SSH"
//     cmds:
//       - task: _ssh:connect
//         vars:
//           VM_NAME: '{{.${applicationName.toUpperCase()}_VM_NAME_PRODUCTION}}'
//           VM_FQDN: '{{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}'
//           VM_IP: '{{.${applicationName.toUpperCase()}_VM_IP_PRODUCTION}}'
//     silent: true
//
//   _ssh:connect:
//     desc: "Connect to a VM via SSH"
//     vars:
//       VM_NAME: '{{default "" .VM_NAME}}'
//       VM_FQDN: '{{default "" .VM_FQDN}}'
//       VM_IP: '{{default "" .VM_IP}}'
//     cmds:
//       - ssh -o StrictHostKeyChecking=no -p 22022 -i {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519 ansible@{{.VM_IP}}
//       # - ssh -o StrictHostKeyChecking=no -p 22022 -i {{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}/ssh/{{.VM_NAME}}_ansible_ed25519 ansible@{{.VM_FQDN}}
//     silent: true
//
//   # =================
//   # === TERRAFORM ===
//   # =================
//
//   # === sandbox ===
//   terraform:init:sandbox:
//     desc: "Initialize Terraform for Sandbox"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'init -upgrade'
//           VARIABLE_STAGE: 'sandbox'
//     silent: true
//
//   terraform:plan:sandbox:
//     desc: "Plan Terraform for Sandbox"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'plan'
//           VARIABLE_STAGE: 'sandbox'
//     silent: true
//
//   terraform:apply:sandbox:
//     desc: "Apply Terraform for Sandbox"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'apply'
//           VARIABLE_STAGE: 'sandbox'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//     silent: true
//
//   terraform:output:sandbox:
//     desc: "Output Terraform for Sandbox"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'output'
//           VARIABLE_STAGE: 'sandbox'
//     silent: true
//
//   terraform:destroy:sandbox:
//     desc: "Destroy Terraform for Sandbox"
//     dir: '{{.GITLAB_MGM_TERRAFORM_DIR}}'
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'destroy'
//           VARIABLE_STAGE: 'sandbox'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//
//   terraform:generate:docs:sandbox:
//     desc: "Generate Terraform Sandbox Documentation"
//     cmds:
//       - task: _terraform:generate:docs
//         vars:
//           STAGE: 'sandbox'
//
//   # === labor ===
//   terraform:init:labor:
//     desc: "Initialize Terraform for Labor"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'init -upgrade'
//           VARIABLE_STAGE: 'labor'
//     silent: true
//
//   terraform:plan:labor:
//     desc: "Plan Terraform for Labor"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'plan'
//           VARIABLE_STAGE: 'labor'
//     silent: true
//
//   terraform:apply:labor:
//     desc: "Apply Terraform for Labor"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'apply'
//           VARIABLE_STAGE: 'labor'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//     silent: true
//
//   terraform:output:labor:
//     desc: "Output Terraform for Labor"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'output'
//           VARIABLE_STAGE: 'labor'
//     silent: true
//
//   terraform:destroy:labor:
//     desc: "Destroy Terraform for Labor"
//     dir: '{{.GITLAB_MGM_TERRAFORM_DIR}}'
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'destroy'
//           VARIABLE_STAGE: 'staging'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//
//   terraform:generate:docs:labor:
//     desc: "Generate Terraform Labor Documentation "
//     cmds:
//       - task: _terraform:generate:docs
//         vars:
//           STAGE: 'labor'
//
//   # === production ===
//   terraform:init:production:
//     desc: "Initialize Terraform for Production"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'init -upgrade'
//           VARIABLE_STAGE: 'production'
//     silent: true
//
//   terraform:plan:production:
//     desc: "Plan Terraform for Production"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'plan'
//           VARIABLE_STAGE: 'production'
//     silent: true
//
//   terraform:apply:production:
//     desc: "Apply Terraform for Production"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'apply'
//           VARIABLE_STAGE: 'production'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//     silent: true
//
//   terraform:output:production:
//     desc: "Output Terraform for Production"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'output'
//           VARIABLE_STAGE: 'production'
//     silent: true
//
//   terraform:destroy:production:
//     desc: "Destroy Terraform for Production"
//     cmds:
//       - task: _terraform:exec
//         vars:
//           VARIABLE_COMMAND: 'destroy'
//           VARIABLE_STAGE: 'production'
//           VARIABLE_AUTOAPPROVE: '-auto-approve'
//     silent: true
//
//   terraform:generate:docs:production:
//     desc: "Generate Terraform Production Documentation"
//     cmds:
//       - task: _terraform:generate:docs
//         vars:
//           STAGE: 'production'
//
//   # === ANSIBLE ===
//
//   # test
//   ansible:test:sandbox:
//     desc: "Test Ansible Connectivity to the Sandbox VM"
//     cmds:
//       - task: _ansible:test:connectivity
//         vars:
//           VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_IP_SANDBOX}}'
//           # VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}'
//           VARIABLE_STAGE: 'sandbox'
//     silent: true
//
//   ansible:test:labor:
//     desc: "Test Ansible Connectivity to the Labor VM"
//     cmds:
//       - task: _ansible:test:connectivity
//         vars:
//           VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_IP_LABOR}}'
//           # VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}'
//           VARIABLE_STAGE: 'labor'
//     silent: true
//
//   ansible:test:production:
//     desc: "Test Ansible Connectivity to the Production VM"
//     cmds:
//       - task: _ansible:test:connectivity
//         vars:
//           VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_IP_PRODUCTION}}'
//           # VARIABLE_HOST: '{{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}'
//           VARIABLE_STAGE: 'production'
//     silent: true
//
//   _ansible:test:connectivity:
//     internal: true
//     dir: '{{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}'
//     cmds:
//       - ansible -i inventory/hosts_{{.VARIABLE_STAGE}}.yml -m ping all --extra-vars "variable_host={{.VARIABLE_HOST}}"
//       # - ansible -i inventory/hosts_{{.VARIABLE_STAGE}}.yml -m ping all
//     silent: true
//
//   # execute playbook
//   ansible:playbook:site:sandbox:
//     desc: "Run Ansible Playbook for Sandbox"
//     cmds:
//       - task: _ansible:playbook:site
//         vars:
//           VARIABLE_STAGE: 'sandbox'
//     silent: true
//
//   ansible:playbook:site:labor:
//     desc: "Run Ansible Playbook for Labor"
//     cmds:
//       - task: _ansible:playbook:site
//         vars:
//           VARIABLE_STAGE: 'labor'
//     silent: true
//
//   ansible:playbook:site:production:
//     desc: "Run Ansible Playbook for Production"
//     cmds:
//       - task: _ansible:playbook:site
//         vars:
//           VARIABLE_STAGE: 'production'
//     silent: true
//
//   _ansible:playbook:site:
//     internal: true
//     dir: '{{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}'
//     cmds:
//       - ansible-playbook site.yml
//       # - ansible-playbook -i inventories/{{.VARIABLE_STAGE}} site.yml
//     silent: true
//
//   # others
//   ansible:generate:docs:
//     desc: "Generate documentation for Ansible"
//     dir: '{{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}'
//     cmds:
//       - ansible-doctor -n -c .ansibledoctor.yml
//     silent: true
//
//   # === INTERNAL ===
//   _python:instal:deps:
//     internal: true
//     desc: "Install Python Dependencies from requirements.txt"
//     dir: '{{.${applicationName.toUpperCase()}_MGM_DIR}}'
//     cmds:
//       - pip install -r requirements.txt
//     silent: true
//
//   _ansible:instal:deps:
//     internal: true
//     desc: "Install Ansible Dependencies from requirements.yml"
//     dir: '{{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}'
//     cmds:
//       - ansible-galaxy install -r requirements.yml --force
//     silent: true
//
//   _terraform:exec:
//     internal: true
//     dir: '{{.${applicationName.toUpperCase()}_MGM_TERRAFORM_DIR}}/environments/{{.VARIABLE_STAGE}}'
//     cmds:
//       - terraform {{.VARIABLE_COMMAND}} {{.VARIABLE_AUTOAPPROVE}}
//     silent: true
// """;
// }
