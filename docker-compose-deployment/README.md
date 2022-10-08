## DEPLOY THE APPLICATION TO AWS ECS USING DOCKER COMPOSE
To run it from your local workstation, first we need to set the docker context to use the ECS to run the docker commands.

### Create a Docker Context for Amazon ECS
```sh
docker context create ecs myecs 
```
After this commmand it will ask credentials. we can select enviroment or we can type aws secret and token.

```sh
docker context ls # i am checking, everythings are ok
docker context use myecs # after i select my aws ecs context
```

and below command will create a ECS cluster with all other components which are required for the application like.

- ECS Cluster
- VPC & Security Groups
- Task Definitions
- Tasks
- Service 
- Load Balancer
- Target Groups

### Magic
```sh
docker compose up
```

Now everythings are ready.

### you can see the containers are running
```sh
docker compose ps
```
and you can see ladbalance endoint url

### if you need we can generate AWS Cloudformation template.
```sh
docker compose convert > aws-cloudformation.yaml
```

### To clean up
This will delete your cluster and all components.
```sh
docker compose down
```