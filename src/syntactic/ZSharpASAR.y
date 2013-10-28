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
  import java.util.Iterator;
  import java.util.Map;
  import java.util.HashMap;
%}

%token EQEQ DIF GT GTE LT LTE IF BREAK CONST ELSE CLASS NEW READ WRITE VOID WHILE RETURN IDENT NUMBER ADDITIVESUM ADDITIVESUB LOGICALAND LOGICALOR CHARCONST

%left ADDITIVESUM ADDITIVESUB LOGICALAND LOGICALOR
%nonassoc EQEQ DIF GT GTE LT LTE

%type <sval> IDENT, Type, Designator, NUMBER

%%

Program    : CLASS IDENT { pushScope(currentScope.addType($2)); } ListDecl '{' ListMethodsDecl '}' { popScope(currentScope); } { showSymbols(universe, 0); }
           ;

ListDecl   : ConstDecl ListDecl
	   | VarDecl ListDecl
	   | ClassDecl ListDecl
	   |;
	
ConstDecl  : CONST Type IDENT '=' NUMBER ';' {
              String type = "int";
              if($5.contains(".")) { // double
                if(!$2.equals("double")) {
                  System.out.println("Tipos incompatíveis: " + $2 + " e double");
                } else {
                  type = "double";
                }
              }
              currentScope.addConst(type, $3);
            }
	   | CONST Type IDENT '=' CHARCONST';' { currentScope.addConst($2, $3); }
	   ;

VarDecl    : Type IDENT { currentScope.addLocal($1, $2); currentType = $1; } ListIDENT ';';

ListIDENT  : ',' IDENT { currentScope.addLocal(currentType, $2); } ListIDENT
	   |
	   ;

ClassDecl  : CLASS IDENT { pushScope(currentScope.addType($2)); } '{' ListVarDecl '}' { popScope(currentScope); }

ListVarDecl: VarDecl ListVarDecl
           | 
           ;
MethodDecl : Type IDENT '(' { pushScope(currentScope.addMethod($1, $2)); } ')' ListVarDecl Block
           | VOID IDENT '(' { pushScope(currentScope.addMethod("void", $2)); } ')' ListVarDecl Block
           | Type IDENT '(' { pushScope(currentScope.addMethod($1, $2)); } FormPars ')' ListVarDecl Block
           | VOID IDENT '(' { pushScope(currentScope.addMethod("void", $2)); } FormPars ')' ListVarDecl Block
           ;
ListMethodsDecl: MethodDecl { popScope(currentScope); } ListMethodsDecl 
           | 
	   ;

FormPars   : Type IDENT { currentScope.addLocal($1, $2); }
           | Type IDENT { currentScope.addLocal($1, $2); } ',' FormPars
           ;


Type       : IDENT 
           | IDENT '[' ']'
           ;

Statment   : Designator { 
              Symbol s = currentScope.findLocal($1);
              if(s == null) {
                s = currentScope.parent.findLocal($1);
              } 
              if(s == null) {
                System.out.println("Variável " + $1 + " não declarada");
              } else if(s.kind == Symbol.Kinds.Const) {
                System.out.println("Você não pode atribuir valores para uma constante :("); 
              } 
            } '=' Expr ';'
	   | Designator '(' ')' ';' 
	   | Designator '(' ActPars ')' ';' 
	   | Designator{ 
              Symbol s = currentScope.findLocal($1);
              if(s == null) {
                s = currentScope.parent.findLocal($1);
              } 
              if(s == null) {
                System.out.println("Variável " + $1 + " não declarada");
              } else if(s.kind == Symbol.Kinds.Const) {
                System.out.println("Você não pode alterar o valor de uma constante :("); 
              } 
            } ADDITIVESUM ';'
	   | Designator{ 
              Symbol s = currentScope.findLocal($1);
              if(s == null) {
                s = currentScope.parent.findLocal($1);
              } 
              if(s == null) {
                System.out.println("Variável " + $1 + " não declarada");
              } else if(s.kind == Symbol.Kinds.Const) {
                System.out.println("Você não pode alterar o valor de uma constante :("); 
              } 
            } ADDITIVESUB ';'
	   | IF '(' Condition ')' Statment 
	   | IF '(' Condition ')' Statment ELSE Statment
	   | WHILE '(' Condition ')' Statment 
           | BREAK ';'
	   | RETURN Expr ';'
	   | RETURN ';'
	   | READ  '(' Designator ')' ';'
	   | WRITE '(' Expr ')' ';'
	   | WRITE '(' Expr ',' NUMBER  ')' ';'
	   | Block
	   | ';' 
	   ;

ListStatment : Statment ListStatment
             |
             ;

Block        : '{' ListStatment '}'
             ;

ActPars      : Expr ListExpr
             ;
             
ListExpr     : ',' Expr ListExpr
             |
             ;
             
Condition    : CondTerm ListCondTerm
             ;
             
ListCondTerm : LOGICALOR CondTerm ListCondTerm
             |
             ;
            
CondTerm     : CondFact ListCondFact                    
             ;
             
ListCondFact : LOGICALAND CondFact
             |
             ;
             
CondFact     : Expr Relop Expr
             ;
           
Expr         :'-' Term ListAddopTerm
             |Term ListAddopTerm
             ;
   
ListAddopTerm:Addop Term ListAddopTerm
             |
             ;

Term         :Factor ListMulopFactor
             ;

ListMulopFactor : Mulop Factor ListMulopFactor
                |
                ;
             
Factor       : Designator
             | Designator '(' ')'
             | Designator '(' ActPars ')'
             | NUMBER
             | CHARCONST
             | NEW IDENT
             | NEW IDENT '[' Expr ']'
             | '(' Expr ')'
             ;

Designator   : IDENT {$$ = $1;} ListIdentExpr
             ;
             
ListIdentExpr: '.' IDENT ListIdentExpr
             | '[' Expr ']' ListIdentExpr
             |
             ;
             
Relop        : GTE
             | EQEQ
             | DIF
             | LTE
             | '>'
             | '<'
             ;           

Addop        : '+'
             | '-'
             ;           

Mulop        : '*'
             | '/'
             | '%'
             ;   

%%

  private Yylex lexer;
  private static Symbol universe;
  private static Symbol currentScope;
  private static String currentType;

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

  public void pushScope(Symbol s) {
    s.parent = currentScope;
    currentScope = s;
  }

  public void popScope(Symbol s) {
    currentScope = s.parent;
  }

  public void showSymbols(Symbol s, int level) {
    for(int i = 0; i < level; i += 1) {
      System.out.print("..");
    }
    System.out.println("[" + s.name + "]");
    Iterator it = s.locals.entrySet().iterator();
    while(it.hasNext()) {
      for(int i = 0; i < level + 1; i += 1) {
        System.out.print("..");
      }
      Map.Entry pairs = (Map.Entry) it.next();
      System.out.println(pairs.getKey() + " - " + ((Symbol)pairs.getValue()).name);
      if(!((Symbol)pairs.getValue()).locals.isEmpty()) {
        showSymbols(((Symbol)pairs.getValue()), level + 1);
      }
    }
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
    System.out.println("");
    universe = new Symbol();
    universe.name = "Universe";
    universe.addBasicTypes();

    currentScope = universe;

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
      System.out.print("done!");
    }
  }

