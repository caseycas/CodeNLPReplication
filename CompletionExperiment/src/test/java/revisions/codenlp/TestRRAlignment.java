package revisions.codenlp;

import static org.junit.Assert.*;

import java.io.File;
import java.util.List;

import org.junit.Test;

import slp.core.modeling.runners.Completion;
import slp.core.util.Pair;

public class TestRRAlignment {

	@Test
	public void testAlignment() {
		//Setup
		File train = new File("/Users/caseycas/CodeNLP/DiverseJavaCompletion/junit-team___junit/");
		File test = new File("/Users/caseycas/CodeNLP/DiverseJavaCompletion/junit-team___junit/"); //src/main/java/junit/extensions/0.java.tokens");
		File outputCsv = new File("mrr_test_full2.csv");
		File scriptLoc = new File("/Users/caseycas/CodeNLP/lexer_stuff/cleanLexer.py");

		NameCompletionExperiment nce_full = new NameCompletionExperiment(train, test, false, outputCsv, scriptLoc, true);
		List<Pair<File, List<Completion>>> fullTest = nce_full.runNameExperiment();

		train = new File("/Users/caseycas/CodeNLP/DiverseJavaNames/junit-team___junit/");
		test = new File("/Users/caseycas/CodeNLP/DiverseJavaNames/junit-team___junit/"); //src/main/java/junit/extensions/0.java.tokens");
		outputCsv = new File("mrr_test_open2.csv");

		scriptLoc = new File("/Users/caseycas/CodeNLP/lexer_stuff/cleanLexer.py");

		NameCompletionExperiment nce_open = new NameCompletionExperiment(train, test, true, outputCsv, scriptLoc, true);
		List<Pair<File, List<Completion>>> openTest = nce_open.runNameExperiment();

		//Debug information and some tests
		//assertTrue(fullTest.size() == 1);
		//assertTrue(openTest.size() == 1);
		nce_full.printSuggestionsFlat(fullTest.get(0), nce_full.getFileLabeler(), true);
		System.out.println("-----------------------------------\n");
		//This is not matching up.. :(
		nce_open.printSuggestionsFlat(openTest.get(0), nce_open.getFileLabeler(), false);
		//file_rrs.forEach(p -> printSuggestions(p, modelRunner, selfTesting));

	}

}
