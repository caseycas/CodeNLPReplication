library(ggplot2)
library(effsize)
library(lsr)
library(car)
library(reshape2)
library(gsubfn)
library(sqldf)
library(data.table)

source(file="./EntropyModel/colorBlind.r")

data_folder = "./EntropyModel/data/tmp/lstm_compare/"
plot_folder = "./Plots/"
#effect_size_file = "./EntropyModel/lstm_ngram_stats.txt"
effect_size_file = "./EntropyModel/lstm_ngram_no_collapse_stats.txt"
#clear the file
stats_out = file(effect_size_file, 'w')
close(stats_out)

source(file="./EntropyModel/LSTMHelperFunctions.r")


#Full
list[n1, c1, l1, ent_plot1] <- createEntropyPlots("eng_full", "Eng Lstm vs 3 gram entropy density", "Eng Lstm vs 3 gram entropy boxplot", "Eng")
list[n2, c2, l2, ent_plot2] <- createEntropyPlots("djava_no_collapse","Java Lstm vs 3 gram entropy density" ,"Java Lstm vs 3 gram entropy boxplot","DJava")
#list[n2, c2, l2, ent_plot2] <- createEntropyPlots("djava_full","Java Lstm vs 3 gram entropy density" ,"Java Lstm vs 3 gram entropy boxplot","DJava")
createLSTMCompare(l1, l2, n1, c2, "English", "Java", "Comparison of lstm entropy of Brown and Java","Comparison of lstm entropy of Brown and Java", "EngJava")
combinedBoxplots(ent_plot1, ent_plot2, "EngJava")

#Find what improves most under lstm for java and english.
eng <- n1
eng$lstm_entropy <- l1[l1$token != "<eos>", ]$lstm_entropy
eng$ent_diff <- eng$ngram_entropy - eng$lstm_entropy
eng_s <- sqldf("SELECT * FROM eng ORDER BY ABS(ent_diff) ASC")
View(eng_s)

java <- c2
java$lstm_entropy <- l2[l2$token != "<eos>", ]$lstm_entropy
java$ent_diff <- java$cache_entropy - java$lstm_entropy
java_s <- sqldf("SELECT * FROM java ORDER BY ABS(ent_diff) ASC")
View(java_s)

#Name
list[n1, c1, l1, ent_plot1] <- createEntropyPlots("eng_names", "Eng Name Lstm vs 3 gram entropy density", "Eng Name Lstm vs 3 gram entropy boxplot", "EngName")
list[n2, c2, l2, ent_plot2] <- createEntropyPlots("djava_no_collapse_names","Java Name Lstm vs 3 gram entropy density" ,"Java Name Lstm vs 3 gram entropy boxplot","DJavaName")
createLSTMCompare(l1, l2, n1, c2, "English Name", "Java Name", "Comparison of entropy of English and Java Names","Comparison of entropy of English and Java Names", "EngJavaName")
combinedBoxplots(ent_plot1, ent_plot2, "EngJavaName")

#C names is off 1 one now? (I think I made a special change to it after convertName.py -> double check)
list[n3, c3, l3, ent_plot3] <- createEntropyPlots("c_no_collapse_names", "C Name Lstm vs 3 gram entropy density", "C Name Lstm vs 3 gram entropy boxplot", "CName")
list[n4, c4, l4, ent_plot4] <- createEntropyPlots("clojure_no_collapse_names","Clojure Name Lstm vs 3 gram entropy density" ,"Clojure Name Lstm vs 3 gram entropy boxplot","ClojureName")
list[n5, c5, l5, ent_plot5] <- createEntropyPlots("ruby_no_collapse_names", "Ruby Name Lstm vs 3 gram entropy density", "Ruby Name Lstm vs 3 gram entropy boxplot", "RubyName")
list[n6, c6, l6, ent_plot6] <- createEntropyPlots("haskell_no_collapse_names","Haskell Name Lstm vs 3 gram entropy density" ,"Haskell Name Lstm vs 3 gram entropy boxplot","HaskellName")


n1$language = "English"
c1$language = "English"
l1$language = "English"


n2$language = "Java"
c2$language = "Java"
l2$language = "Java"

n3$language = "C"
c3$language = "C"
l3$language = "C"

n4$language = "Clojure"
c4$language = "Clojure"
l4$language = "Clojure"

