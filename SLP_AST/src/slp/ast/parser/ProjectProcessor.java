package slp.ast.parser;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;

/**
 * Tool to process all the Java files in a project through the AST tokenizer and
 * put them into a format for the Cache model tool to process.
 * 
 * Input: A Directory one hop up from a set of git cloned Java projects
 * 
 * Output Requirements: (Linearized AST)
 * Each File is put on a spectrum from 0.java_ast.tokens onwards
 * These files will need to be split like the large code files did.
 * Output modifications?
 * Metadata file:
 * Project, file, token, token_type (small set to divide original code with AST components), token_location
 * Project Split file format:
 * 	-This was a .pickle file before (need to then create an alternate format - XML?)
 * @author caseycas
 *
 */


public class ProjectProcessor {
	public static int MAX_TOKEN = 10000;
    
    public static String readFile(File javaFile)
    {
    	try {
			return new String(Files.readAllBytes(Paths.get(javaFile.getAbsolutePath())));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return "";
    }
    
    public static Collection<File> getProjectFiles(File projectDir)
    {
    	System.out.println(projectDir.getAbsolutePath());
    	System.out.println(projectDir.isDirectory());
		return FileUtils.listFiles(projectDir.getAbsoluteFile(), new JavaFileFilter(), TrueFileFilter.INSTANCE);
    }
    
    /**
     * Get the set of git project directories directly below the supplied directory.
     * @param mainDir
     * @return
     */
    public static Set<File> getProjectSet(File mainDir)
    {
    	return Arrays.stream(mainDir.list((File current, String name) -> new File(current, name).isDirectory())).map(d -> new File(mainDir + "/" + d)).collect(Collectors.toSet());
    }
    
    /**
     * Label this AST element as one of three types:
     * PAREN - for ( and )
     * WORD - for the code tokens
     * TAG - for the AST abstract types.
     * @param token
     * @return
     */
    public static String getItemType(String token, String lastType)
    {
    	if(token.equals("(") || token.equals(")"))
    	{
    		return "PAREN";
    	}
    	else if(lastType == "START") //And this is not a PAREN
    	{
    		return "TAG";
    	}
    	else if(lastType == "PAREN")
    	{
    		return "TAG";
    	}
    	else
    	{
    		return "WORD";
    	}
    }
    
    
    /**
     * project,file,token,token_type,token_location
     * elastic___elasticsearch,/core/src/main/java/org/apache/lucene/analysis/
     * miscellaneous/UniqueTokenFilter.java,CompilationUnit,WORD,0
     * @param linearAST
     * @param fileName
     * @param projectDir
     * @param file_id
     */
    public static void writeMetaDataFile(List<String> linearAST, File fileName, File outputDir, File projectDir, int file_id)
    {
       //TODO
    	List<String> output = new ArrayList<String>();
    	output.add("project,file,token,token_type,token_location");
    	Integer i = 0;
    	String lastType = "START";
    	for (String item: linearAST)
    	{
    		lastType = getItemType(item, lastType);
    		output.add(String.join(",", projectDir.getAbsolutePath(), fileName.getAbsolutePath(), item, lastType, i.toString()));
			i++;
    	}
    	try {
			Files.write(Paths.get(outputDir + "/" + file_id + ".java_ast.metadata"), output);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public static void writeTokenFile(List<String> linearAST, File outputDir, int file_id)
    {
    	//Create Output Name
    	String output_name = outputDir + "/" + file_id + ".java_ast.tokens";
    	try {
			Files.write(Paths.get(output_name), String.join(" ", linearAST).getBytes());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }


	public static void main(String[] args)
	{
		//Read the input
		if(args.length != 2)
		{
			System.out.println("Usage: input_directory output_directory");
			System.exit(-1);
		}
		
		File main_dir = new File(args[0]);
		File output_dir = new File(args[1]);
		
		if(!(main_dir.exists() && main_dir.isDirectory()))
		{
			System.out.println("Your input directory either doesn't exist or isn't a directory");
		}
		
		//Get the Projects
        Set<File> projectDirs = getProjectSet(main_dir);
        //projectDirs.stream().forEach(F -> System.out.println(F));
        //System.exit(0);
        int file_id = 0;
        Map<String, Collection<Integer>> projectToFileMap = new HashMap<String, Collection<Integer>>();
        //ASTTokenizer ast = new ASTTokenizer();
        
        ArrayList<File> errorFiles = new ArrayList<File>();
        for(File nextProject: projectDirs)
        {
            //Read in all the java files for the project
            Collection<File> projectFiles = getProjectFiles(nextProject);
            //projectFiles.stream().forEach(F -> System.out.println(F));
            //System.exit(0);
            
            for (File nextJava: projectFiles)
            {
            	    /*if(file_id < 100)
            	    {
            	    		System.exit(0);
            	    		//file_id++;
            	    		//continue;
            	    }*/
            	    //File inFile = files.get(i);
        			//File outFile = new File(out, inFile.getName());
            		ASTToken token = null;
            		//token = JavaASTParser.parse(nextJava);
            	    try
            	    {
            	    		token = JavaASTParser.parse(nextJava);
            	    }
            	    catch(Exception e)
            	    {
            	    		System.err.println(e);
            	    		System.err.println(nextJava);
            	    		errorFiles.add(nextJava);
            	    		continue;
            	    }
        			if (token == null) {
        				System.err.println(nextJava);
        				errorFiles.add(nextJava);
        				continue;
        			}
        			List<String> crawl = ParserValidator.parenCrawl(token, 0);
        			//writeCrawled(outFile, crawl);
        			
                //crawl.stream().forEach(a -> System.out.println(a));
                //System.exit(0);
                
                //Write the metadata file
                writeMetaDataFile(crawl, nextJava, output_dir, nextProject, file_id);
                
                //Write the AST file
                writeTokenFile(crawl, output_dir, file_id);

                //Update the project-file id map
                Set<Integer> temp = new HashSet<Integer>();
                temp.add(file_id);
                projectToFileMap = MapUtils.updateMap(projectToFileMap, nextProject.getName(), temp); //I think I have a util file that does something like this (look it up).
                
                //Increment file id
                file_id++;
                
                /*if(file_id > 1)
                {
                	break;
                }*/
                
            }
            
        }
        //Write the project-file id map
        MapUtils.writeMap(projectToFileMap, new File(output_dir.getAbsolutePath() + "/" + "projectToFileMap.txt"));
        try {
			Files.write(Paths.get(output_dir.getAbsolutePath() + "/" + "errors.txt"), errorFiles.stream().map(f -> f.getAbsolutePath()).collect(Collectors.toList()));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
