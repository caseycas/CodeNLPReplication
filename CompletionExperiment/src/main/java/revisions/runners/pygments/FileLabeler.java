package revisions.runners.pygments;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import revisions.runners.external.ExternalOperation;

/**
 * A wrapper class to invoke a python class with a pygments
 * lexer to identify what types in a file are considered open or closed category. 
 * @author caseycas
 *
 */
public class FileLabeler {
	
	public static final String markerFile = "error.log";
	public static final String successString = "Completed";
	
	//If this is true, we don't want to lex the file again, just look up the csv
	//for the metadata.
	protected boolean cached;
	protected File input;
	protected File output;
	protected File lexer;
	
	/**
	 * 
	 * @param InputDir
	 * @param OutputDir
	 * @param lexerScript
	 */
	public FileLabeler(File InputDir, File OutputDir, File lexerScript)
	{
		input = InputDir;
		output = OutputDir;
		lexer = lexerScript;
		cached = checkCache();
	}
	
	/**The output directory has a marker file to indicate if
	 * the lexing completely properly
	 */
	protected boolean checkCache()
	{
		try {
			Stream<String> lines = Files.lines(Paths.get(output.getAbsolutePath(), markerFile));
			String content = lines.collect(Collectors.joining());
			//System.out.println(content);
			return content.equals(successString);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		
	}
	
	protected void runLexer()
	{
		//python cleanLexer.py /data/ccasal/CodeNLP/DiverseJavaNames/junit-team___junit/ *.java /data/ccasal/CodeNLP/DiverseJavaNames/junit-team___junit/ 0 full 100000000 1.0 --in_place --metadata_light
		String args[] = {input.getAbsolutePath(), "*.java", output.getAbsolutePath(), "0", "full", "-1", "1.0", "--in_place", "--metadata_light"};
		ExternalOperation.callScript("python2.7", lexer, args);
	}
	
	/**
	 * Given some input file, find it's corresponding outputfile and
	 * read in the map for token -> is an open category word?
	 * If the csv files for this information do not yet exist in our output
	 * directory, run the python lexer to generate them.
	 * @param inputFile
	 * @return
	 */
	public Map<Integer, Boolean> getNameMap(File inputFile) throws ScriptFailureException
	{
		Map<Integer, Boolean> nameMap = new HashMap<Integer, Boolean>();
		
		//Generate the cache if necessary
		if(cached == false)
		{
			runLexer();
			cached = checkCache();
			if(cached != true)
			{
				throw new ScriptFailureException("The python lexer failed to write the meta data properly.");
			}
			
		}
		
		//Convert to the output name
		//String metaFile =  output.getAbsolutePath() + "/" + inputFile.getAbsolutePath().replace("/","_").replace(".tokens", ".metadata");
		String metaFile = inputFile.getAbsolutePath().replace(".tokens", ".metadata");
		try (
		            Reader reader = Files.newBufferedReader(Paths.get(metaFile));
		            CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT
		            		    .withSkipHeaderRecord()
		                    .withHeader("Token","IsOpenClass")
		                    .withIgnoreHeaderCase()
		                    .withTrim());
		        ) {
			 Integer i = 0;
			 for(CSVRecord r : csvParser)
			 {
				 //System.out.println(i + ": " + r.get("Token"));
				 nameMap.put(i, Boolean.valueOf(r.get("IsOpenClass")));
				 i++;
			 }
		 } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return nameMap;
	}
	

}
