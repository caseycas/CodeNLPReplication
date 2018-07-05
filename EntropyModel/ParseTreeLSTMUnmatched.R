library(sqldf)
library(ggplot2)

source(file="./EntropyModel/colorBlind.r")

data_folder = "./EntropyModel/data/tmp/lstm_compare/"
plot_folder = "./Plots/"
effect_size_file = "./parse_tree_terminal_stats.txt"
stats_out = file(effect_size_file, 'w')
close(stats_out)

eng_label_simp = "Eng_Parse_Simplified"
eng_label = "Eng_Parse"
java_label = "Java_AST"

source(file="./EntropyModel/LSTMHelperFunctions.r")

readAndFilterEngTree <- function(filename, col_names)
{
  b = read.csv(filename, header=TRUE)
  colnames(b) = col_names
  stopifnot(length(col_names) == 2)
  b$token = as.character(b$token)
  b = b[b$token != "(" & b$token != ")" & b$token != "<eos>" & b$token != ")<eos>(",]
  b = sqldf("SELECT * FROM b WHERE token not in ts")
  b = b[!is.na(b[,col_names[2]]),]
  print(summary(b[,col_names[2]]))
  return(b)
}

readAndFilterJavaTree <- function(filename)
{
  j = read.csv(filename, header=TRUE)
  colnames(j) = c("token", "lstm_entropy")
  j$token <- as.character(j$token)
  j = j[j$token != "(" & j$token != ")" & j$token != "<eos>"& j$token != ")<eos>(" & !startsWith(j$token, "#"),]
  j = j[!is.na(j$lstm_entropy),]
  print(summary(j$lstm_entropy))
  return(j)
}

# Nonterminal Experiment
# Load file (just lstm)
# Remove parens and <eos>
loadNTLinearizedTree <- function(data_folder, data_string, label)
{
  Lstm = read.csv(paste(data_folder, "lstm/", data_string, "_entropy.csv", sep = ""),header=TRUE)
  colnames(Lstm) = c("token", "lstm_entropy")
  ent =  Lstm[Lstm$token != "<eos>" & Lstm$token != ")<eos>(" & Lstm$token != "(" & Lstm$token != ")",]
  ent$language = label
  return(ent)
}

tag_set = c("ROOT","S", "SBAR", "SBARQ", "SINV", "SQ", "ADJP", "ADVP", "CONJP", "FRAG", "INTJ", "LST", "NAC", "NP", "NX", "PP",
           "PRN", "PRT", "QP", "RRC", "UCP", "VP", "WHADJP", "WHAVP", "WHNP", "WHPP", "X", "CC", "CD", "DT", "EX", "FW", "IN",
           "JJ", "JJR", "JJS", "LS", "MD", "NN", "NNS", "NNP", "NNPS", "PDT", "POS", "PRP", "PRP$", "RB", "RBR", "RBS", "RP", "SYM",
           "TO", "UH", "VB", "VBN", "VBD", "VBG", "VBP", "VBZ", "WDT", "WP", "WP$", "WP$", "WRB","ADV", "NOM","DTV", "LGS", "PRD", "PUT",
           "SBJ", "TPC", "VOC","BNF", "DIR","EXT", "LOC","MNR", "PRP", "TMP", "CLR", "SBAR-PRP","CLF", "HLN", "TTL","-LRB", "-RRB",
           "-NONE","*", "0", "T", "NUL", "-NONE-", "-LRB-", "-RRB-", "PRT|ADVP", "ADVP|PRT","#","NN|SYM","VBG|NN","RB|VBG","CD|RB",
           "VBP|TO","PRP|VBP","IN|RP","NN|NNS","JJ|VBG","RB|RP","NN|VBG","JJ|RB","TYPO","NEG","AUX","VBD|VBN","EDITED","WHADVP")
ts <- data.frame(tag_set)

b <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_manual_small_entropy.csv", c("token", "lstm_entropy"))

