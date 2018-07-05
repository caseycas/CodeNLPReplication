rm djava_no_collapse_smalllog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path djava_no_collapse_small --model small --save_path ./models/djava_no_collapse_small
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path djava_no_collapse_small --model small --save_path ./models/djava_no_collapse_small

#rm ruby_no_collapse_smalllog.txt
#CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path ruby_no_collapse_small --model small --save_path ./models/ruby_no_collapse_small
#CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path ruby_no_collapse_small --model small --save_path ./models/ruby_no_collapse_small

#rm haskell_no_collapse_smalllog.txt
#CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path haskell_no_collapse_small --model small --save_path ./models/haskell_no_collapse_small
#CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path haskell_no_collapse_small --model small --save_path ./models/haskell_no_collapse_small

#rm clojure_no_collapse_smalllog.txt
#CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path clojure_no_collapse_small --model small --save_path ./models/clojure_no_collapse_small
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path clojure_no_collapse_small --model small --save_path ./models/clojure_no_collapse_small

#rm c_no_collapse_smalllog.txt
#CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path c_no_collapse_small --model small --save_path ./models/c_no_collapse_small
#CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path c_no_collapse_small --model small --save_path ./models/c_no_collapse_small
