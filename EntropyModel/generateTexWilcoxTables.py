import os
import numpy as np
import sys

captionTech = "Summary of non-parametric effect sizes and 99\% confidence intervals (in bits) comparing each technical and non-technical corpus with Brown and then Java.  Numbers are marked with * if $p < .05$, ** if $p < .01$, *** if $p < .001$ from a Mann Whitney U test."
captionEfl = "Summary of non-parametric effect sizes and 99\% confidence intervals (in bits) comparing each code corpus with Java and Brown.  Numbers are marked with * if $p < .05$, ** if $p < .01$, *** if $p < .001$ from a Mann Whitney U test."
captionName = "Summary of non-parametric effect sizes and 99\% confidence intervals (in bits) comparing the open category words of English with those of several programming languages.  Numbers are marked with * if $p < .05$, ** if $p < .01$, *** if $p < .001$ from a Mann Whitney U test."
captionEngCode = "Summary of non-parametric effect sizes and 99\% confidence intervals (in bits) comparing each code corpus with English a baseline.  Numbers are marked with * if $p < .05$, ** if $p < .01$, *** if $p < .001$ from a Mann Whitney U test."
captionModel = "Summary of non-parametric effect sizes and 99\% confidence intervals (in bits) comparing the locality effects of the cache in each language.   Numbers are marked with * if $p < .05$, ** if $p < .01$, *** if $p < .001$ from a paired Mann Whitney U test."

class texTable:
    def __init__(self, caption, colNames, rowNames, indexMap):
        self.caption = caption
        self.colNames = colNames
        self.rowNames = rowNames
        self.indexMap = indexMap

def parseWilcoxBlock(Routput):
    '''
    Given a block of wilcox output from my r script,
    convert into a tuple of relevant pieces for that
    row in the table.

    Parameters:
    -----------

    Routput - A segment of the Routput for one table entry (one call of printWilcox)

    Returns:
    --------
    ((corpus_model1), (corpus_model2), conf int string, effectSizeString) - a name for the corpus
    covered, the model used for both, the confidence interval set to 3 digits, and the effect size
    string (e.g. .422^{***})
    Model name may sometimes be inferred by the indexMap in buildTable, so if
    its not there, just leave model1/2 blank.
    '''

    corpus_model1 = ""
    corpus_model2 = ""
    pValue = -1
    nameLine = False
    pLine = False
    effLine = False
    confLine = False
    confNext = False

    for line in Routput.split("\n"):
        pieces = line.split()
        if(line.startswith("One sided test")):
            assert(not nameLine)
            nameLine = True
            corpus_model1 = pieces[3]
            corpus_model2 = pieces[5]
        elif(line.startswith("Z = ") and not pLine): #Pulls the one-sided p-value
            pLine = True
            pValue = float(pieces[5])
        elif(line.startswith("Non-parametric effect size:") and not effLine):
            assert(not effLine)
            effLine = True
            effSize = float(pieces[3])
        elif(line.startswith("99 percent confidence interval:")):
            assert(not confLine)
            confLine = True
            confNext = True
        elif(confNext):
            confNext = False
            interval = (float(pieces[0]), float(pieces[1]))

    #Arrange into the correct format:
    #1.Convert p to * format (and reverse if we were measuring in the wrong directory)
    # i.e. p = 1 is ***
    #2 Flip confidence interval if necessary
    flip = False
    confString = ""
    if(pValue >= .95):
        flip = True
        if(pValue >= .999):
            confString = "***"
        elif(pValue >= .99):
            confString = "**"
        else:
            confString = "*"
    elif(pValue <= .05):
        if(pValue <= .001):
            confString = "***"
        elif(pValue <= .01):
            confString = "**"
        else:
            confString = "*"

    if(flip):
        interval = (-interval[1], -interval[0])

    #print(corpus_model1)
    #print(corpus_model2)
    #print("(" + str(np.around(interval[0], 3)) + ", " + str(np.around(interval[1], 3)) + ")")
    #print(str(np.around(effSize, 3)))

    return(corpus_model1, corpus_model2, 
           "(" + str(np.around(interval[0], 3)) + ", " + str(np.around(interval[1], 3)) + ")",
           "$" + str(abs(np.around(effSize, 3))) + "^{" + confString + "}$")


