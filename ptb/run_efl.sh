rm gachonlog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path gachon --model small --save_path ./models/gachon
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path gachon --model small --save_path ./models/gachon

rm teccllog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path teccl --model small --save_path ./models/teccl
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path teccl --model small --save_path ./models/teccl
