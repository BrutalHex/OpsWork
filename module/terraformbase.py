from module.shell import runShell,runShellWithStream
import shlex
import json



def throwException(stderr):
    if stderr:
       raise Exception(stderr)

def formatFiles(terraformPathArgument):
   return runShell(shlex.split(f'terraform {terraformPathArgument} fmt -write=true -recursive'),True)

def verifyInfra(terraformPathArgument):
    stdout, stderr=runShell(shlex.split(f'terraform {terraformPathArgument} init -backend=false'),True)
    if stderr:
         raise Exception(stderr)
    # terraform -chdir=./infra validate -json -no-color
    stdout, stderr=runShell(shlex.split(f'terraform {terraformPathArgument} validate -json -no-color'),True)
    return json.loads(stdout)

def initializeTerraform(terraformPathArgument):
    return runShell(['terraform' ,terraformPathArgument, 'init', ''],True)

def initializeTerraform(terraformPathArgument):
    return runShell(['terraform' ,terraformPathArgument, 'init'],True)

def destroyTerraform(terraformPathArgument):
    runShellWithStream(['terraform' ,terraformPathArgument, 'destroy','-auto-approve'])

def applyTerraform(terraformPathArgument):
    return runShell(['terraform' ,terraformPathArgument, 'apply','-auto-approve'],True)

def getOutPut(terraformPathArgument,key):
    return runShell(shlex.split(f'terraform {terraformPathArgument} output -raw {key}'  ,True))


def updateLocoalKubernetesConfig(terraformPathArgument):
    region, stderr=getOutPut(terraformPathArgument,'region')
    if stderr:
        raise Exception(stderr)
    cluster_name, stderr=getOutPut(terraformPathArgument,'cluster_name')
    if stderr:
        raise Exception(stderr)
    return runShell(shlex.split(f'aws eks --region {region} update-kubeconfig --name {cluster_name}'))