sh createDirs.sh

cp LSTM_data/clojure_no_collapse_name/train LSTM_data/clojure_no_collapse_name/test LSTM_data/clojure_no_collapse_name/valid clojure/no_collapse_names
python fixUnk.py clojure/no_collapse_names

cp LSTM_data/eng_all_parse_manual_full_type/train LSTM_data/eng_all_parse_manual_full_type/test LSTM_data/eng_all_parse_manual_full_type/valid eng_parse_manual/full_type
python fixUnk.py eng_parse_manual/full_type

cp LSTM_data/german/train LSTM_data/german/test LSTM_data/german/valid german/full
python fixUnk.py german/full

cp LSTM_data/CommitMessagesSmall/train LSTM_data/CommitMessagesSmall/test LSTM_data/CommitMessagesSmall/valid commits/full
python fixUnk.py commits/full

cp LSTM_data/diverse_java_small_no_collapse/train LSTM_data/diverse_java_small_no_collapse/test LSTM_data/diverse_java_small_no_collapse/valid djava/no_collapse_small
python fixUnk.py djava/no_collapse_small

cp LSTM_data/spanish/train LSTM_data/spanish/test LSTM_data/spanish/valid spanish/full
python fixUnk.py spanish/full

cp LSTM_data/haskell_no_collapse_name/train LSTM_data/haskell_no_collapse_name/test LSTM_data/haskell_no_collapse_name/valid haskell/no_collapse_names
python fixUnk.py haskell/no_collapse_names

cp LSTM_data/ruby_no_collapse/train LSTM_data/ruby_no_collapse/test LSTM_data/ruby_no_collapse/valid ruby/no_collapse
python fixUnk.py ruby/no_collapse

cp LSTM_data/english_names/train LSTM_data/english_names/test LSTM_data/english_names/valid eng/names
python fixUnk.py eng/names

cp LSTM_data/scifi/train LSTM_data/scifi/test LSTM_data/scifi/valid scifi/full
python fixUnk.py scifi/full

cp LSTM_data/shakespeare/train LSTM_data/shakespeare/test LSTM_data/shakespeare/valid shakespeare/full
python fixUnk.py shakespeare/full

cp LSTM_data/brown/train LSTM_data/brown/test LSTM_data/brown/valid brown/full
python fixUnk.py brown/full

cp LSTM_data/ruby_no_collapse_name/train LSTM_data/ruby_no_collapse_name/test LSTM_data/ruby_no_collapse_name/valid ruby/no_collapse_names
python fixUnk.py ruby/no_collapse_names

cp LSTM_data/java_ast/train_no_cap djava/ast/train
cp LSTM_data/java_ast/valid_no_cap djava/ast/valid
cp LSTM_data/java_ast/test_no_cap djava/ast/test
python fixUnk.py djava/ast

cp LSTM_data/java_ast/train_no_cap_text djava/train
cp LSTM_data/java_ast/valid_no_cap_text djava/valid
cp LSTM_data/java_ast/test_no_cap_text djava/test
python fixUnk.py djava

cp LSTM_data/brown_names/train LSTM_data/brown_names/test LSTM_data/brown_names/valid brown/names
python fixUnk.py brown/names

cp LSTM_data/haskell_no_collapse/train LSTM_data/haskell_no_collapse/test LSTM_data/haskell_no_collapse/valid haskell/no_collapse
python fixUnk.py haskell/no_collapse

cp LSTM_data/c_no_collapse/train LSTM_data/c_no_collapse/test LSTM_data/c_no_collapse/valid c/no_collapse
python fixUnk.py c/no_collapse

cp LSTM_data/teccl/train LSTM_data/teccl/test LSTM_data/teccl/valid teccl/full
python fixUnk.py teccl/full

cp LSTM_data/law/train LSTM_data/law/test LSTM_data/law/valid law/full
python fixUnk.py law/full

cp LSTM_data/diverse_java_no_collapse_name/train LSTM_data/diverse_java_no_collapse_name/test LSTM_data/diverse_java_no_collapse_name/valid djava/no_collapse_names
python fixUnk.py djava/no_collapse_names

cp LSTM_data/clojure_no_collapse/train LSTM_data/clojure_no_collapse/test LSTM_data/clojure_no_collapse/valid clojure/no_collapse
python fixUnk.py clojure/no_collapse

cp LSTM_data/eng_all_parse_manual/train LSTM_data/eng_all_parse_manual/test LSTM_data/eng_all_parse_manual/valid eng_parse_manual/simp_post
python fixUnk.py eng_parse_manual/simp_post

cp LSTM_data/eng_all_parse_manual/train_text eng_parse_manual/train
cp LSTM_data/eng_all_parse_manual/valid_text eng_parse_manual/valid
cp LSTM_data/eng_all_parse_manual/test_text eng_parse_manual/test
python fixUnk.py eng_parse_manual

cp LSTM_data/recipes/train LSTM_data/recipes/test LSTM_data/recipes/valid recipes/full
python fixUnk.py recipes/full

cp LSTM_data/nasa/train LSTM_data/nasa/test LSTM_data/nasa/valid nasa/full
python fixUnk.py nasa/full

