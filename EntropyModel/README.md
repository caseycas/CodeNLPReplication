# Basic Replication

## Data

Make sure you first download the basic replication data as described here: https://github.com/caseycas/CodeNLPReplication#basic-replication-data

## Instructions

To create the plots and statistica values as seen in the paper from the final processed data entropy scores, you can
run these the following R scripts:

EngCodePaperZipfs.R - All Zipf related Plots and values:
Lstm_Ngram.r - Language model entropy boxplots and distribution comparison with the exception of the parse tree experiment.
ParseTreeLSTMUnmatched.R - Language model entropy boxplots and distribution comparison for the parse tree experiment.

To run these you will need to have R installed on your machine and it is also highly recommended that you install RStudio as well.  Also, make sure your working directory in R is set to the parent of this directory (for example: ```setwd(~/CodeNLPReplication)```)

These scripts depend on many supporting R libraries - a script to install all needed libraries can be found here: 

installLibraries.R

Finally, after running Lstm_Ngram.r, a convenience script to generate some (but not all) of the .tex tables seen in the paper can be run with:

```
python2.7 generateTexWilcoxTables.py lstm_ngram_no_collapse_stats.txt lstm_ngram_no_collapse_stats.txt
```
