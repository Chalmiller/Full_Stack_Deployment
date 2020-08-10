### Jenkins 

The following are a few commands to use if running on a MacOS, like myself
```
Install the latest LTS version: brew install jenkins-lts
Install a specific LTS version: brew install jenkins-lts@YOUR_VERSION
Start the Jenkins service: brew services start jenkins-lts
Restart the Jenkins service: brew services restart jenkins-lts
Update the Jenkins version: brew upgrade jenkins-lts
```
Note: Use yamllint to lint check any yaml files. It's very helpful
```
pip install yamllint
```

Also, if you ever run into an issue with the kubectl API, there is a very handy tool for converting the yml files
to the desired updated API:
```
kubectl convert -f <file> --output-version <group>/<version>
like:
kubectl convert -f jenkins_pipeline/jenkins-deployment.yml --output-version apps/v1
```

### Istio
Install Istio and export it into your PATH
```
cd ~/istio-1.6.7
export PATH=$PWD/bin:$PATH
```

generate a namespace for Istio to automatically inject its Envoy sidecar into the cluster

### Docker

Build the images and spin up the containers:

```sh
$ docker-compose up -d --build
```

Run the migrations and seed the database:

```sh
$ docker-compose exec server python manage.py recreate_db
$ docker-compose exec server python manage.py seed_db
```

Testing:

1. [http://localhost:8080/](http://localhost:8080/)

### Kubernetes

#### Minikube

Install and Run Minikube for local cluster deployment

Start the cluster:

```sh
$ minikube config set vm-driver hyperkit
$ minikube start --vm-driver=virtualbox
$ minikube dashboard
```

#### Volume

Create the volume:

```sh
$ kubectl apply -f ./kubernetes/persistent-volume.yml
```

Create the volume claim:

```sh
$ kubectl apply -f ./kubernetes/persistent-volume-claim.yml
```

#### Secrets

Create the secret object:

```sh
$ kubectl apply -f ./kubernetes/secret.yml
```

#### Postgres

Create deployment:

```sh
$ kubectl create -f ./kubernetes/postgres-deployment.yml
```

Create the service:

```sh
$ kubectl create -f ./kubernetes/postgres-service.yml
```

Create the database:

```sh
$ kubectl get pods
$ kubectl exec postgres-<POD_IDENTIFIER> --stdin --tty -- createdb -U postgres books
```

#### Flask

Build and push the image to Docker Hub:

```sh
$ docker build -t chalmiller1/flask-kubernetes ./services/server
$ docker push chalmiller1/flask-kubernetes
```

Create the deployment:

```sh
$ kubectl create -f ./kubernetes/flask-deployment.yml
```

Create the service:

```sh
$ kubectl create -f ./kubernetes/flask-service.yml
```

Apply the migrations and seed the database:

```sh
$ kubectl get pods
$ kubectl exec flask-<POD_IDENTIFIER> --stdin --tty -- python manage.py recreate_db
$ kubectl exec flask-<POD_IDENTIFIER> --stdin --tty -- python manage.py seed_db
```

#### Ingress

Enable and apply:

```sh
$ minikube addons enable ingress
$ kubectl apply -f ./kubernetes/minikube-ingress.yml
```

Add entry to */etc/hosts* file:

```
<MINIKUBE_IP> hello.world
```
^ A Helpful Command to do so is to run 
```
echo "$(minikube ip) hello.world" | sudo tee -a /etc/hosts
```

Note: You need sudo privileges to run this command. 
Also, if for any reason you've run the command more than once, 
you'll need to remove the prvious entries in /etc/hosts

Try it out:

1. [http://hello.world/books/ping](http://hello.world/books/ping)
1. [http://hello.world/books](http://hello.world/books)


#### Vue

Build and push the image to Docker Hub:

```sh
$ docker build -t chalmiller1/vue-kubernetes ./services/client \
    -f ./services/client/Dockerfile-minikube

$ docker push chalmiller1/vue-kubernetes
```


Create the deployment:

```sh
$ kubectl create -f ./kubernetes/vue-deployment.yml
```

Create the service:

```sh
$ kubectl create -f ./kubernetes/vue-service.yml
```

Try it out at [http://hello.world/](http://hello.world/).
