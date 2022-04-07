output "ip_control_planes" {
  value = zipmap(
    libvirt_domain.control_plane.*.network_interface.0.hostname,
    libvirt_domain.control_plane.*.network_interface.0.addresses,
  )
}

output "ip_workers" {
  value = zipmap(
    libvirt_domain.worker.*.network_interface.0.hostname,
    libvirt_domain.worker.*.network_interface.0.addresses,
  )
}

resource "local_file" "hosts" {
  filename = "/tmp/terraform-hosts"
  content  = <<-EOT
# Managed by Terraform
%{ for id in libvirt_domain.control_plane ~}
${id.network_interface.0.addresses.0} ${id.network_interface.0.hostname}
%{ endfor ~}
%{ for id in libvirt_domain.worker ~}
${id.network_interface.0.addresses.0} ${id.network_interface.0.hostname}
%{ endfor ~}
EOT
}

resource "null_resource" "hosts" {
  depends_on = [local_file.hosts]
  provisioner "local-exec" {
    command = "bash generate-hosts.sh"
  }
}
