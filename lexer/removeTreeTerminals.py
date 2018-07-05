import os
import argparse

#Set of tags used in stanford parser, thanks to:
#https://gist.github.com/nlothian/9240750
tag_set = ["ROOT","S", "SBAR", "SBARQ", "SINV", "SQ", "ADJP", "ADVP", "CONJP", "FRAG", "INTJ", "LST", "NAC", "NP", "NX", "PP",
           "PRN", "PRT", "QP", "RRC", "UCP", "VP", "WHADJP", "WHAVP", "WHNP", "WHPP", "X", "CC", "CD", "DT", "EX", "FW", "IN",
           "JJ", "JJR", "JJS", "LS", "MD", "NN", "NNS", "NNP", "NNPS", "PDT", "POS", "PRP", "PRP$", "RB", "RBR", "RBS", "RP", "SYM",
           "TO", "UH", "VB", "VBN", "VBD", "VBG", "VBP", "VBZ", "WDT", "WP", "WP$", "WP$", "WRB","ADV", "NOM","DTV", "LGS", "PRD", "PUT",
           "SBJ", "TPC", "VOC","BNF", "DIR","EXT", "LOC","MNR", "PRP", "TMP", "CLR", "SBAR-PRP","CLF", "HLN", "TTL","-LRB", "-RRB",
           "-NONE","*", "0", "T", "NUL", "-NONE-", "-LRB-", "-RRB-", "PRT|ADVP", "ADVP|PRT","#","NN|SYM","VBG|NN","RB|VBG","CD|RB",
           "VBP|TO","PRP|VBP","IN|RP","NN|NNS","JJ|VBG","RB|RP","NN|VBG","JJ|RB","TYPO","NEG","AUX","VBD|VBN","EDITED","WHADVP"]

punct = [",", ".", "\"", ",\"","'",";", ".\"", "-", "?", "--", ":", "!\"", "?\"", "!", "?--", ".--", "!--", "\'" ,"\'\'", "``", "`", "(", ")", "/", "&","<QUOTE>", "<", ">","$", "#"]


def tagJavaElement(item, last_type, last_token):
    item = item.strip()
    if(item == "(" or item == ")"):
        return "PAREN"
    elif(last_type == ""):
        return "TAG"
    elif(last_type == "PAREN"):
        return "TAG"
    elif(last_type == "TAG" and last_token.strip() == "#PunctTerminal"):
        return "PUNCT"
    else:
        return "WORD"


#Give a parse tree item one of 4 tags:
#PAREN, TAG, WORD, PUNCT
def tagEngElement(item, last):
    item = item.strip()
    simplified_item = item
    #simplify the english types for comparison with our set.
    if("-" in item and not item.startswith("-")):
        simplified_item = item.split("-")[0]
    elif("=" in item):
        simplified_item = item.split("=")[0]

    #Quick-Fix (I don't know why it does this)
    if(simplified_item in ["NP=1", "NP=2", "NP=3"]):
        simplified_item = "NP"

    if(item == "(" or item == ")"):
        return "PAREN"
    elif(simplified_item in tag_set):
        if(last == "PAREN"):
            return "TAG"
    elif(simplified_item in punct):
        if(last == "PAREN"):
            return "TAG"
        else:
            return "PUNCT"
    else:
        return "WORD"

parser = argparse.ArgumentParser(description="Script to filter parse trees to just nonterminals") 
parser.add_argument("input_dir",help = "Location of the train, valid, and test files.", 
                    action="store", type=str)
parser.add_argument("output_dir",help = "Where to put the new train, valid, and test files.", 
                    action="store", type=str)
parser.add_argument("--java_code", help = "Is this a java ast instead of an "+
                    "english parse tree.", action = "store_true")


args = parser.parse_args()
f_base = ["train", "valid", "test"]

in_files = [os.path.join(args.input_dir, f_type) for f_type in f_base]
out_files = [os.path.join(args.output_dir, f_type) for f_type in f_base]

for i in range(0, 3):
    with open(in_files[i], "r") as f:
        with open(out_files[i], "w") as f2:
            for line in f:
                new_line = []
                tokens = line.split()
                last_token = "" #Nothing to start
                token_type = ""
                for t in tokens:
                    print(t)
                    print(tagEngElement(t, token_type))
                    
                    if(args.java_code == True):
                        token_type = tagJavaElement(t, token_type, last_token)
                    else:
                        token_type = tagEngElement(t, token_type)
                   
                    if(token_type in ["PAREN", "TAG"]):
                        new_line.append(t)
                    last_token = t
                    
                f2.write(" ".join(new_line) + "\n")
