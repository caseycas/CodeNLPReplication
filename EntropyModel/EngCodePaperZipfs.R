#This R Script will produce the zipf plots used in the 
#ESE Journal paper.
library(sqldf)
library(lsr)
library(ggplot2)

source(file = "./EntropyModel/ZipfSlopeFunctions.R")

#Full Scale version
labels = c("English Unigrams", "Java Unigrams")
#inputFiles <- c("./NgramData/EnglishUnigrams.csv", "./NgramData/DJavaUnigrams.csv")
inputFiles <- c("./NgramData/EnglishUnigrams.csv", "./NgramData/no_collapse/DJavaUnigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/JavaEnglishUnigramZipf.tiff")
#plot = generateNormalizedFreqPlot(data, "./Plots/JavaEnglishUnigramZipf.pdf")


labels = c("English Bigrams", "Java Bigrams")
inputFiles <- c("./NgramData/EnglishBigrams.csv", "./NgramData/no_collapse/DJavaBigrams.csv")
#inputFiles <- c("./NgramData/EnglishBigrams.csv", "./NgramData/DJavaBigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/JavaEnglishBigramZipf.tiff")


labels = c("English Trigrams", "Java Trigrams")
inputFiles <- c("./NgramData/EnglishTrigrams.csv", "./NgramData/no_collapse/DJavaTrigrams.csv")
#inputFiles <- c("./NgramData/EnglishTrigrams.csv", "./NgramData/DJavaTrigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/JavaEnglishTrigramZipf.tiff")
#plot = generateNormalizedFreqPlot(data, "./Plots/JavaEnglishTrigramZipf.pdf")


# #Names with Literals
labels = c("English Unigrams", "Java Unigrams", "Haskell Unigrams", "Ruby Unigrams", "Clojure Unigrams", "C Unigrams")
inputFiles <- c("./NgramData/no_collapse/EnglishNamesUnigrams.csv", "./NgramData/no_collapse/DJavaNameUnigrams.csv", "./NgramData/no_collapse/HaskellNameUnigrams.csv", "./NgramData/no_collapse/RubyNameUnigrams.csv", "./NgramData/no_collapse/ClojureNameUnigrams.csv","./NgramData/no_collapse/CNameUnigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/CodeEnglishNameUnigramZipf.tiff")

labels = c("English Bigrams", "Java Bigrams", "Haskell Bigrams", "Ruby Bigrams", "Clojure Bigrams", "C Bigrams")
inputFiles <- c("./NgramData/no_collapse/EnglishNamesBigrams.csv", "./NgramData/no_collapse/DJavaNameBigrams.csv", "./NgramData/no_collapse/HaskellNameBigrams.csv", "./NgramData/no_collapse/RubyNameBigrams.csv", "./NgramData/no_collapse/ClojureNameBigrams.csv","./NgramData/no_collapse/CNameBigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/CodeEnglishNameBigramZipf.tiff")


labels = c("English Trigrams", "Java Trigrams", "Haskell Trigrams", "Ruby Trigrams", "Clojure Trigrams", "C Trigrams")
inputFiles <- c("./NgramData/no_collapse/EnglishNamesTrigrams.csv", "./NgramData/no_collapse/DJavaNameTrigrams.csv", "./NgramData/no_collapse/HaskellNameTrigrams.csv", "./NgramData/no_collapse/RubyNameTrigrams.csv", "./NgramData/no_collapse/ClojureNameTrigrams.csv", "./NgramData/no_collapse/CNameTrigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/CodeEnglishNameTrigramZipf.tiff")


#EFL Vs Brown And Java
#Unigram
labels = c("English (Brown) Unigrams", "Java (Small) Unigrams", "Gachon Unigrams", "Teccl Unigrams")
#inputFiles <- c("./NgramData/BrownUnigrams.csv", "./NgramData/DJavaEqUnigrams.csv", "./NgramData/EFL_GachonUnigrams.csv","./NgramData/EFL_TECCLUnigrams.csv")
inputFiles <- c("./NgramData/BrownUnigrams.csv", "./NgramData/no_collapse_small/DJavaUnigrams.csv", "./NgramData/EFL_GachonUnigrams.csv","./NgramData/EFL_TECCLUnigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishProficiencyUnigramZipf.tiff")

