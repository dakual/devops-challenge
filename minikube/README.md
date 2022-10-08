## I pushed docker images to my docker hub
```sh
docker tag backend:latest kurtay/backend:latest 
docker tag frontend:latest kurtay/frontend:latest
docker push kurtay/frontend:latest
docker push kurtay/backend:latest 
```

## minikube
```sh
# start kubernetes cluster
minikube start -n 3 -p <profile-name>

# profile list
minikube profile list

# stop kubernetes cluster
minikube stop -p <profile-name>

# delete kubernetes cluster
minikume delete -p <profile-name>
```

## checking for current context. because i have alot of kubernetes clusters
```sh
kubectl config view
```

## deployment
```sh
cd minikube
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
```

## checking every things are ok
```sh
kubectl get pods,svc,deploy
```

## expose kubernetes service for connect to a service. it will return url
```sh
minikube service frontend
```