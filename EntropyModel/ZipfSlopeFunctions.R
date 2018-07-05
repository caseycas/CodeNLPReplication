library(ggplot2)
library(plyr)
library(zipfR)
library(sqldf)

#Definition for a colorblind friendly template.
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7", "#0072B2", "#D55E00","#F0E442", "#000000", "#999999", "#a50026")
#ColorBrewer
#cbbPalette <- c("#a50026", "#d73027", "#f46d43", "#fdae61", "#fee090", "#e0f3f8", "#abd9e9", "#74add1", "#4575b4", "#313695")

#The Zipf package uses data objects of the form m, Vm
#Where m is the frequency and Vm is the number of distinct
#types at that frequency.  This function converts one of my
#styled dataframes (has a count and ID column) into this form
createFreqSpec <- function(countData)
{
  return(sqldf("SELECT count(*) as Vm, count as m FROM countData GROUP BY count ORDER BY m"))
}

#Create a 'text' based on the unigram counts
fabricateRaw <- function(countData)
{
  output <- c()
  for(i in 1:nrow(countData))
  {
    print(i)
    output <- c(output, rep(as.character(countData$ngram[i]), countData$count[i]))
  }
  return(output)
}

#tmp <- fabricateRaw(BrownUnigram)

zipfOnly <- function(ranks, alpha)
{
  return(1/((ranks)^alpha))
}



lzipf <- function(s,N) -s*log(1:N)-log(sum(1/(1:N)^s))

lzipf2 <- function(a,b,N) -a*log((1:N)+b)-log(sum(1/((1:N)+b)^a))

#Mle testing (Okay, so how to add the Mandelbrot Beta? or should I bother?)
#ll <- function(s) sum(EnglishUnigrams$freq*(s*log(1:nrow(EnglishUnigrams))+log(sum(1/(1:nrow(EnglishUnigrams))^s))))
#fit <- mle(ll, start = list(s=1))
#plot(EnglishUnigrams$ID, EnglishUnigrams$freq, log="xy")
#lines(EnglishUnigrams$ID, exp(lzipf(s.ll, nrow(EnglishUnigrams))), col=2)
#ll2 <- function(s) sum(JavaUnigrams$freq*(s*log(1:nrow(JavaUnigrams))+log(sum(1/(1:nrow(JavaUnigrams))^s))))
#fit2 <- mle(ll2, start = list(s=1))
#plot(JavaUnigrams$ID, JavaUnigrams$freq, log="xy")
#lines(JavaUnigrams$ID, exp(lzipf(s.ll, nrow(JavaUnigrams))), col=2)

#Residuals

#Vector of counts with scalar alpha and beta values, returns the predicted count.
zipfMandelbrot <- function(ranks, alpha, beta)
{
  return(1/(ranks + beta)^alpha)
}

# a log-likelihood function for Zipf Mandlebrot distribution 
# f(r) = 1/(r + Beta) ^ alpha
LL <- function(alpha, beta) {
  
}

#Turn the counts into percentages and frequencies
normalizeCount <- function(data)
{
  data$freq <- data$count/sum(data$count)
  data$percent <-  data$freq*100
  return(data)
}

#Compute a confidence interval for a distribution
#Distribution - a vector/list for the distribution
#Prob - the confidence interval probability (e.g. .95, .99)
#bonferroniCorrection - the number of hypotheses being tested.
getConfInt <- function(distribution, prob, bonferroniCorrection)
{
  distribution = distribution[!is.na(distribution)]
  print(distribution)
  m = mean(distribution)
  var = var(distribution)
  error = qt(1-prob/bonferroniCorrection, df = length(distribution)-1)*sqrt(var/length(distribution))
  return(c(round(m-error, 7), round(m+error,7)))
}


powerLaw <- function(c_value, y_value, x)
{
  c_value*x ^ y_value
}

doublePowerLaw <- function(c_value, y_value, b_value, x)
{
  ifelse(x <= b_value,  c_value*x^-1, c_value*(b_value^ (y_value-1) * x ^ (-y_value)))
}

#Given a dataset with an 'ID' rank column and a 'percent' column, fit
# linear regression to the logged versions of them and return the slope
#NOTE, make ID start with 1 not 0 for this function
getZipfSlope <- function(dataset)
{
  reg = lm(log(percent, 10) ~ log(ID, 10), data = dataset)
  return(reg$coefficients[[2]])
}

#Get the local filename of a .csv file (Remove the file path and the .csv ending)
getCsvLabel <- function(filename)
{
  divided = strsplit(filename, "/")
  local = divided[[1]][length(divided[[1]])]
  return(substr(local, 1, nchar(local)-4))
}

