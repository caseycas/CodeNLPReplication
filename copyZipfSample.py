import pickle
import os
import sys
import argparse
import subprocess
PIPE = subprocess.PIPE


def copyFile(src, target):
    _ok = False
    
    # Call command
    command = ["cp", src, target]
    print(command)
    proc = subprocess.Popen(command, stderr=PIPE, stdout=PIPE)
    out, err = proc.communicate()
    #print(out)
    #print(err)

    if not proc.returncode:
        _ok = True

    return (_ok, err)


def mkOutput(out_dir):
    _ok = False

    # Call command
    command = ["mkdir", "-p", out_dir]
    print(command)
    proc = subprocess.Popen(command, stderr=PIPE, stdout=PIPE)
    out, err = proc.communicate()
    #print(out)
    #print(err)

    if not proc.returncode:
        _ok = True

    return (_ok, err)

#When we down sample the larger corpora, we need to make sure that we're pulling
#the non unk samples together
parser = argparse.ArgumentParser(description="When we downsample we need to grab the equivalent " +
                                             "tokens files (non unk) into a separate directory " +
                                             "to run the Zipf commands on") 
parser.add_argument("input_dir",help = "Directory where the tokens and split_map are" + 
                     "located.", action="store", type=str)
parser.add_argument("ext", help = "Extension of files to be moved", action = "store", type = str)
parser.add_argument("output_dir", help = "Target directory to store the sub-sample.",
                     action="store", type = str)

args = parser.parse_args()

split_map = pickle.load(open(os.path.join(args.input_dir, "split_map.pickle"), 'r'))
sample = split_map[0] + split_map[1] + split_map[2]
print(sample)

mkOutput(args.output_dir)

for fileID in sample:
    inputFile = os.path.join(args.input_dir, fileID + args.ext)
    outputFile = os.path.join(args.output_dir, fileID + args.ext)
    copyFile(inputFile, outputFile)
