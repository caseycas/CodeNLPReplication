#from __future__ import unicode_literals
import os
import nltk
from collections import OrderedDict
import sys
sys.path.append("./lexer/")
import codecs
import argparse
import pickle
import csv
import listUtils
import shellCommand
from restrictType import remapType, TYPE_ORDER
from folderManager import Folder


#Reverse a dictionary of storing lists as items
#Assumes that the lists are disjoint
def invertDictionary(dictionary):
    inverted = {}
    for key, items in dictionary.iteritems():
        for i in items:
            inverted[i] = key

    return inverted


def writeMapToCsv(toWrite, filename):
    i = 0
    with codecs.open(filename, 'wb', 'utf-8') as f:
        for k, v in toWrite.items():
            f.write(str(i) + "," + k + "," + str(v) + "\n")
            i += 1

def getTestedFiles(testDir):
    testfiles = []
    for i in range(0,10):
        with open(testDir + "/fold" + str(i) + ".test", 'r') as f:
            for line in f:
                testfiles.append(line.split("/")[-1].strip())
    return testfiles

#Convert files like 5.java.tokens to 5.java.metadata
def getMetaDataName(baseFile):
    return baseFile.replace("tokens", "metadata")

#Create a mapping between each of the unigrams and its one of 4 basic types.
#I know the same word can have different Pygments types, but I'm not so sure
#about my 4 types (Name, Operator, KeyWord, Literal) Keep an eye out for 
#type ambiguity when combining all unigram instances.
def buildTypeMap(inputDir, corpus):
    unigramTypes = {}
    #Read in the metadata files
    for fileID in corpus.fileids():
        #Convert to metadata variant
        metaID = getMetaDataName(fileID)
        with open(os.path.join(inputDir,metaID), 'r') as f: #NOTE: Potential unicode issues
            reader = csv.reader(f, delimiter=',', quotechar='\"')
            #print(metaID)
            #Skip 2 lines of metadata.
            next(reader, None)
            next(reader, None)
            for line in reader:
                #print(line)
                line = [c.encode('utf-8') for c in line]
                token = line[0].replace(",", "<comma>").replace("\"", "<quote>")
                fullType = line[1]
                limitedType = remapType(fullType)
                if(limitedType not in TYPE_ORDER):
                    print(metaID)
                    print(line)
                    quit()
                if(token in unigramTypes):
                    if(limitedType != unigramTypes[token]):
                        #print("Error: Amgibiguous unigram!")
                        #print(token + ": " + limitedType)
                        #print(token + ": " + unigramTypes[token])
                        #HardCoded Fixes (Force keyword conflicts to be considered keywords)
                        if(limitedType == "Keyword" or unigramTypes[token] == "Keyword"):
                            unigramTypes[token] = "Keyword"
                        elif(limitedType == "Operator" or unigramTypes[token] == "Operator"): #Operators have next priority.
                            unigramTypes[token] = "Operator"
                        else:
                            print(line)
                            quit()
                else:
                    unigramTypes[token] = limitedType

    return unigramTypes

def generateNgram(key, ngramOrder):
    if(ngramOrder == 1):
        return key
    else:
        return " ".join(key)

def generateProjectInfo(key, ngramProjects = {}):
    if(ngramProjects == {}):
        return ""
    else:
        return "," + str(len(ngramProjects[key]))

#Generate a series of columns of size TYPE_ORDER and set each column to true if
#that ngram contains a token of that type.
def generateTypeColumns(key, ngramOrder, unigramMap = {}):
    types = [False] * len(TYPE_ORDER)
    if(unigramMap == {}):
        return ""
    else:
        try:
            if(ngramOrder == 1):
                simpleType = unigramMap[key]
                types[TYPE_ORDER.index(simpleType)] = True
            else:
                for unigram in key:
                    simpleType = unigramMap[unigram]
                    types[TYPE_ORDER.index(simpleType)] = True
        except:
            print(unigramMap)
            print(key)
            quit()

        return "," + ",".join([str(t) for t in types])


