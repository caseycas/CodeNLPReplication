import argparse
import os
import sys

parser = argparse.ArgumentParser(description="Generate scripts to call all the ngram models used in the paper.") 
parser.add_argument("out_dir",help = "Location of your output directory for the R scripts.", action="store", type=str)

args = parser.parse_args()
output_dir = args.out_dir


mainFile = "replicateNgram.sh"
subFiles = ["run_english.sh", "run_otherNls.sh", "run_no_collapseCode.sh", "run_noCollapseNames.sh",
            "run_trees.sh", "run_tree_text.sh", "run_specializedEng.sh", "run_efl.sh"]

permutations = {}
permutations["run_english.sh"] = {"brown" : ["full", "names"], "eng" : ["full", "names"]}
permutations["run_otherNls.sh"] = {"german" : ["full"], "spanish" : ["full"]}
permutations["run_no_collapseCode.sh"] = {"ruby" : ["no_collapse"], "haskell" : ["no_collapse"], "clojure" : ["no_collapse"],"djava" : ["no_collapse", "no_collapse_small"], "c" : ["no_collapse"]}
permutations["run_no_collapseNames.sh"] = {"ruby" : ["no_collapse_names"], "haskell" : ["no_collapse_names"], "clojure" : ["no_collapse_names"],"djava" : ["no_collapse_names"], "c" : ["no_collapse_names"]}
permutations["run_trees.sh"] = {"eng_parse_manual" : ["simp_post", "full_type"], "djava" : ["ast"]}
permutations["run_tree_text.sh"] = {"eng_parse_manual" : ["text"], "djava" : ["text"]}
permutations["run_specializedEng.sh"] = {"recipes" : ["full"], "nasa" : ["full"], "law" : ["full"], "scifi" : ["full"], "shakespeare" : ["full"], "commits" : ["full"]}
permutations["run_efl.sh"] = {"gachon" : ["full"], "teccl" : ["full"]}

ngramOrder = {}
ngramOrder["run_trees.sh"] = 7

#Create data directories set up script (Moved to set up section)
#with open("createDirs.sh", 'w') as f_setup:
#    f_setup.write("mkdir -p data/lstm_comparable\n")
#    for file, c_perm in permutations.iteritems():
#        for corpora, variants in c_perm.iteritems():
#            for variant in variants:
#                f_setup.write("mkdir -p data/lstm_comparable/%s/%s\n" % (corpora, variant))

with open("run_all.sh", 'w') as f_main:
    f_main.write("mkdir -p %s\n\n" % (output_dir))
    for file, c_perm in permutations.iteritems():
        #print(file)
        #print(c_perm)
        f_main.write("sh %s\n" % (file))
        with open(file, 'w') as f:
            for corpora, variants in c_perm.iteritems():
                for variant in variants:
                    fileVariant = variant
                    if(variant != ""): #Handle cases with no additional label..
                        fileVariant =  fileVariant + "_"

                    order = 3
                    if(file in ngramOrder):
                        order = ngramOrder[file]
                    f.write("python bin/lstmComparableTrain.py data/lstm_comparable/%s/%s train valid %d\n" % (corpora, variant, order))
                    f.write("python bin/lstmComparableTest.py data/lstm_comparable/%s/%s train_valid test %d \"-ENTROPY -BACKOFF -DEBUG -FILES\"\n" % (corpora, variant, order))
                    f.write("mkdir -p results/entropy/lstm_compare/%s/%s\n" % (corpora, variant))
                    f.write("cp data/lstm_comparable/%s/%s/test.output results/entropy/lstm_compare/%s/%s/no_cache.output\n" % (corpora, variant, corpora, variant))
                    f.write("cp data/lstm_comparable/%s/%s/test.output %s/%s_%sno_cache_entropy.csv\n" % (corpora, variant, output_dir, corpora, fileVariant))
                    f.write("python bin/lstmComparableTest.py data/lstm_comparable/%s/%s train_valid test %d \"-ENTROPY -BACKOFF -DEBUG -CACHE -CACHE_ORDER 10 -CACHE_DYNAMIC_LAMBDA -WINDOW_CACHE -WINDOW_SIZE 5000 -FILES\"\n" % (corpora, variant, order))
                    f.write("cp data/lstm_comparable/%s/%s/test.output results/entropy/lstm_compare/%s/%s/cache_entropy.csv\n" % (corpora, variant, corpora, variant))
                    f.write("cp data/lstm_comparable/%s/%s/test.output %s/%s_%scache_entropy.csv\n" % (corpora, variant, output_dir, corpora, fileVariant))
                    f.write("\n")
