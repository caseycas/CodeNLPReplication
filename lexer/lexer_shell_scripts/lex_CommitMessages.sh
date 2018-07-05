rm -r ../../LSTM_data/CommitMessages
mkdir ../../LSTM_data/CommitMessages
python ../cleanLexer.py ../../CommitsCorpus *.tokens ../../LSTM_data/CommitMessages 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/CommitMessagesSmall
mkdir ../../LSTM_data/CommitMessagesSmall
python ../cleanLexer.py ../../CommitsCorpus *.tokens ../../LSTM_data/CommitMessagesSmall 4 full 75000 .25 --tri_split
