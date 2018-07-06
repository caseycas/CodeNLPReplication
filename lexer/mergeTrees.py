import os
import random
import argparse

parser = argparse.ArgumentParser(description="Merge the components of the Penn Treebank corpora.") 
parser.add_argument("target_dir", help = "Location of lexed Penn Treebank trees.", action="store", type=str)
args = parser.parse_args()
target_dir = args.target_dir


files = ["train", "valid", "test"]
dirs = [os.path.join(target_dir,"wsj"), os.path.join(target_dir,"brown")]



for next_file in files:
    combinedFile = []
    for next_dir in dirs:
        with open(os.path.join(next_dir, next_file), "r") as f:
            for line in f:
                combinedFile.append(line)

    random.shuffle(combinedFile)

    with open(os.path.join(target_dir,next_file), 'w') as f:
        [f.write(line) for line in combinedFile]
