package revisions.codenlp;


import java.io.File;

import revisions.runners.pygments.*;



/**
 * This example shows a typical use-case for (Java) source code of this tool with detailed comments.
 * We setup a {@link LexerRunner} with a {@link Lexer}, train a {@link Model} using a {@link ModelRunner}
 * and print the overall result. This is a good starting point for understanding the tool's API.
 * See also the {@link BasicNLRunner} for an equivalent example with typical settings for natural language modeling tasks.
 * <br /><br />
 * More complex use-cases can be found in the other examples, such finding entropy for each token and line,
 * using a bi-directional model (in parallel with others), .
 * 
 * @author Vincent Hellendoorn
 */
public class ExperimentManager {


	/***
	 * 4 arguments
	 * training data
	 * test data
	 * boolean for if is this a name corpus or not
	 * file name for an output csv file
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		if (args.length < 1) return;
		// Assumes at least one argument, the path (file or directory) to train on
		File train = new File(args[0]);
		// If second argument, will test on that path, else will 'self-test' on train using full cross-validation per line
		File test = args.length < 2 ? train : new File(args[1]);

		boolean nameCorpus = Boolean.valueOf(args[2]);
		File outputCsv = new File(args[3]);
		File scriptLoc = new File(args[4]);
		boolean selfTest = Boolean.valueOf(args[5]);

		NameCompletionExperiment nce = new NameCompletionExperiment(train, test, nameCorpus, outputCsv, scriptLoc, selfTest);
		nce.runNameExperiment();

	}
}