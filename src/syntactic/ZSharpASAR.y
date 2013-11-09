%{
  /**
   * This is the syntactic specification for the ZSharp Language.
   * The language specification is available at:
   * Description about the language avaliable at:
   *   http://dotnet.jku.at/courses/CC/
   *
   * @author Italo Lobato Qualisoni - 12104861-5 - <italo.qualisoni@acad.pucrs.br>
   * @author William Henrihque Martins - 12104965-4 - <william.henrihque@acad.pucrs.br>
   */
  import java.io.*;
  import java.util.Stack;
%}

%token EQEQ DIF GT GTE LT LTE 
%token ADDITIVESUM ADDITIVESUB LOGICALAND LOGICALOR CHARCONST
%token IF BREAK CONST ELSE CLASS NEW READ WRITE VOID WHILE RETURN
%token IDENT NUMBER 

%left LOGICALOR
%left LOGICALAND
%nonassoc  GTE EQEQ DIF LTE  '>' '<'
%left '+' '-'
%left '*' '/' '%'  
%left NEG 

%type <sval> IDENT Type
%type <sval> Expr Designator

%%

Program    : CLASS IDENT { pushScope(currentScope.addClass($2)); programScope = currentScope; } ListDecl '{' ListMethodsDecl '}' { universe.describe(); }
           ;

ListDecl   : ConstDecl ListDecl
     | VarDecl ListDecl
     | ClassDecl ListDecl
     |;
  
ConstDecl  : CONST Type IDENT '=' NUMBER ';' {
              Symbol type = getType($2);
              currentScope.addConstant($3, type);
            }
     | CONST Type IDENT '=' CHARCONST';' {
            Symbol type = getType($2);
            currentScope.addConstant($3, type); 
          }
     ;

VarDecl    : Type IDENT {
              Symbol type = getType($1);
              Symbol variable = currentScope.addVariable($2, type);
              currentTypeVarDecl = type;

              if(insideClassDecl) {
                variable.kinds.add(Symbol.Kind.Field);
              }
              variable.kinds.add(Symbol.Kind.Variable);
            } ListIDENT ';';

ListIDENT  : ',' IDENT {
                  Symbol variable = currentScope.addVariable($2, currentTypeVarDecl);

                  if(insideClassDecl) {
                    variable.kinds.add(Symbol.Kind.Field);
                  }
                  variable.kinds.add(Symbol.Kind.Variable);
                } ListIDENT
     |
     ;

ClassDecl  : CLASS IDENT {
              insideClassDecl = true; pushScope(currentScope.addClass($2));
            } '{' ListVarDecl '}' { insideClassDecl = false; popScope(currentScope); };

ListVarDecl: VarDecl ListVarDecl
           | 
           ;
MethodDecl : Type IDENT '(' { pushScope(currentScope.addMethod($2, getType($1))); } ')' ListVarDecl Block { popScope(currentScope); }
           | VOID IDENT '(' { pushScope(currentScope.addMethod($2, getType("void"))); } ')' ListVarDecl Block { popScope(currentScope); }
           | Type IDENT '(' { pushScope(currentScope.addMethod($2, getType($1))); } FormPars ')' ListVarDecl Block { popScope(currentScope); }
           | VOID IDENT '(' { pushScope(currentScope.addMethod($2, getType("void"))); } FormPars ')' ListVarDecl Block { popScope(currentScope); }
           ;
ListMethodsDecl: MethodDecl ListMethodsDecl 
           | 
     ;

FormPars   : Type IDENT {
              currentScope.addVariable($2, getType($1));
            }
           | Type IDENT {
              currentScope.addVariable($2, getType($1));
           }',' FormPars
           ;


Type       : IDENT 
           | IDENT { 
              Symbol type = getType($1);
              if(type == null) {
                System.out.println("Error: " + $1 + " must be a type");
              }
            }'[' ']'
           ;

