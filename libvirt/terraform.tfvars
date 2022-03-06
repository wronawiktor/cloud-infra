
libvirt_uri = "qemu:///system"

pool = "default"

image_name = "lockc-image"

image_path = "http://download.opensuse.org/distribution/leap/15.3/appliances/openSUSE-Leap-15.3-JeOS.x86_64-OpenStack-Cloud.qcow2"

network_name = "cloud-network"
network_cidr = "10.16.0.0/24"
network_mode = "nat"

dns_domain = "cloud.local"

locale = "en_US.UTF-8"
timezone = "Etc/UTC"

repositories = {} 
 
packages = [
  "bpftool",
  "conntrack-tools",
  "ebtables",
  "ethtool",
  "iptables",
  "jq",
  "socat",
  "strace",
  "tmux"
]

control_planes = 1
control_plane_memory = 1048
control_plane_vcpu = 1
control_plane_disk_size = "25769803776"

workers = 1
worker_memory = 1048
worker_vcpu = 1
worker_disk_size = "25769803776"

authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvhWKN/uRo0k2RP6xSOomGpS0xsjWtjrZSd8pUGJFiCUICXGcZsGHbsO45Lmuct3opMjsMfjnh3aEULWKZF1nykDhS2+FSP1cckYi34MnxN69TOtU9ko8/Mo9bCgfD80DZ0gjAdLBtuua9saFKPnKcfJrnJUHdGSt67NiNSmIk2u5aMKun7LPZwNKZOt2I+n0SEEYIbDeitP/AW1iEIlYZ2Kk+/DQfl7xrUB5sS3ree++KmnTOZXq+8K9NgHnaJodWx49TxWm+VcthAJcFNVwirhvUEbJPhJ0TpvNwFtYfzLHT375FhI1rFXQyNv2WTItv+uqL9I74UUmIDOMYDSXn mjura@buggy"
]
