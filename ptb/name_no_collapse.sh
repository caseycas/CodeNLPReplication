rm ruby_no_collapse_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path ruby_no_collapse_names --model small --save_path ./models/ruby_no_collapse_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path ruby_no_collapse_names --model small --save_path ./models/ruby_no_collapse_names

rm haskell_no_collapse_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path haskell_no_collapse_names --model small --save_path ./models/haskell_no_collapse_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path haskell_no_collapse_names --model small --save_path ./models/haskell_no_collapse_names

rm clojure_no_collapse_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path clojure_no_collapse_names --model small --save_path ./models/clojure_no_collapse_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path clojure_no_collapse_names --model small --save_path ./models/clojure_no_collapse_names

rm djava_no_collapse_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path djava_no_collapse_names --model small --save_path ./models/djava_no_collapse_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path djava_no_collapse_names --model small --save_path ./models/djava_no_collapse_names

rm c_no_collapse_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path c_no_collapse_names --model small --save_path ./models/c_no_collapse_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path c_no_collapse_names --model small --save_path ./models/c_no_collapse_names
