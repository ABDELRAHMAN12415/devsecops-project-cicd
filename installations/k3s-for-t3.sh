#!/bin/bash
set -e

echo "=== Updating system ==="
sudo yum update -y

echo "=== Adding 2G swap ==="
if [ ! -f /swapfile ]; then
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

echo "=== Installing k3s (minimal) ==="
# Disable heavy addons: traefik, servicelb, local-storage
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --disable servicelb --disable local-storage" sh -

echo "=== Setting kubeconfig permissions ==="
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
mkdir -p $HOME/.kube
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown -R $(id -u):$(id -g) $HOME/.kube
sudo chmod 644 $HOME/.kube/config

echo "=== Done! Test with: kubectl get nodes ==="
kubectl get nodes