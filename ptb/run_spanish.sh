rm spanishlog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path spanish --model small --save_path ./models/spanish
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path spanish --model small --save_path ./models/spanish
