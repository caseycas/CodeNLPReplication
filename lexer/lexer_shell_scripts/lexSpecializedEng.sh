rm -r ../../LSTM_data/law
mkdir ../../LSTM_data/law
python ../cleanLexer.py ../../SpecializedEnglishCorpora/LegalDocuments/USCodeText *.tokens ../../LSTM_data/law 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/nasa
mkdir ../../LSTM_data/nasa
python ../cleanLexer.py ../../SpecializedEnglishCorpora/Requirements/NASA_text *.tokens ../../LSTM_data/nasa 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/shakespeare
mkdir ../../LSTM_data/shakespeare
python ../cleanLexer.py ../../SpecializedEnglishCorpora/NotCodeLike/Shakespeare/lexed *.tokens ../../LSTM_data/shakespeare 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/scifi
mkdir ../../LSTM_data/scifi
python ../cleanLexer.py ../../SpecializedEnglishCorpora/NotCodeLike/GutenbergSF/texts "*.txt" ../../LSTM_data/scifi 4 full 75000 1.0 --tri_split

rm -r ../../LSTM_data/recipes
mkdir ../../LSTM_data/recipes
python ../cleanLexer.py ../../SpecializedEnglishCorpora/RecipeTokens/ *.tokens ../../LSTM_data/recipes 4 full 75000 .02 --tri_split

rm -r ../../LSTM_data/CommitMessagesSmall
mkdir ../../LSTM_data/CommitMessagesSmall
python ../cleanLexer.py ../../SpecializedEnglishCorpora/CommitsCorpus *.tokens ../../LSTM_data/CommitMessagesSmall 4 full 75000 .25 --tri_split