b_full <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_smalllog.csv", c("token", "lstm_entropy"))

bMed <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_manual_med_entropy.csv", c("token", "lstm_entropy"))

bMed_full <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_manual_simp_post_medlog.csv", c("token", "lstm_entropy"))

#Zero tokens
print("Eng Simple Small 0 entropy tokens:")
print(nrow(b[b$lstm_entropy == 0,])/nrow(b))
print("Eng Small 0 entropy tokens:")
print(print(nrow(b_full[b_full$lstm_entropy == 0,])/nrow(b_full)))
print("Eng Simple Med 0 entropy tokens:")
print(print(nrow(bMed[bMed$lstm_entropy == 0,])/nrow(bMed)))
print("Eng Med 0 entropy tokens:")
print(print(nrow(bMed_full[bMed_full$lstm_entropy == 0,])/nrow(bMed_full)))

stopifnot(nrow(b) == nrow(bMed))
stopifnot(nrow(b_full) == nrow(bMed_full))

b2 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_labelled_no_cache_entropy.csv", header=FALSE)
colnames(b2) <- c("file", "token_id", "token", "ngram_entropy", "token_type")
b2$ngram_entropy <- -b2$ngram_entropy

#Need to process another way
#b2_full <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_no_cache_entropy.csv", header=FALSE)
#colnames(b2_full) <- c("file", "token_id", "token", "ngram_entropy", "token_type")
#b2_full$ngram_entropy <- -b2_full$ngram_entropy

b2_full <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_no_cache_entropy.csv", c("token", "ngram_entropy"))
b2_full$ngram_entropy <- -b2_full$ngram_entropy

b3 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_labelled_cache_entropy.csv", header=FALSE)
colnames(b3) <- c("file", "token_id", "token", "cache_entropy", "token_type")
b3$cache_entropy <- -b3$cache_entropy

#Need to process another way
#b3_full <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram//eng_parse_manual_simp_post_cache_entropy.csv", header=FALSE)
#colnames(b3_full) <- c("file", "token_id", "token", "cache_entropy", "token_type")
#b3_full$cache_entropy <- -b3_full$cache_entropy
b3_full <- readAndFilterEngTree("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_simp_post_cache_entropy.csv", c("token", "cache_entropy"))
b3_full$cache_entropy <- -b3_full$cache_entropy

bMed$language <- eng_label_simp
b$language <- eng_label_simp
bMed_full$language <- eng_label
b_full$language <- eng_label
b2$cache_entropy <- b3$cache_entropy
b2_full$cache_entropy <- b3_full$cache_entropy
b2$language <- eng_label_simp
b2_full$language <- eng_label

b_all <- b2[b2$token_type == 'WORD' | b2$token_type == 'STOPWORD' | b2$token_type == 'PUNCT',]
printWilcox(b_all$ngram_entropy, b_all$cache_entropy, "Eng Tokens in AST Simple (Ngram)", "Eng Tokens in AST Simple (Cache)", TRUE)
printWilcox(b2_full$ngram_entropy, b2_full$cache_entropy, "Eng Tokens in AST Full (Ngram)", "Eng Tokens in AST Full (Cache)", TRUE)
printWilcox(b_all$ngram_entropy, b2_full$ngram_entropy, "Eng Tokens in AST Simple (Ngram)", "Eng Tokens in AST Full (Ngram)", FALSE)
printWilcox(b_all$cache_entropy, b2_full$cache_entropy, "Eng Tokens in AST Simple (Cache)", "Eng Tokens in AST Full (Cache)", FALSE)
b_all_plot <- b_all[,c("token","ngram_entropy" ,"cache_entropy", "language")]
b_all_full_plot <- b2_full[,c("token","ngram_entropy" ,"cache_entropy", "language")]

j <- readAndFilterJavaTree("./EntropyModel/data/tmp/lstm_compare/lstm/djava_ast_small_entropy.csv")

