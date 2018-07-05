#!/usr/bin/env python

import os
import sys
import random
from random import shuffle
import pickle

MAX_LINE = 50000
MAX_TOKENS = 10000
DOWNSAMPLE = .34
#DOWNSAMPLE = 1.0

#Names from Full Reductions
#Java = 0.53
#Ruby = 0.87
#Haskell = 0.39
#English Wiki = 0.34

#Labelled Reductions
#Java = .74
#Haskell = .71
#Ruby = .74
#English = .51

#Labelled No Big Reductions
#Java =  0.66
#Haskell = 0.61
#Ruby = 0.88
#Wiki = 0.51

#No_big_equivalent
#Java = .16
#Haskell = .24
#Ruby = .17
#English Wki = .31

#Equivalent Reductions.
#Java = .14
#Haskell = .24
#Ruby = .14

#From http://stackoverflow.com/questions/1265665/python-check-if-a-string-represents-an-int-without-using-try-except
#Triptych
def RepresentsInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

#Read in the map from files to projects in a format of:
#Project1
#P1_file1 (integer)
#P1_file2 (integer)
#...
#Project2
#P2_file1 (integer)
#...
#etc.
def nonPickleLoad(input_file, directory, ending = ".java_ast.tokens"): #ending needs to be made use of if we add more langs.
    project_map = {}
    files = set()
    currentProject = ""
    with open(input_file, 'r') as f:
        for line in f:
            if(RepresentsInt(line)): #file_id
                files.add(directory + "/files/" + line.strip() + ending)
            else: #Project name
                if(currentProject != ""): #Add last project on
                    project_map[currentProject] = files
                    files = set()

                currentProject = line

    project_map[currentProject] = files #Add last project
    return project_map


#List of Lists -> int[0, len(part_files_list)]
#Return which of the lists in this list is smallest
#Selecting an eariler index if theirs a tie.
def getSmallestFold(part_files_list):
    minFold = sys.maxint
    minIndex = 0
    i = 0
    for item in part_files_list:
        #print("MinFold: " + str(minFold))
        if(len(item) < minFold):
            minFold = len(item)
            minIndex = i

        i += 1

    return minIndex


#Reduce the files considered in a project to a subset of them.
def selectRandomSubsample(baseList, fractionSampled):
    sampleSize = int(len(baseList)*fractionSampled)
    #Get random sample of a list for python: credit to answer on this question: 
    #http://stackoverflow.com/questions/6482889/get-random-sample-from-list-while-maintaining-ordering-of-items
    subSample = [baseList[i] for i in sorted(random.sample(xrange(len(baseList)), sampleSize)) ]
    return subSample

def selectRandomSubsampleInt(baseList, sampleSize):
    print("Sample Size:" + str(sampleSize))
    print("To Sample Size: " + str(len(baseList)))
    #Get random sample of a list for python: credit to answer on this question: 
    #http://stackoverflow.com/questions/6482889/get-random-sample-from-list-while-maintaining-ordering-of-items
    subSample = [baseList[i] for i in sorted(random.sample(xrange(len(baseList)), sampleSize)) ]
    return subSample

#Build smoother.
def buildSmoother(order):
    output = ""
    for i in range(1, order+1):
        output += "-kndiscount" + str(i) + " "
        #output += "-wbdiscount" + str(i) + " "
        #output += "-cdiscount" + str(i) + " .5 "
    return output

#Make sure all the data from before has been cleared out.
def clearFiles(input_dir):
    for nextFile in os.listdir(input_dir):
        if(nextFile.startswith("fold")):
            #print(nextFile)
            os.remove(input_dir + "/" + nextFile)

#This is a replacement for the cat function call
#that this code previously used.  Cat can fail when
#large numbers of files are used in the command.
#This method is more reliable.
def write_train_file(input_files, output_file):
    #print(input_files[0])
    print("Writing to " + output_file)
    #quit()
    with open(output_file, "w") as o:
        for t in input_files:
            #print(t)
            with open(t, "r") as i:
                temp = i.read()
                #print(temp)
                #if(len(temp) > MAX_LINE): #SRILM doesn't like it when the line is too long
                #    tokens = temp.split(' ') #If we have more than 10,000 tokens, split these 
                    #print(t)
                    #print(len(temp))
                    #print(len(tokens))
                #    for j in xrange(0, len(tokens), MAX_TOKENS):
                #        if(j + MAX_TOKENS < len(tokens)):
                #            o.write(' '.join(tokens[j: j + MAX_TOKENS]) + "\n")
                #        else:
                #            o.write(' '.join(tokens[j: len(tokens)]))
                #else:
                #    o.write(temp)
                o.write(temp)
            #quit()