Statment   : Designator '=' {
              Symbol s = resolveDesignator("variable");
              currentSymbol = s;
              if(s != null) {
                if(!s.kinds.contains(Symbol.Kind.Variable)) {
                  System.out.println("Attributions must have on the left side a variable, object field or array, " + s.name + " isn't any of that.");
                }
              }
            } Expr { 
              Symbol type = exprStack.peek();
              if(currentSymbol.type != type) {
                System.out.println("Incompatible types for " + currentSymbol.type.name + " and " + type.name + ".");
              }
            }';'
     | Designator '(' { currentDesignatorName = $1; resolveDesignator("method"); } ')' ';' 
     | Designator '(' { currentDesignatorName = $1; resolveDesignator("method"); } ActPars ')' ';' 
     | Designator {
          Symbol s = resolveDesignator("variable");
          if(!s.kinds.contains(Symbol.Kind.Variable)) {
            System.out.println("Increment operator must be a variable, object field or array, " + s.name + " isn't any of that.");
          }
          if(s.type != getType("int")) {
            System.out.println("Increment operator must be int, " + s.name + " is " + s.type.name);
          }
      } ADDITIVESUM ';'
     | Designator {
        Symbol s = resolveDesignator("variable");
        if(!s.kinds.contains(Symbol.Kind.Variable)) {
          System.out.println("Decrement operator must be a variable, object field or array, " + s.name + " isn't any of that.");
        }
        if(s.type != getType("int")) {
          System.out.println("Increment operator must be int, " + s.name + " is " + s.type.name);
        }
      } ADDITIVESUB ';'
     | IF '(' Expr ')' Statment 
     | IF '(' Expr ')' Statment ELSE Statment
     | WHILE '(' Expr ')' { insideWhileLoop = true; } Statment { insideWhileLoop = false; } 
     | BREAK {
        if(!insideWhileLoop) {
          System.out.println("Break command must be inside while loop");
        }
      } ';'
     | RETURN Expr {
        Symbol s = exprStack.pop();

        if(currentScope.type != s) {
          System.out.println("This method must return " + currentScope.type.name + ". So, it can't return " + s.name + ".");
        }
     }';'
     | RETURN ';' { 
        if(!currentScope.type.name.equals("void")) {
          System.out.println("This method must return " + currentScope.type.name + ". So, it can't return void.");
        }
     }
     | READ  '(' Designator {
        Symbol s = resolveDesignator("variable");
        if(s != null) {
          if(!s.kinds.contains(Symbol.Kind.Variable)) {
            System.out.println("Read must have as parameter a variable, object field or array, " + s.name + " isn't any of that.");
          } else if(!s.type.name.equals("int") && !s.type.name.equals("char")) {
            System.out.println("Read must have as parameter int or char.");
          }
        }
      } ')' ';'
     | WRITE '(' Expr {
        Symbol type = exprStack.pop();
        if(type != getType("int") && type!= getType("char")) {
          System.out.println("Write operation can only be applied to int or char, " + type.name + " is not any of that.");
        }
      } ')' ';'
     | WRITE '(' Expr {
        Symbol type = exprStack.pop();
        if(type != getType("int") && type!= getType("char")) {
          System.out.println("Write operation can only be applied to int or char, " + type.name + " is not any of that.");
        }
      } ',' NUMBER  ')' ';'
     | Block
     | ';' 
     ;

ListStatment : Statment ListStatment
             |
             ;

Block        : '{' ListStatment '}'
             ;

ActPars      : Expr { exprStack.pop(); } ListExpr
             ;
             
ListExpr     : ',' Expr ListExpr
             |
             ;

