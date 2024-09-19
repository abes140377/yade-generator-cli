import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

Future<void> run(HookContext context) async {
  final projectDirectory = path.canonicalize(
    context.vars['output_directory'] as String? ?? Directory.current.path,
  );
  final applicationName = context.vars['name'] as String;
  final hostname = context.vars['hostname'] as String;

  final taskfile = File('$projectDirectory/Taskfile.yml');
  final taskfileContent = getTaskfileContent(
    applicationName: applicationName,
    hostname: hostname,
  );

  await taskfile.writeAsString(taskfileContent);

  context.logger
    ..info('')
    ..success('HELLO WORLD!')
    ..info('');
}

///
String getTaskfileContent({
  required String applicationName,
  required String hostname,
}) {
  return """
# https://taskfile.dev

version: '3'

dotenv: ['.env', '.env_private']

vars:
  ${applicationName.toUpperCase()}_MGM_DIR: '.'
  ${applicationName.toUpperCase()}_MGM_TERRAFORM_DIR: './1-terraform'
  ${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR: './2-ansible'

  ${applicationName.toUpperCase()}_VM_NAME_SANDBOX: '${hostname}s'
  ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX: '${hostname}s.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_SANDBOX: 'cas/vms/mgm/sbox/'

  ${applicationName.toUpperCase()}_VM_NAME_LABOR: '${hostname}l'
  ${applicationName.toUpperCase()}_VM_FQDN_LABOR: '${hostname}l.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_LABOR: 'cas/vms/mgm/labor/'

  ${applicationName.toUpperCase()}_VM_NAME_PRODUCTION: '${hostname}p'
  ${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION: '${hostname}p.vm.cas.kvnbw.net'
  VAULT_MOUNT_PATH_PRODUCTION: 'cas/vms/mgm/prod/'
  
  TERRAFORM_DOCS_VERSION: 'v0.18.0'

tasks:
  default:
    desc: "Print some usefull information"
    cmds:
      - echo "Hosts:"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_SANDBOX      - {{.${applicationName.toUpperCase()}_VM_FQDN_SANDBOX}}"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_LABOR        - {{.${applicationName.toUpperCase()}_VM_FQDN_LABOR}}"
      - echo "  ${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION   - {{.${applicationName.toUpperCase()}_VM_FQDN_PRODUCTION}}"
      - echo "Vault:"
      - echo "  VAULT_ADDR                  - \$VAULT_ADDR"
      - echo "  VAULT_TOKEN                 - \$VAULT_TOKEN"
      - echo "  VAULT_SKIP_VERIFY           - \$VAULT_SKIP_VERIFY"
      - echo "Terraform Vars:"
      - echo "  TF_VAR_vault_provider_token - \$TF_VAR_vault_provider_token"
      - echo ""
    silent: true

  core:setup:
    desc: "Top Level Task to Setup Core"
    cmds:
      - pwd
      - task: _python:instal:deps
      - task: _ansible:instal:deps
      # only used to link local collection during development
      # - task: _ansible:link:deps
      - touch {{.${applicationName.toUpperCase()}_MGM_DIR}}/.yade_setup_done
    # only run if .yade_setup_done does not exist
    status:
      - test -f {{.${applicationName.toUpperCase()}_MGM_DIR}}/.yade_setup_done
    silent: true

  # === INTERNAL ===
  _python:instal:deps:
    internal: true
    desc: "Install Python Dependencies from requirements.txt"
    dir: '{{.${applicationName.toUpperCase()}_MGM_DIR}}'
    cmds:
      - pip install -r requirements.txt
    silent: true
  
  _ansible:instal:deps:
    internal: true
    desc: "Install Ansible Dependencies from requirements.yml"
    dir: '{{.${applicationName.toUpperCase()}_MGM_PLAYBOOK_DIR}}'
    cmds:
      - ansible-galaxy install -r requirements.yml --force
    silent: true
""";
}
