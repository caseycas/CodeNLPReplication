rm -r ../../LSTM_data/brown
mkdir ../../LSTM_data/brown
python ../cleanLexer.py ../../BrownCorpus/brown_raw/ *.text ../../LSTM_data/brown 4 full 75000 1.0 --tri_split
rm -r ../../LSTM_data/english
mkdir ../../LSTM_data/english
python ../cleanLexer.py ../../EnglishSample/all *.tokens ../../LSTM_data/english 4 full 75000 1.0 --tri_split
rm -r ../../LSTM_data/brown_names
mkdir ../../LSTM_data/brown_names
python ../cleanLexer.py ../../BrownCorpus/brown_raw/ *.text ../../LSTM_data/brown_names 4 name 75000 1.0 --tri_split
rm -r ../../LSTM_data/english_names
mkdir ../../LSTM_data/english_names
python ../cleanLexer.py ../../EnglishSample/all *.tokens ../../LSTM_data/english_names 4 name 75000 1.0 --tri_split --no_cap
