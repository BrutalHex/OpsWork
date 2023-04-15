import subprocess



def runShell(args,printArgs=False):
    if printArgs:
        print( process.args)
    process = subprocess.Popen(args , 
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE,
                           universal_newlines=True)
    stdout,stderr = process.communicate()

 
    return (stdout,stderr)

def runShellWithStream(args):
    process = subprocess.Popen(args, 
                           stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                           universal_newlines=True)

    while True:
        output = process.stdout.readline()
        print(output.strip())
        # Do something else
        return_code = process.poll()
        if return_code is not None:
            print('RETURN CODE', return_code)
            # Process has finished, read rest of the output 
            for output in process.stdout.readlines():
                print(output.strip())
            break