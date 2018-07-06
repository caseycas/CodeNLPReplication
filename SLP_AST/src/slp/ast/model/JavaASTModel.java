package slp.ast.model;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import slp.ast.parser.ASTToken;
import slp.ast.parser.JavaASTParser;
import slp.core.lexing.LexerRunner;
import slp.core.lexing.code.JavaLexer;
import slp.core.modeling.AbstractModel;
import slp.core.modeling.Model;
import slp.core.modeling.ngram.NGramModel;
import slp.core.translating.Vocabulary;
import slp.core.util.Pair;

public class JavaASTModel extends AbstractModel {

	private ASTToken token;
	private List<Integer> tokens;
	private List<Integer> noRewrite;
	private List<Integer> rewriteDFS;
	private List<Integer> rewriteShallow;
	private List<Integer> rewriteDeep;
	private Model model;

	private int choice;
	public JavaASTModel(Model model, int choice) {
		this.model = model;
		this.choice = choice;
	}

	public JavaASTModel(int choice) {
		this(NGramModel.standard(), choice);
	}
	
	public JavaASTModel(Model model) {
		this(model, 1);
	}

	public JavaASTModel() {
		this(NGramModel.standard());
	}
	
	@Override
	public void notify(File next) {
		boolean valid = true;
		try {
			LexerRunner.setLexer(new JavaLexer());
			ASTToken token = JavaASTParser.parse(next);
			if (token == null) valid = false;
			else {
				this.token = token;
				this.noRewrite = LexerRunner.lex(next)
						.flatMap(l -> l)
						.map(Vocabulary::toIndex).collect(Collectors.toList());
				this.rewriteDFS = rewriteDFS(token).stream()
						.map(p -> p.left+"")
						.map(Vocabulary::toIndex)
						.collect(Collectors.toList());
				this.rewriteShallow = rewriteShallow(token).stream()
						.map(Vocabulary::toIndex)
						.collect(Collectors.toList());
				this.rewriteDeep = rewriteDeep(token).stream()
						.map(Vocabulary::toIndex)
						.collect(Collectors.toList());
				if (LexerRunner.addsSentenceMarkers()) {
					this.rewriteDFS.add(0, Vocabulary.toIndex(Vocabulary.BOS));
					this.rewriteDFS.add(Vocabulary.toIndex(Vocabulary.EOS));
					this.rewriteShallow.add(0, Vocabulary.toIndex(Vocabulary.BOS));
					this.rewriteShallow.add(Vocabulary.toIndex(Vocabulary.EOS));
					this.rewriteDeep.add(0, Vocabulary.toIndex(Vocabulary.BOS));
					this.rewriteDeep.add(Vocabulary.toIndex(Vocabulary.EOS));
				}
				if (this.choice == 0) this.tokens = this.noRewrite;
				else if (this.choice == 1) this.tokens = this.rewriteDFS;
				else if (this.choice == 2) this.tokens = this.rewriteShallow;
				else if (this.choice == 3) this.tokens = this.rewriteDeep;
			}
		} catch (Exception e) {
			valid = false;
		}
		if (!valid) {
			System.err.println("Error parsing; inspect file for syntax errors: " + next);
			System.err.println("Will return vocabulary base-rate for every token in this file; recommend skipping in output.");
			this.token = null;
		}
		this.model.notify(next);
	}

	private static List<Pair<ASTToken, Integer>> rewriteDFS(ASTToken token) {
		List<Pair<ASTToken, Integer>> alignments = new ArrayList<>();
		rewriteDFS(token, alignments);
		return alignments;
	}

	private static void rewriteDFS(ASTToken token, List<Pair<ASTToken, Integer>> alignment) {
		for (ASTToken child : token.getChildren()) {
			if (child.getChildren().isEmpty()) {
				alignment.add(Pair.of(child, alignment.size() + 1));
			}
		}
		for (ASTToken child : token.getChildren()) {
			if (!child.getChildren().isEmpty()) {
				rewriteDFS(child, alignment);
			}
		}
	}

	private static List<String> rewriteShallow(ASTToken token) {
		List<String> alignments = new ArrayList<>();
		rewriteShallow(token, alignments);
		return alignments;
	}

