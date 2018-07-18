# CodeNLPReplication
This repository provides a partial replication package for the paper "Studying the Difference Between Natural and Programming Language Corpora"

# Data
The data used in our experiments is too large to host on Github, so we've stored the raw data and final processed version
of the data on box.com, where a download link is accessible via: https://ucdavis.app.box.com/folder/51568124685

If you want to rerun the R scripts on the final processed data to recreate the plots and statistical tests used in the
paper, you will need probably at least 15 GBs of space.  If you want to rerun all the experiments from the raw data to the final processed step, you will likely need between 100-200 GBs of available space and a GPU compatible tensorflow installation.

## Basic Replication Data

The files ZipfNgram.zip and EntropyData.zip are the final processed data.

```
ZipfNgram.zip - download and unzip into the top level directory of this repostiory.  It should put the files into a subdirectory called NgramData.

EntropyData.zip - download and unzip inside the directory ./EntropyModel/data/
```

## Raw Data

The raw data files should be unzipped into the top level directory of this repository.

These files are:
```
AST_out.zip
CCorpus.zip
ClojureCorpus.zip
RubyCorpus.zip
HaskellCorpus.zip
DiverseJava.zip
BrownCorpus.zip
EnglishSample.zip
EFLCorpus.zip
SpecializedEnglishCorpus.zip
German.zip
Spanish.zip
```

*Note:  As the English consistutency parse trees are part of the Penn Treebank, we cannot freely provide
this data.  If you have paid for access to the Penn Treebank, put your copy of the data in the top level directory.
Likewise, in the final processed data, we have censored the original tokens that make up the parse trees and kept
only a column of labels to distinguish between terminal and non terminals.*

# Basic Replication
A description of how to quickly replicate the results of the paper can be found in [EntropyModel/README.md](https://github.com/caseycas/CodeNLPReplication/blob/master/EntropyModel/README.md)

# Full Replication
Generating your own training/test corpora from the original files involves lexing, running tensorflow, kenlm, with a variety of pre- and post-processing steps for many different programming and natural language corprora.  

Details on installing kenlm can be found here: https://github.com/kpu/kenlm
Details on installing tensorflow: https://www.tensorflow.org/install/

Some shell scripts have been provided to streamline the steps of the experiments, but if you'd like to do a full replication, or run into issues/errors while trying out the basic replication, please contact the authors at:

ccasal@ucdavis.edu
