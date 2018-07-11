package revisions.codenlp;

import java.io.File;
import java.util.List;

import slp.core.modeling.runners.Completion;
import slp.core.util.Pair;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
    		System.out.println(args[0]);
    	    String baseDir = "/Users/caseycas/CodeNLP/";
    	    
    		if(args.length > 1 && args[1].equals("godeep"))
    		{
    			baseDir = "/data/ccasal/CodeNLP/";
    		}
    		File scriptLoc = new File(baseDir + "lexer_stuff/cleanLexer.py");
    		
    		if(args[0].equalsIgnoreCase("full"))
    		{
    			
		File train = new File(baseDir + "DiverseJavaCompletion/");
		File test = new File(baseDir + "DiverseJavaCompletion/");
		File outputCsv = new File("mrr_full.csv");
		
		NameCompletionExperiment nce = new NameCompletionExperiment(train, test, false, outputCsv, scriptLoc, true);
		List<Pair<File, List<Completion>>> fullTest = nce.runNameExperiment();
		
		for(Pair<File, List<Completion>> fileData : fullTest)
		{
			//System.out.println(fileData.left.getName());
			String outputFile = fileData.left.getName().split("\\.")[0] + ".log.full";
			nce.logSuggestionsFlat(fileData, new File("logs/" + outputFile), nce.getFileLabeler(), true);
		}
    		}
    		else if(args[0].equalsIgnoreCase("open"))
    		{

    		File train = new File(baseDir + "DiverseJavaNames/");
    		File test = new File(baseDir + "DiverseJavaNames/");
    		File outputCsv = new File("mrr_open.csv");


    		NameCompletionExperiment nce = new NameCompletionExperiment(train, test, true, outputCsv, scriptLoc, true);
		List<Pair<File, List<Completion>>> openTest = nce.runNameExperiment();
		
		for(Pair<File, List<Completion>> fileData : openTest)
		{
			String outputFile = fileData.left.getName().split("\\.")[0] + ".log.open";
			nce.logSuggestionsFlat(fileData, new File("logs/" + outputFile), nce.getFileLabeler(), false);
		}
    		}
    		else
    		{
    			System.out.println("First argument is either full or open.");
    			return;
    		}
    }
}