jMed <- readAndFilterJavaTree("./EntropyModel/data/tmp/lstm_compare/lstm/djava_ast_med_entropy.csv")

print("Java Small 0 entropy tokens:")
print(nrow(j[j$lstm_entropy == 0,])/nrow(j))
print("Java Medium 0 entropy tokens:")
print(nrow(jMed[jMed$lstm_entropy == 0,])/nrow(jMed))

stopifnot(nrow(j) == nrow(jMed))

j2 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/djava_ast_labelled_small_no_cache_entropy.csv", header=FALSE)
colnames(j2) <- c("file", "token_id", "token", "ngram_entropy", "token_type")
j2$ngram_entropy <- -j2$ngram_entropy

j3 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/djava_ast_labelled_small_cache_entropy.csv", header=FALSE)
colnames(j3) <- c("file", "token_id", "token", "cache_entropy", "token_type")
j3$cache_entropy <- -j3$cache_entropy

#Save j vs j3
#write.csv(j, file = "./EntropyModel/jtest_debug.csv") #with smaller one.
#write.csv(j, file = "./EntropyModel/j_debug.csv")
#write.csv(j3, file = "./EntropyModel/j3_debug.csv")

jMed$language <- java_label
j$language <- java_label
j2$cache_entropy <- j3$cache_entropy
j2$language <- java_label

#Problem is this isn't directly comparable with brown again... (oh well)
j_all <- j2[j2$token_type == 'WORD' | j2$token_type == 'STOPWORD' | j2$token_type == 'PUNCT',]
printWilcox(j_all$ngram_entropy, j_all$cache_entropy, "Java Tokens in AST (Ngram)", "Java Tokens in AST (Cache)", TRUE)
j_all_plot <- j_all[,c("token", "ngram_entropy" ,"cache_entropy",  "language")]



colnames(j_all_plot) <- c("token", "ngram_entropy" ,"cache_entropy",  "language")
colnames(b_all_plot)<- c("token", "ngram_entropy" ,"cache_entropy",  "language")
colnames(b_all_full_plot)<- c("token", "ngram_entropy" ,"cache_entropy",  "language")

#Buggy
#lstm_den <- ggplot(bc_compare, aes(x = lstm_entropy, group = factor(language))) + geom_density(alpha = .5, aes(fill=language)) +  ggtitle("Comparison of Brown Parse, Java AST Names (LSTM)")
#lstm_den_no_out <- lstm_den + coord_cartesian(ylim = ylim1*1.05)

#Full comparison
bc_full_compare <- rbind(j_all_plot, b_all_plot, b_all_full_plot)
#drawNgramBoxplot(bc_full_compare, "Brown Parse, Java AST All Tokens (Ngram)", "7-gram Entropy", "./Plots/JavaVsBrownTreeBoxplot(7grams).eps")
drawNgramBoxplot(bc_full_compare, "", "7-gram Entropy", "./Plots/JavaVsBrownTreeBoxplot(7grams).eps")

#drawCacheBoxplot(bc_full_compare, "Brown Parse, Java AST All Tokens (Cache)", "7-gram 10 Cache Entropy", "./Plots/JavaVsBrownTreeBoxplot(7grams10Cache).eps")
drawCacheBoxplot(bc_full_compare, "", "7-gram 10 Cache Entropy", "./Plots/JavaVsBrownTreeBoxplot(7grams10Cache).eps")

stopifnot(nrow(b) == nrow(bMed))
stopifnot(nrow(b_full) == nrow(bMed_full))
stopifnot(nrow(j) == nrow(jMed))

