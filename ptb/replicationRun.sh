#This script invokes all the subscripts to run the LSTM models
#for corpora included in the journal paper.  You may need to change
#the specifics of the GPU parameters depending on your set up.
#Note that running all of these sequentially will take a long time.
#Run the script in a detached screen.

#Natural Language Corpora
sh run_english.sh
sh run_german.sh
sh run_spanish.sh

#Code
sh run_no_collapse.sh
sh run_no_collapse_small.sh

#Code Open category words
sh name_no_collapse.sh

#Parse Trees
sh run_java_trees.sh
sh run_java_tree_texts.sh
sh run_eng_manual_trees.sh
sh run_eng_tree_texts.sh

#EFL
sh run_efl.sh

#Specialized English
sh run_specialEng.sh
