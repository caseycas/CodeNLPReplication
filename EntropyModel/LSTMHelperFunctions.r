library(ggplot2)
library(effsize)
library(lsr)
library(car)
library(reshape2)
library(gsubfn)
library(sqldf)
library(data.table)
library(coin)


tag_set = c("ROOT","S", "SBAR", "SBARQ", "SINV", "SQ", "ADJP", "ADVP", "CONJP", "FRAG", "INTJ", "LST", "NAC", "NP", "NX", "PP",
           "PRN", "PRT", "QP", "RRC", "UCP", "VP", "WHADJP", "WHAVP", "WHNP", "WHPP", "X", "CC", "CD", "DT", "EX", "FW", "IN",
           "JJ", "JJR", "JJS", "LS", "MD", "NN", "NNS", "NNP", "NNPS", "PDT", "POS", "PRP", "PRP$", "RB", "RBR", "RBS", "RP", "SYM",
           "TO", "UH", "VB", "VBN", "VBD", "VBG", "VBP", "VBZ", "WDT", "WP", "WP$", "WP$", "WRB","ADV", "NOM","DTV", "LGS", "PRD", "PUT",
           "SBJ", "TPC", "VOC","BNF", "DIR","EXT", "LOC","MNR", "PRP", "TMP", "CLR", "SBAR-PRP","CLF", "HLN", "TTL","-LRB", "-RRB",
           "-NONE","*", "0", "T", "NUL", "-NONE-", "-LRB-", "-RRB-", "PRT|ADVP", "ADVP|PRT","#","NN|SYM","VBG|NN","RB|VBG","CD|RB",
           "VBP|TO","PRP|VBP","IN|RP","NN|NNS","JJ|VBG","RB|RP","NN|VBG","JJ|RB","TYPO","NEG","AUX","VBD|VBN","EDITED","WHADVP")

YLabelNgram = "3 gram entropy"
YLabelCache = "3 gram with 10 cache entropy"
YLabelLSTM = "Lstm entropy"

#Review this code
#https://stackoverflow.com/questions/23450221/coinwilcox-test-versus-wilcox-test-in-r
#https://stats.stackexchange.com/questions/79843/is-the-w-statistic-output-by-wilcox-test-in-r-the-same-as-the-u-statistic/79849#79849
#Wilcox model effect size calculation
rFromWilcox<-function(wilcoxModel, N){
  z= statistic(wilcoxModel, type="standardized")[1]
  r = z/ sqrt(N)
  return(r)
}

printWilcox <- function(d1, d2, name1, name2, pairedValue)
{
  #browser()
  stats_out = file(effect_size_file, 'a')
  #tw = wilcox.test(d1, d2, alternative = 'less', paired=pairedValue)
  #tw2 = wilcox.test(d1, d2, conf.int = TRUE, conf.level = .99, paired=pairedValue)
  #Use levels to force the ordering specified (otherwise it looks like wilcox_test chooses the default alphabetical order to label the data.)
  labels = factor(c(rep(name1, length(d1)), rep(name2, length(d2))), levels = c(name1, name2))
  d_c = c(d1, d2)
  #One-sided test (used to answer: Is one significantly less than the other)
  tw = wilcox_test(d_c ~ labels, alternative = 'less', paired=pairedValue)
  #Two-sided test (used for effect size and confidence intervals) We do confidence interval here b/c 1-sided isn't useful (one is -inf)
  tw2 = wilcox_test(d_c ~ labels, conf.int = TRUE, conf.level = .99, paired=pairedValue)
  print(tw)
  print(tw2)
  write(paste(name1, "and", name2, sep = " "),file=stats_out, append=TRUE)
  write(paste("One sided test ", name1, " < ", name2), file=stats_out, append=TRUE)
  write(capture.output(print(tw)),file=stats_out, append=TRUE)
  write(paste("Two sided test ", name1, " != ", name2), file=stats_out, append=TRUE)
  write(capture.output(print(tw2)),file=stats_out, append=TRUE)
  write(paste("Cohens D: ", cohensD(d1, d2), sep = " "),file=stats_out, append=TRUE)
  write(paste("Non-parametric effect size: ", as.character(rFromWilcox(tw2, length(d1) + length(d2))), sep = " "), file = stats_out, append=TRUE)
  close(stats_out)
}

