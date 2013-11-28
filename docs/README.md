Descrição:
==========

Este trabalho realiza a implementação de um analisador sintático e um analisador léxico para a linguagem Z#. Tal linguagem é um subconjunto reduzido da linguagem C#.

Autores:
========

Italo Lobato Qualisoni - 12104861-5 - <italo.qualisoni@acad.pucrs.br>

Lorenzo Kniss - 12111541-4 - <lorenzo.kniss@acad.pucrs.br>

William Henrihque Martins - 12104965-4 - <william.henrihque@acad.pucrs.br>


Estrutura de arquivos:
======================

Os arquivos e diretórios do projeto encontram-se organizados da seguinte forma:

./bin/				 			- binários relacionados ao projeto

	JFlex.jar		 			- cópia local do programa JFlex

	yacc.linux 		 			- cópia local do programa Byacc/J

./dist/							- diretório que recebe o projeto inteiro compilado usando a compilação pelo Makefile

	./doc/				 			- documentação do projeto

		Relatorio.doc	 			- relatório da implementação da solução
		README                      - descrição de todo o projeto

./samples/			 			- diretório contendo programas exemplo

./src/ 				 			- código fonte do projeto

	lexical/		 			- código fonte relacionado a parte léxica

		zsharp.flex	 			- especificação léxica para o analisador léxico

	syntactic/		 			- código fonte relacionado a parte sintática

		ZSharpASAR.y 			- especificação sintática para o analisador sintático

./tests/			 			- diretório contendo testes da solução

		test_all.sh 			- script para testar todos os arquivos contidos na pasta samples

./Makefile			 			- arquivo makefile para a compilação do projeto

Instruções de uso:
==================

Utilizando o linux:
-------------------

Compilação:
-----------

Para compilar, basta executar o comando ```make```.
Esse comando irá fazer a compilação da solução para o diretório 'dist'.
Então, para utilizar o programa gerado basta entrar no diretório 'dist' usando o comando ```cd dist```.

Utilizando o analisador léxico:
-------------------------------

Basta utilizar o comando ```java Yylex <nome-do-arquivo>``` para que o analisador léxico seja executado. A saída desse programa é no console, portanto, para jogar a saída para um arquivo basta utilizar o comando ```java Yylex <nome-do-arquivo> >> <meu-arquivo-de-saida>```.

Ainda existe uma outra maneira utilizando o modo interativo. Para tal, basta executar o comando ```java Yylex``` que será aberto o terminal interativo. Então, basta digitar a entrada e apertar a tecla <ENTER>, dessa forma, cada token reconhecido será mostrado da seguinte forma:

token: NUMERO_DO_TOKEN	<TOKEN>

Onde "NUMERO_DO_TOKEN" indica o número do token reconhecido e "TOKEN" indica o que foi digitado.

Utilizando o analisador sintático:
----------------------------------

Basta utilizar o comando ```java Parser <nome-do-arquivo>``` para que o analisador sintático seja executado. A saída desse programa é no console, portanto, para jogar a saída para um arquivo basta utilizar o comando ```java Parser <nome-do-arquivo> >> <meu-arquivo-de-saida>```.

Ainda existe uma outra maneira utilizando o modo interativo. Para tal, basta executar o comando ```java Parser``` que será aberto o terminal interativo. Então, basta digitar a entrada e apertar a tecla <ENTER>.
