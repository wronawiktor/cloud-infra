#!/bin/bash

ETC_HOSTS="/etc/hosts"
TF_HOSTS="/tmp/terraform-hosts"

if [ ! -f $ETC_HOSTS ]; then
  sleep 2
fi

touch $ETC_HOSTS

if $(grep -q Terraform $ETC_HOSTS); then
  sed -i '/Terraform/Q' $ETC_HOSTS
fi

cat $TF_HOSTS >> $ETC_HOSTS
