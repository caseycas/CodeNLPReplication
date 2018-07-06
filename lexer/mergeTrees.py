import os
import random

files = ["train", "valid", "test"]
dirs = ["./wsj", "./brown"]


for next_file in files:
    combinedFile = []
    for next_dir in dirs:
        with open(os.path.join(next_dir, next_file), "r") as f:
            for line in f:
                combinedFile.append(line)

    random.shuffle(combinedFile)

    with open(next_file, 'w') as f:
        [f.write(line) for line in combinedFile]