def getRow(rowID, indexMap, contentMap, colLength, rowType):
    """
    Parameters:
    rowID - Which row in the table this is
    indexMap - (row, col) -> indexID
    contentMap - indexID -> content
    colLength = number of columns
    rowType = "CONF" or "EFF" (confidence interval vs effect size row)
    """
    #print(rowID)
    indexOrder = [-1]*(colLength-1) #Skip the first column
    for cell, indexID in indexMap.iteritems():
        if(cell[0] == rowID):
            indexOrder[cell[1]] = indexID #Max sure our columns are in the right order.

    #print(indexMap)
    #print(contentMap)
    #print(indexOrder)
    rowString = ""
    for indexID in indexOrder:
        (name1, name2, confString, effString) = contentMap[indexID]
        if(rowType == "CONF"):
            rowString += " & " + confString
        else:
            rowString += " & " + effString

    return rowString




def buildTable(name, colNames, rowNames, indexMap, Routput, caption):
    '''
    Convert the R wilcox text output into a tex table
    with rows for the confidence interval and effect size represented
    with the *, **, *** notation.  (Assumes Routput begins and ends with
    a <table> and </table>)
    Parameters:
    -----------
    name - a string of \label name of the table

    colnames - A list of the names of the columns

    rowNames - A list of the names of rows

    indexMap - a list of tuples indicating where the numbers from each segment
    should in the table (row, col).  This requires awareness of the order they
    were printed in the R output (include a sanity check on the names too?)

    Routput - a string of this table's R output

    caption - The caption to create for the table 

    Returns:
    --------
    String of a tex table
    '''

    contentMap = {}
    subR = ""
    segmentID = 0
    for line in Routput.split("\n"):
        subR += line + "\n"
        if(line.startswith("Non-parametric effect size:")):
            #print("---Single Block---")
            #print(subR)
            #print("---Single Block---")
            (name1, name2, confString, effString) = parseWilcoxBlock(subR)
            subR = ""
            contentMap[segmentID] = (name1, name2, confString, effString)
            segmentID += 1


    tableText = "\\begin{table*}\n"
    tableText += "\\centering\n"
    tableText += "\\caption{%s}" % (caption) + "\n"
    tableText += "\\begin{tabular}{%s}" % ("| c |" + (" c " * (len(colNames) - 1)) + "|")+ "\n"
    tableText += "\\hline\n"
    #print(colNames)
    tableText += "&".join(colNames) + "\\\\ \\hline\n"
    rowID = 0
    for rN in rowNames:
        tableText += "\\multirow{2}{*}{%s} %s \\\\ " % (rN, getRow(rowID, indexMap, contentMap, len(colNames) ,"CONF"))+ "\n"
        tableText += "%s  \\\\ \\hline" % (getRow(rowID, indexMap, contentMap,len(colNames),"EFF"))+ "\n"
        rowID += 1
    tableText += "\\end{tabular}\n"
    tableText += "\\label{%s}" % (name)+ "\n"
    tableText += "\\end{table*}\n"

    return tableText

def convertListToDict(rows, cols, t_list):
    t_dict = {}
    k = 0
    #print(len(rows))
    #print(len(cols))
    #print(len(t_list))
    for i in range(0, len(rows)):
        for j in range(0, len(cols)-1): #Skip the name column
            t_dict[(i, j)] = t_list[k]
            k += 1

    return(t_dict)


try:
    lstmMainFile = sys.argv[1]
    lstmUnMatchedFile = sys.argv[2]
except:
    print("python generateTexWilcoxTable.py <lstmMainFile> <lstmUnMatchedFile>")
    quit()

#Table Generation List
#Name Table
#Code Model Table
#Code Vs Eng Table
#Tech Table (Vs Eng and Vs Java) -> Double check the formating on this one
#EFL Table (Vs Eng and VS Java) ""
# + The LSTM Unmatched Parse (tab:TerminalEntComp)
#Index Map (row, col) -> spot in R script
tableRef = {} 

nameCols =["Language \\textless  English", "Ngram", "Cache", "LSTM"] #Leaves out second column 
nameRows = ["Java", "C", "Clojure", "Ruby", "Haskell"]
nameList = [0, 5, 10, 1, 6, 11, 2, 7, 12, 3, 8, 13, 4, 9, 14]
#print("Name")
nameIM = convertListToDict(nameRows, nameCols, nameList)
tableRef["tab:EngCodeNameEffect"] = (captionName, nameCols, nameRows, nameIM)

#No lstm change
#tableRef["tab:modelEffect"] = (captionModel, modelCols, modelRows, modelIM)