#Scaling to focus less on outliers thanks to Ramnath here:
#http://stackoverflow.com/questions/5677885/ignore-outliers-in-ggplot2-boxplot
bc_lstm_compare <- rbind(j, b, b_full)
#drawLSTMBoxplot(bc_lstm_compare, "English Parse, Java AST All Tokens (LSTM Small)", "LSTM Entropy (Small)", "./Plots/JavaVsBrownTreeBoxplotNoCap(LSTM).eps")
#drawLSTMBoxplotCapped(bc_lstm_compare, "English Parse, Java AST All Tokens (LSTM Small)", "LSTM Entropy (Small)", "./Plots/JavaVsBrownTreeBoxplot(LSTM).eps")

drawLSTMBoxplot(bc_lstm_compare, "", "LSTM Entropy (Small)", "./Plots/JavaVsBrownTreeBoxplotNoCap(LSTM).eps")
drawLSTMBoxplotCapped(bc_lstm_compare, "", "LSTM Entropy (Small)", "./Plots/JavaVsBrownTreeBoxplot(LSTM).eps")

bc_lstm_compare_med <- rbind(jMed, bMed, bMed_full)
#drawLSTMBoxplot(bc_lstm_compare_med, "English Parse, Java AST All Tokens (LSTM Medium)", "LSTM Entropy (Medium)", "./Plots/JavaVsBrownTreeBoxplotNoCapMed(LSTM).eps")
#drawLSTMBoxplotCapped(bc_lstm_compare_med, "English Parse, Java AST All Tokens (LSTM Medium)", "LSTM Entropy (Medium)", "./Plots/JavaVsBrownTreeBoxplotMed(LSTM).eps")

drawLSTMBoxplot(bc_lstm_compare_med, "", "LSTM Entropy (Medium)", "./Plots/JavaVsBrownTreeBoxplotNoCapMed(LSTM).eps")
drawLSTMBoxplotCapped(bc_lstm_compare_med, "", "LSTM Entropy (Medium)", "./Plots/JavaVsBrownTreeBoxplotMed(LSTM).eps")


printWilcox(j_all_plot$ngram_entropy, b_all_plot$ngram_entropy, "Java Tokens in Const. Parse (Ngram)", "Eng Tokens in Const. Parse Simple (Ngram)", FALSE)
printWilcox(j_all_plot$cache_entropy, b_all_plot$cache_entropy, "Java Tokens in Const. Parse (Cache)", "Eng Tokens in Const. Parse Simple (Cache)", FALSE)

printWilcox(j_all_plot$ngram_entropy, b_all_full_plot$ngram_entropy, "Java Tokens in Const. Parse (Ngram)", "Eng Tokens in Const. Parse Full (Ngram)", FALSE)
printWilcox(j_all_plot$cache_entropy, b_all_full_plot$cache_entropy, "Java Tokens in Const. Parse (Cache)", "Eng Tokens in Const. Parse Full (Cache)", FALSE)


printWilcox(j$lstm_entropy, b$lstm_entropy, "Java Tokens in Const. Parse (Lstm Small)", "Eng Tokens in Const. Parse Simple (Lstm Small)", FALSE)
printWilcox(jMed$lstm_entropy, bMed$lstm_entropy, "Java Tokens in Const. Parse (Lstm Med)", "Eng Tokens in Const. Parse Simple (Lstm Med)", FALSE)

printWilcox(j$lstm_entropy, b_full$lstm_entropy, "Java Tokens in Const. Parse (Lstm Small)", "Eng Tokens in Const. Parse Full (Lstm Small)", FALSE)
printWilcox(jMed$lstm_entropy, bMed_full$lstm_entropy, "Java Tokens in Const. Parse (Lstm Med)", "Eng Tokens in Const. Parse Full (Lstm Med)", FALSE)

printWilcox(b$lstm_entropy, b_full$lstm_entropy, "Eng Tokens in Const. Parse Simple (Lstm Small)", "Eng Tokens in Const. Parse Full (Lstm Small)", FALSE)
printWilcox(bMed$lstm_entropy, bMed_full$lstm_entropy, "Eng Tokens in Const. Parse Simple (Lstm Med)", "Eng Tokens in Const. Parse Full (Lstm Med)", FALSE)

