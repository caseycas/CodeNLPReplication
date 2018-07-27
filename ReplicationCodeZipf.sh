#This shell script generates Zipf frequency datasets
#relating to plots for the code corpora that appeared in the paper. 
mkdir -p ./NgramData/no_collapse
mkdir -p ./NgramData/no_collapse_small

python Freq.py ./LSTM_data/diverse_java_no_collapse .*.java.tokens ./NgramData/no_collapse/DJavaUnigrams.csv 1
python Freq.py ./LSTM_data/ruby_no_collapse .*.rb.tokens ./NgramData/no_collapse/RubyUnigrams.csv 1
python Freq.py ./LSTM_data/c_no_collapse .*.c.tokens ./NgramData/no_collapse/CUnigrams.csv 1
python Freq.py ./LSTM_data/haskell_no_collapse .*.hs.tokens ./NgramData/no_collapse/HaskellUnigrams.csv 1
python Freq.py ./LSTM_data/clojure_no_collapse .*.clj.tokens ./NgramData/no_collapse/ClojureUnigrams.csv 1

python Freq.py ./LSTM_data/diverse_java_no_collapse .*.java.tokens ./NgramData/no_collapse/DJavaBigrams.csv 2
python Freq.py ./LSTM_data/ruby_no_collapse .*.rb.tokens ./NgramData/no_collapse/RubyBigrams.csv 2
python Freq.py ./LSTM_data/c_no_collapse .*.c.tokens ./NgramData/no_collapse/CBigrams.csv 2
python Freq.py ./LSTM_data/haskell_no_collapse .*.hs.tokens ./NgramData/no_collapse/HaskellBigrams.csv 2
python Freq.py ./LSTM_data/clojure_no_collapse .*.clj.tokens ./NgramData/no_collapse/ClojureBigrams.csv 2

python Freq.py ./LSTM_data/diverse_java_no_collapse .*.java.tokens ./NgramData/no_collapse/DJavaTrigrams.csv 3
python Freq.py ./LSTM_data/ruby_no_collapse .*.rb.tokens ./NgramData/no_collapse/RubyTrigrams.csv 3 
python Freq.py ./LSTM_data/c_no_collapse .*.c.tokens ./NgramData/no_collapse/CTrigrams.csv 3 
python Freq.py ./LSTM_data/haskell_no_collapse .*.hs.tokens ./NgramData/no_collapse/HaskellTrigrams.csv 3 
python Freq.py ./LSTM_data/clojure_no_collapse .*.clj.tokens ./NgramData/no_collapse/ClojureTrigrams.csv 3

python Freq.py ./LSTM_data/diverse_java_no_collapse_name .*.java.tokens ./NgramData/no_collapse/DJavaNameUnigrams.csv 1
python Freq.py ./LSTM_data/ruby_no_collapse_name .*.rb.tokens ./NgramData/no_collapse/RubyNameUnigrams.csv 1
python Freq.py ./LSTM_data/c_no_collapse_name .*.c.tokens ./NgramData/no_collapse/CNameUnigrams.csv 1
python Freq.py ./LSTM_data/haskell_no_collapse_name .*.hs.tokens ./NgramData/no_collapse/HaskellNameUnigrams.csv 1
python Freq.py ./LSTM_data/clojure_no_collapse_name .*.clj.tokens ./NgramData/no_collapse/ClojureNameUnigrams.csv 1

python Freq.py ./LSTM_data/diverse_java_no_collapse_name .*.java.tokens ./NgramData/no_collapse/DJavaNameBigrams.csv 2
python Freq.py ./LSTM_data/ruby_no_collapse_name .*.rb.tokens ./NgramData/no_collapse/RubyNameBigrams.csv 2
python Freq.py ./LSTM_data/c_no_collapse_name .*.c.tokens ./NgramData/no_collapse/CNameBigrams.csv 2
python Freq.py ./LSTM_data/haskell_no_collapse_name .*.hs.tokens ./NgramData/no_collapse/HaskellNameBigrams.csv 2
python Freq.py ./LSTM_data/clojure_no_collapse_name .*.clj.tokens ./NgramData/no_collapse/ClojureNameBigrams.csv 2

python Freq.py ./LSTM_data/diverse_java_no_collapse_name .*.java.tokens ./NgramData/no_collapse/DJavaNameTrigrams.csv 3
python Freq.py ./LSTM_data/ruby_no_collapse_name .*.rb.tokens ./NgramData/no_collapse/RubyNameTrigrams.csv 3 
python Freq.py ./LSTM_data/c_no_collapse_name .*.c.tokens ./NgramData/no_collapse/CNameTrigrams.csv 3 
python Freq.py ./LSTM_data/haskell_no_collapse_name .*.hs.tokens ./NgramData/no_collapse/HaskellNameTrigrams.csv 3 
python Freq.py ./LSTM_data/clojure_no_collapse_name .*.clj.tokens ./NgramData/no_collapse/ClojureNameTrigrams.csv 3

#Ensure we copy only from the sample.
python copyZipfSample.py LSTM_data/diverse_java_small_no_collapse .java.tokens LSTM_data/diverse_java_small_no_collapse/selectedFiles
python Freq.py ./LSTM_data/diverse_java_small_no_collapse/selectedFiles .*.java.tokens ./NgramData/no_collapse_small/DJavaUnigrams.csv 1
python Freq.py ./LSTM_data/diverse_java_small_no_collapse/selectedFiles  .*.java.tokens ./NgramData/no_collapse_small/DJavaBigrams.csv 2
python Freq.py ./LSTM_data/diverse_java_small_no_collapse/selectedFiles  .*.java.tokens ./NgramData/no_collapse_small/DJavaTrigrams.csv 3
