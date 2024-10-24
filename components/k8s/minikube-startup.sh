#!/bin/bash
# @file minikube-startup.sh
# @brief Start minikube and enable addons.
# @description
#   This script starts minikube and enables the addons metrics-server, dashboard and ingress. The
#   script starts minikube differently depending on whether it is running in a Vagrantbox or not.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo "[INFO] ========================================================"
echo "[INFO] Running as user $USER"
hostnamectl
echo "[INFO] ========================================================"
echo "[INFO] Documentation"
echo "[INFO]   https://sommerfeld-io.github.io/vm-ubuntu"
echo "[INFO] ========================================================"

IS_VAGRANT=false
if [ "$USER" = "vagrant" ]; then
  IS_VAGRANT=true
fi
readonly IS_VAGRANT


echo "[INFO] Start minikube"
if [ "$IS_VAGRANT" = true ]; then
  echo "[INFO] with additional configuration for Vagrantbox"
  minikube start --extra-config=apiserver.service-node-port-range=7000-7080 --extra-config=apiserver.bind-address=0.0.0.0
else
  minikube start
fi

echo "[INFO] Enable addons"
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable ingress