cp LSTM_data/c_no_collapse_name/train LSTM_data/c_no_collapse_name/test LSTM_data/c_no_collapse_name/valid c/no_collapse_names
python fixUnk.py c/no_collapse_names

cp LSTM_data/english/train LSTM_data/english/test LSTM_data/english/valid eng/full
python fixUnk.py eng/full

cp LSTM_data/gachon/train LSTM_data/gachon/test LSTM_data/gachon/valid gachon/full
python fixUnk.py gachon/full

cp LSTM_data/diverse_java_no_collapse/train LSTM_data/diverse_java_no_collapse/test LSTM_data/diverse_java_no_collapse/valid djava/no_collapse
python fixUnk.py djava/no_collapse

ln LSTM_data/clojure_no_collapse_name/train LSTM_data/clojure_no_collapse_name/test LSTM_data/clojure_no_collapse_name/valid clojure_no_collapse_names
ln LSTM_data/eng_all_parse_manual_full_type/train LSTM_data/eng_all_parse_manual_full_type/test LSTM_data/eng_all_parse_manual_full_type/valid eng_parse_manual_full_type
ln LSTM_data/german/train LSTM_data/german/test LSTM_data/german/valid german
ln LSTM_data/CommitMessagesSmall/train LSTM_data/CommitMessagesSmall/test LSTM_data/CommitMessagesSmall/valid commits
ln LSTM_data/diverse_java_small_no_collapse/train LSTM_data/diverse_java_small_no_collapse/test LSTM_data/diverse_java_small_no_collapse/valid djava_no_collapse_small
ln LSTM_data/spanish/train LSTM_data/spanish/test LSTM_data/spanish/valid spanish
ln LSTM_data/haskell_no_collapse_name/train LSTM_data/haskell_no_collapse_name/test LSTM_data/haskell_no_collapse_name/valid haskell_no_collapse_names
ln LSTM_data/ruby_no_collapse/train LSTM_data/ruby_no_collapse/test LSTM_data/ruby_no_collapse/valid ruby_no_collapse
ln LSTM_data/english_names/train LSTM_data/english_names/test LSTM_data/english_names/valid eng_names
ln LSTM_data/scifi/train LSTM_data/scifi/test LSTM_data/scifi/valid scifi
ln LSTM_data/shakespeare/train LSTM_data/shakespeare/test LSTM_data/shakespeare/valid shakespeare
ln LSTM_data/brown/train LSTM_data/brown/test LSTM_data/brown/valid brown_data
ln LSTM_data/ruby_no_collapse_name/train LSTM_data/ruby_no_collapse_name/test LSTM_data/ruby_no_collapse_name/valid ruby_no_collapse_names
ln LSTM_data/java_ast/train LSTM_data/java_ast/test LSTM_data/java_ast/valid djava_ast
ln LSTM_data/java_ast/train_text djava_ast/train
ln LSTM_data/java_ast/valid_text djava_ast/valid
ln LSTM_data/java_ast/test_text djava_ast/test
ln LSTM_data/brown_names/train LSTM_data/brown_names/test LSTM_data/brown_names/valid brown_names
ln LSTM_data/haskell_no_collapse/train LSTM_data/haskell_no_collapse/test LSTM_data/haskell_no_collapse/valid haskell_no_collapse
ln LSTM_data/c_no_collapse/train LSTM_data/c_no_collapse/test LSTM_data/c_no_collapse/valid c_no_collapse
ln LSTM_data/teccl/train LSTM_data/teccl/test LSTM_data/teccl/valid teccl
ln LSTM_data/law/train LSTM_data/law/test LSTM_data/law/valid law
ln LSTM_data/diverse_java_no_collapse_name/train LSTM_data/diverse_java_no_collapse_name/test LSTM_data/diverse_java_no_collapse_name/valid djava_no_collapse_names
ln LSTM_data/clojure_no_collapse/train LSTM_data/clojure_no_collapse/test LSTM_data/clojure_no_collapse/valid clojure_no_collapse
ln LSTM_data/eng_all_parse_manual/train LSTM_data/eng_all_parse_manual/test LSTM_data/eng_all_parse_manual/valid eng_parse_manual
ln LSTM_data/eng_all_parse_manual/train_text eng_parse_manual/train
ln LSTM_data/eng_all_parse_manual/valid_text eng_parse_manual/valid
ln LSTM_data/eng_all_parse_manual/test_text eng_parse_manual/test
ln LSTM_data/recipes/train LSTM_data/recipes/test LSTM_data/recipes/valid recipes
ln LSTM_data/nasa/train LSTM_data/nasa/test LSTM_data/nasa/valid nasa
ln LSTM_data/c_no_collapse_name/train LSTM_data/c_no_collapse_name/test LSTM_data/c_no_collapse_name/valid c_no_collapse_names
ln LSTM_data/english/train LSTM_data/english/test LSTM_data/english/valid eng_data
ln LSTM_data/gachon/train LSTM_data/gachon/test LSTM_data/gachon/valid gachon
ln LSTM_data/diverse_java_no_collapse/train LSTM_data/diverse_java_no_collapse/test LSTM_data/diverse_java_no_collapse/valid djava_no_collapse
