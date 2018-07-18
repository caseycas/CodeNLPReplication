import csv

#This is a quick-fix script to map the log names to the entropy.csv files
#It just changes the names to what we expected + adds a header.

#Log name -> csv name
nameMap = {}
nameMap["brown_datalog.txt"] = "brown_full_entropy.csv"
nameMap["brown_nameslog.txt"] = "brown_names_entropy.csv"
nameMap["c_nameslog.txt"] = "c_names_entropy.csv"
nameMap["clog.txt"] = "c_full_entropy.csv"
nameMap["clojure_nameslog.txt"] = "clojure_names_entropy.csv"
nameMap["clojurelog.txt"] = "clojure_full_entropy.csv"
nameMap["djava_datalog.txt"] = "djava_full_entropy.csv"
nameMap["djava_names_smalllog.txt"] = "djava_names_small_entropy.csv"
nameMap["djava_nameslog.txt"] = "djava_names_entropy.csv"
nameMap["djava_smalllog.txt"] = "djava_small_entropy.csv"
nameMap["eng_datalog.txt"] = "eng_full_entropy.csv"
nameMap["germanlog.txt"] = "german_full_entropy.csv"
nameMap["spanishlog.txt"] = "spanish_full_entropy.csv"
nameMap["eng_nameslog.txt"] = "eng_names_entropy.csv"
nameMap["gachonlog.txt"] = "gachon_full_entropy.csv"
nameMap["haskell_nameslog.txt"] = "haskell_names_entropy.csv"
nameMap["haskelllog.txt"] = "haskell_full_entropy.csv"
nameMap["lawlog.txt"] = "law_full_entropy.csv"
nameMap["nasalog.txt"] = "nasa_full_entropy.csv"
nameMap["recipeslog.txt"] = "recipes_full_entropy.csv"
nameMap["recipes_biglog.txt"] = "recipes_big_full_entropy.csv"
nameMap["ruby_nameslog.txt"] = "ruby_names_entropy.csv"
nameMap["rubylog.txt"] = "ruby_full_entropy.csv"
nameMap["scifilog.txt"] = "scifi_full_entropy.csv"
nameMap["shakespearelog.txt"] = "shakespeare_full_entropy.csv"
nameMap["teccllog.txt"] = "teccl_full_entropy.csv"
nameMap["commitslog.txt"] = "commits_full_entropy.csv"

nameMap["djava_no_collapselog.txt"] = "djava_no_collapse_entropy.csv"
nameMap["djava_no_collapse_nameslog.txt"] = "djava_no_collapse_names_entropy.csv"
nameMap["djava_no_collapse_smalllog.txt"] = "djava_no_collapse_small_entropy.csv"

nameMap["ruby_no_collapselog.txt"] = "ruby_no_collapse_entropy.csv"
nameMap["ruby_no_collapse_nameslog.txt"] = "ruby_no_collapse_names_entropy.csv"
nameMap["ruby_no_collapse_smalllog.txt"] = "ruby_no_collapse_small_entropy.csv"

nameMap["clojure_no_collapselog.txt"] = "clojure_no_collapse_entropy.csv"
nameMap["clojure_no_collapse_nameslog.txt"] = "clojure_no_collapse_names_entropy.csv"
nameMap["clojure_no_collapse_smalllog.txt"] = "clojure_no_collapse_small_entropy.csv"

nameMap["haskell_no_collapselog.txt"] = "haskell_no_collapse_entropy.csv"
nameMap["haskell_no_collapse_nameslog.txt"] = "haskell_no_collapse_names_entropy.csv"
nameMap["haskell_no_collapse_smalllog.txt"] = "haskell_no_collapse_small_entropy.csv"

nameMap["c_no_collapselog.txt"] = "c_no_collapse_entropy.csv"
nameMap["c_no_collapse_nameslog.txt"] = "c_no_collapse_names_entropy.csv"
nameMap["c_no_collapse_smalllog.txt"] = "c_no_collapse_small_entropy.csv"

nameMap["djava_ast_smalllog.txt"] = "djava_ast_small_entropy.csv"
nameMap["djava_ast_medlog.txt"] = "djava_ast_med_entropy.csv"
nameMap["djava_ast_text_smalllog.txt"] = "djava_ast_text_small_entropy.csv"
nameMap["djava_ast_text_medlog.txt"] = "djava_ast_text_med_entropy.csv"

nameMap["eng_parse_manual_smalllog.txt"] = "eng_parse_manual_simp_post_small_entropy.csv"
nameMap["eng_parse_manual_medlog.txt"] = "eng_parse_manual_simp_post_med_entropy.csv"
nameMap["eng_parse_text_smalllog.txt"] = "eng_parse_text_small_entropy.csv"
nameMap["eng_parse_text_medlog.txt"] = "eng_parse_text_med_entropy.csv"

nameMap["eng_parse_manual_full_type_medlog.txt"] = "eng_parse_manual_full_type_med_entropy.csv"
nameMap["eng_parse_manual_full_type_smalllog.txt"] = "eng_parse_manual_full_type_small_entropy.csv"

#nameMap["eng_parse_manual_nt_smalllog.txt"] = "eng_parse_manual_small_nt_entropy.csv"
#nameMap["eng_parse_manual_full_type_nt_smalllog.txt"] = "eng_parse_manual_full_small_nt_entropy.csv"
#nameMap["djava_ast_nt_smalllog.txt"] = "djava_ast_small_nt_entropy.csv"

#nameMap["eng_parse_manual_nt_medlog.txt"] = "eng_parse_manual_med_nt_entropy.csv"
#nameMap["eng_parse_manual_full_type_nt_medlog.txt"] = "eng_parse_manual_full_med_nt_entropy.csv"
#nameMap["djava_ast_nt_medlog.txt"] = "djava_ast_med_nt_entropy.csv"

for log_name, csv_name in nameMap.iteritems():
    with open(log_name, 'r') as in_file:
        with open(csv_name, 'w') as out_file:
            out_file.write("word,lstm_entropy\n")
            writer = csv.writer(out_file, delimiter = ",", quotechar="\"")
            if("_nt_" not in csv_name):
                writer.writerow(["<start>", "NA"]) #Account for the shift
                #if(log_name != "c_nameslog.txt"): #C had a 1 token first line = only shifts 1 (this is no longer true?
            if(log_name != "haskell_no_collapse_nameslog.txt"): #Haskell has a shift of 1
                writer.writerow(["<start>", "NA"])
            priorline = in_file.readline()
            currentline = in_file.readline()
            for line in in_file:
                writer.writerow(priorline.strip().split(","))
                priorline = currentline
                currentline = line

            #Then ignore the last line of the file (we're representing it where it belongs in position 2 with an NA)
