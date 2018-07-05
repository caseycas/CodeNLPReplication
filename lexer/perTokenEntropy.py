import sys
from folderManager import Folder

#This script is designed to take a debug output file from Zhaopeng's cache model code
#and average the entropys of all tokens of the types included in the type file.

START = "<bead>"
REF = "<ref>"
PROB = "<prob>"
END = "</bead>"

#string, list --> boolean
#Returns true if one of the types in the list is in the string, false otherwise.
def checkType(tokenLine, types):
    for t in types:
        if(("|" + t + ">") in tokenLine):
            return True
    
    return False

#<prob> 5.60519e-45 |||  </prob> -> 5.60519e-45
#<prob> -1.57726 ||| ngram prob: 0.005351828032, in cache: 1/2 </prob> -> -1.57726
def parseProb(probLine):
    return float(probLine.split()[1])

try:
    inputDir = sys.argv[1]
    typeFile = sys.argv[2]
    outputFile = sys.argv[3]
except:
    print("Please enter the input directory,type file, and output file as command line inputs.")
    quit()


types = []
fileExtension = "*.test.output"

with open(typeFile, 'r') as f:
    for line in f:
        types.append(line.strip())

phase = START
isConsideredType = False
labelEntropyDict = {} #Token, list of entropies from the test.


for path in codeFolder.fullFileNames(fileExtension, recursive=True):

    with open(inputFile, 'r') as f:
        for line in f:
            line = line.strip()
            #print(line)
            if(line.startswith(START)):
                isConsideredType = False
            elif(line.startswith(REF)):
                isConsideredType = checkType(line, types)
                if(isConsideredType):
                    print(line)
                    line.replace("<ref>","").replace("<\ref>").strip()
            elif(line.startswith(PROB)):
                if(isConsideredType):
                    entropySum += parseProb(line)
                    totalTypeCount += 1
            elif(not line.startswith(END)):
                print(line)
                print("Unexpected phase")
                quit()


print("Count of Token Types: " + str(totalTypeCount))
print("Entropy sum: " + str(-entropySum))
print("Cross Entropy: " + str(-entropySum/totalTypeCount))

#<bead>
#<ref> <package|Token.Keyword.Namespace> </ref>
#<prob> 5.60519e-45 |||  </prob>
#</bead>
        
