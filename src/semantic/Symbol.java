import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;
import java.util.HashSet;
import java.util.ArrayList;

public class Symbol {

	public enum Kind {
		Class
		, Array // anything that has some kind of index
		, Field // an class object, maybe it could also be a method of a class
		, Variable // well, you know, variables :)
		, Method
		, Type
		, Argument
	}

	public Symbol parent;

	public String name;
	public Symbol type;
	public HashSet<Kind> kinds;
	public HashMap<String,Symbol> types;
	public HashMap<String,Symbol> variables;
	public HashMap<String,Symbol> constants;
	public HashMap<String,ArrayList<Symbol>> methods;
	public ArrayList<Symbol> arguments;

	public void construct() {
		kinds = new HashSet<Kind>();
		types = new HashMap<String,Symbol>();
		variables = new HashMap<String,Symbol>();
		constants = new HashMap<String,Symbol>();
		methods = new HashMap<String,ArrayList<Symbol>>();
		arguments = new ArrayList<Symbol>();
	}

	public Symbol(boolean universe) {
		construct();
		if(universe == true) {
			this.name = "*UNIVERSE*";
			Symbol intSymbol = new Symbol();
			intSymbol.name = "int";
			types.put("int", intSymbol);
			intSymbol.kinds.add(Kind.Type);

			ArrayList<Symbol> intParams = new ArrayList<Symbol>();
			Symbol intParam = new Symbol();
			intParam.name = "arr";
			intParam.type = intSymbol;
			intParams.add(intParam);
			addMethod("len", intSymbol, intParams);

			Symbol charSymbol = new Symbol();
			charSymbol.name = "char";
			types.put("char", charSymbol);
			charSymbol.kinds.add(Kind.Type);

			ArrayList<Symbol> charParams = new ArrayList<Symbol>();
			Symbol charParam = new Symbol();
			charParam.name = "arr";
			charParam.type = charSymbol;
			charParams.add(charParam);
			addMethod("len", intSymbol, charParams);

			Symbol booleanSymbol = new Symbol();
			booleanSymbol.name = "boolean";
			types.put("boolean", booleanSymbol);
			booleanSymbol.kinds.add(Kind.Type);

			Symbol voidSymbol = new Symbol();
			voidSymbol.name = "void";
			types.put("void", voidSymbol);
			voidSymbol.kinds.add(Kind.Type);

			Symbol nullSymbol = new Symbol();
			nullSymbol.name = "null";
			constants.put("null", nullSymbol);
			types.put("null", nullSymbol);

			ArrayList<Symbol> _ordParams = new ArrayList<Symbol>();
			Symbol _ordParam = new Symbol();
			_ordParam.name = "chr";
			_ordParam.type = getType("char");
			_ordParams.add(_ordParam);
			addMethod("ord", intSymbol, _ordParams);

			ArrayList<Symbol> _chrParams = new ArrayList<Symbol>();
			Symbol _chrParam = new Symbol();
			_chrParam.name = "nro";
			_chrParam.type = getType("int");
			_chrParams.add(_chrParam);
			addMethod("chr", charSymbol, _chrParams);
		}
	}

	public Symbol() {
		construct();
	}

	public Symbol addClass(String name) {
		Symbol s = new Symbol();
		s.name = name;
		s.kinds.add(Kind.Class);

		types.put(name, s);

		return s;
	}

	public Symbol addLenMethod(Symbol klass, Symbol type) {
		ArrayList<Symbol> sParams = new ArrayList<Symbol>();
		Symbol sParam = new Symbol();
		sParam.name = "arr";
		sParam.type = klass;
		sParams.add(sParam);
		return addMethod("len", type, sParams);
	}

	public Symbol addVariable(String name, Symbol type, boolean argument) {
		Symbol s = addVariable(name, type);
		if(argument) {
			s.kinds.add(Kind.Argument);
		}
		return s;
	}

	public Symbol addVariable(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		s.kinds.add(Kind.Variable);
		variables.put(name, s);
		return s;
	}

	public Symbol addArrayVariable(String name, Symbol type, boolean argument) {
		Symbol s = addArrayVariable(name, type);
		if(argument) {
			s.kinds.add(Kind.Argument);
		}
		return s;
	}

	public Symbol addArrayVariable(String name, Symbol type) {
		Symbol s = addVariable(name, type);
		s.kinds.add(Kind.Array);
		return s;
	}

	public Symbol addConstant(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		constants.put(name, s);
		return s;
	}

	public Symbol addMethod(String name, Symbol type, ArrayList<Symbol> formPars) {
		Symbol s = addMethod(name, type);
		s.arguments = formPars;
		return s;
	}

	public Symbol addMethod(String name, Symbol type) {
		Symbol s = new Symbol();
		s.name = name;
		s.type = type;

		s.kinds.add(Kind.Method);

		ArrayList<Symbol> m = methods.get(name);
		if(m == null) {
			methods.put(name, new ArrayList<Symbol>());
		}
		methods.get(name).add(s);
		return s;
	}

	public Symbol getType(String name) {
		return types.get(name);
	}

	public Symbol getVariable(String name) {
		return variables.get(name);
	}

	public Symbol getMethod(String name, ArrayList<Symbol> actPars) {
		ArrayList<Symbol> m = methods.get(name);
		int i = 0;
		Symbol r = null;
		if(m != null) {
			for(Symbol method : m) {
				r = method;
				if(actPars.size() == method.arguments.size()) {
					for(Symbol argument : method.arguments) {
						if(actPars.get(0) != argument.type) {
							r = null;
						}
					}
				}
				if(r != null) {
					return r;
				}
			}
		}
		return r;
	}

	public Symbol getConstant(String name) {
		return constants.get(name);
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
		describeMethods(methods.entrySet().iterator(), level);
	}

	private void describeInner(Iterator it, int level) {
		while(it.hasNext()) {
			Map.Entry pairs = (Map.Entry) it.next();
			Symbol s = (Symbol)pairs.getValue();
			s.describe(level + 1);
		}
	}

	private void describeMethods(Iterator it, int level) {
		while(it.hasNext()) {
			Map.Entry pairs = (Map.Entry) it.next();
			ArrayList<Symbol> m = (ArrayList<Symbol>)pairs.getValue();
			for(Symbol method : m) {
				System.out.print("[" + method.name + "(");
				for(Symbol argument : method.arguments) {
					System.out.print(argument.type.name + ",");
				}
				System.out.println(")]");
			}
		}
	}

}