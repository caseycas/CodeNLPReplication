package slp.ast.parser;

import java.util.ArrayList;
import java.util.List;

public class ASTToken {

	private final ASTToken parent;
	private final List<ASTToken> children;
	
	private final String text;
	private final String type;
	private final boolean isPunct;

	public ASTToken(ASTToken parent, String text) {
		this(parent, text, "", false);
	}
	
	public ASTToken(ASTToken parent, String text, boolean isPunct)
	{
		this(parent, text, "", isPunct);
	}
	
	public ASTToken(ASTToken parent, String text, String type) {
		this(parent, text, type, false);
	}

	public ASTToken(ASTToken parent, String text, String type, boolean isPunct) {
		this.parent = parent;
		this.text = text;
		this.type = type;
		this.isPunct = isPunct;
		this.children = new ArrayList<>();
	}
	
	public ASTToken getParent() {
		return this.parent;
	}

	public void addChild(ASTToken token) {
		this.children.add(token);
	}

	public void addChild(int index, ASTToken token) {
		this.children.add(index, token);
	}
	
	public List<ASTToken> getChildren() {
		return this.children;
	}

	public ASTToken getChild(int index) {
		return this.getChildren().get(index);
	}
	
	public String getText() {
		return this.text;
	}
	
	public String getType() {
		return type;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(this.text);
//		if (this.parent != null) {
//			sb.append(" <- ");
//			sb.append(this.parent.getText());
//		}
		if (!this.type.isEmpty()) {
			sb.append("\t");
			sb.append(this.type);
		}
		return sb.toString();
	}

	public boolean getIsPunct() {
		return isPunct;
	}
}
