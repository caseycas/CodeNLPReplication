rm djava_ast_smalllog.txt
rm djava_astlog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path djava_ast --model small --save_path ./models/djava_ast
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path djava_ast --model small --save_path ./models/djava_ast
mv djava_astlog.txt djava_ast_smalllog.txt

rm djava_astlog.txt
rm djava_ast_medlog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path djava_ast --model small --save_path ./models/djava_ast_med
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path djava_ast --model medium --save_path ./models/djava_ast_med
mv djava_astlog.txt djava_ast_medlog.txt
