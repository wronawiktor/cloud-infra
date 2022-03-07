#cloud-config

hostname: ${hostname}
locale: ${locale} # en_US.UTF-8
timezone: ${timezone} # Etc/UTC

users:
  - name: student
    groups: users
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
${authorized_keys}

packages:
${packages}
