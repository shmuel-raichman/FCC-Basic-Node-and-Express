B"H

This is a project i did as exercise a while ago from  `free code camp`.
The project didn't have docker iamge, just basic nodejs express server.
I Added Dockerfile & helm chart (`myapps` is the chart diractory) plus the github actions for deployments (More near the end of this document),
The chart is generic (hence the weird name).

added few endpoints:
    /log - 20 last commits
    /version - GITHUB_SHA + GITHUB_REF
    /health - return status code 200 for k8s health check.
Added unit test:
    Added fake unit test just have test.
    The tests are running in the build process.

Getting started:
```bash
# Clone the project to local dircatory
git clone https://github.com/smuel1414/FCC-Basic-Node-and-Express.git
# Chnage diractory to the project diractory.
cd FCC-Basic-Node-and-Express
```

Run the project localy:
Requirements:
    nodejs
    npm
```bash
npm install
npm start
# If the port 3000 already taken start it on diffrent port 
# (in bash, on windows you will need to define PORT environment variable seperate and run the above command):
`PORT=8888 npm start`
```

Build and Run with docker:
Requirements:
    docker engine
```bash
docker build -t fcc-basic-node-and-express .
docker run --rm -it --name myapp-dev -p 3333:3000 fcc-basic-node-and-express
# -p your_pc_port:docker_container_port
```
Open browser: http://localhost:3333

Run with docker:
Requirements:
    docker engine
```bash
docker run --rm -it --name myapp-dev -p 3333:3000 smuel770/fcc-basic-node-and-express:latest
# -p your_pc_port:docker_container_port
```
Open browser: http://localhost:3333

Install the project into kubernets cluster (using existing docker image):
Requirements:
    helm 3 (local)
    bash (local)
    git (local)
    kubernetes cluster
    nginx ingress controller (installed in the k8s cluster)

```bash
# Chnage diractory to the install script diractory.
cd install
# Add execute permissions to the install script.
sudo chmod +x install-chart.sh
# Install the chart on your kubernetes cluster.
ENVIRONMENT=dev ./install-chart.sh latest smuel770/fcc-basic-node-and-express
# ENVIRONMENT=dev ./install-chart.sh TAG REPO
```

Add ingres hostname to /etc/hosts
To get the ingress hostname and IP:
```bash
kubectl get ingress -n {dev/qa/prod}
# This is an example output copy the host 
# NAME                                CLASS    HOSTS                                          ADDRESS        PORTS     AGE
# fcc-basic-node-and-express-myapps   <none>   fcc-basic-node-and-express.dev.raichmans.com   192.168.65.3   80, 443   7h14m
# Get your ingress controller IP
kubectl get service -n nginx-ingress-controller 
# This is an example output copy the EXTERNAL-IP of the  nginx-ingress-controller and use this in your DNS
# NAME                                       TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
# nginx-ingress-controller                   LoadBalancer   10.100.14.160   35.188.73.18   80:30111/TCP,443:32286/TCP   27h
# nginx-ingress-controller-default-backend   ClusterIP      10.100.1.212    <none>         80/TCP                       27h
```

Adding host mapping to your nginx ingress controller
```bash
# Add DNS mapping pointing to your ingress controller into to your /etc/hosts or DNS server.
sudo sh -c 'echo "35.188.73.18 fcc-basic-node-and-express.dev.raichmans.com" >> /etc/hosts'
```



Installing helm 3: https://helm.sh/docs/intro/install/
Installing git (debian\ubuntu): sudo apt install git
Installing bash: Well you need to have it, Or if you on windows 10 install WSL here is how - https://docs.microsoft.com/en-us/windows/wsl/install-win10

Installing kubernets: this is out of the scope for this document (if you not familar with kubernets go learn about it, it's a graet tool).
Installing ingress controller in kubernets cluster
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install nginx-ingress-controller --namespace=nginx-ingress-controller bitnami/nginx-ingress-controller --create-namespace
```

# Deployment
The project is built and deployed by git branchs rules.
All deployment process is done by github actions `.github/workflows`.
The app is running on Google cloud GKE cluster in three diffrent namespaces.
secret for deployment are stored as secret variables in github.

App running after deployment here:
https://fcc-basic-node-and-express.raichmans.com/
https://fcc-basic-node-and-express.dev.raichmans.com/
https://fcc-basic-node-and-express.qa.raichmans.com/


And shut down agian around wednesday or when you tell me you check it out.
There are some issues i opend in the repo and didn't got to do.

# Build and deploy rules
dev:
    on:
    manual:
    push:
        branches: 
        - "*"
        - '!master'
        - '!dev'
QA:
    on:
    manual:
    pull_request:
        branches: 
        - dev
PROD:
    on:
    manual:
    pull_request:
        branches: 
        - main
Package: (Build and push docker image)
    on:
    manual:
Build: (Build docker image)
    on:
    manual:

If i forgat somthing ask me about it ..
