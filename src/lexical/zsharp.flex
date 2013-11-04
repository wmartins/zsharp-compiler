/**
 * This class is a lexer for the Z# (ZSharp) language.
 * Description about the language avaliable at:
 *   http://dotnet.jku.at/courses/CC/
 *
 * @author Italo Lobato Qualisoni - 12104861-5 - <italo.qualisoni@acad.pucrs.br>
 * @author William Henrihque Martins - 12104965-4 - <william.henrihque@acad.pucrs.br>
 */
%%

%{
	private Parser yyparser;

	public Yylex(java.io.Reader r, Parser yyparser) {
		this(r);
		this.yyparser = yyparser;
	}	
%}
%public
%class Yylex
%integer
%unicode
%line
%column

%{

public static void main(String[] argv) {

	Yylex scanner;
	if(argv.length == 0) {
		try {
			scanner = new Yylex(System.in);
			while(!scanner.zzAtEOF) {
				System.out.println("token: " + scanner.yylex() + "\t<" + scanner.yytext() + ">");
			}
		} catch(Exception e) {
		}
	} else {
		for(int i = 0; i < argv.length; i++) {
			scanner = null;
			try {
				scanner = new Yylex(new java.io.FileReader(argv[i]));
				while(!scanner.zzAtEOF) {
					System.out.println("token: " + scanner.yylex() + "\t<" + scanner.yytext() + ">");
				}
			} catch(java.io.FileNotFoundException e) {
			} catch(java.io.IOException e) {
			} catch (Exception e) {
			}
		}
	}
	
}

public int getLine() {
	return yyline + 1;
}

public int getColumn() {
	return yycolumn + 1;
}

%}
%%
[ \t]
|\r
|\n
|\r\n
| "/*"[^*]~"*/"
|"//"[^\r\n]*
|"/**" ( [^*] | \*+ [^/*] )* "**/" { }

"+"|
","|
"."|
"-"|
"*"|
"/"|
"%"|
"="|
"("|
")"|
"["|
"]"|
"{"|
"}"|
";"|				
">"|					
"<" {return yycharat(0);}

"=="					{ return Parser.EQEQ; }
"!="				        { return Parser.DIF; }
">="					{ return Parser.GTE; }
"<="					{ return Parser.LTE; }
"&&"					{ return Parser.LOGICALAND; }
"||"					{ return Parser.LOGICALOR; }
"++"					{ return Parser.ADDITIVESUM;}
"--"					{ return Parser.ADDITIVESUB;}

"if" 					{ return Parser.IF; }
"break"				{ return Parser.BREAK; }
"const"				{ return Parser.CONST; }
"else"		 		{ return Parser.ELSE; }
"class"				{ return Parser.CLASS;}
"new"				{ return Parser.NEW; }
"read"		 		{ return Parser.READ; }
"write"				{ return Parser.WRITE;}
"void"				{ return Parser.VOID; }
"while"		 		{ return Parser.WHILE; }
"return"			{ return Parser.RETURN;}

'[ -&(-~]+'				{ return Parser.CHARCONST; }
[a-zA-Z][a-zA-Z0-9_]*		{ yyparser.yylval = new ParserVal(yytext()); return Parser.IDENT; }
[0-9]+				{ return Parser.NUMBER; }

. { System.out.println(yyline + 1 + ": invalid character: " + yytext()); }
