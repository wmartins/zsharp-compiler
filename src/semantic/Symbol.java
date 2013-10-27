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

	public Symbol findLocal(String name) {
		return locals.get(translateName(Kinds.Local, name));
	}

	public Symbol addType(String name) {
		Symbol s = new Symbol();
		s.name = name;

		s.kind = Kinds.Type;

		locals.put(name, s);
		return s;
	}

	public String translateName(Kinds kind, String name) {
		switch(kind) {
			case Local:
				return name + " - local";
			case Meth:
				return name + " - meth";
			default:
				return name;
		}
	}

	public Symbol addMethod(String type, String name) {
		String newName = translateName(Kinds.Local, name);
		if(locals.get(newName) != null) {
			System.out.println("Método já declarado :/");
		}
		Symbol s = new Symbol();
		s.name = newName;
		s.kind = Kinds.Meth;
		s.type = type;

		locals.put(newName, s);
		return s;
	}

	public Symbol addLocal(String type, String name) {
		String newName = translateName(Kinds.Local, name);
		if(locals.get(newName) != null) {
			System.out.println("Variável já declarada :/");
		}
		Symbol s = new Symbol();
		s.name = newName;
		s.kind = Kinds.Local;
		s.type = type;

		locals.put(newName, s);
		return s;
	}

	public Symbol addConst(String type, String name) {
		String newName = translateName(Kinds.Local, name);
		if(locals.get(newName) != null) {
			System.out.println("Constante já declarada :/");
		}
		
		Symbol s = new Symbol();
		s.name = newName;
		s.kind = Kinds.Const;
		s.type = type;

		locals.put(newName, s);
		return s;
	}

	public void addBasicTypes() {
		addType("int");
		addType("char");
	}

}