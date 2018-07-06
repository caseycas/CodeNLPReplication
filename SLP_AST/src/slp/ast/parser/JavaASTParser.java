package slp.ast.parser;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.CompilationUnit;
import org.eclipse.jdt.core.dom.ITypeBinding;
import org.eclipse.jdt.core.dom.SimpleName;
import org.eclipse.jdt.core.dom.StructuralPropertyDescriptor;

import slp.core.lexing.LexerRunner;
import slp.core.lexing.code.JavaLexer;

public class JavaASTParser {

	private static Pattern punct_pattern = Pattern.compile("\\W+");
	
	public static ASTToken parse(File file) {
		LexerRunner.setLexer(new JavaLexer());
		// Temporarily disable adding delimiters when lexing (if set) since this would break the parsing
		boolean delimiters = LexerRunner.addsSentenceMarkers();
		LexerRunner.addSentenceMarkers(false);
		List<List<String>> lines = LexerRunner.lex(file)
				.map(l -> l.collect(Collectors.toList())).collect(Collectors.toList());
		String text = lines.stream().map(l -> l.stream()
				.collect(Collectors.joining(" ")))
				.collect(Collectors.joining("\n"));
		LexerRunner.addSentenceMarkers(delimiters);
		ASTToken parsed = parse(file, text);
		if (!validate(file, parsed)) parsed = null;
		return parsed;
	}

	private static boolean validate(File next, ASTToken token) {
		if (token == null) return false;
		List<String> terminals = new ArrayList<>();
		getTerminals(token, terminals);
		boolean delimiters = LexerRunner.addsSentenceMarkers();
		LexerRunner.addSentenceMarkers(false);
		List<String> trueTokens = LexerRunner.lex(next)
				.flatMap(l -> l)
				.collect(Collectors.toList());
		LexerRunner.addSentenceMarkers(delimiters);
		return terminals.equals(trueTokens);
	}

	private static void getTerminals(ASTToken token, List<String> terminals) {
		if (!token.getText().startsWith("#")) terminals.add(token.getText());
		for (ASTToken child : token.getChildren()) getTerminals(child, terminals);
	}

	private static ASTToken parse(File file, String text) {
		ASTParser parser = ASTParser.newParser(AST.JLS8);
		Map<String, String> options = JavaCore.getOptions();
		options.put(JavaCore.COMPILER_SOURCE, JavaCore.VERSION_1_8);
		parser.setCompilerOptions(options);
		parser.setKind(ASTParser.K_COMPILATION_UNIT);
		parser.setSource(text.toCharArray());
		parser.setResolveBindings(true);
		parser.setBindingsRecovery(true);
		String[] sources = { "" };
		String[] classpath = { System.getProperty("java.home") + "/lib/rt.jar" };
		parser.setUnitName(file.getAbsolutePath());
		parser.setEnvironment(classpath, sources, new String[] { "UTF-8" }, true);

		try {
			CompilationUnit cu = (CompilationUnit) parser.createAST(null);
			ASTNodeWrapper nodeTree = visit(cu);
			fixArrayDimensions(nodeTree);
			return collectNodes(text, nodeTree, null);
		} catch (IllegalArgumentException e) {
			System.err.println(e);
			System.err.println("In JavaASTTokenizer.tokenize(), on file (if set correctly): " + file);
			return null;
		} catch (StringIndexOutOfBoundsException e) {
			System.err.println("Position mismatch, like syntax error in " + file);
			System.err.println(e);
			return null;
		}
	}

	@SuppressWarnings("rawtypes")
	private static ASTNodeWrapper visit(ASTNode node) throws IllegalArgumentException {
		ASTNodeWrapper wrapper = new ASTNodeWrapper(node);
		List list = node.structuralPropertiesForType();
		// For all child nodes ...
		for (int i = 0; i < list.size(); i++) {
			// ... retrieve the associated property,
			StructuralPropertyDescriptor curr = (StructuralPropertyDescriptor) list.get(i);
			Object child = node.getStructuralProperty(curr);
			// if the child is a regular AST node, visit it directly,
			if (child instanceof ASTNode) {
				wrapper.addChild(visit((ASTNode) child));
			}
			// else if the child is a list of nodes, flatten and visit in order,
			else if (child instanceof List) {
				List children = (List) child;
				for (Object el : children) {
					if (el instanceof ASTNode) {
						wrapper.addChild(visit((ASTNode) el));
					}
				}
			}
		}
		return wrapper;
	}

	/**
	 * For some reason, the dimensions of an array are added as a list to the end of ArrayCreation 
	 * nodes (node-type 3) instead of as a child to their corresponding dimension nodes. This code fixes that.
	 */
	private static void fixArrayDimensions(ASTNodeWrapper nodeTree) {
		for (ASTNodeWrapper child : nodeTree.getChildren()) fixArrayDimensions(child);
		if (nodeTree.getNode().getNodeType() == 3) {
			List<ASTNodeWrapper> children = nodeTree.getChildren();
			List<ASTNodeWrapper> typeChildren = children.get(0).getChildren();
			for (int i = children.size() - 1; i > 0; i--) {
				if (children.get(i).getNode().getNodeType() == 4) continue;
				ASTNodeWrapper node = children.remove(i);
				typeChildren.get(i).children.add(node);
			}
		}
	}