#Bigram
labels = c("English (Brown) Bigrams", "Java (Small) Bigrams", "Gachon Bigrams", "Teccl Bigrams")
#inputFiles <- c("./NgramData/BrownBigrams.csv", "./NgramData/DJavaEqBigrams.csv", "./NgramData/EFL_GachonBigrams.csv","./NgramData/EFL_TECCLBigrams.csv")
inputFiles <- c("./NgramData/BrownBigrams.csv", "./NgramData/no_collapse_small/DJavaBigrams.csv", "./NgramData/EFL_GachonBigrams.csv","./NgramData/EFL_TECCLBigrams.csv")

data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishProficiencyBigramZipf.tiff")

#Trigram
labels = c("English (Brown) Trigrams", "Java (Small) Trigrams", "Gachon Trigrams", "Teccl Trigrams")
#inputFiles <- c("./NgramData/BrownTrigrams.csv", "./NgramData/DJavaEqTrigrams.csv", "./NgramData/EFL_GachonTrigrams.csv","./NgramData/EFL_TECCLTrigrams.csv")
inputFiles <- c("./NgramData/BrownTrigrams.csv", "./NgramData/no_collapse_small/DJavaTrigrams.csv", "./NgramData/EFL_GachonTrigrams.csv","./NgramData/EFL_TECCLTrigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishProficiencyTrigramZipf.tiff")

#Technical corpora
labels = c("Brown Unigrams", "Java (Small) Unigrams", "Scifi Unigrams", "Shakespeare Unigrams", "NASA Unigrams", "US Code Unigrams", "Recipe Unigrams", "Commit (Small) Unigrams")
#inputFiles <- c("./NgramData/BrownUnigrams.csv","./NgramData/DJavaEqUnigrams.csv", "./NgramData/SFUnigrams.csv", "./NgramData/SPUnigrams.csv", "./NgramData/NASAUnigrams.csv", "./NgramData/LEUnigrams.csv")
inputFiles <- c("./NgramData/BrownUnigrams.csv","./NgramData/no_collapse_small/DJavaUnigrams.csv", "./NgramData/SFUnigrams.csv", "./NgramData/SPUnigrams.csv", "./NgramData/NASAUnigrams.csv", "./NgramData/LEUnigrams.csv", "./NgramData/RecipeUnigrams.csv", "./NgramData/CMSmallUnigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishDomainsVsJavaUnigramsZipf.tiff", c("Java (Small) Unigrams","Commit (Small) Unigrams", "US Code Unigrams", "Recipe Unigrams","NASA Unigrams","Scifi Unigrams", "Shakespeare Unigrams","English Unigrams"))

labels = c("Brown Bigrams", "Java (Small) Bigrams", "Scifi Bigrams", "Shakespeare Bigrams", "NASA Bigrams", "US Code Bigrams", "Recipe Bigrams", "Commit (Small) Bigrams")
#inputFiles <- c("./NgramData/BrownBigrams.csv","./NgramData/DJavaEqBigrams.csv", "./NgramData/SFBigrams.csv", "./NgramData/SPBigrams.csv", "./NgramData/NASABigrams.csv", "./NgramData/LEBigrams.csv")
inputFiles <- c("./NgramData/BrownBigrams.csv","./NgramData/no_collapse_small/DJavaBigrams.csv", "./NgramData/SFBigrams.csv", "./NgramData/SPBigrams.csv", "./NgramData/NASABigrams.csv", "./NgramData/LEBigrams.csv", "./NgramData/RecipeBigrams.csv","./NgramData/CMSmallBigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishDomainsVsJavaBigramsZipf.tiff", c("Java (Small) Bigrams","Commit (Small) Bigrams","US Code Bigrams","Recipe Bigrams","NASA Bigrams","Scifi Bigrams", "Shakespeare Bigrams","English Bigrams"))


labels = c("Brown Trigrams", "Java (Small) Trigrams", "Scifi Trigrams", "Shakespeare Trigrams", "NASA Trigrams", "US Code Trigrams", "Recipe Trigrams", "Commit (Small) Trigrams")
#inputFiles <- c("./NgramData/BrownTrigrams.csv","./NgramData/DJavaEqTrigrams.csv", "./NgramData/SFTrigrams.csv", "./NgramData/SPTrigrams.csv", "./NgramData/NASATrigrams.csv", "./NgramData/LETrigrams.csv")
inputFiles <- c("./NgramData/BrownTrigrams.csv","./NgramData/no_collapse_small/DJavaTrigrams.csv", "./NgramData/SFTrigrams.csv", "./NgramData/SPTrigrams.csv", "./NgramData/NASATrigrams.csv", "./NgramData/LETrigrams.csv", "./NgramData/RecipeTrigrams.csv","./NgramData/CMSmallTrigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/EnglishDomainsVsJavaTrigramsZipf.tiff", c("Java (Small) Trigrams","Commit (Small) Trigrams","US Code Trigrams", "Recipe Trigrams", "NASA Trigrams","Scifi Trigrams", "Shakespeare Trigrams","English Trigrams"))