	private static void rewriteShallow(ASTToken token, List<String> alignment) {
		List<String> terminals = new ArrayList<>();
		for (ASTToken child : token.getChildren()) {
			if (child.getChildren().isEmpty()) {
				terminals.add(child.getText());
			}
		}
		if (!terminals.isEmpty()) alignment.add(terminals.stream().collect(Collectors.joining(" "+(char) 31)));
		for (int i = 1; i < terminals.size(); i++) alignment.add("");
		for (ASTToken child : token.getChildren()) {
			if (!child.getChildren().isEmpty()) {
				rewriteShallow(child, alignment);
			}
		}
	}

	private static List<String> rewriteDeep(ASTToken token) {
		List<String> alignments = new ArrayList<>();
		rewriteDeep(token, alignments);
		return alignments;
	}

	private static void rewriteDeep(ASTToken token, List<String> alignment) {
		List<String> terminals = new ArrayList<>();
		for (ASTToken child : token.getChildren()) {
			if (child.getChildren().isEmpty()) {
				terminals.add(child.getText());
			} else if (child.getChildren().size() == 1 && child.getChild(0).getChildren().isEmpty()) {
				terminals.add(child.getChild(0).getText());
			} else if (child.getChildren().size() == 1 && child.getChild(0).getChildren().size() == 1
					&& child.getChild(0).getChild(0).getChildren().isEmpty()) {
				terminals.add(child.getChild(0).getChild(0).getText());
			}
		}
		if (!terminals.isEmpty()) alignment.add(terminals.stream().collect(Collectors.joining(" "+(char) 31)));
		for (int i = 1; i < terminals.size(); i++) alignment.add("");
		for (ASTToken child : token.getChildren()) {
			if (!child.getChildren().isEmpty() && !(child.getChildren().size() == 1 && child.getChild(0).getChildren().isEmpty())
					&& !(child.getChildren().size() == 1 && child.getChild(0).getChildren().size() == 1 && child.getChild(0).getChild(0).getChildren().isEmpty())) {
				rewriteDeep(child, alignment);
			}
		}
	}

	@Override
	public void learnToken(List<Integer> input, int index) {
		if (this.token == null) return;
		if (!Vocabulary.toWord(this.tokens.get(index)).isEmpty()) {
			List<Integer> filtered = IntStream.range(0, index)
					.filter(t -> !Vocabulary.toWord(this.tokens.get(t)).isEmpty())
					.mapToObj(t -> this.tokens.get(t)).collect(Collectors.toList());
			this.model.learnToken(filtered, filtered.size() - 1);
		}
	}

	@Override
	public void forgetToken(List<Integer> input, int index) {
		if (this.token == null) return;
		if (!Vocabulary.toWord(this.tokens.get(index)).isEmpty()) {
			List<Integer> filtered = IntStream.range(0, index)
					.filter(t -> !Vocabulary.toWord(this.tokens.get(t)).isEmpty())
					.mapToObj(t -> this.tokens.get(t)).collect(Collectors.toList());
			this.model.forgetToken(filtered, filtered.size() - 1);
		}
	}

	private Pair<Double, Double> last;
	@Override
	public Pair<Double, Double> modelAtIndex(List<Integer> input, int index) {
		if (this.token == null) return Pair.of(0.0, 0.0);
		if (!Vocabulary.toWord(this.tokens.get(index)).isEmpty()) {
			List<Integer> filtered = IntStream.range(0, index + 1)
					.filter(t -> !Vocabulary.toWord(this.tokens.get(t)).isEmpty())
					.mapToObj(t -> this.tokens.get(t)).collect(Collectors.toList());
			Pair<Double, Double> res = this.model.modelToken(filtered, filtered.size() - 1);
			this.last = res;
			return res;
		} else {
			if (this.last.left == 0.0) return Pair.of(0.0, 0.0);
			else return Pair.of(1.0, 1.0);
		}
	}

	@Override
	public Map<Integer, Pair<Double, Double>> predictAtIndex(List<Integer> input, int index) {
		if (this.token == null) new HashMap<>();
		// TODO Auto-generated method stub
		return new HashMap<>();
	}
}
