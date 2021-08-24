#! /bin/sh

# Stop if a command fails, and echo command
set -ex

minikube delete || echo "No current minikube to delete"
if which minikube; then
    rm $(which minikube)
fi
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube ~/.local/bin/
minikube start

minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server
