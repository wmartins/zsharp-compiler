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
	String type;
	HashMap<String,Symbol> locals;
	Symbol parent;

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

	public Symbol addMethod(String type, String name) {
		Symbol s = new Symbol();
		s.name = name;
		s.kind = Kinds.Meth;
		s.type = type;

		locals.put(name, s);
		return s;
	}

	public Symbol addLocal(String type, String name) {
		Symbol s = new Symbol();
		s.name = name;
		s.kind = Kinds.Local;
		s.type = type;

		locals.put(name, s);
		return s;
	}

	public void addBasicTypes() {
		addType("int");
		addType("char");
	}

}