createEntropyPlotsNoLSTM <- function(data_string, densityTitle, boxplotTitle, savePrefix)
{
  #print(paste(data_folder, "ngram/", data_string, "_no_cache_entropy.csv", sep = ""))
  Ngram = read.csv(paste(data_folder, "ngram/", data_string, "_no_cache_entropy.csv", sep = ""), header=FALSE)
  colnames(Ngram) = c("file", "id", "token", "ngram_entropy")
  Ngram$ngram_entropy = -Ngram$ngram_entropy
  
  CNgram = read.csv(paste(data_folder, "ngram/", data_string, "_cache_entropy.csv", sep = ""), header=FALSE)
  colnames(CNgram) = c("file", "id", "token", "cache_entropy")
  CNgram$cache_entropy = -CNgram$cache_entropy
  
  ent = Ngram
  ent$cache_entropy = CNgram$cache_entropy
  
  ent_plot = melt(ent)
  ent1 = ggplot(ent_plot, aes(variable, value, fill = variable)) +
    geom_boxplot() + 
    scale_fill_manual(values=cbbPalette)  + 
    theme(axis.text.x = element_text(size=12), 
          axis.title = element_text(size=14),
          axis.text.y = element_text(size=12),
          axis.title = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") + 
    xlab("Language Model") + 
    ylab("Entropy") +
    ggtitle(boxplotTitle)
  
  ent2 = ggplot(ent_plot, aes(x=value, group = variable, fill = variable)) + geom_density(alpha = .5) + xlab("entropy") + scale_fill_manual(values=cbbPalette) + ggtitle(densityTitle)
  print(ent1)
  print(ent2)
  
  ggsave(ent1, file = paste(plot_folder, savePrefix, "NgramBoxPlot.eps", sep = ""))
  ggsave(ent2, file = paste(plot_folder, savePrefix, "NgramDensityPlot.eps", sep = ""))
  
  return(list(Ngram, CNgram, ent_plot))
} 

createEntropyPlots <- function(data_string, densityTitle, boxplotTitle, savePrefix)
{
  #browser()
  #print(paste(data_folder, "ngram/", data_string, "_no_cache_entropy.csv", sep = ""))
  Ngram = read.csv(paste(data_folder, "ngram/", data_string, "_no_cache_entropy.csv", sep = ""), header=FALSE)
  colnames(Ngram) = c("file", "id", "token", "ngram_entropy")
  Ngram$ngram_entropy = -Ngram$ngram_entropy
  
  CNgram = read.csv(paste(data_folder, "ngram/", data_string, "_cache_entropy.csv", sep = ""), header=FALSE)
  colnames(CNgram) = c("file", "id", "token", "cache_entropy")
  CNgram$cache_entropy = -CNgram$cache_entropy
  
  
  Lstm = read.csv(paste(data_folder, "lstm/", data_string, "_entropy.csv", sep = ""))
  #Lstm = Lstm[!is.na(Lstm$lstm_entropy),] #I'm accidently adding an extra eos token at the end.  Remove it just in case.
  colnames(Lstm) = c("token", "lstm_entropy")
  Lstm = Lstm[Lstm$token != "<eos>",]
  ent =  Lstm
  ent$ngram_entropy = Ngram$ngram_entropy
  ent$cache_entropy = CNgram$cache_entropy
  
  #I'm switching from a paired to unpaired test because the lstm model doesn't exactly match the cache and ngram models
  printWilcox(ent$lstm_entropy, ent$ngram_entropy, paste(data_string, "_lstm", sep= ""), paste(data_string, "_ngram", sep=""),FALSE)
  
  printWilcox(ent$cache_entropy, ent$ngram_entropy, paste(data_string, "_cache", sep= ""), paste(data_string, "_ngram", sep=""),TRUE)
  #Produce an unpaired result as well in case we need the consistency.
  printWilcox(ent$cache_entropy, ent$ngram_entropy, paste(data_string, "_cache", sep= ""), paste(data_string, "_ngram", sep=""),FALSE)
  
  #I'm switching from a paired to unpaired test because the lstm model doesn't exactly match the cache and ngram models
  printWilcox(ent$lstm_entropy, ent$cache_entropy, paste(data_string, "_lstm", sep= ""), paste(data_string, "_cache", sep=""),FALSE)
  #print(wilcox.test(ent$lstm_entropy, ent$cache_entropy, alternative = 'less', paired=TRUE))
  #print(cohensD(ent$lstm_entropy, ent$cache_entropy, paired=TRUE))
  #print(cohensD(ent$lstm_entropy, ent$cache_entropy))
  
  ent_plot = melt(ent)
  ent1 = ggplot(ent_plot, aes(variable, value, fill = variable)) +
    geom_boxplot() + 
    scale_fill_manual(values=cbbPalette)  + 
    theme(axis.text.x = element_text(size=12), 
          axis.title = element_text(size=14),
          axis.text.y = element_text(size=12),
          axis.title = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") + 
    xlab("Language Model") + 
    ylab("Entropy") +
    ggtitle(boxplotTitle)
  
  ent2 = ggplot(ent_plot, aes(x=value, group = variable, fill = variable)) + geom_density(alpha = .5) + xlab("entropy") + scale_fill_manual(values=cbbPalette) + ggtitle(densityTitle)
  #print(ent1)
  #print(ent2)
  
  ggsave(ent1, file = paste(plot_folder, savePrefix, "LSTMBoxPlot.eps", sep = ""))
  ggsave(ent2, file = paste(plot_folder, savePrefix, "LSTMDensityPlot.eps", sep = ""))
  
  return(list(Ngram, CNgram, Lstm, ent_plot))
} 

#Feed in lstm's and best ngram models (cache for code regular for nl)
createLSTMCompare <- function(lstm1, lstm2, ngram1, ngram2, group1, group2, boxplotTitle, densityTitle, savePrefix)
{
  #LSTM Brown vs Code
  lcompare1 = lstm1
  lcompare1$language = paste("lstm", group1, sep="_")
  lcompare1$entropy = lcompare1$lstm_entropy
  lcompare1 = lcompare1[,c("language", "entropy")]
  
  lcompare2 <- lstm2
  lcompare2$language = paste("lstm", group2, sep="_")
  lcompare2$entropy = lcompare2$lstm_entropy
  lcompare2 = lcompare2[,c("language", "entropy")]
  
  ncompare1 = ngram1
  if("ngram_entropy" %in% colnames(ncompare1))
  {
    ncompare1$language = paste("ngram", group1, sep="_")
    ncompare1$entropy = ncompare1$ngram_entropy
  }
  else
  {
    ncompare1$language = paste("cache", group1, sep="_")
    ncompare1$entropy = ncompare1$cache_entropy
  }
  ncompare1 = ncompare1[,c("language", "entropy")]
  
  ncompare2 <- ngram2
  if("ngram_entropy" %in% colnames(ncompare2))
  {
    ncompare2$language = paste("ngram", group2, sep="_")
    ncompare2$entropy = ncompare2$ngram_entropy
  }
  else
  {
    ncompare2$language = paste("cache", group2, sep="_")
    ncompare2$entropy = ncompare2$cache_entropy
  }
  ncompare2 = ncompare2[,c("language", "entropy")]
  
  
  printWilcox(lcompare1$entropy, lcompare2$entropy, lcompare1$language[[1]], lcompare2$language[[1]], FALSE)
  #print(wilcox.test(lcompare1$entropy, lcompare2$entropy, alternative = 'less'))
  #print(cohensD(lcompare1$entropy, lcompare2$entropy))
  
  printWilcox(ncompare1$entropy, ncompare2$entropy, ncompare1$language[[1]], ncompare2$language[[1]], FALSE)
  #print(wilcox.test(ncompare1$entropy, ncompare2$entropy, alternative = 'less'))
  #print(cohensD(ncompare1$entropy, ncompare2$entropy))
  
  
  combined <- rbind(lcompare1, lcompare2)
  combinedfull <- rbind(ncompare1, ncompare2, lcompare1, lcompare2)
  p1 <- ggplot(combined, aes(factor(language), entropy))
  
  p2 <- ggplot(combined, aes(x = entropy, group = factor(language))) + geom_density(alpha = .5, aes(fill=language)) + xlab("entropy") +  scale_fill_manual(values=cbbPalette) + ggtitle(boxplotTitle)
  print(p1)
  print(p2)
  ggsave(p1, file =paste(plot_folder, savePrefix, "LSTMBoxPlot.eps", sep = ""))
  ggsave(p2, file =paste(plot_folder, savePrefix, "LSTMDensityPlot.eps", sep = ""))
}

combinedBoxplots <- function(ent_plot1, ent_plot2, savePrefix)
{
  ent_plot1$variable = as.character(ent_plot1$variable)
  ent_plot2$variable = as.character(ent_plot2$variable)
  
  ent_plot1[ent_plot1$variable == "lstm_entropy",]$variable = "Eng. Lstm"
  ent_plot1[ent_plot1$variable == "ngram_entropy",]$variable = "Eng. Ngram"
  ent_plot1[ent_plot1$variable == "cache_entropy",]$variable = "Eng. Cache"
  
  ent_plot2[ent_plot2$variable == "lstm_entropy",]$variable = "Java Lstm"
  ent_plot2[ent_plot2$variable == "ngram_entropy",]$variable = "Java Ngram"
  ent_plot2[ent_plot2$variable == "cache_entropy",]$variable = "Java Cache"
  
  #ent_plot1$variable = as.factor(ent_plot1$variable)
  #ent_plot2$variable = as.factor(ent_plot2$variable)
  ent_plot = rbind(ent_plot1[ent_plot1$variable == "Eng. Lstm",], ent_plot2[ent_plot2$variable == "Java Lstm",], ent_plot1[ent_plot1$variable == "Eng. Ngram",], ent_plot2[ent_plot2$variable == "Java Ngram",], ent_plot1[ent_plot1$variable == "Eng. Cache",], ent_plot2[ent_plot2$variable == "Java Cache",])
  ent_plot$variable = as.factor(ent_plot$variable)
  ent_plot$variable = factor(ent_plot$variable, levels = c("Eng. Lstm", "Java Lstm", "Eng. Ngram", "Java Ngram", "Eng. Cache", "Java Cache"))
  #Plot Testing.
  boxplotTitle = "Lstm, Trigram, and Trigram Cache Entropy Boxplot"
  p1 = ggplot(ent_plot, aes(variable, value, fill = variable)) + 
    geom_boxplot() + 
    scale_fill_manual(values=cbbPalette)  + 
    theme(axis.text.x = element_text(size=12, face = "bold"), 
          axis.title = element_text(size=14),
          axis.text.y = element_text(size=12),
          axis.title = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") + 
    xlab("Language Model") + 
    ylab("Entropy") +
    ggtitle(boxplotTitle)
  print(p1)
  ggsave(p1, file =paste(plot_folder, savePrefix, "LSTMBoxPlot.eps", sep = ""), width = 19.05, height = 13.2, dpi = 600, units = "cm")
}

loadLSTM <- function(data_string, lang)
{
  Lstm = read.csv(paste(data_folder, "lstm/", data_string, "_entropy.csv", sep = ""))
  #Lstm = Lstm[!is.na(Lstm$lstm_entropy),] #I'm accidently adding an extra eos token at the end.  Remove it just in case.
  colnames(Lstm) = c("token", "lstm_entropy")
  ent =  Lstm[Lstm$token != "<eos>",]
  ent$language = lang
  return(ent)
}


drawNgramBoxplot <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(factor(language), ngram_entropy)) + 
    geom_boxplot(aes(fill=language)) + 
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  ggsave(plot_out, file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}

drawCacheBoxplot <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(factor(language), cache_entropy)) + 
    geom_boxplot(aes(fill=language)) + 
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  ggsave(plot_out, file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}


drawLSTMBoxplot <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(factor(language), lstm_entropy)) + 
    geom_boxplot(aes(fill=language)) +  
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  ggsave(plot_out, file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}

drawLSTMBoxplotCapped <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(factor(language), lstm_entropy)) + 
    geom_boxplot(aes(fill=language)) +  
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  ylim1 = boxplot.stats(data$lstm_entropy)$stats[c(1, 5)]
  plot_out_clip = plot_out +coord_cartesian(ylim = ylim1*1.05)
  ggsave(plot_out_clip,  file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}