# Infrastructure
it has been built on top of **aws eks**.it provisions **subnets** in 3 zones. 
and also uses **nodegroups** for deployment of the containers in Kubernetes.
for the purpose of the **scal up/down** it uses **EKS Autoscaler**.
after creation of the infrastructure it simply deploys a helm chart 
located at `.\services\myapp` which is a nginx image.


# Prerequisites
- Python 3.9.11
- aws-cli 2.7.3
- helm 3.10.3
- kubectl 1.25.2

# setup
clone the project and then navigate to the root folder in the CLI.

## aws
configure the **aws cli** using `aws configure` with your service account credentials. 

## install dependencies
execute below commands to install the dependencies of the setup script:
- `pip install -r requirements.txt`

## setup script
execute this command to build the infrastructure,it's just a wrapper for Terraform and Helm.
- `python3 setup.py`

## Destroy
to destroy the environment , first delete the **myapp** service then execute below command:
`kubectl delete svc ui-one && python3 destroy.py`

# Check scaling:
in a seprate cli execute : `kubectl get pods -w` then open another 
cli and execute `kubectl get nodes -w` then execute: 
`kubectl scale --replicas=3 deployment ui-one`
for **automated scaling**.
to check the auto scaler logs execute: 
`kubectl logs deployment/cluster-autoscaler -n kube-system`

# endpoint
to get service endpoint execute:
`echo $(kubectl get svc ui-one -o jsonpath="{.status.loadBalancer.ingress[].hostname}")`


