rm -r ../../LSTM_data/diverse_java_no_collapse
mkdir ../../LSTM_data/diverse_java_no_collapse
python ../cleanLexer.py ../../DiverseJava *.java ../../LSTM_data/diverse_java_no_collapse 0 full 75000 1.0 --metadata --tri_split

rm -r ../../LSTM_data/diverse_java_small_no_collapse
mkdir ../../LSTM_data/diverse_java_small_no_collapse
python ../cleanLexer.py ../../DiverseJava *.java ../../LSTM_data/diverse_java_small_no_collapse 0 full 75000 0.07183056 --metadata --tri_split

rm -r ../../LSTM_data/ruby_no_collapse
mkdir ../../LSTM_data/ruby_no_collapse
python ../cleanLexer.py ../../RubyCorpus *.rb ../../LSTM_data/ruby_no_collapse 0 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/haskell_no_collapse
mkdir ../../LSTM_data/haskell_no_collapse
python ../cleanLexer.py ../../HaskellCorpus *.hs ../../LSTM_data/haskell_no_collapse 0 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/clojure_no_collapse
mkdir ../../LSTM_data/clojure_no_collapse
python ../cleanLexer.py ../../ClojureCorpus *.clj ../../LSTM_data/clojure_no_collapse 0 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/c_no_collapse
mkdir ../../LSTM_data/c_no_collapse
python ../cleanLexer.py ../../CCorpus *.c ../../LSTM_data/c_no_collapse 0 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/ruby_small_no_collapse
mkdir ../../LSTM_data/ruby_small_no_collapse
python ../cleanLexer.py ../../RubyCorpus *.rb ../../LSTM_data/ruby_small_no_collapse 0 full 75000 0.08209681 --tri_split

rm -r ../../LSTM_data/haskell_small_no_collapse
mkdir ../../LSTM_data/haskell_small_no_collapse
python ../cleanLexer.py ../../HaskellCorpus *.hs ../../LSTM_data/haskell_small_no_collapse 0 full 75000 0.06809228 --tri_split

rm -r ../../LSTM_data/clojure_small_no_collapse
mkdir ../../LSTM_data/clojure_small_no_collapse
python ../cleanLexer.py ../../ClojureCorpus *.clj ../../LSTM_data/clojure_small_no_collapse 0 full 75000 0.09630582 --tri_split

rm -r ../../LSTM_data/c_small_no_collapse
mkdir ../../LSTM_data/c_small_no_collapse
python ../cleanLexer.py ../../CCorpus *.c ../../LSTM_data/c_small_no_collapse 0 full 75000 0.08703379 --tri_split
