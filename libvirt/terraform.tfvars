
libvirt_uri = "qemu:///system"

pool = "default"

image_name = "cloud-image"
image_path = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"

network_name = "cloud-network"
network_cidr = "10.16.0.0/24"
network_mode = "nat"

dns_domain = "cloud.local"

locale = "en_US.UTF-8"
timezone = "Etc/UTC"

repositories = {} 
 
packages = [
  "curl",
  "jq",
  "strace"
]

username = "student"
control_planes = 1
control_plane_memory = 1048
control_plane_vcpu = 1
control_plane_disk_size = "25769803776"

workers = 1
worker_memory = 1048
worker_vcpu = 1
worker_disk_size = "25769803776"

authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDphayKQWAIZ7C+7vstprWA/MJUa0UTQtOWNKte4PT1PJcaxfMT57GqqFdGJDop6SZmRmWwGRKdpwj5AZCX+tGsbx3/o/lbmCbL+mXxX88Fc8748Lv/OxvAilPar2dNJp4JR1tDChV7JJHeDhAl/ANhXYQoEHAAnV/RZLnODM2DN2wURfFjgDj0iOyY3fZbSBaMUHFyeDwJ7Pa38HvclVpFhQN428VtuE1IxvaLClD2D2a7Hm4gKSZNqImkqWxtunE5gcq/+BFCHfkxEkOzGCRu/VMIBh85IoowuQj4WIY4dlC7LcyJNKF2NQWnPsZ0l9SxVoAVtNd/p0Qpmr/NazxLshK8CGuhlGR2pZle5tnLM2o9Cu73eMoRZBzO4EQub0sYOnpKKJqJBjaa862MluWRzmRjJMMLg21LsEFn9399nLYeKSkOKqqqPGrDlj71V4oNEdmX+wGn8G4qSFmZwbZu/6Pql66ASWd66/NRXWQnaLO/OiUqmLkV2liC+LrkJ97jF3xnxHaT9LkaQ7livB1hknUI/3w0L5S/FbUDzsQ4AMx9+SGG7tYhzqT1qTXziEvKIBxq44j/tG/i0ltGHTc3Ac0/puWdYYk6P/23k2rD2d62hdJ99CcIBhsoTB6gBQCsKu2/5LqCzSmO5db2gg6eL+86iWF65VbIiRkWmgrEaQ== root@lfs458host1"
]
