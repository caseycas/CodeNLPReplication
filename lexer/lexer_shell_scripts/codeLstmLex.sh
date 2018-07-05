rm -r ../../LSTM_data/ruby
mkdir ../../LSTM_data/ruby
python ../cleanLexer.py ~/CodeNLP/RubyCorpus *.rb ~/CodeNLP/LSTM_data/ruby 4 full 75000 1.0 --tri_split
rm -r ../../LSTM_data/haskell
mkdir ../../LSTM_data/haskell
python ../cleanLexer.py ~/CodeNLP/HaskellCorpus *.hs ~/CodeNLP/LSTM_data/haskell 4 full 75000 1.0 --tri_split

#I need to check on the stats for this again...
rm -r ../../LSTM_data/clojure
mkdir ../../LSTM_data/clojure
python ../cleanLexer.py ~/CodeNLP/ClojureCorpus *.clj ~/CodeNLP/LSTM_data/clojure 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/c
mkdir ../../LSTM_data/c
python ../cleanLexer.py ~/CodeNLP/CCorpus *.c ~/CodeNLP/LSTM_data/c 4 full 75000 1.0 --tri_split
