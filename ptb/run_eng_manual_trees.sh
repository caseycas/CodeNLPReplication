rm eng_parse_manuallog.txt
rm eng_parse_manual_smalllog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path eng_parse_manual --model small --save_path ./models/eng_parse_manual
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path eng_parse_manual --model small --save_path ./models/eng_parse_manual
mv eng_parse_manuallog.txt eng_parse_manual_smalllog.txt


rm eng_parse_manual_log.txt
rm eng_parse_manual_medlog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path eng_parse_manual --model medium --save_path ./models/eng_parse_manual_med
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path eng_parse_manual --model medium --save_path ./models/eng_parse_manual_med
mv eng_parse_manuallog.txt eng_parse_manual_medlog.txt
