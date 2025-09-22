#!/bin/bash
set -e

echo "========= Installing Java 17 & Maven ========="
sudo yum update -y
sudo yum install -y java-17-amazon-corretto-devel maven git

echo "========= Installing Docker ========="
sudo yum install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

echo "========= Installing Jenkins ========="
# Add Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
sudo yum install -y jenkins

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "========= Configuring Jenkins user ========="
sudo usermod -aG docker jenkins
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

echo "========= Versions ========="
java -version
mvn -v
jenkins --version
docker --version
git --version

echo "========= Setup Completed ========="