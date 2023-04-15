from module.shell import *
from module.terraformbase import *
from module.randomizer import *
from module.file_handler import *
from module.awsApi import *
import json
from module.colors import *

terraformPathArgument= '-chdir=./infra'
 

recreateBackendBucket()

#format
stdout, stderr=formatFiles(terraformPathArgument)
throwException(stderr)

# verify 
parsedOutput=verifyInfra(terraformPathArgument)

 

if not bool(parsedOutput["valid"]):
    print(f'{bcolors.FAIL}{json.dumps(parsedOutput, indent=4)}{bcolors.ENDC}')
    raise SystemExit(0)
# initialize the terraform modules
stdout, stderr =initializeTerraform(terraformPathArgument)
print( stdout )
#apply infrastructue:
#stdout, stderr =applyTerraform(terraformPathArgument)
throwException(stderr)
print( stdout )
#update kubernetes local file:
stdout, stderr=updateLocoalKubernetesConfig(terraformPathArgument)
throwException(stderr)
print( stdout )

#helm


stdout, stderr=runShell(shlex.split('helm repo add istio https://istio-release.storage.googleapis.com/charts'),True)
if stderr:
    raise Exception(stderr)
stdout, stderr=runShell(shlex.split('helm repo add eks https://aws.github.io/eks-charts'),True)
throwException(stderr)


stdout, stderr=runShell(shlex.split('helm repo update'),True)
if stderr:
    raise Exception(stderr)

stdout, stderr=runShell(shlex.split('helm upgrade --install istio-base istio/base -n istio-system --create-namespace'),True)
throwException(stderr)

 
stdout, stderr=runShell(shlex.split('helm upgrade --install istiod istio/istiod -n istio-system'),True)
throwException(stderr)

clusterName=getOutPut(terraformPathArgument,'cluster_name')
clusterRole=getOutPut(terraformPathArgument,'cluster_role')
#
stdout, stderr=runShell(shlex.split(f'helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName={clusterName[0]}'),True)
throwException(stderr)

stdout, stderr=runShell(shlex.split(f'helm upgrade --install base ./services/base --create-namespace --timeout=1m --wait --set cluster.roleArn={clusterRole[0]} --set cluster.name={clusterName[0]}'),true)
throwException(stderr)

 

stdout, stderr=runShell(shlex.split(f'helm upgrade --install myapp ./services/myapp --create-namespace --timeout=1m --wait --set cluster.roleArn={clusterRole[0]} --set cluster.name={clusterName[0]}'),True)
throwException(stderr)