## Create infrastructure
In this deployment i am creating aws eks cluster. the is one node group and it has 2 Amazon Linux nodes.

```sh
cd terraform-aws-eks

terraform init
terraform plan
terraform apply --auto-approve
```

## for destroy infrastracture
```sh
terraform destroy --auto-approve
```

### Add cluster to kubectl config file
```sh
aws eks --region eu-central-1 update-kubeconfig --name redacre-cluster
```

### Apply deployment to AWS EKS
```sh
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/frontend-deployment.yml
kubectl get deploy,svc,pods
```
on the kubectl output "EXTERNAL-IP" is our endpoint anddress

## EKS enviroment correctly running. you can check with this url
```sh
http://ac327e60602884e26b5233125151693a-1161107545.eu-central-1.elb.amazonaws.com/
```