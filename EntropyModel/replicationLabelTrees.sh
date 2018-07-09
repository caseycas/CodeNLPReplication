#Labelling scripts:

#English lstm script
python labelTreeEntropy.py data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_small_entropy.csv 0 ../lexer/stopwords.txt data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_small_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_small_entropy.csv 0 ../lexer/stopwords.txt data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_small_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_med_entropy.csv 0 ../lexer/stopwords.txt data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_med_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_med_entropy.csv 0 ../lexer/stopwords.txt data/tmp/lstm_compare/lstm/eng_parse_manual_full_type_med_entropy_labelled.csv --header




#English ngram
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_no_cache_entropy.csv 2 ../lexer/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_no_cache_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_no_cache_entropy.csv 2 ../lexer/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_no_cache_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_cache_entropy.csv 2 ../lexer/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_cache_entropy_labelled.csv --header

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_cache_entropy.csv 2 ../lexer/stopwords.txt data/tmp/lstm_compare/ngram/eng_parse_manual_full_type_cache_entropy_labelled.csv --header

#Java lstm
python labelTreeEntropy.py data/tmp/lstm_compare/lstm/djava_ast_small_entropy.csv 0 ../lexer/javaKeywords.txt data/tmp/lstm_compare/lstm/djava_ast_small_entropy_labelled.csv --header --java_code

python labelTreeEntropy.py data/tmp/lstm_compare/lstm/djava_ast_med_entropy.csv 0 ../lexer/javaKeywords.txt data/tmp/lstm_compare/lstm/djava_ast_med_entropy_labelled.csv --header --java_code


#Java ngram
python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_no_cache_entropy.csv 2 ../lexer/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_small_no_cache_entropy_labelled.csv --header --java_code

python labelTreeEntropy.py data/tmp/lstm_compare/ngram/djava_ast_small_cache_entropy.csv 2 ../lexer/javaKeywords.txt data/tmp/lstm_compare/ngram/djava_ast_small_cache_entropy_labelled.csv --header --java_code
