# Basic Replication

To simply regenerate plots and values as seen in the paper from the final processed data entropy scores, you can
run these the following R scripts:

EngCodePaperZipfs.R - All Zipf related Plots and values:
Lstm_Ngram.r - Language model entropy boxplots and distribution comparison with the exception of the parse tree experiment.
ParseTreeLSTMUnmatched.R - Language model entropy boxplots and distribution comparison for the parse tree experiment.

To run these you will need to have R installed on your machine and it is also highly recommended that you install RStudio as well.

These scripts depend on many supporting R libraries - a script to install all needed libraries can be found here: 

<TODO>

Second, you will need to download the final processed Zipf and model result data.  These are too large to be hosted on
GitHub and can be found:

<TODO Zipf Download> = Download and unzip to CodeNLPReplication/NgramData
  
<TODO Entropy Download> = Download and unzip to CodeNLPReplication/EntropyModel/data
