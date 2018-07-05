import csv

in_files = ["./data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_no_cache_entropy.csv", 
            "./data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_cache_entropy.csv", 
            "./data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_smalllog.txt", 
            "./data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_medlog.txt"]

out_files = ["./data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_no_cache_entropy.csv",
             "./data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_cache_entropy.csv", 
             "./data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_smalllog.csv", 
             "./data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_medlog.csv"]

def simplifyType(token):
    if("-" in token and not token.startswith("-")):
        return token.split("-")[0]
    elif("=" in token):
        return token.split("=")[0]
    else:
        return token


for next_in, next_out in zip(in_files,out_files):
    with open(next_in, 'r') as f:
        with open(next_out, 'w') as f2:
        csvreader = csv.reader(f, delimiter = ",", quotechar='\"')
        csvwriter = csv.writer(f, delimiter = ",", quotechar='\"')
        if(next_in.endswith(".txt")): #Add header to the lstm versions.
            csvwriter.writerow(["token","lstm_entropy"])
        for row in csvreader:
            csvwriter.writerow([simplifyType(row[0]), row[1]])
            