n5$language = "Ruby"
c5$language = "Ruby"
l5$language = "Ruby"

n6$language = "Haskell"
c6$language = "Haskell"
l6$language = "Haskell"

combined <- rbind(n1, n2, n3 ,n4, n5, n6)
drawNgramBoxplot(combined, "", YLabelNgram,"./Plots/PLVsEnglishName3gramBoxplot.tiff")
drawNgramBoxplot(combined, "", YLabelNgram,"./Plots/PLVsEnglishName3gramBoxplot.png")

combined  <- rbind(c1, c2, c3, c4, c5, c6)
drawCacheBoxplot(combined, "", YLabelCache,"./Plots/PLVsEnglishName3gramCacheBoxplot.tiff")
drawCacheBoxplot(combined, "", YLabelCache,"./Plots/PLVsEnglishName3gramCacheBoxplot.png")

combined  <- rbind(l1,l2,l3,l4,l5,l6)
drawLSTMBoxplot(combined, "", YLabelLSTM,"./Plots/PLVsEnglishNameLSTMBoxplot.tiff")
drawLSTMBoxplot(combined, "", YLabelLSTM,"./Plots/PLVsEnglishNameLSTMBoxplot.png")


write("<NameTable>",file=effect_size_file, append=TRUE)
#Name effect sizes.
printWilcox(n2$ngram_entropy, n1$ngram_entropy, n2$language[[1]], n1$language[[1]], FALSE)
printWilcox(n3$ngram_entropy, n1$ngram_entropy, n3$language[[1]], n1$language[[1]], FALSE)
printWilcox(n4$ngram_entropy, n1$ngram_entropy, n4$language[[1]], n1$language[[1]], FALSE)
printWilcox(n5$ngram_entropy, n1$ngram_entropy, n5$language[[1]], n1$language[[1]], FALSE)
printWilcox(n6$ngram_entropy, n1$ngram_entropy, n6$language[[1]], n1$language[[1]], FALSE)

printWilcox(c2$cache_entropy, c1$cache_entropy, c2$language[[1]], c1$language[[1]], FALSE)
printWilcox(c3$cache_entropy, c1$cache_entropy, c3$language[[1]], c1$language[[1]], FALSE)
printWilcox(c4$cache_entropy, c1$cache_entropy, c4$language[[1]], c1$language[[1]], FALSE)
printWilcox(c5$cache_entropy, c1$cache_entropy, c5$language[[1]], c1$language[[1]], FALSE)
printWilcox(c6$cache_entropy, c1$cache_entropy, c6$language[[1]], c1$language[[1]], FALSE)

printWilcox(l2$lstm_entropy, l1$lstm_entropy, l2$language[[1]], l1$language[[1]], FALSE)
printWilcox(l3$lstm_entropy, l1$lstm_entropy, l3$language[[1]], l1$language[[1]], FALSE)
printWilcox(l4$lstm_entropy, l1$lstm_entropy, l4$language[[1]], l1$language[[1]], FALSE)
printWilcox(l5$lstm_entropy, l1$lstm_entropy, l5$language[[1]], l1$language[[1]], FALSE)
printWilcox(l6$lstm_entropy, l1$lstm_entropy, l6$language[[1]], l1$language[[1]], FALSE)
write("<\\NameTable>",file=effect_size_file, append=TRUE)




#Create Comparison for each of the Code Language models
list[n1, c1, l1, ent_plot] <- createEntropyPlots("eng_full", "Eng Lstm vs 3 gram entropy density", "Eng Lstm vs 3 gram entropy boxplot", "Eng")
list[ng, cg, lg, ent_plot] <- createEntropyPlots("german_full", "German Lstm vs 3 gram entropy density", "German Lstm vs 3 gram entropy boxplot", "German")
list[ns, cs, ls, ent_plot] <- createEntropyPlots("spanish_full", "Spanish Lstm vs 3 gram entropy density", "Spanish Lstm vs 3 gram entropy boxplot", "Spanish")

