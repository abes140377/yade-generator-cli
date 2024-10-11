# ======================================
# === REQUIRED VARIABLES FOR SANDBOX ===
# ======================================

location = "Karlsruhe"
stage = "sbox"
function = "mgm"

vms = [
    {
        num_cpus = 4
        memory = 8196
        system_disk_size = 80
        additional_disks = []
        additional_domains = []
    }
]
