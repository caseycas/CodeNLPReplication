rm -r ../../LSTM_data/teccl
mkdir ../../LSTM_data/teccl
python ../cleanLexer.py ../../EFLCorpus/GachonLexed *.tokens ../../LSTM_data/teccl 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/gachon
mkdir ../../LSTM_data/gachon
python ../cleanLexer.py ../../EFLCorpus/TECCL_Corpus_V1.1/TECCL_Lexed *.tokens ../../LSTM_data/gachon 4 full 75000 1.0 --tri_split