Expr         : Expr LOGICALOR Expr { checkLogicOperation(); }
             | Expr  LOGICALAND Expr  { checkLogicOperation(); }
             | Expr  GTE  Expr { checkLogicOperation(); }
             | Expr  EQEQ Expr { checkLogicOperation(); }
             | Expr  DIF  Expr { checkLogicOperation(); }
             | Expr  LTE  Expr { checkLogicOperation(); }
             | Expr  '>'  Expr { checkLogicOperation(); }
             | Expr  '<'  Expr { checkLogicOperation(); }
             | Expr  '+'  Expr { checkNumericOperation(); }
             | Expr  '-'  Expr { checkNumericOperation(); }
             | '-' Expr  %prec NEG {
                Symbol type = exprStack.pop();
                if(type != getType("int")) {
                  System.out.println("The unary minus operation can be only applied to int, " + type.name + " is not int.");
                }
                exprStack.push(type);

              }
             | Expr  '*'  Expr { checkNumericOperation(); }
             | Expr  '/'  Expr { checkNumericOperation(); }
             | Expr  '%'  Expr { checkNumericOperation(); }
             | Designator {
                  currentDesignatorName = $1;
                  Symbol s = resolveDesignator("variable");
                  if(s == null) {
                    s = resolveDesignator("constant");
                  }
                  if(currentDesignatorName.equals("null") || s == null) {
                    exprStack.push(getType("null"));
                  } else {
                    exprStack.push(s.type);
                  }
              }
             | Designator '(' ')' {
                currentDesignatorName = $1;
                Symbol s = resolveDesignator("method");
                if(s == null) {
                  exprStack.push(getType("null"));
                } else {
                  exprStack.push(s.type);
                }
              }
             | Designator '(' { 
                currentDesignatorName = $1;
                Symbol s = resolveDesignator("method");
                if(s == null) {
                  exprStack.push(getType("null"));
                } else {
                  exprStack.push(s.type);
                }
              } ActPars ')'
             | NUMBER { exprStack.push(getType("int")); /* TODO: */ }
             | CHARCONST { exprStack.push(getType("char")); /* TODO: */ }
             | NEW IDENT { 
                Symbol s = getType($2);
                exprStack.push(s);
             }
             | NEW IDENT '[' Expr {
                Symbol s = exprStack.pop();
                if(s != getType("int")) {
                  System.out.println("Arrays of types can only be created with integer sizes " + s.name + " is not an integer type.");
                }
                Symbol type = getType($2);
                exprStack.push(type);
              } ']'
             | '(' Expr ')'
             ;

Designator   : IDENT { designatorStack.begin(); designatorStack.push($1); } ListIdentExpr
             ;
             
ListIdentExpr: '.' IDENT { designatorStack.push($2); } ListIdentExpr
             | '[' Expr { exprStack.pop(); } ']' ListIdentExpr
             |
             ;
     

%%

  private Yylex lexer;
  private static Symbol universe, currentScope, programScope, currentTypeVarDecl, currentSymbol;
  private static StackStack<String> designatorStack;
  private static boolean insideWhileLoop, insideClassDecl;
  private static Stack<Symbol> exprStack;
  private static String currentDesignatorName;

  private Symbol pushScope(Symbol s) {
    Symbol oldCurrentScope = currentScope;
    currentScope = s;
    currentScope.parent = oldCurrentScope;
    return oldCurrentScope;
  }

  private Symbol popScope(Symbol s) {
    currentScope = s.parent;
    return s;
  }

  private Symbol getType(String s) {
    Symbol type = currentScope.getType(s);
    if(type == null) {
      type = programScope.getType(s);
    }
    if(type == null) {
      type = universe.getType(s);
    }
    return type;
  }

  private Symbol getMethod(String s) {
    Symbol method = currentScope.getMethod(s);
    if(method == null) {
      method = programScope.getMethod(s);
    }
    if(method == null) {
      method = universe.getMethod(s);
    }
    return method;
  }

  private Symbol getVariable(String s) {
    Symbol variable = currentScope.getVariable(s);
    if(variable == null) {
      variable = programScope.getVariable(s);
    }
    if(variable == null) {
      variable = universe.getVariable(s);
    }
    return variable;
  }

  private Symbol getConstant(String s) {
    Symbol constant = currentScope.getConstant(s);
    if(constant == null) {
      constant = programScope.getConstant(s);
    }
    if(constant == null) {
      constant = universe.getConstant(s);
    }
    return constant;
  }

  private void checkLogicOperation() {
    Symbol _1 = exprStack.pop();
    Symbol _3 = exprStack.pop();

    if(_1 == getType("null") || _3 == getType("null")) {
      return;
    }

    if(_1 != _3) {
      System.out.println("Incompatible types for " + _1.name + " and " + _3.name + ".");
    }
    exprStack.push(getType("boolean"));

  }

  private void checkNumericOperation() {
    Symbol _1 = exprStack.pop();
    Symbol _3 = exprStack.pop();

    if(_1 != _3) {
      System.out.println("Incompatible types for " + _1.name + " and " + _3.name + ".");
    }
    exprStack.push(getType("int"));
  }

