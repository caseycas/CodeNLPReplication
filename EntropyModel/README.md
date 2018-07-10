# Basic Replication

To simply regenerate plots and values as seen in the paper from the final processed data entropy scores, you can
run these the following R scripts:

EngCodePaperZipfs.R - All Zipf related Plots and values:
Lstm_Ngram.r - Language model entropy boxplots and distribution comparison with the exception of the parse tree experiment.
ParseTreeLSTMUnmatched.R - Language model entropy boxplots and distribution comparison for the parse tree experiment.

To run these you will need to have R installed on your machine and it is also highly recommended that you install RStudio as well.  Also, make sure your working directory in R is set to the parent of this directory (for example: ```setwd(~/CodeNLPReplication)```)

These scripts depend on many supporting R libraries - a script to install all needed libraries can be found here: 

installLibraries.R

Second, you will need to download the final processed Zipf and model result data.  These are too large to be hosted on
GitHub and can be found at the following Dropbox links.  (NOTE on the data:  The Penn Treebank parse trees requires a fee to access.  In the spirit of providing data for a direct replication, we have included a version with only our metadata labels and the actual labels have been removed.)  

(TODO Zipf Download) = Download and unzip to CodeNLPReplication/NgramData
  
(TODO Entropy Download) = Download and unzip to CodeNLPReplication/EntropyModel/data
