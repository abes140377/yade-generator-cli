# yade-project-generator-cli

# Create ansible playbook with Ansible Development Environment (ADE)

usage: ansible-creator init playbook [-h] [--na] [--lf LOG_FILE] [--ll {notset,debug,info,warning,error,critical}] [--la {true,false}] [--json] [-v] [-f] collection-name [path]

Positional arguments:
 collection-name             The name for the playbook adjacent collection in the format '<namespace>.<name>'.
 path                        The destination directory for the playbook project. The default is the current working directory. (default: ./)

Options:
 --json                      Output messages as JSON (default: False)
 --la   --log-append <bool>  Append to log file. (choices: true, false) (default: true)
 --lf   --log-file <file>    Log file to write to. (default: /home/itag001202/tmp/ansible-creator.log)
 --ll   --log-level <level>  Log level for file output. (choices: notset, debug, info, warning, error, critical) (default: notset)
 --na   --no-ansi            Disable the use of ANSI codes for terminal color. (default: False)
 -f     --force              Force re-initialize the specified directory. (default: False)
 -h     --help               Show this help message and exit
 -v     --verbosity          Give more Cli output. Option is additive, and can be used up to 3 times. (default: 0)

    rm -rf /home/itag001202/projects/cas-yade/src/cas-example-mgm
    ansible-creator init playbook cas.example /home/itag001202/projects/cas-yade/src/cas-example-mgm \
        --no-ansi --force -vv --lf=/tmp/ansible-create-cas-example-mgm.log --ll=debug --la=false