list[n2, c2, l2, ent_plot] <- createEntropyPlots("djava_no_collapse","Java Lstm vs 3 gram entropy density" ,"Java Lstm vs 3 gram entropy boxplot","DJava")
list[n3, c3, l3, ent_plot] <- createEntropyPlots("c_no_collapse", "C Lstm vs 3 gram entropy density", "C Lstm vs 3 gram entropy boxplot", "C")
list[n4, c4, l4, ent_plot] <- createEntropyPlots("clojure_no_collapse","Clojure Lstm vs 3 gram entropy density" ,"Clojure Lstm vs 3 gram entropy boxplot","Clojure")
list[n5, c5, l5, ent_plot] <- createEntropyPlots("ruby_no_collapse","Ruby Lstm vs 3 gram entropy density" ,"Ruby Lstm vs 3 gram entropy boxplot","Ruby")
list[n6, c6, l6, ent_plot] <- createEntropyPlots("haskell_no_collapse","Haskell Lstm vs 3 gram entropy density" ,"Haskell Lstm vs 3 gram entropy boxplot","Haskell")


n1$language = "English"
c1$language = "English"
l1$language = "English"

ng$language = "German"
cg$language = "German"
lg$language = "German"

ns$language = "Spanish"
cs$language = "Spanish"
ls$language = "Spanish"

n2$language = "Java"
c2$language = "Java"
l2$language = "Java"



n3$language = "C"
c3$language = "C"
l3$language = "C"

n4$language = "Clojure"
c4$language = "Clojure"
l4$language = "Clojure"

n5$language = "Ruby"
c5$language = "Ruby"
l5$language = "Ruby"

n6$language = "Haskell"
c6$language = "Haskell"
l6$language = "Haskell"

write("<CodeModelTable>",file=effect_size_file, append=TRUE)
printWilcox(n1$ngram_entropy, c1$cache_entropy, paste(n1$language[[1]], "_ngram"), paste(c1$language[[1]], "_cache"), TRUE)
printWilcox(ng$ngram_entropy, cg$cache_entropy, paste(ng$language[[1]], "_ngram"), paste(cg$language[[1]], "_cache"), TRUE)
printWilcox(ns$ngram_entropy, cs$cache_entropy, paste(ns$language[[1]], "_ngram"), paste(cs$language[[1]], "_cache"), TRUE)
printWilcox(n2$ngram_entropy, c2$cache_entropy, paste(n2$language[[1]], "_ngram"), paste(c2$language[[1]], "_cache"), TRUE)
printWilcox(n3$ngram_entropy, c3$cache_entropy, paste(n3$language[[1]], "_ngram"), paste(c3$language[[1]], "_cache"), TRUE)
printWilcox(n4$ngram_entropy, c4$cache_entropy, paste(n4$language[[1]], "_ngram"), paste(c4$language[[1]], "_cache"), TRUE)
printWilcox(n5$ngram_entropy, c5$cache_entropy, paste(n5$language[[1]], "_ngram"), paste(c5$language[[1]], "_cache"), TRUE)
printWilcox(n6$ngram_entropy, c6$cache_entropy, paste(n6$language[[1]], "_ngram"), paste(c6$language[[1]], "_cache"), TRUE)
write("<\\CodeModelTable>",file=effect_size_file, append=TRUE)

write("<CodeModelTable2>",file=effect_size_file, append=TRUE)
printWilcox(c1$cache_entropy, l1$lstm_entropy, paste(n1$language[[1]], "_cache"), paste(c1$language[[1]], "_lstm"), TRUE)
printWilcox(cg$cache_entropy, lg$lstm_entropy, paste(ng$language[[1]], "_cache"), paste(cg$language[[1]], "_lstm"), TRUE)
printWilcox(cs$cache_entropy, ls$lstm_entropy, paste(ns$language[[1]], "_cache"), paste(cs$language[[1]], "_lstm"), TRUE)
printWilcox(c2$cache_entropy, l2$lstm_entropy, paste(n2$language[[1]], "_cache"), paste(c2$language[[1]], "_lstm"), TRUE)
printWilcox(c3$cache_entropy, l3$lstm_entropy, paste(n3$language[[1]], "_cache"), paste(c3$language[[1]], "_lstm"), TRUE)
printWilcox(c4$cache_entropy, l4$lstm_entropy, paste(n4$language[[1]], "_cache"), paste(c4$language[[1]], "_lstm"), TRUE)
printWilcox(c5$cache_entropy, l5$lstm_entropy, paste(n5$language[[1]], "_cache"), paste(c5$language[[1]], "_lstm"), TRUE)
printWilcox(c6$cache_entropy, l6$lstm_entropy, paste(n6$language[[1]], "_cache"), paste(c6$language[[1]], "_lstm"), TRUE)
write("<\\CodeModelTable2>",file=effect_size_file, append=TRUE)

