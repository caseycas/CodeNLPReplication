from __future__ import division #int/int division gets floating point return
import sys
import os 
from folderManager import Folder
import dictUtils
import itertools


def getProjectName(filepath):
    return filepath.split("/")[0]

def getName(filepath, dirLevel):
    pieces = filepath.split("/")
    if(len(pieces) < dirLevel):
        return filepath
    else:
        return "/".join(pieces[-dirLevel:])


try:
    inputDir = sys.argv[1]
    fileExt = sys.argv[2]
    dirLevel = int(sys.argv[3])
    assert(dirLevel >= 1)
except:
    print("usage:  python projectSimilarity.py inputDir fileExt dirLevel")
    print("dirlevel must be >= 1")
    quit()

basePath = os.path.abspath(inputDir)
codeFolder = Folder(basePath)

project_profiles = {}

#Read in directory structure
for path in codeFolder.fullFileNames(fileExt, recursive=False):
    reducedPath = path.replace(basePath + "/", "")
    project = getProjectName(reducedPath)
    name = getName(reducedPath, dirLevel)
    #print(project)
    #print(name)
    project_profiles = dictUtils.addItemToDictSet(project_profiles, project, name)

jaccards = [] #list of tuples

#Perform comparisons (Jaccard index):
for k1, k2 in itertools.combinations(project_profiles, 2):
    unionSize = len(set.union(project_profiles[k1], project_profiles[k2]))
    intersectionSize = len(set.intersection(project_profiles[k1], project_profiles[k2]))
    jaccards.append((k1, k2, intersectionSize/unionSize))

jaccards.sort(key=lambda tup: tup[2])
for index in jaccards:
    if(index[2] > .1):
        print(index)