def split(input_file_dir, fold_num, suffix):
    files_list = []
    file_dir = os.path.join(input_file_dir, 'files')
    for file in os.listdir(file_dir):
        if file.endswith(suffix):
            files_list.append((int(file[:file.find('.')]), os.path.join(file_dir, file)))

    files_list.sort()
    files_list = [file for id, file in files_list]

    files_number = len(files_list)

    part_files_number = files_number/fold_num
    left_files_number = files_number%fold_num

    part_files_list = []

    # multi-process
    last_end = 0
    for i in xrange(fold_num):
        start = last_end
        last_end = start + part_files_number
        if i < left_files_number:
            last_end += 1
        
        part_files_list.append(files_list[start:last_end])

    return part_files_list

#A reworked version of split that will divide the files up into training
#and test sets more randomly.
def random_split(input_file_dir, fold_num, suffix):
    print("Random split.")
    files_list = []
    file_dir = os.path.join(input_file_dir, 'files')
    for file in os.listdir(file_dir):
        if file.endswith(suffix):
            files_list.append((int(file[:file.find('.')]), os.path.join(file_dir, file)))


    files_list.sort()
    files_list = [file for id, file in files_list]

    #Try it with a shuffle
    shuffle(files_list)
    #for next in files_list:
    #    print(next)
    #quit()
    
    files_number = len(files_list)

    part_files_number = files_number/fold_num
    left_files_number = files_number%fold_num

    part_files_list = []

    # multi-process
    last_end = 0
    for i in xrange(fold_num):
        start = last_end
        last_end = start + part_files_number
        if i < left_files_number:
            last_end += 1

        part_files_list.append(files_list[start:last_end])

    return part_files_list  

#Return a list of all files (IDs in /files) for a project based on a map 
#created by our lexer.
def getAllFilesInProjects(projectDict, keys):
    files_list = []
    for k in keys:
        pFiles = projectDict[k]
        files_list += pFiles

    out = list(set(files_list)) #I was having a duplication problem here somehow...
    #print("Files Grabbed: " + str(len(out)))
    return out
    
#Random split doesn't make as much sense when breaking up at the project level.
#Use an approximate bin packing scheme:
#I.e. put the next project in the smallest bin...
def balancedProjectSplit(input_file_dir, fold_num, suffix, fromPickle=True):
    print("Balanced Project Split.")
    if(fromPickle):
        project_to_file_map = pickle.load(open(os.path.join(input_file_dir, "project_file_map.pickle"), "r"))
    else:
        project_to_file_map = nonPickleLoad(os.path.join(input_file_dir, "projectToFileMap.txt"), input_file_dir)
    #print(project_to_file_map)
    #quit()

    projects = project_to_file_map.keys()
    #Sort by size
    project_files = [(p, getAllFilesInProjects(project_to_file_map, [p])) for p in projects]
    #print(project_files[0][0])
    project_files = sorted(project_files, key = lambda pro: len(pro[1]), reverse = True)
    #for p in project_files:
    #    print(p[0])
    #quit()
    project_number = len(projects)
    print("Project count: " + str(project_number))
    assert(project_number >= fold_num)

    part_files_list = []
    for i in range(0, fold_num):
        part_files_list.append([])

    cur_fold = 0
    increasing = True

    #Add the next project in the list to the smallest current bin.
    for pro_tuple in project_files:
        #1. Get min index (if tie, select earliest in list)
        cur_fold = getSmallestFold(part_files_list)
        #2. Add pro_tuple to that list
        part_files_list[cur_fold] += pro_tuple[1]

    #The # of projects should not be too big, so just go over the training sets, back and
    #forth adding projects in order of decreasing size.
    #for pro_tuple in project_files:
    #   part_files_list[cur_fold] += pro_tuple[1]
    #   if(increasing):
    #       if(cur_fold == fold_num-1): #Reached end
    #           increasing = False
    #       else:
    #           cur_fold += 1
    #   else:
    #       if(cur_fold == 0): #Reached beginning again
    #           increasing = True
    #       else:
    #           cur_fold -= 1

    return part_files_list

