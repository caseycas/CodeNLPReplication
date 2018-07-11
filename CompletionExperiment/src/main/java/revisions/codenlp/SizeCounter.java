package revisions.codenlp;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import slp.core.lexing.Lexer;
import slp.core.lexing.runners.LexerRunner;
import slp.core.lexing.simple.WhitespaceLexer;
import slp.core.util.Pair;

/**
 * Quick fix script to count the tokens in the files.
 * @author caseycas
 *
 */
public class SizeCounter {
	
	public static Pair<File, Integer> fileSize(Pair<File, Stream<Stream<String>>> tokens)
	{
		long size = tokens.right.flatMap(Function.identity()).count();
		return new Pair<File, Integer>(tokens.left, new Integer((int) size));
	}
	
	public static void main(String[] args)
	{
		File baseDir = new File(args[0]);
		File outputCsv = new File(args[1]);
		
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
		
		Stream<Pair<File, Stream<Stream<String>>>> files = lexerRunner.lexDirectory(baseDir);
		Map<File, Integer> sizeCounts = files.map(f -> fileSize(f)).collect(Collectors.toMap(Pair::left, Pair::right));
		try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputCsv.toURI())))
		{
			CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT
					.withHeader("File", "Total_Tokens"));
			for(Map.Entry<File, Integer> f : sizeCounts.entrySet())
			{
			csvPrinter.printRecord(f.getKey(), f.getValue());
			csvPrinter.flush();
			}
			csvPrinter.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
