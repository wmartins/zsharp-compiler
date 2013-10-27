import java.util.HashMap;

public class Symbol {

	public enum Kinds {
		Const
		, Global
		, Field
		, Arg
		, Local
		, Type
		, Meth
		, Prog
	}

	Kinds kind;
	String name;
	HashMap<String,Symbol> locals;

	public Symbol() {
		locals = new HashMap<String,Symbol>();
	}

	public Symbol addType(String name) {
		Symbol s = new Symbol();
		s.name = name;

		s.kind = Kinds.Type;

		locals.put(name, s);
		return s;
	}

	public void addBasicTypes() {
		addType("int");
		addType("char");
	}

}