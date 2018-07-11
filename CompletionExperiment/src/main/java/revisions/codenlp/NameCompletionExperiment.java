package revisions.codenlp;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.DoubleSummaryStatistics;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.OptionalDouble;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import revisions.runners.pygments.FileLabeler;
import revisions.runners.pygments.ScriptFailureException;
import slp.core.counting.giga.GigaCounter;
import slp.core.lexing.Lexer;
import slp.core.lexing.runners.LexerRunner;
import slp.core.lexing.simple.WhitespaceLexer;
import slp.core.modeling.Model;
import slp.core.modeling.dynamic.CacheModel;
import slp.core.modeling.dynamic.NestedModel;
import slp.core.modeling.mix.MixModel;
import slp.core.modeling.ngram.JMModel;
import slp.core.modeling.runners.Completion;
import slp.core.modeling.runners.ModelRunner;
import slp.core.translating.Vocabulary;
import slp.core.util.Pair;

public class NameCompletionExperiment {
	
	protected File train;
	protected File test;
	protected boolean nameCorpus;
	protected File outputCsv; 
	protected File scriptLoc;
	protected boolean selfTesting;
	protected PredictionRunner modelRunner;
	protected FileLabeler fl;
	Map<File, Integer> fileSizes;
	

	public NameCompletionExperiment(File train, File test, boolean nameCorpus, File outputCsv, File scriptLoc, boolean selfTesting)
	{
		this.train = train;
		this.test = test;
		this.nameCorpus = nameCorpus;
		this.outputCsv = outputCsv;
		this.scriptLoc = scriptLoc;
		this.selfTesting = selfTesting;
		fl = new FileLabeler(test, test, scriptLoc);
		fileSizes = new HashMap<File, Integer>();
		setupModel();
	}
	
	private void setupModel()
	{
		// 1. Lexing
		//   a. Set up lexer using a JavaLexer
		//		- The second parameter informs it that we want to files as a block, not line by line

		//Assume pre lexing for consistency.
		Lexer lexer = new WhitespaceLexer();
		//		if(nameCorpus == true)
		//		{
		//			lexer = new WhitespaceLexer();
		//		}
		//		else //May need to change depending on if I lex first.
		//		{
		//			 lexer = new JavaLexer();
		//		}

		LexerRunner lexerRunner = new LexerRunner(lexer, false);
		//Stream<Stream<String>> lines = lexerRunner.lexFile(new File("/Users/caseycas/CodeNLP/DiverseJavaCompletion/junit-team___junit/src/main/java/org/junit/30.java.tokens"));
		//lines.flatMap(Function.identity()).forEach(System.out::println);
		//System.exit(0);

		//   b. Since our data does not contain sentence markers (for the start and end of each file), add these here
		//		- The model will assume that these markers are present and always skip the first token when modeling
		lexerRunner.setSentenceMarkers(true);
		//   c. Only lex (and model) files that end with "java". See also 'setRegex'

		//Assuming prior lexing for consistency
		lexerRunner.setExtension("tokens");
		//		if(nameCorpus == true)
		//		{
		//			lexerRunner.setExtension("tokens");
		//		}
		//		else //This may need to change if I decide to do the lexing first
		//		{
		//			lexerRunner.setExtension("java");
		//		}



		// 2. Vocabulary:
		//    - For code, we typically make an empty vocabulary and let it be built while training.
		//    - Building it first using the default settings (no cut-off, don't close after building)
		//		should yield the same result, and may be useful if you want to write the vocabulary before training.
		//    - If interested, use: VocabularyRunner.build(lexerRunner, train);
		Vocabulary vocabulary = new Vocabulary();


		// 3. Model
		//	  a. We will use an n-gram model with simple Jelinek-Mercer smoothing (works well for code)
		//		 - The n-gram order of 6 is used, which is also the standard
		//       - Let's use a GigaCounter (useful for large corpora) here as well; the nested model later on will copy this behavior.
		Model model = new JMModel(6, new GigaCounter());
		//    b. We can get more fancy by converting the model into a complex mix model.
		//       - For instance, we can wrap the ModelRunner in a nested model, causing it to learn all files in test into a new 'local' model
		//		 - Most mixed models don't need access to a LexerRunner or vocabulary, but NestedModel actually creates new Models on the fly
		model = new NestedModel(model, lexerRunner, vocabulary, test);
		//       - Then, add an ngram-cache component.
		//         * Order matters here; the last model in the mix gets the final say and thus the most importance
		model = MixModel.standard(model, new CacheModel());
		//       - Finally, we can enable dynamic updating for the whole mixture (won't affect cache; it's dynamic by default)
		model.setDynamic(true);
		//	  c. We create a ModelRunner with this model and ask it to learn the train directory
		//		 - This invokes Model.learn for each file, which is fine for n-gram models since these are count-based;
		//         other model implementations may prefer to train in their own way.
		modelRunner = new PredictionRunner(model, lexerRunner, vocabulary);
		
		//Call 1) that can be removed if selfTesting with the Nested model
		modelRunner.learnDirectory(train);
		
		//    d. We assume you are self-testing if the train and test directory are equal.
		//		 This will make it temporarily forget any sequence to model, effectively letting you train and test on all your data
		
		//If the training really does equal the test set, override the user specified selfTraining (or default)
		//Call 2) that can be removed if selfTesting with the Nested model
		sizeSanityCheck();
		
		//TMP: Disabling this b/c Vincent said it would be approximately the same, but faster.
		if(train.equals(test))
		{
			selfTesting = train.equals(test);
		}
		
		modelRunner.setSelfTesting(selfTesting);
		//TMP: Disabling this b/c Vincent said it would be approximately the same, but faster.
		
		//		 - If you plan on using a NestedModel to self-test, you can also just remove the two above calls;
		//		   they teach the global model the same things that the nested model knows, which barely boosts performance.
		//		This shouldn't give a different result, but will probably be slower than just the Nested Model.
		System.out.println("Training complete");
	}
	
