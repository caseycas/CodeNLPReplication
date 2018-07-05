rm -r ../../LSTM_data/RubyClosed
mkdir ../../LSTM_data/RubyClosed
python ../cleanLexer.py ../../RubyCorpus *.rb ../../LSTM_data/RubyClosed 0 closed 75000 1.0

rm -r ../../LSTM_data/HaskellClosed
mkdir ../../LSTM_data/HaskellClosed
python ../cleanLexer.py ../../HaskellCorpus *.hs ../../LSTM_data/HaskellClosed 0 closed 75000 1.0

rm -r ../../LSTM_data/ClojureClosed
mkdir ../../LSTM_data/ClojureClosed
python ../cleanLexer.py ../../ClojureCorpus *.clj ../../LSTM_data/ClojureClosed 0 closed 75000 1.0

rm -r ../../LSTM_data/CClosed
mkdir ../../LSTM_data/CClosed
python ../cleanLexer.py ../../CCorpus *.c ../../LSTM_data/CClosed 0 closed 75000 1.0

rm -r ../../LSTM_data/DiverseJavaClosed
mkdir ../../LSTM_data/DiverseJavaClosed
python ../cleanLexer.py ../../DiverseJava *.java ../../LSTM_data/DiverseJavaClosed 0 closed 75000 1.0