write("<CodeVsEngTable>",file=effect_size_file, append=TRUE)
#Do wilcox comparisons of each code vs English.
printWilcox(ng$ngram_entropy, n1$ngram_entropy, ng$language[[1]], n1$language[[1]], FALSE)
printWilcox(ns$ngram_entropy, n1$ngram_entropy, ns$language[[1]], n1$language[[1]], FALSE)
printWilcox(n2$ngram_entropy, n1$ngram_entropy, n2$language[[1]], n1$language[[1]], FALSE)
printWilcox(n3$ngram_entropy, n1$ngram_entropy, n3$language[[1]], n1$language[[1]], FALSE)
printWilcox(n4$ngram_entropy, n1$ngram_entropy, n4$language[[1]], n1$language[[1]], FALSE)
printWilcox(n5$ngram_entropy, n1$ngram_entropy, n5$language[[1]], n1$language[[1]], FALSE)
printWilcox(n6$ngram_entropy, n1$ngram_entropy, n6$language[[1]], n1$language[[1]], FALSE)

printWilcox(cg$cache_entropy, c1$cache_entropy, cg$language[[1]], c1$language[[1]], FALSE)
printWilcox(cs$cache_entropy, c1$cache_entropy, cs$language[[1]], c1$language[[1]], FALSE)
printWilcox(c2$cache_entropy, c1$cache_entropy, c2$language[[1]], c1$language[[1]], FALSE)
printWilcox(c3$cache_entropy, c1$cache_entropy, c3$language[[1]], c1$language[[1]], FALSE)
printWilcox(c4$cache_entropy, c1$cache_entropy, c4$language[[1]], c1$language[[1]], FALSE)
printWilcox(c5$cache_entropy, c1$cache_entropy, c5$language[[1]], c1$language[[1]], FALSE)
printWilcox(c6$cache_entropy, c1$cache_entropy, c6$language[[1]], c1$language[[1]], FALSE)

printWilcox(lg$lstm_entropy, l1$lstm_entropy, lg$language[[1]], l1$language[[1]], FALSE)
printWilcox(ls$lstm_entropy, l1$lstm_entropy, ls$language[[1]], l1$language[[1]], FALSE)
printWilcox(l2$lstm_entropy, l1$lstm_entropy, l2$language[[1]], l1$language[[1]], FALSE)
printWilcox(l3$lstm_entropy, l1$lstm_entropy, l3$language[[1]], l1$language[[1]], FALSE)
printWilcox(l4$lstm_entropy, l1$lstm_entropy, l4$language[[1]], l1$language[[1]], FALSE)
printWilcox(l5$lstm_entropy, l1$lstm_entropy, l5$language[[1]], l1$language[[1]], FALSE)
printWilcox(l6$lstm_entropy, l1$lstm_entropy, l6$language[[1]], l1$language[[1]], FALSE)
write("<\\CodeVsEngTable>",file=effect_size_file, append=TRUE)


combined <- rbind(n1, ng, ns, n2, n3 ,n4, n5, n6)
drawNgramBoxplot(combined, "", YLabelNgram,"./Plots/PLVsNL3gramBoxplot.tiff")
drawNgramBoxplot(combined, "", YLabelNgram,"./Plots/PLVsNL3gramBoxplot.png")

combined  <- rbind(c1, cg, cs, c2, c3, c4, c5, c6)
drawCacheBoxplot(combined, "", YLabelCache,"./Plots/PLVsNL3gramCacheBoxplot.tiff")
drawCacheBoxplot(combined, "", YLabelCache,"./Plots/PLVsNL3gramCacheBoxplot.png")

combined  <- rbind(l1,lg,ls,l2,l3,l4,l5,l6)
drawLSTMBoxplot(combined, "", YLabelLSTM,"./Plots/PLVsNLLSTMBoxplot.tiff")
drawLSTMBoxplot(combined, "", YLabelLSTM,"./Plots/PLVsNLLSTMBoxplot.png")

