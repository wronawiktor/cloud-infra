#!/bin/bash

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi

if [ "$#" -eq 1 ]; then
  HELM_VER=$1
  HELM_URL=https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz
fi

if curl --output /dev/null --silent --head --fail "$HELM_URL"; then
  echo "Installing Helm $HELM_VER"
else
  HELM_VER=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name')
  HELM_URL=https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz
  echo "Installing Helm $HELM_VER (latest)"
fi

curl -sSL "$HELM_URL" | sudo tar -C /usr/local/bin --strip-components=1 -xzf - linux-amd64/helm
