import sys
import os
import argparse
import Android
import re
import pickle

from lexerFileManagement import *
from clConfig import *


"""
Another lexer for source code designed to put it in the format
expected by tensorflow lstms.
Requirements: Handles code and natural language (starting with 
Java and English)
Replaces values with <UNK> (needs two passes) that fall outside
the main vocabulary, using a frequency cut off determined by
vocabulary size argument.
Goal is to keep it cleaner than simplePyLex became.
"""


parser = argparse.ArgumentParser(description="Lexer to convert corpora into a " +
                                  "tensorflow lstm friendly form.") 
parser.add_argument("input_dir",help = "Top level directory of project/" + 
                     "data directory.  Will process all files recursively down " + 
                     "from here.", action="store", type=str)
parser.add_argument("ext", help = "A regular expression for the extension"+
                     " of all files to process (e.g. *.java for all java files)."+
                     "If you have files of this type in your current directory, "+
                     "you can send the ext in surrounded by quotes, e.g. "+ 
                     "\"*.txt\" will be needed to avoided selecting " + 
                     "stopwords.txt in your shell.",
                     action="store", type = str)
parser.add_argument("output_dir", help = "The output directory where the" +
                     " results are stored.", action = "store", type = str)
parser.add_argument("collapse_type", help = "0,1,2,3,4 whether to replace str spaces with _," + 
                     "replace all strings with <str>, space the \"'s out, to "+ 
                     "collpase strings to <str> and numbers to a shrunken type"+
                     " <int>, <float>, etc.",action= "store", type  = int)
parser.add_argument("token_split", help = "What special modifications " +
                     "to make to the output [full, name, name_literal, closed]. " +
                     "Full reports the text as is.  Name removes stopwords " +
                     "and punctuation. Name_literal does the same as name, " +
                     "except it also keeps all string and number literals." +
                     "Finally, closed does the opposite of name, keeping only" +
                     "the closed category words.", action = "store", type = str)
parser.add_argument("max_vocab", help = "Maximum vocabulary size" +
                     "if < 0, we have an unlimited vocab size and replace" +
                     " nothing with <UNK>.", type = int)
parser.add_argument("corpus_fraction", help = "What percentage of the files" +
                    "do we include in the training, validation, and test sets."+
                    "Used to create corpora of comparable sizes if one is " +
                    "significantly larger than another. This is used only " +
                    "for cases where --tri_split is enabled.", 
                    action = "store",type = float, default = 1.0)
parser.add_argument("--tri_split", help = "Final output is stored in " +
                    " train/test/validation sets, with sizes determined "+ 
                    "by the values in ttv_splits in clConfig.py. When false"
                    "creates only one to one file maps.", action = "store_true")
parser.add_argument("--metadata", help = "Create a type information file " +
                    "for each lexed file. Note that we always create a map of" +
                    "file ids used to create the train/test/and validation " +
                    "sets, and the mapping of the file ideas to their original"+
                    "locations.", action = "store_true")
parser.add_argument("--metadata_light", help = "Creates an alternative type of "+
                    "metadata file, using the file name as base rather than the "+
                    "token id, and storing only the token and IsOpenCategory "+
                    "classifier.  (This is somewhat different in as the output "+
                    "isn't structured the same as the other versions.  I may "+
                    "consider revising the structure of the older versions to "+
                    "reflect the additional information here.", action="store_true")
parser.add_argument("--crossproject", help = "Only valid if we have --trisplit"+
                    " enabled, otherwise ignore it.  If that is true and we "+
                    "are lexing from source code projects, make sure that the"+
                    "choice of test files are distinct projects from the " +
                    "training set. That is, we randomly split our test set "+
                    "on the project rather than the file level.", 
                    action = "store_true")
parser.add_argument("--tree_sent", help = "When parsing constituency trees "+
                    "if this option is enabled then we guarantee one " +
                    "per line.  Has no effect for non-parse tree corpora.",
                    action = "store_true")

parser.add_argument("--mirror_corpus", help = "Sometimes we are processing "+
                    "a corpus in several different ways, but wish to have " +
                    "the equivalent files be split into the training and " +
                    "testing sets (such as comparing plain text with a tree " +
                    "based version).  This optional argument, takes a " +
                    "directory containing the output of another lexer and " +
                    "the pickle files stored there to reconstruct an " +
                    "equivalent split in the new corpus.  This option is " +
                    " only used when --tri-split option is enabled.",
                    action = "store", type = str)