#Domain 
#(Revise to make sure we use the small corpora)
list[n_b, c_b, l_b, ent_plot1] <- createEntropyPlots("brown_full", "Brown Lstm vs 3 gram entropy density", "Brown Lstm vs 3 gram entropy boxplot", "Brown")
list[n_j, c_j, l_j, ent_plot2] <- createEntropyPlots("djava_no_collapse_small","Java Lstm vs 3 gram entropy density" ,"Java Name Lstm vs 3 gram entropy boxplot","DJavaSmall")
#list[n_j, c_j, l_j, ent_plot2] <- createEntropyPlots("djava_small","Java Lstm vs 3 gram entropy density" ,"Java Name Lstm vs 3 gram entropy boxplot","DJavaSmall")


list[n1, c1, l1, ent_plot] <- createEntropyPlots("nasa_full", "Nasa Lstm vs 3 gram entropy density", "Nasa Lstm vs 3 gram entropy boxplot", "Nasa")
list[n2, c2, l2, ent_plot] <- createEntropyPlots("scifi_full", "Scifi Lstm vs 3 gram entropy density", "Scifi Lstm vs 3 gram entropy boxplot", "Scifi")
list[n3, c3, l3, ent_plot] <- createEntropyPlots("law_full", "Law Lstm vs 3 gram entropy density", "Law Lstm vs 3 gram entropy boxplot", "Law")
list[n4, c4, l4, ent_plot] <- createEntropyPlots("shakespeare_full", "Shakespeare Lstm vs 3 gram entropy density", "Shakespeare Lstm vs 3 gram entropy boxplot", "Shakespeare")
list[n5, c5, l5, ent_plot] <- createEntropyPlots("recipes_full", "Recipe Lstm vs 3 gram entropy density", "Recipe Lstm vs 3 gram entropy boxplot", "Recipe")
list[n6, c6, l6, ent_plot] <- createEntropyPlots("commits_full", "Commit Lstm vs 3 gram entropy density", "Commit Lstm vs 3 gram entropy boxplot", "Commit")


printWilcox(n1$ngram_entropy, c1$cache_entropy, "NASA Ngram", "NASA Cache", TRUE) # Cache worse, but neglible
printWilcox(n3$ngram_entropy, c3$cache_entropy, "LAW Ngram", "LAW Cache", TRUE) #Cache better, small effect.

printWilcox(n2$ngram_entropy, c2$cache_entropy, "Scifi Ngram", "Scifi Cache", TRUE) 
printWilcox(n4$ngram_entropy, c4$cache_entropy, "Shakespeare Ngram", "Shakespeare Cache", TRUE) 

printWilcox(n5$ngram_entropy, c5$cache_entropy, "Recipes Ngram", "Recipe Cache", TRUE)
printWilcox(n5$ngram_entropy, c5$cache_entropy, "Commits Ngram", "Commits Cache", TRUE)

printWilcox(n_b$ngram_entropy, c_b$cache_entropy, "Brown Ngram", "Brown Cache", TRUE) 
printWilcox(n_j$ngram_entropy, c_j$cache_entropy, "Java Ngram", "Java Cache", TRUE) 


#Create boxplots for each of the 3 types of models.
n_j$language = "Java"
c_j$language = "Java"
l_j$language = "Java"

n_b$language = "Brown"
c_b$language = "Brown"
l_b$language = "Brown"

n1$language = "Nasa"
c1$language = "Nasa"
l1$language = "Nasa"

n2$language = "Scifi"
c2$language = "Scifi"
l2$language = "Scifi"

n3$language = "Law"
c3$language = "Law"
l3$language = "Law"

n4$language = "Shakespeare"
c4$language = "Shakespeare"
l4$language = "Shakespeare"

n5$language = "Recipes"
c5$language = "Recipes"
l5$language = "Recipes"

n6$language = "Commits"
c6$language = "Commits"
l6$language = "Commits"

write("<TechTable>",file=effect_size_file, append=TRUE)
#Do wilcox comparisons for all the domain specific langauges.
printWilcox(n_j$ngram_entropy, n_b$ngram_entropy, n_j$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n1$ngram_entropy, n_b$ngram_entropy, n1$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n2$ngram_entropy, n_b$ngram_entropy, n2$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n3$ngram_entropy, n_b$ngram_entropy, n3$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n4$ngram_entropy, n_b$ngram_entropy, n4$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n5$ngram_entropy, n_b$ngram_entropy, n5$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n6$ngram_entropy, n_b$ngram_entropy, n6$language[[1]], n_b$language[[1]], FALSE)

