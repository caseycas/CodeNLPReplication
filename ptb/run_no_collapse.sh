rm ruby_no_collapselog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path ruby_no_collapse --model small --save_path ./models/ruby_no_collapse
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path ruby_no_collapse --model small --save_path ./models/ruby_no_collapse

rm haskell_no_collapselog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path haskell_no_collapse --model small --save_path ./models/haskell_no_collapse
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path haskell_no_collapse --model small --save_path ./models/haskell_no_collapse

rm clojure_no_collapselog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path clojure_no_collapse --model small --save_path ./models/clojure_no_collapse
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path clojure_no_collapse --model small --save_path ./models/clojure_no_collapse

rm djava_no_collapselog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path djava_no_collapse --model small --save_path ./models/djava_no_collapse
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path djava_no_collapse --model small --save_path ./models/djava_no_collapse

rm c_no_collapselog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path c_no_collapse --model small --save_path ./models/c_no_collapse
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path c_no_collapse --model small --save_path ./models/c_no_collapse
