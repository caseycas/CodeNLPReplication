#rm -r ../../LSTM_data/ruby_no_collapse_name
#mkdir ../../LSTM_data/ruby_no_collapse_name
#python ../cleanLexer.py ../../RubyCorpus *.rb ../../LSTM_data/ruby_no_collapse_name 0 name_literal 75000 1.0 --tri_split --no_cap

rm -r ../../LSTM_data/haskell_no_collapse_name
mkdir ../../LSTM_data/haskell_no_collapse_name
python ../cleanLexer.py ../../HaskellCorpus *.hs ../../LSTM_data/haskell_no_collapse_name 0 name_literal 75000 1.0 --tri_split --no_cap

rm -r ../../LSTM_data/clojure_no_collapse_name
mkdir ../../LSTM_data/clojure_no_collapse_name
python ../cleanLexer.py ../../ClojureCorpus *.clj ../../LSTM_data/clojure_no_collapse_name 0 name_literal 75000 1.0 --tri_split --no_cap

rm -r ../../LSTM_data/c_no_collapse_name
mkdir ../../LSTM_data/c_no_collapse_name
python ../cleanLexer.py ../../CCorpus *.c ../../LSTM_data/c_no_collapse_name 0 name_literal 75000 1.0 --tri_split --no_cap

rm -r ../../LSTM_data/diverse_java_no_collapse_name
mkdir ../../LSTM_data/diverse_java_no_collapse_name
python ../cleanLexer.py ../../DiverseJava *.java ../../LSTM_data/diverse_java_no_collapse_name 0 name_literal 75000 1.0 --metadata --tri_split --no_cap