	private static ASTToken collectNodes(String text, ASTNodeWrapper tree, ASTToken parent) {
		ASTNode root = tree.node;
		int start = root.getStartPosition();
		int end = start + root.getLength();
		if (root.getLength() > 1000000000) {
			throw new IllegalArgumentException("Syntax error in current file near node at " + start + ", content: " + root.toString());
		}
		ASTToken currToken = addCurrent(parent, root);
		getChildren(text, tree, currToken, start, end).forEach(currToken::addChild);
		return currToken;
	}

	private static ASTToken addCurrent(ASTToken parent, ASTNode root) {

		String value = "#" + ASTNodeWrapper.nodeTextType(root);
		//value = "#" + Integer.toString(root.getNodeType());

		//System.out.println(value);
		String type = "";
		if (root.getNodeType() == 42) {
			ITypeBinding binding = ((SimpleName) root).resolveTypeBinding();
			if (binding != null)
				type = binding.getQualifiedName();
		}
		ASTToken currToken = new ASTToken(parent, value, type);
		return currToken;
	}

	private static List<ASTToken> getChildren(String text, ASTNodeWrapper tree, ASTToken currToken, int start, int end) {
		List<ASTToken> children = new ArrayList<>();
		int index = start;
		for (ASTNodeWrapper childTree : tree.children) {
			ASTNode childNode = childTree.node;
			int childIndex = childNode.getStartPosition();
			// Add any punctuation and similar tokens in between child-nodes
			if (childIndex > index) {
				//System.out.println("-----------------");
				//System.out.println("mid: " + text.substring(index, childIndex));
				//System.out.println(childNode.getNodeType());
				//System.out.println("-----------------");
				children.addAll(appendTerminals(text.substring(index, childIndex), currToken,true));
				index = childIndex;
			}
			children.add(collectNodes(text, childTree, currToken));
			index += childNode.getLength();
			if (index != childNode.getLength() + childIndex) {
				System.err.println("Pos mismatch: " + index + ", " + childIndex + ", " + childNode.getLength());
				index = childIndex + childNode.getLength();
			}
		}
		if (index < end)
		{
			/*System.out.println("-----------------");
			System.out.println("end: " + text.substring(index, end));
			System.out.println(currToken.getText());
			System.out.println(tree.children.size());
			System.out.println("-----------------");*/
			children.addAll(appendTerminals(text.substring(index, end), currToken, true));
			/*if(tree.children.size() == 0)
			{
				children.addAll(appendTerminals(text.substring(index, end), currToken, false));
			}
			else
			{
				children.addAll(appendTerminals(text.substring(index, end), currToken, true));
			}*/
		}
		return children;
	}

	/**
	 * def_Punct tells us if we are sure this should be considered a "punct" type.
	 * If we're not sure, look to see if it seems like punctuation.
	 * @param intermediate
	 * @param token
	 * @param def_Punct
	 * @return
	 */
	private static List<ASTToken> appendTerminals(String intermediate, ASTToken token, boolean def_Punct) {
		String content = intermediate.trim().replaceAll("[\n\r]+", "");
		if (!content.isEmpty()) {
			return new JavaLexer().lex(Collections.singletonList(intermediate))
					.flatMap(l -> l).map(t -> new ASTToken(token, t, def_Punct || punctCheck(t)))
					.collect(Collectors.toList());
		}
		else
		{
			return Collections.emptyList();
		}
	}
	
	private static boolean punctCheck(String text)
	{
		 String content = text.trim().replaceAll("[\n\r]+", "");
		 Matcher m = punct_pattern.matcher(content);
		 return m.matches();
	}

	private static class ASTNodeWrapper {
		private final ASTNode node;
		private final List<ASTNodeWrapper> children;

		private ASTNodeWrapper(ASTNode node) {
			this.node = node;
			this.children = new ArrayList<>();
		}

		private void addChild(ASTNodeWrapper node) {
			this.children.add(node);
		}

		public ASTNode getNode() {
			return node;
		}

		public List<ASTNodeWrapper> getChildren() {
			return children;
		}

		public static String nodeTextType(ASTNode node)
		{
			return node.getClass().getName().replace("org.eclipse.jdt.core.dom.", "");
		}

		@Override
		public String toString() {
			return this.node.getNodeType() +
					" [" + this.children.stream().map(node -> node.node.getNodeType()+"").collect(Collectors.joining(", ")) + "]";
			//return nodeTextType(this.node) +
			//		" [" + this.children.stream().map(node -> nodeTextType(node.node) + "").collect(Collectors.joining(", ")) + "]";

		}
	}
}
