#!/bin/bash

echo "Starting up the Minikube local environment and dashboard..."
minikube config set vm-driver hyperkit
minikube start
# minikube dashboard

echo "Creating the volume for kubernetes..."

kubectl apply -f ./kubernetes/persistent-volume.yml
kubectl apply -f ./kubernetes/persistent-volume-claim.yml

echo "Creating the persistent volume and namespace for Jenkins..."
# kubectl apply -f jenkins_pipeline/jenkins-namespace.yml
kubectl create namespace jenkins
# kubectl apply -f jenkins_pipeline/jenkins-volume.yml
kubectl create -f jenkins_pipeline/jenkins-deployment.yml
# create the Jenkins service through the service file
kubectl create -f jenkins_pipeline/jenkins-service.yml

# the stable/jenkins is being deprecated, so we need to use the bitnami version
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm install jenkins -f jenkins_pipeline/values.yml bitnami/jenkins --namespace jenkins

echo "Creating the database credentials..."

kubectl apply -f ./kubernetes/secret.yml


echo "Creating the postgres deployment and service..."

kubectl create -f ./kubernetes/postgres-deployment.yml
kubectl create -f ./kubernetes/postgres-service.yml



echo "Creating the flask deployment and service..."

kubectl create -f ./kubernetes/flask-deployment.yml
kubectl create -f ./kubernetes/flask-service.yml


echo "Adding the ingress..."

minikube addons enable ingress
kubectl apply -f ./kubernetes/minikube-ingress.yml


echo "Creating the vue deployment and service..."

kubectl create -f ./kubernetes/vue-deployment.yml
kubectl create -f ./kubernetes/vue-service.yml
