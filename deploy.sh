#!/bin/bash

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

echo "Creating the volume..."

kubectl apply -f ./kubernetes/persistent-volume.yml
kubectl apply -f ./kubernetes/persistent-volume-claim.yml


echo "Creating the database credentials..."

kubectl apply -f ./kubernetes/secret.yml


echo "Creating the postgres deployment and service..."

kubectl create -f ./kubernetes/postgres-deployment.yml
kubectl create -f ./kubernetes/postgres-service.yml
POD_NAME=$(kubectl get pod -l service=postgres -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME --stdin --tty -- createdb -U sample books


echo "Creating the flask deployment and service..."

kubectl create -f ./kubernetes/flask-deployment.yml
kubectl create -f ./kubernetes/flask-service.yml
FLASK_POD_NAME=$(kubectl get pod -l app=flask -o jsonpath="{.items[0].metadata.name}")
kubectl exec $FLASK_POD_NAME --stdin --tty -- python manage.py recreate_db
kubectl exec $FLASK_POD_NAME --stdin --tty -- python manage.py seed_db


echo "Adding the ingress..."

minikube addons enable ingress
kubectl apply -f ./kubernetes/minikube-ingress.yml


echo "Creating the vue deployment and service..."

kubectl create -f ./kubernetes/vue-deployment.yml
kubectl create -f ./kubernetes/vue-service.yml