#General Comparison of Natural and Programming Languages
labels = c("English Unigrams", "German Unigrams", "Spanish Unigrams", "Java Unigrams", "Ruby Unigrams", "C Unigrams", "Haskell Unigrams", "Clojure Unigrams")
#inputFiles <- c("./NgramData/EnglishBigrams.csv", "./NgramData/DJavaBigrams.csv","./NgramData/RubyBigrams.csv","./NgramData/CBigrams.csv", "./NgramData/HaskellBigrams.csv","./NgramData/ClojureBigrams.csv")
inputFiles <- c("./NgramData/EnglishUnigrams.csv", "./NgramData/GermanUnigrams.csv", "./NgramData/SpanishUnigrams.csv", "./NgramData/no_collapse/DJavaUnigrams.csv","./NgramData/no_collapse/RubyUnigrams.csv","./NgramData/no_collapse/CUnigrams.csv", "./NgramData/no_collapse/HaskellUnigrams.csv","./NgramData/no_collapse/ClojureUnigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/NLVsPLUnigramsZipf.tiff", c("C Unigrams","Clojure Unigrams","Ruby Unigrams", "Java Unigrams", "Haskell Unigrams", "English Unigrams", "German Unigrams", "Spanish Unigrams"))



labels = c("English Bigrams",  "German Bigrams", "Spanish Bigrams","Java Bigrams", "Ruby Bigrams", "C Bigrams", "Haskell Bigrams", "Clojure Bigrams")
#inputFiles <- c("./NgramData/EnglishBigrams.csv", "./NgramData/DJavaBigrams.csv","./NgramData/RubyBigrams.csv","./NgramData/CBigrams.csv", "./NgramData/HaskellBigrams.csv","./NgramData/ClojureBigrams.csv")
inputFiles <- c("./NgramData/EnglishBigrams.csv", "./NgramData/GermanBigrams.csv", "./NgramData/SpanishBigrams.csv","./NgramData/no_collapse/DJavaBigrams.csv","./NgramData/no_collapse/RubyBigrams.csv","./NgramData/no_collapse/CBigrams.csv", "./NgramData/no_collapse/HaskellBigrams.csv","./NgramData/no_collapse/ClojureBigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/NLVsPLBigramsZipf.tiff", c("C Bigrams","Clojure Bigrams","Ruby Bigrams", "Java Bigrams", "Haskell Bigrams", "English Bigrams", "German Bigrams", "Spanish Bigrams"))

#English Full vs Program Language Full
labels = c("English Trigrams", "German Trigrams", "Spanish Trigrams", "Java Trigrams", "Ruby Trigrams", "C Trigrams", "Haskell Trigrams", "Clojure Trigrams")
#inputFiles <- c("./NgramData/EnglishTrigrams.csv", "./NgramData/DJavaTrigrams.csv","./NgramData/RubyTrigrams.csv","./NgramData/CTrigrams.csv", "./NgramData/HaskellTrigrams.csv","./NgramData/ClojureTrigrams.csv")
inputFiles <- c("./NgramData/EnglishTrigrams.csv", "./NgramData/GermanTrigrams.csv", "./NgramData/SpanishTrigrams.csv", "./NgramData/no_collapse/DJavaTrigrams.csv","./NgramData/no_collapse/RubyTrigrams.csv","./NgramData/no_collapse/CTrigrams.csv", "./NgramData/no_collapse/HaskellTrigrams.csv","./NgramData/no_collapse/ClojureTrigrams.csv")
data <- getDatasets(inputFiles, labels)
plot = generateNormalizedFreqPlot(data, "./Plots/NLVsPLTrigramsZipf.tiff", c("C Trigrams","Clojure Trigrams","Ruby Trigrams", "Java Trigrams", "Haskell Trigrams", "English Trigrams", "German Trigrams", "Spanish Trigrams"))