printWilcox(c_j$cache_entropy, c_b$cache_entropy, c_j$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c1$cache_entropy, c_b$cache_entropy, c1$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c2$cache_entropy, c_b$cache_entropy, c2$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c3$cache_entropy, c_b$cache_entropy, c3$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c4$cache_entropy, c_b$cache_entropy, c4$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c5$cache_entropy, c_b$cache_entropy, c5$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c6$cache_entropy, c_b$cache_entropy, c6$language[[1]], c_b$language[[1]], FALSE)

printWilcox(l_j$lstm_entropy, l_b$lstm_entropy, l_j$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l1$lstm_entropy, l_b$lstm_entropy, l1$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l2$lstm_entropy, l_b$lstm_entropy, l2$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l3$lstm_entropy, l_b$lstm_entropy, l3$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l4$lstm_entropy, l_b$lstm_entropy, l4$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l5$lstm_entropy, l_b$lstm_entropy, l5$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l6$lstm_entropy, l_b$lstm_entropy, l6$language[[1]], l_b$language[[1]], FALSE)

#And vs Java
printWilcox(n_b$ngram_entropy, n_j$ngram_entropy, n_b$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n1$ngram_entropy, n_j$ngram_entropy, n1$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n2$ngram_entropy, n_j$ngram_entropy, n2$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n3$ngram_entropy, n_j$ngram_entropy, n3$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n4$ngram_entropy, n_j$ngram_entropy, n4$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n5$ngram_entropy, n_j$ngram_entropy, n5$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n6$ngram_entropy, n_j$ngram_entropy, n6$language[[1]], n_j$language[[1]], FALSE)

printWilcox(c_b$cache_entropy, c_j$cache_entropy, c_b$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c1$cache_entropy, c_j$cache_entropy, c1$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c2$cache_entropy, c_j$cache_entropy, c2$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c3$cache_entropy, c_j$cache_entropy, c3$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c4$cache_entropy, c_j$cache_entropy, c4$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c5$cache_entropy, c_j$cache_entropy, c5$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c6$cache_entropy, c_j$cache_entropy, c6$language[[1]], c_j$language[[1]], FALSE)

printWilcox(l_b$lstm_entropy, l_j$lstm_entropy, l_b$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l1$lstm_entropy, l_j$lstm_entropy, l1$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l2$lstm_entropy, l_j$lstm_entropy, l2$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l3$lstm_entropy, l_j$lstm_entropy, l3$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l4$lstm_entropy, l_j$lstm_entropy, l4$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l5$lstm_entropy, l_j$lstm_entropy, l5$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l6$lstm_entropy, l_j$lstm_entropy, l6$language[[1]], l_j$language[[1]], FALSE)
write("<\\TechTable>",file=effect_size_file, append=TRUE)

n <- rbind(n_j, n_b, n1, n2, n3 ,n4, n5,n6)
drawNgramBoxplot(n, "", YLabelNgram,"./Plots/DomainSpecific3gramBoxplot.tiff")
drawNgramBoxplot(n, "", YLabelNgram,"./Plots/DomainSpecific3gramBoxplot.png")

cache <- rbind(c_j, c_b, c1, c2, c3, c4,c5,c6)
drawCacheBoxplot(cache, "", YLabelCache,"./Plots/DomainSpecific3gramCacheBoxplot.tiff")
drawCacheBoxplot(cache, "", YLabelCache,"./Plots/DomainSpecific3gramCacheBoxplot.png")

l <- rbind(l_j, l_b, l1,l2,l3,l4,l5,l6)
drawLSTMBoxplot(l, "", YLabelLSTM,"./Plots/DomainSpecificLSTMBoxplot.tiff")
drawLSTMBoxplot(l, "", YLabelLSTM,"./Plots/DomainSpecificLSTMBoxplot.png")



#EFL
list[n_b, c_b, l_b, ent_plot1] <- createEntropyPlots("brown_full", "Brown Lstm vs 3 gram entropy density", "Brown Lstm vs 3 gram entropy boxplot", "Brown")
list[n_j, c_j, l_j, ent_plot2] <- createEntropyPlots("djava_no_collapse_small","Java Lstm vs 3 gram entropy density" ,"Java Name Lstm vs 3 gram entropy boxplot","DJavaSmall")
#list[n_j, c_j, l_j, ent_plot2] <- createEntropyPlots("djava_small","Java Lstm vs 3 gram entropy density" ,"Java Name Lstm vs 3 gram entropy boxplot","DJavaSmall")

