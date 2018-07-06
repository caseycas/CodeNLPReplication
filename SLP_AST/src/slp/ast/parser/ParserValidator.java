package slp.ast.parser;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import slp.core.lexing.LexerRunner;
import slp.core.util.Util;

public class ParserValidator {
	public static void main(String[] args) throws IOException {
		File root = new File("/Users/caseycas/CodeNLP/AST_test/");
		File out = new File(root.getAbsolutePath() + "-AST");
		if (!out.exists()) out.mkdir();
		List<File> files = Util.getFiles(root);
		for (int i = 0; i < files.size(); i++) {
			File inFile = files.get(i);
			File outFile = new File(out, inFile.getName());
			ASTToken token = JavaASTParser.parse(inFile);
			if (token == null) {
				System.err.println(inFile);
				continue;
			}
			List<String> crawl = parenCrawl(token, 0);
			writeCrawled(outFile, crawl);

			/*
			List<String> reLines = crawl.stream()
					.map(l -> l.split("\t"))
					.filter(l -> !l[1].startsWith("#"))
					.map(l -> l[1]).collect(Collectors.toList());
			List<String> tokens = LexerRunner.lex(inFile)
					.flatMap(l -> l)
					.collect(Collectors.toList());
			boolean equals = reLines.equals(tokens);// reLines.size() == test.size();// test.equals(tokens);
			System.out.println(inFile + "\t" + equals);
			if (!equals) {
				System.out.println(inFile + "\t" + tokens.size() + "\t" + reLines.size() + "\t" + equals + "\t"
						+ tokens.stream().collect(Collectors.joining(" ")).equals(reLines.stream().collect(Collectors.joining(" "))));
//				IntStream.range(0, test.size()).forEach(j -> System.out.println(test.get(j) + "\t" + tokens.get(j)
//					+ "\t" + test.get(j).equals(tokens.get(j))));
				System.out.println(tokens);
				System.out.println(reLines);

			}*/
			//			break;
		}
	}

	public static void writeCrawled(File outFile, List<String> crawl) {
		try (BufferedWriter fw = new BufferedWriter(new FileWriter(outFile))) {
			for (String line : crawl) {
				fw.append(line);
				fw.append(' ');
				//fw.append('\n');
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static List<String> crawl(ASTToken token, int depth) {
		List<String> lines = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		sb.append(depth + "\t");
		sb.append(token.getText());
		lines.add(sb.toString());
		for (ASTToken child : token.getChildren()) lines.addAll(crawl(child, depth + 1));
		return lines;
	}

	public static List<String> parenCrawl(ASTToken token, int depth)
	{
		List<String> lines = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		//sb.append(depth + "\t");
		//Make sure there are no-left over spaces.
		
		if(token.getChildren().isEmpty())
		{
			//Use a Pseudo "PunctTerminal" type for all the things
			//not usually included in an AST.  This will format it
			//similarly to the brown parses.
			//Test, this is now all terminal stuff (we want the extra wrapper
			//around nodes that are not an only child node).
			if(token.getIsPunct() && token.getParent().getChildren().size() > 1)
			{
				lines.add("(");
				lines.add("#PunctTerminal"); //Use actual punctuation marker b/c English does as well?
				if(token.getText().trim().equals("("))
				{
					//sb.append("#OPEN_PAREN ");
					sb.append("OPEN_PAREN");
				}
				else if (token.getText().trim().equals(")"))
				{
					//sb.append("#CLOSE_PAREN ");
					sb.append("CLOSE_PAREN");
				}
				else
				{
					//sb.append("#" + token.getText() + " ");
					sb.append(token.getText().replace(" ", "_"));
				}
				lines.add(sb.toString()); 
				lines.add(")");
				return lines;
			}
			else
			{
				if(token.getText().trim().equals("("))
				{
					sb.append("OPEN_PAREN");
				}
				else if (token.getText().trim().equals(")"))
				{
					sb.append("CLOSE_PAREN");
				}
				else
				{
					sb.append(token.getText().replace(" ", "_"));
				}
				lines.add(sb.toString()); 
				return lines;
			}
		}
		else
		{
			lines.add("(");
			sb.append(token.getText());
			lines.add(sb.toString());
			for (ASTToken child : token.getChildren()) lines.addAll(parenCrawl(child, depth + 1));
			lines.add(")");
			return lines;
		}
	}
}
