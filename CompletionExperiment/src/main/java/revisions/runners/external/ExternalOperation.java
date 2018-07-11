package revisions.runners.external;

import java.io.File;
import java.io.IOException;

public class ExternalOperation {
	/**
	 * Given a file path to a script, the interpreter for the script, and a array of arguments
	 * Invoke with blocking call <interpreter> <pathToScript> <args>
	 * Being sure to clean up input, output, and error streams correctly.
	 * @param pathToScript
	 */
	public static String callScript(String interpreter, File pathToScript, String[] args)
	{
		String tmp[] = new String[args.length + 2];
		
		tmp[0] = interpreter;
		tmp[1] = pathToScript.getAbsolutePath();
		for (int i = 2; i < tmp.length; i++)
		{
			tmp[i] = args[i-2];
		}
		
		return callCommand(tmp);
	}
	
	/**
	 * Invoke an external command, args[0] is the command name.
	 * @param args
	 */
	public static String callCommand(String[] args)
	{
		/*
		 * A sample command
		 */
		//String[] cmd = {
		//		"/bin/bash",
		//		"-c",
		//		"git -C " + project + " blame " + nextSrc + " >  " + outputFileName
		//		};
		
		try {
			Process toExecute;
			for(int i = 0; i < args.length; i++)
			{
				System.out.print(args[i] + " ");
			}
			System.out.println("");
			toExecute = Runtime.getRuntime().exec(args);
			StreamGobbler errorGobbler = new 
					StreamGobbler(toExecute.getErrorStream(), "ERR");            

			StreamGobbler outputGobbler = new 
					StreamGobbler(toExecute.getInputStream(), "OUT");
			errorGobbler.start();
			outputGobbler.start(); //TODO: Handle this output somehow.
			toExecute.waitFor();
			//System.out.println("Output: " + outputGobbler.output);
			return outputGobbler.output;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(-1);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			System.exit(-1);
		}
		
		//TODO: Return output
		return "";
		
	}
	
	

}