def randomProjectSplit(input_file_dir, fold_num, suffix):
    print("Random project split.")
    project_to_file_map = pickle.load(open(os.path.join(input_file_dir, "project_file_map.pickle"), "r"))
    
    projects = project_to_file_map.keys()
    shuffle(projects)
    project_number = len(projects)
    assert(project_number >= fold_num)

    part_project_number = project_number/fold_num
    left_project_number = project_number%fold_num
    print("Part pro #: " + str(part_project_number))
    print("Left pro #: " + str(left_project_number))

    part_files_list = []

    # multi-process
    last_end = 0
    for i in xrange(fold_num):
        start = last_end
        last_end = start + part_project_number
        if i < left_project_number:
            last_end += 1
        print("Start: " + str(start))
        print("End: " + str(last_end))
        part_files_list.append(getAllFilesInProjects(project_to_file_map, projects[start:last_end]))

    return part_files_list

def create_fold(input_file_dir, fold_num, downSample, splitSelection):
    part_files_list = []
    if(splitSelection == 0):
        part_files_list = balancedProjectSplit(input_file_dir, fold_num, '.tokens') #Make test sets a balanced set of projects.
    elif(splitSelection == 1):
        part_files_list = randomProjectSplit(input_file_dir, fold_num, '.tokens') #Make test sets a random set of projects.
    elif(splitSelection == 2):
        part_files_list = random_split(input_file_dir, fold_num, '.tokens') #Use for english corpus
    elif(splitSelection == 3):
        part_files_list =  part_files_list = balancedProjectSplit(input_file_dir, fold_num, '.tokens', False) #Make test sets a balanced set of projects, determined from a non-pickle style format.

    #Not used in entropy calculations
    method_files_list = random_split(input_file_dir, fold_num, '.scope')

    #Look at a random fraction of the projects.
    #Problem, the data can become very small if we have a wide range of project sizes and are dividing the folds as such
    #Should we try to even out the # of files, i.e. take a random sample of only the bigger projects to make the file quota?
    #if(downSample != 1.0):
    #    print("Start sizes:")
    #    for p in part_files_list:
    #        print(str(len(p)))
    #    part_files_list = [selectRandomSubsample(nextFold, downSample) for nextFold in part_files_list]
    #    print("End sizes:")
    #    for p in part_files_list:
    #        print(str(len(p)))
    #    #quit()

    #Create a version that aims to create a balanced split of files (i.e. it downsamples more aggressively
    #in the big projects)
    if(downSample != 1.0):
        #0.Get the total number of files we have.
        #1.Get the number of files we need to reduce to.
        #2.Sort by size of fold from smallest to biggest, get the smallest.
        #3.If 10*This size is bigger than raw reductions across the board, then first reduce all folds to
        #this size.  Then downsample the rest evenly...
        #If it is smaller, check next biggest and do #2 if bigger, repeat until we find one that satisfies
        #Then, we only want to sample down on the bigger ones if 10* the smallest is too small
        totalFiles = sum(len(item) for item in part_files_list)
        targetSize = int(totalFiles * downSample)
        print("Total Files: " + str(totalFiles))
        print("Target Size: " + str(targetSize))
        part_files_list = sorted(part_files_list, key=lambda x: len(x))
        print("Start sizes:")
        for p in part_files_list:
            print(str(len(p)))

        part_files_sampled = []
        too_Small_Count = 0
        reducedSize = 0
        for i in range(0, len(part_files_list)):
            smallestSplit = len(part_files_list[i]) * len(part_files_list) #Add modifier for lost space before...
            #if(i < len(part_files_list) - 1): 
            #    for fold in part_files_list[:i]:
            #        change = len(part_files_list[i+1]) - len(fold)
            #        if(change > 0):
            #            smallestSplit += change
            #        else:
            #            break
            print("Smallest Split:" + str(smallestSplit))

            if(smallestSplit > targetSize):
                part_files_sampled += part_files_list[:i+1] #This seems to be needed in some cases and not in others???
                
                #This can can remove too much?  (It's okay as long as its in the same general size.)
                part_files_sampled += [selectRandomSubsampleInt(nextFold, len(part_files_list[i])) for nextFold in part_files_list[i+1:]]
                reducedSize = len(part_files_list[i])
                break
            else:
                too_Small_Count += 1
        
        print("Mid sizes:")
        for p in part_files_sampled:
            print(str(len(p)))
        
        newSize = sum(len(item) for item in part_files_sampled)
        leftToRemove = sum(len(item) for item in part_files_sampled) - targetSize
        print("New Total Size:" + str(newSize))
        print("Left to remove:" + str(leftToRemove))  
        if(leftToRemove > 0):      
            #Now, we remove an equal amount of files from each sample that is too big until we reach the % target.
            foldReduce = (leftToRemove)/(len(part_files_list) - too_Small_Count)
         
            #Do we need to add a check to make sure we don't reduce the big ones below our smallest ones? (Only small problem in Ruby....)
            part_files_list = part_files_sampled[:too_Small_Count] + [selectRandomSubsampleInt(nextFold, len(nextFold) - foldReduce) for nextFold in part_files_sampled[too_Small_Count:]]
        else:
            part_files_list = part_files_sampled
         
        print("End sizes:")
        for p in part_files_list:
            print(str(len(p)))

    for i in xrange(fold_num):
        train_files = []
        for j in xrange(fold_num):
            if j != i:
                train_files.extend(part_files_list[j])
        
        print >> open('%s/fold%d.test' % (input_file_dir, i), 'w'), '\n'.join(part_files_list[i])
        print >> open('%s/fold%d.scope' % (input_file_dir, i), 'w'), '\n'.join(method_files_list[i])
        #This is a problem.  Should do this manually.
        write_train_file(train_files, input_file_dir + "/fold" + str(i) + ".train")
        #os.system('cat %s > %s/fold%d.train' % (' '.join(train_files), input_file_dir, i))
        #print('cat %s > %s/fold%d.train' % (' '.join(train_files), input_file_dir, i))
        #quit()

