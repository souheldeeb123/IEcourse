souhel deeb 99243006
deebsouhel@gmail.com

------------
written files:
lex.flex

Jflex and Byacc Output:
MyC.java
MyC.class
Parser.java
Parser.class

Analysis input:
input.txt

Analysis result:
TokenResult.txt
SymbolTable.txt


-------------
how to run:

jflex lex.flex
javac Main.java
yacc.exe -J Syn.y
javac Parser.java
java Parser input.txt