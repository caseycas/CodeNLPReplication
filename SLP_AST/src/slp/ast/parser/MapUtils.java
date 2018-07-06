package slp.ast.parser;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

public class MapUtils {

	public static <T,S> Map<T, Collection<S>> updateMap(Map<T, Collection<S>> toUpdate, T key, Collection<S> toAdd)
	{
		//System.out.println(key);
		//toAdd.stream().forEach(item -> System.out.println(item));
		if(toUpdate.containsKey(key))
		{
			toUpdate.get(key).addAll(toAdd);
			return toUpdate;
		}
		else
		{
			toUpdate.put(key, toAdd);
			return toUpdate;
		}
	}
	
	public static <T,S> void writeMap(Map<T, Collection<S>> toWrite, File outputFile)
	{
		List<String> output = new ArrayList<String>();
		for(Map.Entry<T, Collection<S>> entry : toWrite.entrySet())
		{
			output.add(entry.getKey().toString());
			for (S next : entry.getValue())
			{
				output.add(next.toString());
			}
		}
		try {
			Files.write(Paths.get(outputFile.getAbsolutePath()), output);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