def train(input_file_dir, fold_num, order, downSample, splitSelection):
    create_fold(input_file_dir, fold_num, downSample, splitSelection)
    
    pipes = [os.pipe() for i in xrange(fold_num)]

    
    for i in xrange(fold_num):
        pid = os.fork()
        if pid == 0:
            os.close(pipes[i][0])
            
            train_file = '%s/fold%d.train' % (input_file_dir, i)
            discountStr = buildSmoother(order)

            #Get vocab...
            print("~/mitlm-0.4.1/estimate-ngram -t %s -write-vocab %s.vocab" % (train_file, train_file))
            os.system("~/mitlm-0.4.1/estimate-ngram -t %s -write-vocab %s.vocab" % (train_file, train_file))
            #Alternative uses mitlm instead...
            print('~/mitlm-0.4.1/estimate-ngram -order %d -v %s.vocab -unk -smoothing ModKN -t %s -write-lm %s.%dgrams' % (order, train_file, train_file, train_file, order))
            os.system('~/mitlm-0.4.1/estimate-ngram -order %d -v %s.vocab -unk -smoothing ModKN -t %s -write-lm %s.%dgrams' % (order, train_file, train_file, train_file, order))

            #Using the berkeleylm as a base instead:
            #print("java -ea -mx1000m -server -cp ~/berkeleylm/src edu.berkeley.nlp.lm.io.MakeKneserNeyArpaFromText %d %s.%dgrams %s" % (order, train_file, order, train_file))
            #os.system("java -ea -mx1000m -server -cp ~/berkeleylm/src edu.berkeley.nlp.lm.io.MakeKneserNeyArpaFromText %d %s.%dgrams %s" % (order, train_file, order, train_file))

            #Original Srilm
            #print('./bin/ngram-count -text %s -lm %s.kn.lm.gz -order %d -unk -kndiscount -interpolate' % (train_file, train_file, order))
            #os.system('./bin/ngram-count -text %s -lm %s.kn.lm.gz -order %d -unk -kndiscount -interpolate' % (train_file, train_file, order))
            #print('./bin/ngram -lm %s.kn.lm.gz -unk -order %d -write-lm %s.%dgrams' % (train_file, order, train_file, order))
            #os.system('./bin/ngram -lm %s.kn.lm.gz -unk -order %d -write-lm %s.%dgrams' % (train_file, order, train_file, order))
            #os.system('rm %s.kn.lm.gz' % train_file)

            #Kenlm
            #print('~/kenlm/build/bin/lmplz -o %d --interpolate_unigrams 0 <% >%s.%dgrams'% (order, train_file, order))
            #os.system('lmplz -o %d --interpolate_unigrams 0 <%s >%s.%dgrams'% (order, train_file, train_file, order))
            sys.exit()
        else:
            os.close(pipes[i][1])
    
    for p in pipes:
        os.wait()


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print './files_train.py input_file_dir ngram_order [DownSample] [SplitSelection 0,1,2,3]'
        sys.exit(1)

    print("Start!.")
    input_file_dir = sys.argv[1]
    order = int(sys.argv[2])
    fold_num = 10
    downSample = 1.0
    splitSelection = 0
    
    
    if(len(sys.argv) >= 4):
        downSample = float(sys.argv[3])
        assert(downSample >= 0.0 and downSample <= 1.0)
        

    if(len(sys.argv) >= 5):
        splitSelection = int(sys.argv[4])
        assert(splitSelection in (0,1,2,3))

     
   
    clearFiles(input_file_dir) 
    train(input_file_dir, fold_num, order, downSample, splitSelection)