parser.add_argument("--no_cap", help = "Generate an equivalent version of "+
                    "test, train, and valid split but with no vocabulary "+
                    "limit.  Requires --tri_split flag to be true, otherwise "+
                    "it does nothing.", action = "store_true")
parser.add_argument("--ast_simplify", help = "Used only when parsing an " +
                    "English Constituency Parse.  Replaces the types with" +
                    "only the simpliest prefix version.", action = "store_true")
parser.add_argument("--dedup", help = "When parsing a natural language text, "+
                    "select every other sentence.  Used for corpora where the "+
                    "initial processing lead to duplicated sentences.", 
                    action = "store_true")
#TODO: I should probably clean this up for all the different versions later,
#but at the moment I just want it as a hack for the Rosetta Code experiment.
parser.add_argument("--in_place", help="Place the files in the same directories"+
                    "that they came from (Note that this option ignores output dir). " +
                    "Currently only supported for code corpora.", action="store_true")
parser.add_argument("--collapse_name", help = "When parsing a code file, replace all "+
                     "the identifiers/Types (e.g. anything under the Token.Name " +
                     "categories) with their Pygments token.", action="store_true")
parser.add_argument("--retain_line", help="By default, the lexer removes blank lines "+
                    "from the files.  With retain_line, we keep the line numbers of "+
                    "the file.  Comments are removed, but the line alignment is still "+
                    "perserved. ", action="store_true")


args = parser.parse_args()

args.ext = args.ext.replace("\"", "") #Remove quotes


basePath = os.path.abspath(args.input_dir)

#Project -> file mapping
projectFiles = {} #String -> #List of Strings
reindexMap = {} #String -> int (file id)
#Functions defined in this corpus
corpusDefintions = {}
#counts of words
vocabulary = {}

#Count of Error tokens
errorCount = 0

fileList = getFilesToLex(basePath, args.ext)
#Guarantee an order
fileList = sorted(fileList)
print(fileList[0:10])
print(len(fileList))

#If this is a single file, set the basePath to the immediately above directory
if(os.path.isfile(basePath)):
    basePath, head = ntpath.split(basePath)

if(args.ext in TREE_TEXTS):
    (vocabulary, reindexMap, i) = \
        ProcessTreeCorpus(basePath, args, vocabulary, projectFiles)
elif(args.ext in NATURAL_LANGUAGE_EXTS):
    (vocabulary, reindexMap, i) = \
        ProcessNLCorpus(basePath, args, vocabulary, projectFiles)
else:
    (vocabulary, reindexMap, projectFiles, i) = ProcessCodeCorpus(fileList, basePath, 
                                                   errorCount, args,
                                                   vocabulary, projectFiles)   

maxID = i-1
if(args.ext in NATURAL_LANGUAGE_EXTS):
    out_ext = ".txt.tokens"
elif(args.ext not in TREE_TEXTS or args.ext == "*.mrg"):
    out_ext = "." + args.ext[2:] + ".tokens"
else: 
    out_ext = "." + args.ext[2:]

#Perform the vocabulary cutoff
print(len(vocabulary))
if(args.max_vocab < 0 or len(vocabulary) > args.max_vocab):
    non_unk = vocabCutoff(vocabulary, args.max_vocab)
    #Rewrite all files with UNK
    for fileID in range(0, maxID+1):
        replaceWithUNK(non_unk, args.output_dir, fileID, out_ext)

#Record mapping to original files and projects.
#if(args.output_dir.endswith("/")):
#    aboveOutputDir = "/".join(args.output_dir.split("/")[0:-2]) 
#else:
#    aboveOutputDir = "/".join(args.output_dir.split("/")[0:-1])
#pickle.dump(projectFiles, open(aboveOutputDir + "/project_file_map.pickle", "w"))
pickle.dump(projectFiles, open(os.path.join(args.output_dir, PM_FILE), "w"))
pickle.dump(reindexMap, open(os.path.join(args.output_dir, RI_FILE), "w"))


if(args.tri_split):
    createTriSplitCorpus(maxID,args,vocabulary,out_ext,reindexMap,
                         projectFiles,args.corpus_fraction,args.crossproject)
