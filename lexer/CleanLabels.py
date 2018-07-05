import os
from folderManager import Folder
import codecs
import sys
import utilities

try:
    inputDir = sys.argv[1]
    fileType = sys.argv[2]
    outputDir = sys.argv[3]
except:
    print("usage python Freq.py inputDir fileTypeWildCard outputDir")
    print("e.g. python Freq.py /Users/caseycas/CodeNLP/HaskellCorpus/files/ *.hs.tokens /Users/caseycas/CodeNLP/HaskellCorpus/files/ 2")
    quit()



# Path to root folder containing the source code
codeFolder = Folder(os.path.abspath(sys.argv[1]))
for path in codeFolder.fullFileNames(fileType, recursive=False):
    filename = path.split("/")[-1]
    print(filename)
    words = []
    with codecs.open(path, 'r', 'utf-8') as f:
        for line in f:
            words += line.split()

        words = [utilities.removeLabel(w) for w in words]

    with codecs.open(outputDir + filename, 'w', 'utf-8') as f2:
        f2.write(" ".join(words))