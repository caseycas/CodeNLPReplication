import os
from folderManager import Folder

codeFolder = Folder("/Users/caseycas/CodeNLP/EFLCorpus/TECCL_Corpus_V1.1/02TECCL_V1.1_POS/")

fileList = codeFolder.fullFileNames("*.txt")
print(len(fileList))

for path in fileList:
	print(path)
	lines = []
	with open(path, 'r') as f:
	    for line in f:
	        lines.append(line.replace("<s>", "").replace("</s>", ""))
	with open(path, 'w') as f:
	    for line in lines:
	        f.write(line)