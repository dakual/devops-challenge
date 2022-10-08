## Deployment URL
http://ac327e60602884e26b5233125151693a-1161107545.eu-central-1.elb.amazonaws.com/

### Preparing development enviroment
```sh
# clone repository
git clone git@gitlab.com:redacre/test-project.git

# create enviroment
python3 -m venv venv
source venv/bin/activate

# install requirements
pip install -r api/requirements.txt
```

### Build and run docker containers
```sh
# build backend
docker build -t backend -f Dockerfile.backend.yml .
# run backend
docker run -it --rm -p 5000:5000 backend

# build frontend
docker build -t frontend -f Dockerfile.frontend.yml .
# run frontend
docker run -it --rm -p 3000:3000 frontend

# build and run with docker compose
docker compose up --build
```

### Push Docker image to ECR
```sh
# authenticate docker to a aws ecr public registry
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/m2a7z1o1

# create redacre backend repository
aws ecr-public create-repository --repository-name backend --region us-east-1

# create redacre backend repository
aws ecr-public create-repository --repository-name frontend --region us-east-1

# tag backend image
docker tag backend:latest public.ecr.aws/m2a7z1o1/backend:latest 

# tag frontend image
docker tag frontend:latest public.ecr.aws/m2a7z1o1/frontend:latest 

# push to aws ecr public registry
docker push public.ecr.aws/m2a7z1o1/backend:latest 
docker push public.ecr.aws/m2a7z1o1/frontend:latest 
```

> Not: I changed API url from source code. beause it was "localhost:5000/stats". I did "/stats". And after, I defined reverse proxy in the nginx config file.

## Now we are going to "terraform-aws-eks" folder
