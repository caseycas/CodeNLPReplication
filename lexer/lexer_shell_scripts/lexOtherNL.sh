#Goal of reduction was to get a corpus of around 17 million tokens (comparable to the others)
rm -r ../../LSTM_data/german
mkdir ../../LSTM_data/german
#python ../cleanLexer.py ../../Conll/GermanSplit/ *.tokens ../../LSTM_data/german 4 full 75000 0.6556283 --tri_split --dedup
python ../cleanLexer.py ../../Conll/GermanSplit/ *.tokens ../../LSTM_data/german 4 full 75000 0.6271292 --tri_split --dedup --no_cap
#python ../cleanLexer.py ../../Conll/GermanSample/ *.tokens ../../LSTM_data/german 4 full 75000 1.0 --tri_split --dedup

rm -r ../../LSTM_data/spanish
mkdir ../../LSTM_data/spanish
python ../cleanLexer.py ../../Conll/SpanishSplit/ *.tokens ../../LSTM_data/spanish 4 full 75000 0.4260058 --tri_split --dedup --no_cap
