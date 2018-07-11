package revisions.runners.external;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * 
 * StreamGobbler class credited to:
 * http://www.javaworld.com/article/2071275/core-java/when-runtime-exec---won-t.html?page=2
 *
 */
public class StreamGobbler extends Thread
{
	InputStream is;
	String type;
	String output;

	StreamGobbler(InputStream is, String type)
	{
		this.is = is;
		this.type = type;
		this.output = "";
	}

	public void run()
	{
		try
		{
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line=null;
			while ( (line = br.readLine()) != null)
			{
				if(output != "")
				{
					output += "\n";
				}
				if(type.equals("ERR")) //Print out error stream
				{
					System.out.println(type + ">" + line); 
				}
				output += line;
			}
		
			br.close();
			isr.close();
		} catch (IOException ioe)
		{
			ioe.printStackTrace();  
		}
	}
	
}