#Write the output to the file. ngramProjects and unigramMap are optional arguments
#If ngramProjects != [] then list all the projects in which this ngram appears.
#If unigramMap != {} then generate columns with boolean values for each type.
def writeOutput(outputFile, sfd_tokens, ngramOrder, ngramProjects = {}, unigramMap = {}):
    #Write to file
    i = 0
    freq_bag = []
    infreq_bag = []

    with codecs.open(outputFile, 'wb', 'utf-8') as f:
        for k, v in sfd_tokens.items():
            #print(k)
            #print(k.encode('utf-8'))
            #try:
            tmp = str(i) + "," + generateNgram(k, ngramOrder) + "," + str(v) + generateProjectInfo(k, ngramProjects) + generateTypeColumns(k, ngramOrder, unigramMap) +  "\n"
            #except:
            #    print('Row failure. Skipping')
            #    continue
            #    continue
            f.write(tmp)
            if(v <= 110):
                freq_bag += list(k)
            else:
                infreq_bag += list(k)
            i += 1

    #freq_tokens = nltk.FreqDist(freq_bag)
    #infreq_tokens = nltk.FreqDist(infreq_bag)

    #s_freq_tokens = OrderedDict(sorted(freq_tokens.items(), key=lambda tpl: -int(tpl[1])))
    #s_infreq_tokens = OrderedDict(sorted(infreq_tokens.items(), key=lambda tpl: -int(tpl[1]))) 

    #print(s_freq_tokens)
    #print(s_infreq_tokens)

    #writeMapToCsv(s_freq_tokens, "/home/ccasal/CodeNLP/FreqTokens.csv")
    #writeMapToCsv(s_infreq_tokens, "/home/ccasal/CodeNLP/InFreqTokens.csv")


def processFreq(inputDir, fileType, outputFile, ngramOrder, testLocation, projectMap, trackTypes):
    corpus = nltk.corpus.PlaintextCorpusReader(inputDir, fileType, word_tokenizer=nltk.tokenize.regexp.WhitespaceTokenizer())

    actuallTestFiles = []
    try:
        actualTestFiles = getTestedFiles(testLocation)
        print(len(actualTestFiles))
        #print(actualTestFiles)
    except:
        actualTestFiles = []
        print("No test files found or directory not given.  Counting all files in corpus.")

    sfd_tokens = OrderedDict()
    ngramProjects = {}
    unigramMap = {}

    if(trackTypes):
        unigramMap = buildTypeMap(inputDir, corpus)

    if(projectMap != ""):
        projectFiles = pickle.load(open(projectMap, 'r'))
        #Invert the dictionary
        fileProjects = invertDictionary(projectFiles)
        #print(fileProjects)
        #Get a frequency distribution for each project, then combine them after tracking the additional project information
        projectWords = {}
        for key in projectFiles.iterkeys():
            projectWords[key] = []

        for fileid in corpus.fileids():
            #print(inputDir + "/" + fileid)
            if(os.path.getsize(os.path.join(inputDir,fileid)) > 0 and (actualTestFiles == [] or fileid in actualTestFiles)):
                project = fileProjects[os.path.join(inputDir,fileid)]
                for w in corpus.words(fileid):
                    projectWords[project].append(w.replace(",", "<comma>").replace("\"", "<quote>"))

        #Get the ngram counts for each project.
        projectFreqDists = {}

        for project, words in projectWords.iteritems():
            if(ngramOrder >= 2):
                projectFreqDists[project] = nltk.FreqDist(nltk.ngrams(words, ngramOrder))
            else:
                projectFreqDists[project] = nltk.FreqDist(words)

        #Build map of ngram -> [set of projects]
        for project, FreqDist in projectFreqDists.iteritems():
            for ngram in FreqDist.iterkeys():
                if(ngram in ngramProjects):
                    ngramProjects[ngram].add(project)
                else:
                    ngramProjects[ngram] = set([project])

        #Combine FreqDists and sort.
        #FreqDist doesn't implement radd, so we can't use sum :(
        freqDistList = projectFreqDists.items()
        fd_tokens = freqDistList[0][1]
        #print(len(fd_tokens))
        for i in range(1, len(freqDistList)):
            fd_tokens += freqDistList[i][1]

        sfd_tokens = OrderedDict(sorted(fd_tokens.items(), key=lambda tpl: -int(tpl[1])))

    else:
        words = []
        count = 0
        for fileid in corpus.fileids(): #This is inefficient (Need to split the file into small enough pieces I think.)
            if(os.path.getsize(os.path.join(inputDir, fileid)) > 0 and (actualTestFiles == [] or fileid in actualTestFiles)):
                #print(fileid)
                for w in corpus.words(fileid):
                    #print(str(count) + ":" + w)
                    count += 1
                    words.append(w.replace(",", "<comma>").replace("\"", "<quote>"))

        #words = corpus.words()
        #words = [w.replace(",", "<comma>") for w in words]

        if(ngramOrder >= 2):
            fd_tokens = nltk.FreqDist(nltk.ngrams(words, ngramOrder))
        else:
            fd_tokens = nltk.FreqDist(words)


        sfd_tokens = OrderedDict(sorted(fd_tokens.items(), key=lambda tpl: -int(tpl[1])))


    writeOutput(outputFile, sfd_tokens, ngramOrder, ngramProjects, unigramMap)


