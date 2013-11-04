import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;
import java.util.HashSet;

public class Symbol {

	public enum Kind {
		Class
		, Array // anything that has some kind of index
		, Field // an class object, maybe it could also be a method of a class
		, Variable // well, you know, variables :)
	}

	public Symbol parent;

	public String name;
	public Symbol type;
	public HashSet<Kind> kinds;
	public HashMap<String,Symbol> types;
	public HashMap<String,Symbol> variables;
	public HashMap<String,Symbol> constants;
	public HashMap<String,Symbol> methods;

	public void construct() {
		kinds = new HashSet<Kind>();
		types = new HashMap<String,Symbol>();
		variables = new HashMap<String,Symbol>();
		constants = new HashMap<String,Symbol>();
		methods = new HashMap<String,Symbol>();
	}

	public Symbol(boolean universe) {
		construct();
		if(universe == true) {
			this.name = "*UNIVERSE*";
			Symbol intSymbol = new Symbol();
			intSymbol.name = "int";
			types.put("int", intSymbol);

			Symbol charSymbol = new Symbol();
			charSymbol.name = "char";
			types.put("char", charSymbol);

			Symbol voidSymbol = new Symbol();
			voidSymbol.name = "void";
			types.put("void", voidSymbol);

			Symbol nullSymbol = new Symbol();
			nullSymbol.name = "null";
			constants.put("null", nullSymbol);
		}
	}

	public Symbol() {
		construct();
	}

	public Symbol addClass(String name) {
		Symbol s = new Symbol();
		s.name = name;
		kinds.add(Kind.Class);

		types.put(name, s);
		return s;
	}

	public Symbol addVariable(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		variables.put(name, s);
		return s;
	}

	public Symbol addConstant(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		constants.put(name, s);
		return s;
	}

	public Symbol addMethod(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		methods.put(name, s);
		return s;
	}

	public Symbol getType(String name) {
		return types.get(name);
	}

	public Symbol getVariable(String name) {
		return variables.get(name);
	}

	public Symbol getMethod(String name) {
		return methods.get(name);
	}

	public Symbol getConstant(String name) {
		return constants.get(name);
	}

	public Symbol getSymbol(String name) {
		return methods.get(name);
	}

	public void describe() {
		describe(0);
	}

	public void describe(int level) {
		Iterator it;
		for(int i = 0; i < level; i += 1) {
			System.out.print("..");
		}
		System.out.println("[" + name + "]");
		describeInner(types.entrySet().iterator(), level);
		describeInner(constants.entrySet().iterator(), level);
		describeInner(variables.entrySet().iterator(), level);
		describeInner(methods.entrySet().iterator(), level);
	}

	private void describeInner(Iterator it, int level) {
		while(it.hasNext()) {
			Map.Entry pairs = (Map.Entry) it.next();
			Symbol s = (Symbol)pairs.getValue();
			s.describe(level + 1);
		}
	}

}