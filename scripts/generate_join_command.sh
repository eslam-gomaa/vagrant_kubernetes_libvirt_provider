#!/bin/bash

if sudo kubeadm token create --print-join-command --ttl=0| grep token > /var/share/join_command.sh; then
    echo "Join command generated successfully"
fi