/*
 *  First of all, sorry for the long method. I swear, it was very very hard to think about it.
 *  Feel free to improve it and make it pretty if you want, but this method is really dangerous.
 *  Now, because of that things, I think that an explain about this would be nice, so, here it goes:
 */

/*
 * This method resolves the designator stack, so, it can return any useful designator.
 * -------------------------------
 * Examples:
 * -------------------------------
 * - myVar.myProperty[myIndex.giveMeIndex] : will retrieve "myProperty"
 *
 * -------------------------------
 * Why do I need to do that?
 * -------------------------------
 * Simple, look at the example, if you see it as the gramatic tree, it should be something like:
 *
 *  IDENT   ListIdentExpr
 *                       \
 *                        . IDENT [ EXPR ]
 *                                   |
 *                               Designator
 *                              /          \
 *                           IDENT          ListIdentExpr
 *                                                       \
 *                                                        . IDENT [ EXPR ]
 *                                                                    |
 *                                                                Designator
 *                                                               /    |     \
 *                                                              IDENT   .    IDENT
 * ---
 * This is what I call a designator mess.
 * But it's not so bad, if you look at the structure, it can be easily solved with a stack :)
 * And this is what resolveDesignator does, it manages this resolution algorithm using stacks!
 * Cool right?
 * ---
 */

  private Symbol resolveDesignator(String resolveType) {
    int size = designatorStack.size();
    String el;
    Symbol r = null, scope = null, type = null, variable = null;
    Stack<String> reverseStack = new Stack<String>();

    if(size == 1) {
      el = designatorStack.pop();
      if(resolveType.equals("variable")) {
        r = getVariable(el);
        if(r == null) {
          r = getConstant(el);
        }
      } else if(resolveType.equals("method")) {
        r = getMethod(el);
        if(r == null) {
          System.out.println("Method " + currentDesignatorName + " not found");
        }
      } else if(resolveType.equals("constant")) {
        r = getConstant(el);
      }
    } else {
      while(size > 0) {
        reverseStack.push(designatorStack.pop());
        size -= 1;
      }
      while(!reverseStack.empty()) {
        if(resolveType.equals("variable")) {
          el = reverseStack.pop();
          if(type != null) {
            r = variable = type.getVariable(el);
            if(variable == null) {
              System.out.println(el + " is not a property of " + type.name);
            } else {
              type = variable.type;
            }
          } else {
            variable = getVariable(el);
            if(variable != null) {
              type = variable.type;
            }
          }
        }
      }
    }
    designatorStack.end();

    return r;
  }

  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e.getMessage());
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
    System.err.println ("Line: " + lexer.getLine());
    System.err.println ("Column: " + lexer.getColumn());
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive;

  public static void main(String args[]) throws IOException {

    universe = new Symbol(true);
    currentScope = universe;
    insideWhileLoop = false;
    designatorStack = new StackStack<String>();
    exprStack = new Stack<Symbol>();

    System.out.println("");

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file {
      // interactive mode
      interactive = true;
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      System.out.println("[Quit with CTRL-D]");
      System.out.print("> ");
      interactive = true;
      yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();
    
    if (interactive) {
      System.out.print("\ndone!");
    }
  }