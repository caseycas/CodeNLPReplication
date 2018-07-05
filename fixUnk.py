import os
import argparse
sys.path.append("./lexer/")
from folderManager import Folder

parser = argparse.ArgumentParser(description = "Kenlm doesn't handle existing <unk> so let's hide them as UNK")

parser.add_argument("input_dir", help = "Directory to look at.  Since the explicity <unk> is used only" +
                   "with the lstm sets, we we replace unks in train, valid, and test files only.",
                   action="store", type = str)

lstm_files = ["train", "valid", "test"]
#lstm_files = ["train_valid"]

args = parser.parse_args()

baseDir = Folder(args.input_dir)

#fileList = baseDir.fullFileNames("train_valid",True)
#print(fileList)
#quit()
fileList = [os.path.join(args.input_dir,f) for f in lstm_files]
print(fileList)

for path in fileList:
        fileContents = ''.join(open(path, 'r').readlines())
        fileContents = fileContents.replace("<unk>", "UNK")
        with open(path, 'w') as f:
                f.write(fileContents)
