## Kubernetes deployment with terrafor kubernetes provider
> I run this deployment only locally in minikube and it is running. but I haven't run it on the aws.

### Add cluster to kubectl config file
```sh
aws eks --region eu-central-1 update-kubeconfig --name redacre-cluster
```

### Apply deployment on the k8s
```sh
terraform init
terraform plan
terraform apply --auto-approve
```

## for destroy k8s deploymenet
```sh
terraform destroy --auto-approve
```