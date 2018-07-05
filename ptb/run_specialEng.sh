rm nasalog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path nasa --model small --save_path ./models/nasa
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path nasa --model small --save_path ./models/nasa

rm lawlog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path law --model small --save_path ./models/law
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path law --model small --save_path ./models/law

rm scifilog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path scifi --model small --save_path ./models/scifi
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path scifi --model small --save_path ./models/scifi

rm shakespearelog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path shakespeare --model small --save_path ./models/shakespeare
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path shakespeare --model small --save_path ./models/shakespeare

rm recipeslog.txt
CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path recipes --model small --save_path ./models/recipes
CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path recipes --model small --save_path ./models/recipes

#rm recipes_biglog.txt
#CUDA_VISIBLE_DEVICES=0 python3 ptb_word_lm.py --data_path recipes_big --model small --save_path ./models/recipes_big
#CUDA_VISIBLE_DEVICES=0 python3 tester.py --data_path recipes_big --model small --save_path ./models/recipes_big
