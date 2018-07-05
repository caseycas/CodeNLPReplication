rm -r ../../LSTM_data/ruby/names
mkdir ../../LSTM_data/ruby/names
python ../cleanLexer.py ~/CodeNLP/RubyCorpus *.rb ~/CodeNLP/LSTM_data/ruby/names 4 name 75000 1.0 --tri_split
rm -r ../../LSTM_data/haskell/names
mkdir ../../LSTM_data/haskell/names
python ../cleanLexer.py ~/CodeNLP/HaskellCorpus *.hs ~/CodeNLP/LSTM_data/haskell/names 4 name 75000 1.0 --tri_split

#I need to check on the stats for this again...
rm -r ../../LSTM_data/clojure/names
mkdir ../../LSTM_data/clojure/names
python ../cleanLexer.py ~/CodeNLP/ClojureCorpus *.clj ~/CodeNLP/LSTM_data/clojure/names 4 name 75000 1.0 --tri_split

rm -r ../../LSTM_data/c/names
mkdir ../../LSTM_data/c/names
python ../cleanLexer.py ~/CodeNLP/CCorpus *.c ~/CodeNLP/LSTM_data/c/names 4 name 75000 1.0 --tri_split
