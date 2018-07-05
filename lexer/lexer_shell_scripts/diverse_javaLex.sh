rm -r ../../LSTM_data/diverse_java
mkdir ../../LSTM_data/diverse_java
python ../cleanLexer.py ~/CodeNLP/DiverseJava *.java /Users/caseycas/CodeNLP/LSTM_data/diverse_java 4 full 75000 1.0 --metadata --tri_split
rm -r ../../LSTM_data/diverse_java_small
mkdir ../../LSTM_data/diverse_java_small
python ../cleanLexer.py ~/CodeNLP/DiverseJava *.java /Users/caseycas/CodeNLP/LSTM_data/diverse_java_small 4 full 75000 0.07183056 --metadata --tri_split
rm -r ../../LSTM_data/diverse_java_names
mkdir ../../LSTM_data/diverse_java_names
python ../cleanLexer.py ~/CodeNLP/DiverseJava *.java /Users/caseycas/CodeNLP/LSTM_data/diverse_java_names 4 name 75000 1.0 --metadata --tri_split
rm -r ../../LSTM_data/diverse_java_small_names
mkdir ../../LSTM_data/diverse_java_small_names
python ../cleanLexer.py ~/CodeNLP/DiverseJava *.java /Users/caseycas/CodeNLP/LSTM_data/diverse_java_small_names 4 name 75000 0.07183056 --metadata --tri_split
