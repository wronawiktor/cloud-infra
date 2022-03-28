#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi

# Chceck is there any new packages
apt update && apt upgrade --yes
echo "Upgrade complete"

# Install required packages
apt install --yes qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager git-core libguestfs-tools jq software-properties-common
echo "Install complete"

# Add your user to the libvirt and kvm group
usermod -a -G kvm $(whoami)
usermod -a -G libvirt $(whoami)
echo "Added your user to the libvirt and kvm group"

# Check user permissions

# Set security_driver = "none"
LIBVIRT_SEC_DRIVER="$(grep "security_driver = \"none\"" /etc/libvirt/qemu.conf)"
LIBVIRT_SEC_DRIVER=${LIBVIRT_SEC_DRIVER// /}
if [[ "$LIBVIRT_SEC_DRIVER" != 'security_driver="none"' ]] ; then
    sed -i -e 's/#security_driver = "selinux"/security_driver = "none"/g' /etc/libvirt/qemu.conf
    echo "security_driver set to none"
else
    echo "security_driver is already set to none"
fi

# Start libvirtd
systemctl start libvirtd
if [[ $(pidof libvirtd) ]]; then
        echo "Libvirt is running"
else
        echo "Libvirt error"
        exit 1
fi

# Download Linux cloud image
IMG_PATH="/var/lib/libvirt/images/"
if [ -d "$IMG_PATH" ]; then
	echo "Folder exist"
else
	mkdir -p "$IMG_PATH"
	echo "Folder has been created: $IMG_PATH"
	echo "Downloading..."
fi

curl -L https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img --output ${IMG_PATH+"bionic-server-cloudimg-amd64.img"}

if [ -f "${IMG_PATH+"bionic-server-cloudimg-amd64.img"}" ]; then
    echo "System image was downloaded"
else
    echo "System image download error"
    exit 1
fi

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt install terraform
if command -v terraform &> /dev/null; then
    echo "Terraform installation complete"
else
    echo "Terraform installation error"
    exit 1 
fi

# Clone cloud-infra
# git clone https://github.com/go4clouds/cloud-infra

# Copy settings file for Terraform
TF_SET_FILE="./libvirt/terraform.tfvars"
if [ -f $TF_SET_FILE ]; then
    echo "Terraform settings file already exist"
else
    cp ./libvirt/terraform.tfvars.examples $TF_SET_FILE
    if [ -f $TF_SET_FILE ]; then
        echo "Terraform settings file copied"
    else 
        echo "Terraform settings file copy error"
        exit 1
    fi
fi

# Copy your ssh-key
if [ -f "~/.ssh/id_rsa.pub" ]; then
    SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)"
#   echo "authorized_keys = [\n \\"$SSH_PUB_KEY\"]"
#   test = [\\n \"$TEST\" \\n]" >> "$TF_SET_FILE"
    sed -i -e "s|\"SSH_PUB_KEY\"|\"${SSH_PUB_KEY}\"|g" "$TF_SET_FILE"
    echo "Added your ssh key to terraform settings"
else
    echo "No public ssh key to copy, you can generate it by 'ssh-keygen' "
fi

# Start Terraform
terraform init
# terraform plan
# terraform apply --auto-approve

exit 0
