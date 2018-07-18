#This script creates the Zipf frequency data for all the natural
#language versions of the corpora
#Rerun to double check that the most current Zipf is being used...

#Brown (Eng Small) (1-3)
python Freq.py ./LSTM_data/brown .*.txt.tokens ./NgramData/BrownUnigrams.csv 1
python Freq.py ./LSTM_data/brown .*.txt.tokens ./NgramData/BrownBigrams.csv 2
python Freq.py ./LSTM_data/brown .*.txt.tokens ./NgramData/BrownTrigrams.csv 3

#Eng Full (1-3)
python Freq.py ./LSTM_data/english .*.txt.tokens ./NgramData/EnglishUnigrams.csv 1
python Freq.py ./LSTM_data/english .*.txt.tokens ./NgramData/EnglishBigrams.csv 2
python Freq.py ./LSTM_data/english .*.txt.tokens ./NgramData/EnglishTrigrams.csv 3

#SciFi
python Freq.py ./LSTM_data/scifi .*.txt.tokens ./NgramData/SFUnigrams.csv 1
python Freq.py ./LSTM_data/scifi .*.txt.tokens ./NgramData/SFBigrams.csv 2
python Freq.py ./LSTM_data/scifi .*.txt.tokens ./NgramData/SFTrigrams.csv 3
# NASA Directives
python Freq.py ./LSTM_data/nasa .*.txt.tokens ./NgramData/NASAUnigrams.csv 1
python Freq.py ./LSTM_data/nasa .*.txt.tokens ./NgramData/NASABigrams.csv 2
python Freq.py ./LSTM_data/nasa .*.txt.tokens ./NgramData/NASATrigrams.csv 3
#Legal English
python Freq.py ./LSTM_data/law .*.txt.tokens ./NgramData/LEUnigrams.csv 1
python Freq.py ./LSTM_data/law .*.txt.tokens ./NgramData/LEBigrams.csv 2
python Freq.py ./LSTM_data/law .*.txt.tokens ./NgramData/LETrigrams.csv 3
#Shakespeare
python Freq.py ./LSTM_data/shakespeare .*.txt.tokens ./NgramData/SPUnigrams.csv 1
python Freq.py ./LSTM_data/shakespeare .*.txt.tokens ./NgramData/SPBigrams.csv 2
python Freq.py ./LSTM_data/shakespeare .*.txt.tokens ./NgramData/SPTrigrams.csv 3
#Recipes
python Freq.py ./LSTM_data/recipes .*.tokens ./NgramData/RecipeUnigrams.csv 1
python Freq.py ./LSTM_data/recipes .*.tokens ./NgramData/RecipeBigrams.csv 2
python Freq.py ./LSTM_data/recipes .*.tokens ./NgramData/RecipeTrigrams.csv 3
#CommitMessages (Ensure we build the zipf plots only of the sample)
python copyZipfSample.py LSTM_data/CommitMessagesSmall *.txt.tokens LSTM_data/CommitMessagesSmall/selectedFiles
python Freq.py ./LSTM_data/CommitMessagesSmall/selectedFiles .*.txt.tokens ./NgramData/CMSmallUnigrams.csv 1
python Freq.py ./LSTM_data/CommitMessagesSmall/selectedFiles .*.txt.tokens ./NgramData/CMSmallBigrams.csv 2
python Freq.py ./LSTM_data/CommitMessagesSmall/selectedFiles .*.txt.tokens ./NgramData/CMSmallTrigrams.csv 3


python Freq.py ./LSTM_data/english_names .*.tokens ./NgramData/NamesFull/EnglishNamesUnigram.csv 1
python Freq.py ./LSTM_data/english_names .*.tokens ./NgramData/NamesFull/EnglishNamesBigram.csv 2 
python Freq.py ./LSTM_data/english_names .*.tokens ./NgramData/NamesFull/EnglishNamesTrigram.csv 3

#EFL Corpora
python Freq.py  ./LSTM_data/gachon .*.txt.tokens  ./NgramData/EFL_GachonUnigrams.csv 1
python Freq.py  ./LSTM_data/gachon .*.txt.tokens   ./NgramData/EFL_GachonBigrams.csv 2
python Freq.py  ./LSTM_data/gachon .*.txt.tokens   ./NgramData/EFL_GachonTrigrams.csv 3

python Freq.py  ./LSTM_data/teccl .*.txt.tokens   ./NgramData/EFL_TECCLUnigrams.csv 1
python Freq.py  ./LSTM_data/teccl .*.txt.tokens   ./NgramData/EFL_TECCLBigrams.csv 2
python Freq.py  ./LSTM_data/teccl .*.txt.tokens  ./NgramData/EFL_TECCLTrigrams.csv 3

#Other Natural languages
python Freq.py ./LSTM_data/german_zipf .*.tokens ./NgramData/GermanUnigrams.csv 1
python Freq.py ./LSTM_data/german_zipf .*.tokens ./NgramData/GermanBigrams.csv 2
python Freq.py ./LSTM_data/german_zipf .*.tokens ./NgramData/GermanTrigrams.csv 3

python Freq.py ./LSTM_data/spanish_zipf .*.tokens ./NgramData/SpanishUnigrams.csv 1
python Freq.py ./LSTM_data/spanish_zipf .*.tokens ./NgramData/SpanishBigrams.csv 2
python Freq.py ./LSTM_data/spanish_zipf .*.tokens ./NgramData/SpanishTrigrams.csv 3
