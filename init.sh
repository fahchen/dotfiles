#!/bin/sh

sudo apt-get update
sudo apt-get -y install buildah fish

# install k3s
curl -sfL https://get.k3s.io | sudo sh -s - --disable=traefik
# install helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https make --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

if ! test -f ~/.kubeconfig.yaml; then
  echo "\nexport TZ=Asia/Shanghai;" >> ~/.bashrc
  echo "\nexport KUBECONFIG=~/.kubeconfig.yaml;" >> ~/.bashrc
  echo "\nalias k=kubectl;" >> ~/.bashrc
  sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kubeconfig.yaml
  git clone https://github.com/Byzanteam/jet-deployment.git ~/jet-deployment
fi
