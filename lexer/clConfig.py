#test, train, validate splits
splits = {"test" : .15, "train": .7, "validate" : .15}
#What file to use when English "name" is requested.
stopwordsFile = "stopwords2.txt" #"stopwords.txt"

MIRROR_ERROR = "mirror_errors.txt"

SPLIT_FILE = "split_map.pickle"
PM_FILE = "project_file_map.pickle"
RI_FILE = "reindex.pickle"

#Refers to the expected file name in to be created
#in a prior step for transformed files that are still
#semantically equivalent to the original corpus we wish
#to mirror.
MIRROR_FILE = "mirror_corpus.pickle"

#File to indicate any errors that happened during lexing
logFile = "error.log"


#SPACING FLAG IDs
NO_BLANKS = 0 #Default, remove blank lines
ORIGINAL = 1 #Retain the original line numbers of the file
SINGLE_LINE = 2 #Collapse the whole file onto 1 line