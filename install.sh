#!/bin/bash
set -e

echo "🔄 Updating system..."
sudo apt update -y

echo "🐳 Installing Docker..."
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo "✅ Docker installed successfully. Version:"
docker --version

echo "🔍 Installing Trivy (vulnerability scanner)..."
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

echo "✅ Trivy installed successfully. Version:"
trivy --version

echo "🎉 EC2 setup complete! Ready for Docker deployments."
