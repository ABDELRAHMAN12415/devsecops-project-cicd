#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."

# Update system
sudo yum update -y
sudo systemctl daemon-reload

# Install dependencies (Amazon Linux)
sudo yum install -y \
  git \
  docker \
  vim \
  gcc gcc-c++ make \
  jq \
  python3-pip \
  curl \
  containerd

pip3 install jc

# Enable & start Docker
sudo systemctl enable docker
sudo systemctl start docker

### Kubernetes install for Amazon Linux
# Add Kubernetes repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF

sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet

### UUID of VM (only works on bare metal/cloud VMs)
jc dmidecode | jq .[1].values.uuid -r

echo ".........----------------#################._.-.-KUBERNETES-.-._.#################----------------........."
sudo rm -f /root/.kube/config
sudo kubeadm reset -f

# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Initialize Kubernetes cluster
sudo kubeadm init --pod-network-cidr '10.244.0.0/16' --service-cidr '10.96.0.0/16' --skip-token-print

mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Install Weave Net CNI
kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
kubectl rollout status daemonset weave-net -n kube-system --timeout=90s
sleep 5

# Remove control-plane taint
node=$(kubectl get nodes -o=jsonpath='{.items[0].metadata.name}')
for taint in $(kubectl get node $node -o jsonpath='{range .spec.taints[*]}{.key}{":"}{.effect}{"-"}{end}'); do
    kubectl taint node $node $taint --overwrite
done

kubectl get nodes -o wide