list[n1, c1, l1, ent_plot] <- createEntropyPlots("gachon_full", "Gachon Lstm vs 3 gram entropy density", "Gachon Lstm vs 3 gram entropy boxplot", "Gachon")
list[n2, c2, l2, ent_plot] <- createEntropyPlots("teccl_full", "Teccl Lstm vs 3 gram entropy density", "Teccl Lstm vs 3 gram entropy boxplot", "Teccl")

n_j$language = "Java"
c_j$language = "Java"
l_j$language = "Java"

n_b$language = "Brown"
c_b$language = "Brown"
l_b$language = "Brown"

n1$language = "Gachon"
c1$language = "Gachon"
l1$language = "Gachon"

n2$language = "Teccl"
c2$language = "Teccl"
l2$language = "Teccl"

write("<EFLTable>",file=effect_size_file, append=TRUE)
#Do wilcox comparisons for all the domain specific langauges vs english base
printWilcox(n_j$ngram_entropy, n_b$ngram_entropy, n_j$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n1$ngram_entropy, n_b$ngram_entropy, n1$language[[1]], n_b$language[[1]], FALSE)
printWilcox(n2$ngram_entropy, n_b$ngram_entropy, n2$language[[1]], n_b$language[[1]], FALSE)

printWilcox(c_j$cache_entropy, c_b$cache_entropy, c_j$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c1$cache_entropy, c_b$cache_entropy, c1$language[[1]], c_b$language[[1]], FALSE)
printWilcox(c2$cache_entropy, c_b$cache_entropy, c2$language[[1]], c_b$language[[1]], FALSE)

printWilcox(l_j$lstm_entropy, l_b$lstm_entropy, l_j$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l1$lstm_entropy, l_b$lstm_entropy, l1$language[[1]], l_b$language[[1]], FALSE)
printWilcox(l2$lstm_entropy, l_b$lstm_entropy, l2$language[[1]], l_b$language[[1]], FALSE)

#And vs Java
printWilcox(n_b$ngram_entropy, n_j$ngram_entropy, n_b$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n1$ngram_entropy, n_j$ngram_entropy, n1$language[[1]], n_j$language[[1]], FALSE)
printWilcox(n2$ngram_entropy, n_j$ngram_entropy, n2$language[[1]], n_j$language[[1]], FALSE)

printWilcox(c_b$cache_entropy, c_j$cache_entropy, c_b$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c1$cache_entropy, c_j$cache_entropy, c1$language[[1]], c_j$language[[1]], FALSE)
printWilcox(c2$cache_entropy, c_j$cache_entropy, c2$language[[1]], c_j$language[[1]], FALSE)

printWilcox(l_b$lstm_entropy, l_j$lstm_entropy, l_b$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l1$lstm_entropy, l_j$lstm_entropy, l1$language[[1]], l_j$language[[1]], FALSE)
printWilcox(l2$lstm_entropy, l_j$lstm_entropy, l2$language[[1]], l_j$language[[1]], FALSE)
stats_out = file(effect_size_file, 'a')
write("<\\EFLTable>",file=stats_out, append=TRUE)
close(stats_out)


n <- rbind(n_j, n_b, n1, n2)
drawNgramBoxplot(n, "", YLabelNgram,"./Plots/EFL3gramBoxplot.tiff")
drawNgramBoxplot(n, "", YLabelNgram,"./Plots/EFL3gramBoxplot.png")

colnames(c_j) <- c("file","id","token","cache_entropy","language")
cache <- rbind(c_j, c_b, c1, c2)
drawCacheBoxplot(cache, "", YLabelCache,"./Plots/EFL3gramCacheBoxplot.tiff")
drawCacheBoxplot(cache, "", YLabelCache,"./Plots/EFL3gramCacheBoxplot.png")

l <- rbind(l_j, l_b, l1,l2)
drawLSTMBoxplot(l, "", YLabelLSTM,"./Plots/EFLLSTMBoxplot.tiff")
drawLSTMBoxplot(l, "", YLabelLSTM,"./Plots/EFLLSTMBoxplot.png")
