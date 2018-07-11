package revisions.runners.pygments;

import java.io.File;

import revisions.runners.external.ExternalOperation;

public class PygmentsInvokerExample {
	protected File inDir;
	protected File outDir;
	protected File scriptSource;
	
	public PygmentsInvokerExample(File in, File out, File script)
	{
		inDir = in;
		outDir = out;
		scriptSource = script;
	}
	
	protected void runLexer()
	{
		//python cleanLexer.py /data/ccasal/CodeNLP/DiverseJavaNames/junit-team___junit/ *.java /data/ccasal/CodeNLP/DiverseJavaNames/junit-team___junit/ 0 full 100000000 1.0 --in_place --metadata_light
		
		if(inDir.equals(outDir) || inDir.getParent().equals(outDir.getAbsolutePath()))
		{
			System.out.println("In place");
			//System.out.println(inDir);
			String args[] = {inDir.getAbsolutePath(), "*.java", outDir.getAbsolutePath(), "0", "full", "1000000000", "1.0", "--in_place", "--collapse_name", "--retain_line"};
			ExternalOperation.callScript("python2.7", scriptSource, args);
		}
		else
		{
			System.out.println("Not in place");
			//System.out.println(inDir);
			//System.out.println(inDir.getAbsolutePath());
			//System.out.println(inDir.getParent());
			String args[] = {inDir.getAbsolutePath(), "*.java", outDir.getAbsolutePath(), "0", "full", "1000000000", "1.0", "--collapse_name", "--retain_line"};
			ExternalOperation.callScript("python2.7", scriptSource, args);
		}
		
	}
	
	public static void main(String args[])
	{
		if(args.length != 3)
		{
			System.out.println("Usage: input_directory output_directory lexer_location");
			return;
		}
		File input = new File(args[0]);
		// If second argument, will test on that path, else will 'self-test' on train using full cross-validation per line
		File output = new File(args[1]);
		File scriptLoc = new File(args[2]);
		PygmentsInvokerExample pie = new PygmentsInvokerExample(input, output, scriptLoc);
		pie.runLexer();

	}

}