#Read in a csv file with three columns, one for the ID, one for the ngram, and
#one for the ngram's count. Give it header names and turn the counts into
#percentages.  Then, label all items in the dataset with 'label', useful for 
#when distinguising datasets for the ggplots.
readInCsv <- function(inputFile, label)
{
  tmp = read.csv(inputFile,  header=FALSE, quote="")
  colnames(tmp) = c("ID", "ngram", "count")
  tmp$ID = tmp$ID+1 #Reset to start at 1.
  tmp = normalizeCount(tmp)
  tmp$group <- label
  return(tmp)
}

# brown.MLE <- zm.ll(BrownUnigram$count, N = nrow(BrownUnigram), dist = "Zipf-Man")

#Given a list of csv files to read in, produce a list of data frames.
#Each csv file should have 3 columns, an ID rank, the ngram, and an ngram count.
getDatasets <- function(inputFiles, labels = c())
{
  datasets = c()
  if(length(labels) != length(inputFiles))
  {
    for (i in 1:length(inputFiles))
    {
     datasets[[i]] = readInCsv(inputFiles[i], getCsvLabel(inputFiles[i]))
     print(getCsvLabel(inputFiles[i]))
     print(paste("Token Count: ", sum(datasets[[i]]$count)))
    }
  }
  else
  {
    for (i in 1:length(inputFiles))
    {
      datasets[[i]] = readInCsv(inputFiles[i], labels[i])
      print(labels[i])
      print(paste("Token Count: ", sum(datasets[[i]]$count)))
    }
  }
  return(datasets)
}

#InputFiles is a pair, this builds a new table using the ranks of the terms 
#in the first table and the frequencies of the terms in the second.
#Keep only the terms observed in the ranks of the first.
buildIndepentRankFreq <- function(inputFiles, label)
{
  rankCorpus = readInCsv(inputFiles[[1]], label)
  freqCorpus = readInCsv(inputFiles[[2]], label)
  combined = sqldf("SELECT rankCorpus.ID as ID, rankCorpus.ngram as ngram, freqCorpus.count as count, freqCorpus.freq as freq, freqCorpus.percent as percent FROM rankCorpus INNER JOIN freqCorpus ON rankCorpus.ngram = freqCorpus.ngram ORDER BY rankCorpus.ID;")
  combined$group = label
  return(combined)
}

#Similar to above, but keeps ALL ranks from the first corpus. Assign a very small count
#to them to approximate count 0.
buildIndepentRankFreqRetaining <- function(inputFiles, label)
{
  rankCorpus = readInCsv(inputFiles[[1]], label)
  freqCorpus = readInCsv(inputFiles[[2]], label)
  combined = sqldf("SELECT rankCorpus.ID as ID, rankCorpus.ngram as ngram, freqCorpus.count as count, freqCorpus.freq as freq, freqCorpus.percent as percent FROM rankCorpus LEFT JOIN freqCorpus ON rankCorpus.ngram = freqCorpus.ngram ORDER BY rankCorpus.ID;")
  #combined[is.na(combined$count),]$count = .001
  #combined = normalizeCount(combined)
  combined$group = label
  return(combined)
}