#Comparison with texts
#Text Versions.
bt <- read.csv("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_text_small_entropy.csv", header = TRUE)
colnames(bt) <- c("token", "lstm_entropy")
bt <- bt[bt$token != "<eos>",]

#Doesn't exist yet.
btMed <- read.csv("./EntropyModel/data/tmp/lstm_compare/lstm/eng_parse_text_med_entropy.csv", header = TRUE)
colnames(btMed) <- c("token", "lstm_entropy")
btMed <- btMed[btMed$token != "<eos>",]


bt2 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_text_no_cache_entropy.csv", header = FALSE)
colnames(bt2) <- c("file", "token_id", "token", "ngram_entropy")
bt2$ngram_entropy <- -bt2$ngram_entropy

bt3 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/eng_parse_manual_text_cache_entropy.csv", header = FALSE)
colnames(bt3) <- c("file", "token_id", "token", "cache_entropy")
bt3$cache_entropy <- -bt3$cache_entropy

bt$ngram_entropy <- bt2$ngram_entropy
bt$cache_entropy <- bt3$cache_entropy

jt <- read.csv("./EntropyModel/data/tmp/lstm_compare/lstm/djava_ast_text_small_entropy.csv", header = TRUE)
colnames(jt) <- c("token", "lstm_entropy")
jt <- jt[jt$token != "<eos>",]

jtMed <- read.csv("./EntropyModel/data/tmp/lstm_compare/lstm/djava_ast_text_med_entropy.csv", header = TRUE)
colnames(jtMed) <- c("token", "lstm_entropy")
jtMed <- jtMed[jtMed$token != "<eos>",]

jt2 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/djava_ast_small_text_no_cache_entropy.csv", header = FALSE)
colnames(jt2) <- c("file", "token_id", "token", "ngram_entropy")
jt2$ngram_entropy <- -jt2$ngram_entropy

jt3 <- read.csv("./EntropyModel/data/tmp/lstm_compare/ngram/djava_ast_small_text_cache_entropy.csv", header = FALSE)
colnames(jt3) <- c("file", "token_id", "token", "cache_entropy")
jt3$cache_entropy <- -jt3$cache_entropy

jt$ngram_entropy <- jt2$ngram_entropy
jt$cache_entropy <- jt3$cache_entropy

#printWilcox(jt$ngram_entropy, jt$cache_entropy, "Java AST Text Ngram", "Java AST Text Cache", TRUE)
#printWilcox(bt$ngram_entropy, bt$cache_entropy, "Eng Tree Text Ngram", "Eng Tree Text Cache", TRUE)

#printWilcox(bt$ngram_entropy, jt$cache_entropy, "Eng Tree Text Ngram", "Java AST Text Cache", FALSE)
#printWilcox(bt$lstm_entropy, jt$lstm_entropy, "Eng Tree Text LSTM", "Java AST Text LSTM", FALSE)

#printWilcox(bt$ngram_entropy, b_all_plot$best_ngram_entropy, "Eng Raw Text Ngram", "Eng Tree Terminal Ngram", FALSE)
#printWilcox(jt$cache_entropy, j_all_plot$best_ngram_entropy, "Java Raw Text Cache", "Java Tree Terminal Cache", FALSE)



#printWilcox(bt$lstm_entropy, b$lstm_entropy, "Eng Raw Text Lstm", "Eng Tree Terminal Lstm", FALSE)
#printWilcox(jt$lstm_entropy, j$lstm_entropy, "Java Raw Text Lstm", "Java Tree Terminal Lstm", FALSE)

