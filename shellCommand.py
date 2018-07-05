import subprocess
PIPE = subprocess.PIPE

def executeCommand(arguments):
    command_ok = False
    proc = subprocess.Popen(arguments, stderr=PIPE, stdout=PIPE)
    _pc = proc.communicate()

    if not proc.returncode:
        command_ok = True

    return command_ok