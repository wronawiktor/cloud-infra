#! /bin/bash

if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi

# Chceck is there any new packages
sudo apt update && apt upgrade --yes
echo "Upgrade complete"

# Install required packages
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager git-core libguestfs-tools jq
echo "Install complete"

# Add your user to the libvirt and kvm group
sudo usermod -a -G kvm $(whoami)
sudo usermod -a -G libvirt $(whoami)
echo "Added your user to the libvirt and kvm group"

# Check user permissions

# Set security_driver = "none"
COMMAND="$(sudo grep "security_driver = \"none\"" /etc/libvirt/qemu.conf)"
COMMAND=${COMMAND// /}
if [[ "$COMMAND" != 'security_driver="none"' ]] ; then
    sudo sed -i -e 's/#security_driver = "selinux"/security_driver = "none"/g' /etc/libvirt/qemu.conf
    echo "security_driver set to none"
else
    echo "security_driver is already set to none"
fi

# Start libvirtd
sudo systemctl start libvirtd
# sudo systemctl status libvirtd
if [ pidof libvirtd != "" ]; then
    echo "Libvirt is running"
else
    echo "Libvirt error"
    exit 1
fi

# Download Linux cloud image
IMG_PATH ="/var/lib/libvirt/images/bionic-server-cloudimg-amd64.img"
sudo  curl -L https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img --output $IMG_PATH
if [ -f "$IMG_PATH" ]; then
    echo "System image was downloaded"
else
    echo "System image download error"
    exit 1
fi

# Install Terraform
sudo -i
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
if ! command -v terraform &> /dev/null; then
    echo "Terraform installation error"
    exit 1
else
    echo "Terraform installation complete" 
fi

# Clone cloud-infra
git clone https://github.com/go4clouds/cloud-infra

# Copy settings file for Terraform
TF_SET_FILE="~/git/cloud-infra/libvirt/terraform.tfvars"
if [ -f $TF_SET_FILE ]; then
    echo "Terraform settings file already exist"
else
    cp ~/git/cloud-infra/libvirt/terraform.tfvars.examples $TF_SET_FILE
    if [ -f $TF_SET_FILE ]; then
        echo "Terraform settings file copied"
    else 
        echo "Terraform settings file copy error"
        exit 1
    fi
fi

# Copy your ssh-key
if [ -f "~/.ssh/id_rsa.pub" ]; then
    KEY = cat ~/.ssh/id_rsa.pub
    TEMPLATE=authorized_keys = [
        ""
    ]
    TEMPLATE_K = authorized_keys = [
        "${KEY}"
    ]
    sudo sed -i -e 's/${TEMPLATE}/${TEMPLATE_K}/g' $TF_SET_FILE
    echo "Added your ssh key to terraform settings"
else
    echo "No public ssh key to copy, you can generate it by 'ssh-keygen' "
fi

# Start Terraform
terraform init
terraform plan
terraform apply --auto-approve

exit 0
