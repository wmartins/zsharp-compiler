# Authors:
#
# Italo Lobato Qualisoni - 12104861-5 - <italo.qualisoni@acad.pucrs.br>
# William Henrihque Martins - 12104965-4 - <william.henrihque@acad.pucrs.br>

# Paths

PATH_DIR = $(shell pwd)
PATH_BIN = $(PATH_DIR)/bin
PATH_SRC = $(PATH_DIR)/src
PATH_DIST = $(PATH_DIR)/dist
PATH_TESTS = $(PATH_DIR)/tests

# Binaries

JAVA = java
JFLEX = $(JAVA) -jar $(PATH_BIN)/JFlex.jar
BYACCJ = $(PATH_BIN)/yacc.linux -tv -J

# Make rules

all: permission clean copy semantic_compile flex syntactic_compile flex_compile

permission:
	cd $(PATH_BIN);\
	chmod +x yacc.linux
copy:
	cp $(PATH_SRC)/semantic/Symbol.java $(PATH_DIST)
	cp $(PATH_SRC)/lexical/zsharp.flex $(PATH_DIST)
	cp $(PATH_SRC)/syntactic/ZSharpASAR.y $(PATH_DIST)

semantic_compile:
	cd $(PATH_DIST);\
	javac Symbol.java

syntactic_compile:
	cd $(PATH_DIST);\
	$(BYACCJ) ZSharpASAR.y;\
	javac Parser.java

flex_compile:
	cd $(PATH_DIST);\
	javac Yylex.java

flex: 
	cd $(PATH_DIST);\
	$(JFLEX) zsharp.flex -d ./

clean:
	rm -rf $(PATH_DIST)
	mkdir dist

test: all
	cd $(PATH_TESTS);\
	./test_all.sh

docs: docs/report.html
	rm -f docs/report.pdf
	wkhtmltopdf docs/report.html docs/report.pdf
