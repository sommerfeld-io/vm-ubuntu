#!/bin/bash
# @file argocd.sh
# @brief Bootstrap script to deploy ArgoCD and applications on minikube.
# @description
#   This script is used to deploy ArgoCD and applications on minikube. The installation of
#   minikube, helm, kubectl, etc is done by `bootstrap.sh`.
#
#   ArgoCD Autopilot is used to deploy ArgoCD itselt to the Kubernetes cluster. ArgoCD then deploys
#   the applications from the `XXXXXXXXXXXXXXXXXXXX` directory.

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace



export GIT_REPO="https://github.com/sommerfeld-io/vm-ubuntu.git/components/k8s/argocd"
readonly ARGO_PROJECT="default-project"


echo "[INFO] === Github Token ========================================"
read -spr "Enter Token: " GIT_TOKEN
export GIT_TOKEN
readonly GIT_TOKEN


echo "[INFO] === Environment ========================================"
echo "User     = $USER"
echo "Hostname = $HOSTNAME"
echo "Home dir = $HOME"
hostnamectl
echo "[INFO] === ArgoCD Autopilot version ==========================="
argocd-autopilot version
echo "Repo and path = $GIT_REPO"
echo "[INFO] ========================================================"


echo "[INFO] Bootstrap ArgoCD"
argocd-autopilot repo bootstrap

echo "[INFO] Create Project"
argocd-autopilot project create "$ARGO_PROJECT"

echo "[INFO] Create Application"
argocd-autopilot app create hello-world \
  --app github.com/argoproj-labs/argocd-autopilot/examples/demo-app \
  -p "$ARGO_PROJECT" \
  --wait-timeout 2m


echo "[INFO] === Login =============================================="
echo "Execute the port forward command, and browse to"
echo "http://localhost:8080. You can log in with user: admin, and the"
echo "password from the previous step."
echo "[INFO] ========================================================"