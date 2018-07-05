rm -r ../../LSTM_data/brown_parse_manual
mkdir ../../LSTM_data/brown_parse_manual
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/brown/ *.mrg ../../LSTM_data/brown_parse_manual 4 full 75000 1.0 --tree_sent --tri_split --ast_simplify

rm -r ../../LSTM_data/wsj_parse_manual
mkdir ../../LSTM_data/wsj_parse_manual
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/wsj/ *.mrg ../../LSTM_data/wsj_parse_manual 4 full 75000 1.0 --tree_sent --tri_split --ast_simplify

#These are the variants without the type reduction
rm -r ../../LSTM_data/brown_parse_manual_full_type
mkdir ../../LSTM_data/brown_parse_manual_full_type
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/brown/ *.mrg ../../LSTM_data/brown_parse_manual_full_type 0 full 75000 1.0 --tree_sent --tri_split

rm -r ../../LSTM_data/wsj_parse_manual_full_type
mkdir ../../LSTM_data/wsj_parse_manual_full_type
python ../cleanLexer.py ../../PennTreebank/Files/treebank_3/parsed/mrg/wsj/ *.mrg ../../LSTM_data/wsj_parse_manual_full_type 0 full 75000 1.0 --tree_sent --tri_split

#Java parse tree
