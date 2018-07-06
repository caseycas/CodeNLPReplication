package slp.ast.example;

import java.io.File;
import java.util.DoubleSummaryStatistics;
import java.util.List;
import java.util.stream.Stream;

import slp.ast.model.JavaASTModel;
import slp.core.lexing.LexerRunner;
import slp.core.lexing.code.JavaLexer;
import slp.core.modeling.Model;
import slp.core.modeling.ModelRunner;
import slp.core.modeling.mix.InverseMixModel;
import slp.core.modeling.ngram.NGramCache;
import slp.core.util.Pair;

public class JavaASTRunner {
	public static void main(String[] args) {
		args = new String[] { "E:/Java/Micro/Train", "E:/Java/Micro/Test" };

		if (args.length < 1) return;
		// Assumes at least one argument, the path (file or directory) to train on
		File train = new File(args[0]);
		// If second argument, will test on that path, else will 'self-test' on train using full cross-validation per line
		File test = args.length < 2 ? train : new File(args[1]);

		// 1. Lexing
		//   a. Set up lexer using a JavaLexer
		LexerRunner.setLexer(new JavaLexer());
		//   b. Do not tokenize per line for Java (invoked for the sake of example; false is the default)
		LexerRunner.perLine(false);
		//   c. But, do add delimiters (to start and end of file)
		LexerRunner.addSentenceMarkers(true);
		
		
		// 2. Vocabulary -- skipped, just built while modeling
		
		
		// 3. Model
		//    a. No per line modeling for Java (default)
		ModelRunner.perLine(false);
		//    b. Self-testing if train is equal to test; will un-count each file before modeling it.
		ModelRunner.selfTesting(train.equals(test));
		//    c. Set n-gram model order, 6 works well for Java
		ModelRunner.setNGramOrder(6);
		//    d. Use an n-gram model with simple Jelinek-Mercer smoothing (works well for code)
		Model modelA = new JavaASTModel(1);
		modelA = new InverseMixModel(modelA, new JavaASTModel(new NGramCache(), 1));
		Model modelB = new JavaASTModel(3);
		modelB = new InverseMixModel(modelB, new JavaASTModel(new NGramCache(), 3));
		Model model = new InverseMixModel(modelA, modelB);
		ModelRunner.learn(model, train);
//		model = new NestedModel(test, model);
		model.setDynamic(true);
		//    e. Finally, pass this model to a JavaAST Model instance, which will transform its input to AST format and use this internally.
		//    f. Train this model on all files in 'train' recursively, using the usual updating mechanism (same as for dynamic updating).
		//       - Note that this invokes Model.learn for each file, which is fine for n-gram models since these are count-based;
		//          other models may prefer to pre-train when calling the Model's constructor.
		
		
		// 4. Running
		//    a. Model each file in 'test' recursively
		Stream<Pair<File, List<List<Double>>>> modeledFiles = ModelRunner.model(model, test);
		//    b. Retrieve entropy statistics by mapping the entropies per file
		DoubleSummaryStatistics statistics = modeledFiles.map(pair -> pair.right)
			// Note the "skip(1)" (per file), since we added delimiters and we generally don't model the start-of-line token
			.flatMap(f -> f.stream().flatMap(l -> l.stream()).skip(1))		
			.mapToDouble(d -> d)
			.summaryStatistics();
		
		System.out.printf("Modeled %d tokens, average entropy:\t%.4f\n", statistics.getCount(), statistics.getAverage());
	}
}