engCodeCols =["Language \\textless  English", "Ngram", "Cache", "LSTM"] #Leaves out second column 
engCodeRows = ["German", "Spanish", "Java", "C", "Clojure", "Ruby", "Haskell"]
#engCodeList = [0, 5, 10, 1, 6, 11, 2, 7, 12, 3, 8, 13, 4, 9, 14]
engCodeList = [0,7,14,1,8,15,2,9,16,3,10,17,4,11,18,5,12,19,6,13,20]
#print("EngCode")
engCodeIM = convertListToDict(engCodeRows, engCodeCols, engCodeList)
tableRef["tab:EngCodeEffect"] = (captionEngCode, engCodeCols, engCodeRows, engCodeIM)

#in order by moving right to left top to bottom
techCols =["Brown \\textgreater Language", "Ngram", "Cache", "LSTM"] #Leaves out second column 
techRows = ["Java", "NASA", "Science Fiction", "US Code", "Shakespeare", "Recipes", "Commits"]*2
#Pre-recipe
#techList = [0, 5, 10, 1, 6, 11, 2, 7, 12, 3, 8, 13, 4, 9, 14, 
#            15, 20, 25, 16, 21, 26, 17, 22, 27, 18, 23, 28, 19, 24, 29]
#Some Haskell to generate (consider reimplementing in a python variation
#6 - dimensions of tech Rows
#3 - dimensions of # language models
#foldr (++) [] ((map (\i -> take 3 (iterate (+6) i))) (take 6 (iterate (+1) 0)))
#foldr (++) [] ((map (\i -> take 3 (iterate (+6) i))) (take 6 (iterate (+1) 18)))
#techList = [0,6,12,1,7,13,2,8,14,3,9,15,4,10,16,5,11,17,
#            18,24,30,19,25,31,20,26,32,21,27,33,22,28,34,23,29,35]
#With commits too.
#foldr (++) [] ((map (\i -> take 3 (iterate (+7) i))) (take 7 (iterate (+1) 0)))
#foldr (++) [] ((map (\i -> take 3 (iterate (+7) i))) (take 7 (iterate (+1) 21)))
techList =             [0,7,14,1,8,15,2,9,16,3,10,17,4,11,18,5,12,19,6,13,20,
            21,28,35,22,29,36,23,30,37,24,31,38,25,32,39,26,33,40,27,34,41]
#print("Tech")
techIM = convertListToDict(techRows, techCols, techList)

tableRef["tab:JavaBrownTechEff"] = (captionTech, techCols, techRows, techIM)

eflCols =["Language \\textgreater  Java (Small)", "Ngram", "Cache", "LSTM"] #Leaves out second column 
eflRows = ["Java", "Gachon", "TECCL"]*2
#print("Efl")
eflList = [0, 3, 6, 1, 4, 7, 2, 5, 8,
           9, 12, 15, 10, 13, 16, 11, 14, 17]
eflIM = convertListToDict(eflRows, eflCols, eflList)
tableRef["tab:JavaBrownLangProficiency"] = (captionEfl, eflCols, eflRows, eflIM)

with open(lstmMainFile, 'r') as f:
    tableRaw = ""
    inTable = False
    for line in f:
        if(line[0] == "<" and line[1] != "\\"):
            inTable = True
            if(line.startswith("<NameTable>") or line.startswith("<NameLiteralTable>")):
                name = "tab:EngCodeNameEffect"
            elif(line.startswith("<CodeModelTable>")):
                name = "tab:modelEffect" # May drop the LSTM part
            elif(line.startswith("<CodeVsEngTable>")):
                name = "tab:EngCodeEffect"
            elif(line.startswith("<TechTable>")):
                name = "tab:JavaBrownTechEff"
            elif(line.startswith("<EFLTable>")):
                name = "tab:JavaBrownLangProficiency"
            elif(line.startswith("<CodeModelTable2>")):
                name = "tab:modelEffect" #Ignore results for now.
            else:
                print(line)
                print("Unsupported Table Name")
                assert(0)
        elif(line.startswith("<\\")):
            if(name != "tab:modelEffect"): #Skip this one for now
                (caption, colNames, rowNames, indexMap) = tableRef[name]
                #print("---Raw---")
                #print(tableRaw)
                #print("---Raw---")
                print(name)
                print(buildTable(name, colNames, rowNames, indexMap, tableRaw, caption))
            inTable = False
            tableRaw = ""
        elif(inTable):
            tableRaw += line #(Check if this is needed)

print("Done!")
#Just do this one manually
#with open(lstmUnMatchedFile, 'r') as f:
#    TODO
