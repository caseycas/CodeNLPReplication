rm germanlog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path german --model small --save_path ./models/german
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path german --model small --save_path ./models/german
