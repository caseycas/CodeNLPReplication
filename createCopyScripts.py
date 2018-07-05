import argparse
import os
import sys

parser = argparse.ArgumentParser(description="Generate scripts to link/copy to the tensorflow and kenlm libaries.") 
parser.add_argument("src_dir", help = "Location of the src data directory with the lexed corpora.", action="store", type=str)
parser.add_argument("ngram_out_dir",help = "Location of of the data directories for the ngram models.", action="store", type=str)
parser.add_argument("lstm_out_dir",help = "Location of of the data directories for the ptb lstm models.", action="store", type=str)

args = parser.parse_args()
ngram_out = args.ngram_out_dir
lstm_out = args.lstm_out_dir
src_dir = args.src_dir

mainFile = "copyData.sh"
subFiles = ["copy_english.sh", "copy_otherNls.sh", "copy_no_collapseCode.sh", "copy_noCollapseNames.sh",
            "copy_trees.sh", "copy_tree_text.sh", "copy_specializedEng.sh", "copy_efl.sh"]

ngramMap = {}
ngramMap["clojure_no_collapse"] = "clojure/no_collapse"
ngramMap["clojure_no_collapse_name"] = "clojure/no_collapse_names"
ngramMap["c_no_collapse"] = "c/no_collapse"
ngramMap["c_no_collapse_name"] = "c/no_collapse_names"
ngramMap["diverse_java_no_collapse"] = "djava/no_collapse"
ngramMap["diverse_java_no_collapse_name"] = "djava/no_collapse_names"
ngramMap["diverse_java_small_no_collapse"] = "djava/no_collapse_small"
ngramMap["ruby_no_collapse"] = "ruby/no_collapse"
ngramMap["ruby_no_collapse_name"] = "ruby/no_collapse_names"
ngramMap["haskell_no_collapse"] = "haskell/no_collapse"
ngramMap["haskell_no_collapse_name"] = "haskell/no_collapse_names"

ngramMap["spanish"] = "spanish/full"
ngramMap["german"] = "german/full"
ngramMap["english"] = "eng/full"
ngramMap["english_names"] = "eng/names"
ngramMap["brown"] = "brown/full"
ngramMap["brown_names"] = "brown/names"


ngramMap["eng_all_parse_manual"] = "eng_parse_manual/simp_post"
ngramMap["eng_all_parse_manual_full_type"] = "eng_parse_manual/full_type"
ngramMap["java_ast"] = "djava/ast"

ngramMap["scifi"] = "scifi/full"
ngramMap["shakespeare"] = "shakespeare/full"
ngramMap["nasa"] = "nasa/full"
ngramMap["law"] = "law/full"
ngramMap["recipes"] = "recipes/full"
ngramMap["CommitMessagesSmall"] = "commits/full"

ngramMap["teccl"] = "teccl/full"
ngramMap["gachon"] = "gachon/full"

#TODO Tree Texts



#LSTM texts
lstmMap = {}
lstmMap["clojure_no_collapse"] = "clojure_no_collapse"
lstmMap["clojure_no_collapse_name"] = "clojure_no_collapse_names"
lstmMap["c_no_collapse"] = "c_no_collapse"
lstmMap["c_no_collapse_name"] = "c_no_collapse_names"
lstmMap["diverse_java_no_collapse"] = "djava_no_collapse"
lstmMap["diverse_java_no_collapse_name"] = "djava_no_collapse_names"
lstmMap["diverse_java_small_no_collapse"] = "djava_no_collapse_small"
lstmMap["ruby_no_collapse"] = "ruby_no_collapse"
lstmMap["ruby_no_collapse_name"] = "ruby_no_collapse_names"
lstmMap["haskell_no_collapse"] = "haskell_no_collapse"
lstmMap["haskell_no_collapse_name"] = "haskell_no_collapse_names"

lstmMap["spanish"] = "spanish"
lstmMap["german"] = "german"
lstmMap["english"] = "eng_data"
lstmMap["english_names"] = "eng_names"
lstmMap["brown"] = "brown_data"
lstmMap["brown_names"] = "brown_names"


lstmMap["eng_all_parse_manual"] = "eng_parse_manual"
lstmMap["eng_all_parse_manual_full_type"] = "eng_parse_manual_full_type"
lstmMap["java_ast"] = "djava/ast"

lstmMap["scifi"] = "scifi"
lstmMap["shakespeare"] = "shakespeare"
lstmMap["nasa"] = "nasa"
lstmMap["law"] = "law"
lstmMap["recipes"] = "recipes"
lstmMap["CommitMessagesSmall"] = "commits"

lstmMap["teccl"] = "teccl"
lstmMap["gachon"] = "gachon"


#TODO tree texts


#Create data directories set up script
with open("createDirs.sh", 'w') as f_setup:
    f_setup.write("mkdir -p %s\n" % (ngram_out))
    f_setup.write("mkdir -p %s\n\n" % (lstm_out))
    for src, dest in ngramMap.iteritems():
        f_setup.write("mkdir -p %s/%s\n" % (ngram_out, dest))

    f_setup.write("\n")

    for src, dest in lstmMap.iteritems():
        f_setup.write("mkdir -p %s/%s\n" % (lstm_out, dest))

with open("copyData.sh", 'w') as f_main:
    f_main.write("sh createDirs.sh\n\n")
    for src, dest in ngramMap.iteritems():
        src = os.path.join(src_dir, src)
        f_main.write("cp %s/train %s/test %s/valid %s\n" % (src, src, src, dest))
        #Fix Unk is necessary to run with kenlm. (Make sure to put it in the top level directory)
        f_main.write("python fixUnk.py %s\n\n" % (dest))
    for src, dest in lstmMap.iteritems():
        f_main.write("ln %s/train %s/test %s/valid %s\n" % (src, src, src, dest))