#Produce a log-scaled normalized Ngram frequency plot and save it to outputFile.
generateNormalizedFreqPlot <- function(datasets, outputFile, legend_labels = c(), plot_title = "")
{
  combined = ldply(datasets, data.frame)
  freq_plot = ggplot(combined, aes(x=ID, y=percent, color = group)) + geom_point(size = .5)  + scale_x_log10() + xlab("Rank ID") + ggtitle(plot_title) + scale_y_log10()
  if(length(legend_labels) != 0)
  {
   freq_plot = freq_plot + scale_colour_manual(breaks = legend_labels, values=cbbPalette)
  }
  else
  {
    freq_plot = freq_plot + scale_colour_manual(values=cbbPalette)
  }
  freq_plot = freq_plot +
    theme(axis.text.x = element_text(size=12), 
          axis.title = element_text(size=14),
          axis.text.y = element_text(size=12),
          legend.title = element_blank(),
          legend.text=element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"))
  #print(freq_plot)
  ggsave(freq_plot, file=outputFile, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
  return(freq_plot)
}

#engComb$PL_est <- e_powerLaw(engComb$ID)
#engComb$DPL_est <- e_dpl(engComb$ID)
#eng2 <- melt(engComb, id.vars=c("ID"))
#p1 <- ggplot(eng2, aes(x=ID, y= value, color = variable)) + geom_point(size = .5) + scale_colour_manual(values=cbbPalette) + scale_x_log10() + ggtitle("English Unigram MLE Fits") + scale_y_log10()
#p1
#ggsave(p1, file = "~/CodeNLP/Plots/EnglishUnigramPredictedSimulatedActualZipf.png")

#Generate a hexbin plot for just one graph.
generateNormalizedFreqPlotSingle <- function(dataset, outputFile, lookupName = "", fitTable = data.frame())
{
  if(lookupName != "")
  {
    plRow = sqldf(paste("SELECT * FROM fitTable WHERE file =\"",lookupName,"\" AND type = \"Powerlaw\"",sep="") )
    print(plRow[[4]])
    print(plRow[[3]])
    dataset$PL_est = powerLaw(plRow[[4]], plRow[[3]], dataset$ID)
    dplRow = sqldf(paste("SELECT * FROM fitTable WHERE file =\"",lookupName,"\" AND type = \"Double_Powerlaw\"",sep="") )
    dataset$DPL_est = doublePowerLaw(dplRow[[4]], dplRow[[3]], dplRow[[5]], dataset$ID)
    print(dplRow[[4]])
    print(dplRow[[3]])
    print(dplRow[[5]])
    #View(dataset)
    d2 = dataset[,c("ID", "freq", "PL_est", "DPL_est")]
    d_plot <- melt(d2, id.vars=c("ID"))
    #View(d_plot)
    freq_plot = ggplot(d_plot, aes(x=ID, y= value, color = variable)) + geom_point(size = .5) + scale_colour_manual(values=cbbPalette) + scale_x_log10() + ggtitle("NgramID Vs Percentage") + scale_y_log10()
    ggsave(freq_plot, file=outputFile, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
    return(freq_plot)
  }
  else
  {
    freq_plot = ggplot(dataset, aes(x=ID, y=percent)) + geom_point(size = .5) + stat_binhex(bins=50) + scale_x_log10() + ggtitle("Ngram ID Vs Percentage") + scale_y_log10()
    #print(freq_plot)
    ggsave(freq_plot, file=outputFile, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
    return(freq_plot)
  }
}

#Fit the estimated double and single powerlaw fits to the functions.
fillSimColumns <- function(dataset, fitTable, lookupName)
{
  plRow = sqldf(paste("SELECT * FROM fitTable WHERE file =\"",lookupName,"\" AND type = \"Powerlaw\"",sep="") )
  dataset$PL_est = powerLaw( plRow[[4]], plRow[[3]], dataset$ID)
  dplRow = sqldf(paste("SELECT * FROM fitTable WHERE file =\"",lookupName,"\" AND type = \"Double_Powerlaw\"",sep="") )
  dataset$DPL_est = doublePowerLaw(dplRow[[4]], dplRow[[3]], dplRow[[5]], dataset$ID)
  return(dataset)
}

#Expects dataset to have a "ID" column for the rank.
functionFitPlot <- function(dataset, predicted_col, actual_col, outputFile)
{
  dataset$residual = dataset[,c(predicted_col)] - dataset[,c(actual_col)]
  r_plot = ggplot(dataset, aes(x = ID, y = residual)) + geom_point(size = .5) + ggtitle("Fitted Rank Vs Residual")
  ggsave(r_plot, file = outputFile)
  return(r_plot)
}

chi_sq <- function(dataset, predicted_col, actual_col)
{
  chi_stat = sum((dataset[,c(predicted_col)]- dataset[,c(actual_col)])^2/dataset[,c(predicted_col)])
  print(chi_stat)
  return(pchisq(chi_stat, df = 1, lower.tail=FALSE))
}

#Example:
#inputFiles <- c("./DJavaUnigram.csv", "./BrownUnigrams.csv")
#data <- getDatasets(inputFiles)
#javaSlope <- getZipfSlope(data[[1]])
#brownSlope <- getZipfSlope(data[[2]])
#If this was a distribution, you could use the getConfInt on the list of javaSlopes or brownSlopes here.
#getConfInt(javaSlopes, .99, 2) if doing 2 hypothesis for instance.
#plot = generateNormalizedFreqPlot(data, "~/ExampleOut.png")

#
# BrownUnigram$predicted <- zipfMandelbrot(BrownUnigram$ID + 1, 1.13, 2.7)
# BrownUnigram$predicted <- BrownUnigram$predicted/sum(BrownUnigram$predicted)
# freq_plot+geom_line(data = BrownUnigram, aes(x=log(ID), y = log(predicted)))
# BrownUnigram$resid <- BrownUnigram$freq - BrownUnigram$predicted
# ggplot(data=BrownUnigram, aes(x=predicted, y=resid)) + geom_point(size=.5)
# ggplot(data=BrownUnigram, aes(x=log(predicted), y=resid)) + geom_point(size=.5)