printWilcox(jt$ngram_entropy, bt$ngram_entropy, "Java Text Tokens (Ngram)", "Eng Text Tokens (Ngram)", FALSE)
printWilcox(jt$cache_entropy, bt$cache_entropy, "Java Text Tokens (Cache)", "Eng Text Tokens (Cache)", FALSE)
printWilcox(jt$lstm_entropy, bt$lstm_entropy, "Java Text Tokens (lstm)", "Eng Text Tokens (lstm)", FALSE)
#Todo Medium text version (once we are more confident in correctness...)
printWilcox(jtMed$lstm_entropy, btMed$lstm_entropy, "Java Text Tokens (lstm med)", "Eng Text Tokens (lstm med)", FALSE)



#Density plot comparisons


# eng_s_nt <- loadNTLinearizedTree(data_folder, "eng_parse_manual_small_nt", eng_label_simp)
# eng_nt <- loadNTLinearizedTree(data_folder, "eng_parse_manual_full_small_nt", eng_label)
# java_nt <- loadNTLinearizedTree(data_folder, "djava_ast_small_nt", java_label)
# 
# engMed_s_nt <- loadNTLinearizedTree(data_folder, "eng_parse_manual_med_nt", eng_label_simp)
# engMed_nt <- loadNTLinearizedTree(data_folder, "eng_parse_manual_full_med_nt", eng_label)
# javaMed_nt <- loadNTLinearizedTree(data_folder, "djava_ast_med_nt", java_label)
# 
# stopifnot(nrow(eng_s_nt) == nrow(engMed_s_nt))
# stopifnot(nrow(eng_nt) == nrow(engMed_nt))
# stopifnot(nrow(java_nt) == nrow(javaMed_nt))
# 
# write("<NonTerminalTable>",file=effect_size_file, append=TRUE)
# printWilcox(eng_s_nt$lstm_entropy, eng_nt$lstm_entropy, "Eng Simplified Nonterminals (LSTM Small)", "Eng Full Nonterminals (LSTM Small)", FALSE)
# printWilcox(engMed_s_nt$lstm_entropy, engMed_nt$lstm_entropy, "Eng Simplified Nonterminals (LSTM Med)", "Eng Full Nonterminals (LSTM Med)", FALSE)
# 
# printWilcox(eng_s_nt$lstm_entropy, java_nt$lstm_entropy, "Eng Simplified Nonterminals (LSTM Small)", "Java Nonterminals (LSTM Small)", FALSE)
# printWilcox(eng_nt$lstm_entropy, java_nt$lstm_entropy, "Eng Full Nonterminals (LSTM Small)", "Java Nonterminals (LSTM Small)", FALSE)
# 
# printWilcox(engMed_s_nt$lstm_entropy, javaMed_nt$lstm_entropy, "Eng Simplified Nonterminals (LSTM Med)", "Java Nonterminals (LSTM Med)", FALSE)
# printWilcox(engMed_nt$lstm_entropy, javaMed_nt$lstm_entropy, "Eng Full Nonterminals (LSTM Med)", "Java Nonterminals (LSTM Med)", FALSE)
# write("<\\NonTerminalTable>",file=effect_size_file, append=TRUE)
# 
# s_nt <- rbind(eng_nt, eng_s_nt, java_nt)
# drawLSTMBoxplot(s_nt, "English and Java Non Terminals (LSTM Small)", "LSTM entropy", "./Plots/JavaEngTreeNonTermBoxplot(LSTM_Small).eps")
# drawLSTMBoxplotCapped(s_nt, "English and Java Non Terminals (LSTM Small)", "LSTM entropy", "./Plots/JavaEngTreeNonTermBoxplotCap(LSTM_Small).eps")
# 
# 
# m_nt <- rbind(engMed_nt, engMed_s_nt, javaMed_nt)
# drawLSTMBoxplot(m_nt, "English and Java Non Terminals (LSTM Medium)", "LSTM entropy", "./Plots/JavaEngTreeNonTermBoxplot(LSTM_Med).eps")
# drawLSTMBoxplotCapped(m_nt, "English and Java Non Terminals (LSTM Medium)", "LSTM entropy", "./Plots/JavaEngTreeNonTermBoxplotCap(LSTM_Med).eps")
