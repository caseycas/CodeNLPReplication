#Create the English parse trees with type simplication.
rm -r ../../LSTM_data/brown_parse_manual
mkdir ../../LSTM_data/brown_parse_manual
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/brown/ *.mrg ../../LSTM_data/brown_parse_manual 4 full 75000 1.0 --tree_sent --tri_split --ast_simplify

rm -r ../../LSTM_data/wsj_parse_manual
mkdir ../../LSTM_data/wsj_parse_manual
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/wsj/ *.mrg ../../LSTM_data/wsj_parse_manual 4 full 75000 1.0 --tree_sent --tri_split --ast_simplify

#Merge the trees
rm -r ../../LSTM_data/eng_all_parse_manual
mkdir ../../LSTM_data/eng_all_parse_manual
mkdir -p ../../LSTM_data/eng_all_parse_manual/brown
mkdir -p ../../LSTM_data/eng_all_parse_manual/wsj
cp ../../LSTM_data/brown_parse_manual/train ../../LSTM_data/brown_parse_manual/valid ../../LSTM_data/brown_parse_manual/test ../../LSTM_data/eng_all_parse_manual/brown
cp ../../LSTM_data/wsj_parse_manual/train ../../LSTM_data/wsj_parse_manual/valid ../../LSTM_data/wsj_parse_manual/test ../../LSTM_data/eng_all_parse_manual/wsj
python ../mergeTrees.py ../../LSTM_data/eng_all_parse_manual

#Create the equivalent text only corpus
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual/valid ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual/valid_text 
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual/train ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual/train_text 
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual/test ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual/test_text 


#These are the variants without the type reduction
rm -r ../../LSTM_data/brown_parse_manual_full_type
mkdir ../../LSTM_data/brown_parse_manual_full_type
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/brown/ *.mrg ../../LSTM_data/brown_parse_manual_full_type 0 full 75000 1.0 --tree_sent --tri_split

rm -r ../../LSTM_data/wsj_parse_manual_full_type
mkdir ../../LSTM_data/wsj_parse_manual_full_type
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/wsj/ *.mrg ../../LSTM_data/wsj_parse_manual_full_type 0 full 75000 1.0 --tree_sent --tri_split

#Merge the trees
rm -r ../../LSTM_data/eng_all_parse_manual_full_type
mkdir ../../LSTM_data/eng_all_parse_manual_full_type
cp ../../LSTM_data/brown_parse_manual/train ../../LSTM_data/brown_parse_manual/valid ../../LSTM_data/brown_parse_manual/test ../../LSTM_data/eng_all_parse_manual_full_type/brown
cp ../../LSTM_data/wsj_parse_manual/train ../../LSTM_data/wsj_parse_manual/valid ../../LSTM_data/wsj_parse_manual/test ../../LSTM_data/eng_all_parse_manual_full_type/wsj
python ../mergeTrees.py ../../LSTM_data/eng_all_parse_manual_full_type

#Create the equivalent text only corpus
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual_full_type/valid ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual_full_type/valid_text 
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual_full_type/train ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual_full_type/train_text
python ../reduceTreeToText.py ../../LSTM_data/eng_all_parse_manual_full_type/test ../lexer_stuff/stopwords.txt ../../LSTM_data/eng_all_parse_manual_full_type/test_text

#Lex the Java modified parse tree.  We create an equivalent version of the test/train/valid files with no vocabulary cap for
#the ngram models.  Without it, the corpus is too repetitive for kenlm to process.
rm -r ../../LSTM_data/java_ast
mkdir ../../LSTM_data/java_ast
python ../cleanLexer.py ../../AST_out *.java_ast.tokens ../../LSTM_data/java_ast 4 full 75000 0.1347948 --tri_split --no_cap

#Create the equivalent text only corpus
python reduceTreeToText.py ../../LSTM_data/java_ast/test ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/test_text --java_code
python reduceTreeToText.py ../../LSTM_data/java_ast/test_no_cap ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/test_no_cap_text --java_code

python reduceTreeToText.py ../../LSTM_data/java_ast/train ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/train_text --java_code
python reduceTreeToText.py ../../LSTM_data/java_ast/train_no_cap ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/train_no_cap_text --java_code

python reduceTreeToText.py ../../LSTM_data/java_ast/valid ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/valid_text --java_code
python reduceTreeToText.py ../../LSTM_data/java_ast/valid_no_cap ../lexer_stuff/stopwords.txt ../../LSTM_data/java_ast/valid_no_cap_text --java_code