parser = argparse.ArgumentParser(description = "Create ngram frequencies from a corpus.")
parser.add_argument('inputDir', help = 'Input directory where the lexed files are stored.')
parser.add_argument('fileType', help = "Regex for the file type in the directory to be stored.  Uses .*.<ext>.")
parser.add_argument('outputFile', help = "Path and name of the csv file to create")
parser.add_argument('ngramOrder', type = int, help = "The order of ngrams to generate.")
parser.add_argument('-testLocation', '-tl', default = "", help = "Optional argument to specify the language model test option to select only ngrams that were used in the test/train sets.")
parser.add_argument('-projectMap', '-pM', default = "", help = "Optional argument to specify a pickle file with a mapping of files to projects.  If included then provide an additional column listing all projects the ngrams appear in.")
parser.add_argument('-trackTypes', '-tt', action='store_true', help = "Optional argument to specify storing in 4 columns what types appear in each ngram.")
parser.add_argument('-independentSplit', '-iS', action='store_true', help = "Optional argument to estimate rank and frequency independently by dividing the corpora as per the Piantadosi Zipf Paper (2014/2015).")
args = parser.parse_args()

inputDir = args.inputDir
fileType = args.fileType
outputFile = args.outputFile
ngramOrder = args.ngramOrder
testLocation = args.testLocation
projectMap = args.projectMap
trackTypes = args.trackTypes
independentSplit = args.independentSplit

assert(ngramOrder > 0)

if(args.independentSplit):
    #Divide the corpus into two.
    #1) Get set of files in the base directory.
    basePath = os.path.abspath(inputDir)
    codeFolder = Folder(basePath)
    #These variant requires regexes of the form *.<ext> not .*.<ext>
    fileList = codeFolder.fullFileNames(fileType[1:], recursive=False)
    #2) Divide into 2 randomly.
    splitFiles = listUtils.partitionList(fileList)
    #3) Save each in a temp directory. (cd ../input_dir mkdir [rank|freq]_input_dir) (use ln -s to copy)
    (parentDir, localDir) = os.path.split(basePath)
    rankDir = os.path.join(parentDir, "rank_" + localDir)
    freqDir = os.path.join(parentDir, "freq_" + localDir)
    #print(splitFiles[0])
    #print(splitFiles[1])
    #print(len(splitFiles[0]))
    #print(len(splitFiles[1]))
    #print(rankDir)
    #print(freqDir)
    #quit()

    #-------------------------------------------------------------------------------------------
    shellCommand.executeCommand(["rm", "-r" ,rankDir])
    shellCommand.executeCommand(["rm", "-r" ,freqDir])
    shellCommand.executeCommand(["mkdir", rankDir])
    shellCommand.executeCommand(["mkdir", freqDir])

    #Rank corpus
    for nextFile in splitFiles[0]:
        #Create new name and link it.
        newFile = os.path.join(rankDir, os.path.split(nextFile)[1])
        shellCommand.executeCommand(["ln", "-s", nextFile, newFile])
    #Freq corpus
    for nextFile in splitFiles[1]:
        #Create new name and link it.
        newFile = os.path.join(freqDir, os.path.split(nextFile)[1])
        shellCommand.executeCommand(["ln", "-s", nextFile, newFile])

    #Create new outputFiles: BrownUnigrams.csv -> BrownUnigramsRank.csv
    rankOut = outputFile.split(".")[0] + "Rank.csv"
    freqOut = outputFile.split(".")[0] + "Freq.csv"


    #4) Read in each temp directory as a separate corpus (join them together in R)
    processFreq(rankDir, fileType, rankOut, ngramOrder, testLocation, projectMap, trackTypes)
    processFreq(freqDir, fileType, freqOut, ngramOrder, testLocation, projectMap, trackTypes)
    #rank_corpus = nltk.corpus.PlaintextCorpusReader(rankDir, fileType, word_tokenizer=nltk.tokenize.regexp.WhitespaceTokenizer())
    #freq_corpus = nltk.corpus.PlaintextCorpusReader(freqDir, fileType, word_tokenizer=nltk.tokenize.regexp.WhitespaceTokenizer())


else:
    processFreq(inputDir, fileType, outputFile, ngramOrder, testLocation, projectMap, trackTypes)
    #corpus = nltk.corpus.PlaintextCorpusReader(inputDir, fileType, word_tokenizer=nltk.tokenize.regexp.WhitespaceTokenizer())
    #corpus = nltk.corpus.PlaintextCorpusReader(inputDir, fileType)

