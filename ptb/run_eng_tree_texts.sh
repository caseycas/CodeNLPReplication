rm eng_parse_textlog.txt
rm eng_parse_text_smalllog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path eng_parse_text --model small --save_path ./models/eng_parse_text #comment out for later runs
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path eng_parse_text --model small --save_path ./models/eng_parse_text
mv eng_parse_textlog.txt eng_parse_text_smalllog.txt

rm eng_parse_text_log.txt
rm eng_parse_text_medlog.txt
CUDA_VISIBLE_DEVICES=2 python3 ptb_word_lm.py --data_path eng_parse_text --model medium --save_path ./models/eng_parse_text_med #comment out for later runs
CUDA_VISIBLE_DEVICES=2 python3 tester.py --data_path eng_parse_text --model medium --save_path ./models/eng_parse_text_med
mv eng_parse_textlog.txt eng_parse_text_medlog.txt
