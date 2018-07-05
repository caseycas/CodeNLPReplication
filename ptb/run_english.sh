rm brown_datalog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path brown_data --model small --save_path ./models/brown
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path brown_data --model small --save_path ./models/brown

rm brown_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path brown_names --model small --save_path ./models/brown_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path brown_names --model small --save_path ./models/brown_names


rm eng_datalog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path eng_data --model small --save_path ./models/eng_data
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path eng_data --model small --save_path ./models/eng_data
rm eng_nameslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path eng_names --model small --save_path ./models/eng_names
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path eng_names --model small --save_path ./models/eng_names
