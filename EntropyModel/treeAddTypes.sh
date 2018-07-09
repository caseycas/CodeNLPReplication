#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_labelled_cache_entropy.csv
#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_no_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_labelled_no_cache_entropy.csv

#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_direct_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_direct_labelled_cache_entropy.csv
#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_direct_no_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_direct_labelled_no_cache_entropy.csv

#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_bigram_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_bigram_labelled_cache_entropy.csv
#python labelTreeEntropy.py data/tmp/lstm_compare/ngram/brown_parse_bigram_no_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/brown_parse_bigram_labelled_no_cache_entropy.csv


python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_bigram_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_bigram_labelled_cache_entropy.csv
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_bigram_no_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_bigram_labelled_no_cache_entropy.csv

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_labelled_cache_entropy.csv
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_no_cache_entropy.csv 2 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_labelled_no_cache_entropy.csv

#Not sure if I'm happy with what we're calling a stopword in the AST
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_no_cache_entropy.csv 2 ../lexer_stuff/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_labelled_small_no_cache_entropy.csv --java_code
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_cache_entropy.csv 2 ../lexer_stuff/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_labelled_small_cache_entropy.csv --java_code

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_bigram_no_cache_entropy.csv 2 ../lexer_stuff/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_labelled_small_bigram_no_cache_entropy.csv --java_code
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_bigram_cache_entropy.csv 2 ../lexer_stuff/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_labelled_small_bigram_cache_entropy.csv --java_code



#Lstms
python labelTreeEntropy.py data/tmp/lstm_compare/lstm/djava_ast_small_entropy.csv 0 ../lexer_stuff/javaKeywords.txt data/tmp/lstm_compare/lstm/djava_ast_labelled_small_entropy.csv --header --java_code
#python labelTreeEntropy.py data/tmp/lstm_compare/lstm/brown_parse_full_entropy.csv 0 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/lstm/brown_parse_labelled_full_entropy.csv --header
#python labelTreeEntropy.py data/tmp/lstm_compare/lstm/brown_parse_direct_entropy.csv 0 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/lstm/brown_parse_direct_labelled_full_entropy.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/lstm/eng_parse_manual_entropy.csv 0 ../lexer_stuff/stopwords.txt data/tmp/lstm_compare/lstm/eng_parse_manual_labelled_entropy.csv --header