	/**
	 * Print out the size of the training corpus.
	 */
	public void sizeSanityCheck()
	{
		Stream<Pair<File, Stream<Stream<String>>>> files = modelRunner.getLexerRunner().lexDirectory(train);
		System.out.println("Files Used: " + files.count());
	}



//	public void printSuggestions(Pair<File, List<List<Double>>> rrs)
//	{
//		List<List<String>> suggestions = modelRunner.getSuggestions(rrs.left, selfTesting);
//		List<String> flatTokens = modelRunner.getLexerRunner().lexFile(rrs.left).flatMap(Function.identity()).collect(Collectors.toList());
//		List<Double> flatRRs = rrs.right.stream().flatMap(l -> l.stream()).collect(Collectors.toList());
//		//We are treating the whole file as one line at the moment.  Remove the start and end predictions...
//		flatRRs = flatRRs.subList(1, flatRRs.size()-1);
//
//		int i = 0;
//		for(String t : flatTokens)
//		{
//			System.out.println(t + ": (" + String.join(" ", suggestions.get(i)) + ")  RR: " + flatRRs.get(i));
//			i++;
//		}
//
//	}
	
	public void printSuggestionsFlat(Pair<File, List<Completion>> fRRs, FileLabeler fl, boolean filter)
	{
		//List<List<String>> suggestions = modelRunner.getSuggestions(fRRs.left, selfTesting);
		List<List<Pair<Integer, Double>>> tmp = fRRs.right.stream().map(c -> c.getPredictions()).collect(Collectors.toList());
		List<List<Integer>> tmp2 = tmp.stream().map(c -> c.stream().map(p -> p.left).collect(Collectors.toList())).collect(Collectors.toList());
		List<List<String>> suggestions = tmp2.stream().map(modelRunner.getVocabulary()::toWords).collect(Collectors.toList());
//		List<List<String>> suggestions2 = fRRs.right.stream()
//											.map(c -> c.getPredictions().stream().map(p -> p.left)
//															.map(modelRunner.getVocabulary()::toWord)
//															.collect(Collectors.toList())))
//											.collect(Collectors.toList());
		List<String> flatTokens = modelRunner.getLexerRunner().lexFile(fRRs.left).flatMap(Function.identity()).collect(Collectors.toList());
		//TODO: Extract the Ranks again...
		List<Double> flatRRs = fRRs.right.stream().map(c -> c.getRank()).map(ModelRunner::toMRR).collect(Collectors.toList()); //fRRs.right;
		
		//Remove the starting and ending tokens.
		//suggestions = suggestions.subList(1, suggestions.size()-1);
		flatTokens = flatTokens.subList(1, flatTokens.size()-1);
		
		if(filter == true)
		{
			try {
			final Map<Integer, Boolean> nameMap = fl.getNameMap(fRRs.left);
			System.out.println(nameMap.size());
			//Mismatch due to sentence markers? (Add some in my script? No. Identify and remove them here. Ask Vincent about it)
			for(Map.Entry<Integer, Boolean> kv : nameMap.entrySet())
			{
				System.out.println(kv.getKey() + ":" + kv.getValue());
			}
			System.out.println("Name map: " + nameMap.size());
			System.out.println("Flat tokens: " + flatTokens.size());
			assert(flatTokens.size() == nameMap.size());
			flatTokens =   IntStream.range(0, flatTokens.size())
					.filter(i -> nameMap.get(i) == true)
					.peek(System.out::println)
					.mapToObj(flatTokens::get)
					.collect(Collectors.toList());
			}
			catch(ScriptFailureException e)
			{
				e.printStackTrace();
				System.exit(-1);
			}
		}

		System.out.println("Suggestion Length:"  + suggestions.size());
		System.out.println("Lexed Length: " + flatTokens.size());
		System.out.println("Reciprocal Rank Length:" + flatRRs.size());
		
		int i = 0;
		double total = 0.0;
		for(String t : flatTokens)
		{
			System.out.println(t + ": (" + String.join(" ", suggestions.get(i)) + ")  RR: " + flatRRs.get(i));
			total += flatRRs.get(i);
			i++;
		}
		System.out.println("Total MRR:");
		System.out.println(total/((double)flatTokens.size()));

	}
	
	
	public void logSuggestionsFlat(Pair<File, List<Completion>> fRRs, File outputFile, FileLabeler fl, boolean filter)
	{
		System.out.println("Writing to File: " + outputFile.getAbsolutePath());
		try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputFile.toURI())))
		{
			PrintWriter linePrinter = new PrintWriter(writer);
			linePrinter.println("File:" + fRRs.left);
			List<List<Pair<Integer, Double>>> tmp = fRRs.right.stream().map(c -> c.getPredictions()).collect(Collectors.toList());
			List<List<Integer>> tmp2 = tmp.stream().map(c -> c.stream().map(p -> p.left).collect(Collectors.toList())).collect(Collectors.toList());
			List<List<String>> suggestions = tmp2.stream().map(modelRunner.getVocabulary()::toWords).collect(Collectors.toList());

			List<String> flatTokens = modelRunner.getLexerRunner().lexFile(fRRs.left).flatMap(Function.identity()).collect(Collectors.toList());
			//TODO: Extract the Ranks again...
			List<Double> flatRRs = fRRs.right.stream().map(c -> c.getRank()).map(ModelRunner::toMRR).collect(Collectors.toList()); //fRRs.right;
			
			//Remove the starting and ending tokens.
			//suggestions = suggestions.subList(1, suggestions.size()-1);
			flatTokens = flatTokens.subList(1, flatTokens.size()-1);
			
			if(filter == true)
			{
				try {
				final Map<Integer, Boolean> nameMap = fl.getNameMap(fRRs.left);
				linePrinter.println(nameMap.size());
				//Mismatch due to sentence markers? (Add some in my script? No. Identify and remove them here. Ask Vincent about it)
				for(Map.Entry<Integer, Boolean> kv : nameMap.entrySet())
				{
					linePrinter.println(kv.getKey() + ":" + kv.getValue());
				}
				linePrinter.println("Name map: " + nameMap.size());
				linePrinter.println("Flat tokens: " + flatTokens.size());
				assert(flatTokens.size() == nameMap.size());
				flatTokens =   IntStream.range(0, flatTokens.size())
						.filter(i -> nameMap.get(i) == true)
						.peek(linePrinter::println)
						.mapToObj(flatTokens::get)
						.collect(Collectors.toList());
				}
				catch(ScriptFailureException e)
				{
					e.printStackTrace();
					System.exit(-1);
				}
			}

			linePrinter.println("Suggestion Length:"  + suggestions.size());
			linePrinter.println("Lexed Length: " + flatTokens.size());
			linePrinter.println("Reciprocal Rank Length:" + flatRRs.size());
			
			int i = 0;
			double total = 0.0;
			for(String t : flatTokens)
			{
				linePrinter.println(t + ": (" + String.join(" ", suggestions.get(i)) + ")  RR: " + flatRRs.get(i));
				total += flatRRs.get(i);
				i++;
			}
			linePrinter.println("Total MRR:");
			linePrinter.println(total/((double)flatTokens.size()));

		} catch (IOException e1) {

			e1.printStackTrace();
		}
	}

	public void printFileMRR(Pair<File, List<List<Double>>> rrs)
	{
		System.out.print(rrs.left + ":");
		System.out.println(rrs.right.stream().flatMap(l -> l.stream())
				.mapToDouble(d -> d).average());
	}

	public Pair<File, List<Completion>> filterRRs(FileLabeler fl, Pair<File, List<List<Completion>>> rrs)
	{
		System.out.println(rrs.left);
		try {
			final Map<Integer, Boolean> nameMap = fl.getNameMap(rrs.left);

			//rrs.right.stream().forEach(System.out::println);

			List<Completion> flatRRs = rrs.right.stream().flatMap(l -> l.stream()).collect(Collectors.toList());
			//We are treating the whole file as one line at the moment.  Remove the start and end predictions...
			flatRRs = flatRRs.subList(1, flatRRs.size()-1);
			fileSizes.put(rrs.left, flatRRs.size());
			//System.out.println(nameMap.size());
			//Mismatch due to sentence markers? (Add some in my script? No. Identify and remove them here. Ask Vincent about it)
//			for(Map.Entry<Integer, Boolean> kv : nameMap.entrySet())
//			{
//				System.out.println(kv.getKey() + ":" + kv.getValue());
//			}
//			System.out.println(flatRRs.size());
//			System.out.println(flatRRs);
			flatRRs =   IntStream.range(0, flatRRs.size())
					.filter(i -> nameMap.get(i) == true)
					.mapToObj(flatRRs::get)
					.collect(Collectors.toList());

			return new Pair<File, List<Completion>>(rrs.left, flatRRs);
		} catch (ScriptFailureException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			System.exit(-1);
			return null;
		}
	}

	public Pair<File, List<Completion>> filterRRs(Pair<File, List<List<Completion>>> rrs)
	{
		System.out.println(rrs.left);
		List<Completion> flatRRs = rrs.right.stream().flatMap(l -> l.stream()).collect(Collectors.toList());
		
		//We are treating the whole file as one line at the moment.  Remove the start and end predictions...
		flatRRs = flatRRs.subList(1, flatRRs.size()-1);
		fileSizes.put(rrs.left, flatRRs.size());
		return new Pair<File, List<Completion>>(rrs.left, flatRRs);
	}

	public void appendFileMRR(Pair<File, List<Completion>> rrs, Integer fileSize, CSVPrinter csvPrinter)
	{
		//We aleady flatted this, so make it nested again
		List<List<Completion>> mockLines = new ArrayList<List<Completion>>();
		mockLines.add(rrs.right);
		DoubleSummaryStatistics out = modelRunner.getCompletionStats(mockLines);
//		OptionalDouble mrr = rrs.right.stream()
//				.map(c -> c.getPredictions())
//				.mapToDouble(d -> d).average();
		try {
			csvPrinter.printRecord(rrs.left, out.getAverage(), fileSize, rrs.right.size());
			csvPrinter.flush();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public Pair<File, Integer> fileCount(Pair<File, List<List<Completion>>> completions)
	{
		List<Completion> flatRRs = completions.right.stream().flatMap(l -> l.stream()).collect(Collectors.toList());
		return new Pair<File, Integer>(completions.left, flatRRs.size());
	}
	
	public List<Pair<File, List<Completion>>> runNameExperiment()
	{
		Stream<Pair<File, List<List<Completion>>>> file_rrs = modelRunner.completeDirectory(test);

		//Model Directory (This seems to work but may take a really long time to go through all the files?)
		//Stream<Pair<File, List<List<Double>>>> file_rrs = modelRunner.predictDirectory(test);
		
		//Map<File, Integer> fileSizes = file_rrs.map(l -> fileCount(l)).collect(Collectors.toMap(Pair::left, Pair::right));

		System.out.println("Suggestions Complete, Now filtering....");
		List<Pair<File, List<Completion>>> filtered_rrs = null;// = new ArrayList<Pair<File, List<Double>>>();
		//Bwriter;
		try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputCsv.toURI())))
		{
			CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT
					.withHeader("File", "MRR", "Total_Tokens", "Predicted_Tokens"));

			//System.out.println("MRRs:");
			//file_rrs.forEach(l -> printFileMRR(l));
			if(nameCorpus == true)
			{
				System.out.println("Name Corpus - no filter");
				filtered_rrs = file_rrs.map(l -> filterRRs(l)).collect(Collectors.toList());
			}
			else
			{
				System.out.println("Full Corpus - filtering names");
				filtered_rrs = file_rrs.map(l -> filterRRs(fl, l)).collect(Collectors.toList());
			}
			System.out.println("Writing to file.");
			filtered_rrs.stream()
					.forEach(l -> appendFileMRR(l, fileSizes.get(l.left), csvPrinter));
			
			csvPrinter.close();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//Stream<Pair<File, List<List<Double>>>> suggestions = modelRunner.predict(test);
		//Try with an example file.

		/*
		 * Note: the above consumes the per-token entropies, so they are lost afterwards.
		 * If you'd like to store them first, use something like:
		 * 
		 *  Map<File, List<List<Double>>> stored =
		 * 		modeledFiles.collect(Collectors.toMap(Pair::left, Pair::right));
		 * 
		 * This may consume a sizeable chunk of RAM across millions of tokens
		 */
		return filtered_rrs;
	}

	public FileLabeler getFileLabeler()
	{
		return fl;
	}

}
