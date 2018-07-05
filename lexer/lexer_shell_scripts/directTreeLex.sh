rm -r ~/CodeNLP/LSTM_data/brown_parse_direct
mkdir ~/CodeNLP/LSTM_data/brown_parse_direct
python ../cleanLexer.py ~/CodeNLP/BrownCorpus/LexedCTreeDirect/ *.txt.tokens ~/CodeNLP/LSTM_data/brown_parse_direct 4 full 75000 1.0 --tree_sent
