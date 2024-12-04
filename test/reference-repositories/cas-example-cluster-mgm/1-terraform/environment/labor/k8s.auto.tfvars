control_plane_group = {
  count            = 3
  num_cpus         = 2
  memory           = 4096 # 1024 * 4
  system_disk_size = 64
  process          = "icas" # todo: validate, must be 4 letters: icas, wiba, ...
  location         = "Karlsruhe"
}

worker_groups = {
  icas = {
    count            = 2
    memory           = 8192 # 1024 * 8
    num_cpus         = 4
    system_disk_size = 128
    process          = "icas"  # todo: validate, must be 4 letters: icas, wiba, ...
    group_stage      = "labor" # todo: validate that if process == 'icas': stage == var.cluster_stage
    location         = "Karlsruhe"
  }
  hugo-labor = {
    count            = 2
    memory           = 8192 # 1024 * 8
    num_cpus         = 4
    system_disk_size = 128
    process          = "hugo" # todo: validate, must be 4 letters: icas, wiba, ...
    group_stage      = "labor"
    location         = "Karlsruhe"
  }
}
