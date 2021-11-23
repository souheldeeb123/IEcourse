import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Objects;

%%
%class MyC
%standalone
%column
%line
%byaccj

ErrorNum = \d+\.+|\d+\.\d+\.[\d\.]*|\d+\.\.[\d+\.]*
ErrorIdent = [0-9]+[a-zA-Z][a-zA-Z\_0-9]*
Comments = \/\*[^\*]*\*\/|\/\/[^\n]*\n
DoubleChar = \<\=|\>\=|\=\=|\!\=|\|\||\&\&
SingleChar = [\(\)\{\}\,\;\+\-\*\/\%\<\>\=\!\[\]]
Keyword = if|else|while|for|return|break
ArrayOperator = new|size
DataType = void|bool|int|float
BooleanValue = true|false
FloatNumber = \d+\.\d+
IntegerNumber = \d+
Identifier = [a-zA-Z\_][a-zA-Z\_0-9]*
WhiteSpace = [\t\n ]+
EndOfFile = \z


%{
    private Parser yyparser = new Parser();

    public MyC(java.io.Reader r, Parser yyparser) {
        this(r);
        this.yyparser = yyparser;
    }

    public int getLine() {
    		return yyline;
    }

    public int getColumn() {
        return yycolumn;
    }

    class Symbol {
        private int id;
        private String name;
        private String type;

        public Symbol(int id, String name, String type) {
            this.id = id;
            this.name = name;
            this.type = type;
        }

        public int getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getType() {
            return type;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Symbol symbol = (Symbol) o;
            return Objects.equals(name, symbol.name);
        }

        @Override
        public int hashCode() {
            return Objects.hash(name);
        }
    }

    int tableIndex = 256;
    ArrayList<Symbol> symbolTable = new ArrayList<>();
    BufferedWriter writer;
    BufferedWriter errorLog;
    BufferedWriter symbolWriter;
    {
        try{
           writer = new BufferedWriter(new FileWriter("TokenResult.txt"));
           errorLog = new BufferedWriter(new FileWriter("ErrorLog.txt"));
           symbolWriter = new BufferedWriter(new FileWriter("SymbolTable.txt"));
        } catch(IOException e) {
            e.printStackTrace();
        }
    }
%}

%eof{
    {
        try{
            writer.close();
            errorLog.close();
            symbolWriter.close();
        } catch(IOException e){
            e.printStackTrace();
        }
    }
%eof}


%%
{Comments} {}
{DoubleChar} {
    String word = "Unknown";
    String input = yytext();
    switch (input){
        case "<=":
            word = "LE";
            break;
        case ">=":
            word = "GE";
            break;
        case "==":
            word = "EQ";
            break;
        case "!=":
            word = "NE";
            break;
        case "||":
            word = "OR";
            break;
        case "&&":
            word = "AND";
            break;
    }

    Symbol symbol = new Symbol(tableIndex, word, word);
    try {
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }

        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    }catch (IOException e){
        e.printStackTrace();
    }

    switch(word){
        case "LE":
            return Parser.LE;
        case "GE":
            return Parser.GE;
        case "EQ":
            return Parser.EQ;
        case "NE":
            return Parser.NE;
        case "AND":
            return Parser.AND;
        case "OR":
            return Parser.OR;
    }
}
{SingleChar} {
    Symbol symbol = new Symbol((int) yytext().toCharArray()[0], yytext(), yytext());

    try {
        if (!symbolTable.contains(symbol)){
            symbolTable.add(symbol);
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
        }

        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    return (int) yycharat(0);
}
{Keyword} {
    Symbol symbol = new Symbol(tableIndex, yytext().toUpperCase(), yytext().toUpperCase());

    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    switch(yytext().toUpperCase()){
        case "IF":
            return Parser.IF;
        case "ELSE":
            return Parser.ELSE;
        case "WHILE":
            return Parser.WHILE;
        case "FOR":
            return Parser.FOR;
        case "RETURN":
            return Parser.RETURN;
        case "BREAK":
            return Parser.BREAK;
    }
}
{ArrayOperator} {
    Symbol symbol = new Symbol(tableIndex, yytext().toUpperCase(), yytext().toUpperCase());

    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    switch(yytext().toUpperCase()){
        case "NEW":
            return Parser.NEW;
        case "SIZE":
            return Parser.SIZE;
    }
}
{DataType} {
    Symbol symbol = new Symbol(tableIndex, yytext().toUpperCase(), yytext().toUpperCase());

    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    switch(yytext().toUpperCase()){
        case "VOID":
            return Parser.VOID;
        case "BOOL":
            return Parser.BOOL;
        case "INT":
            return Parser.INT;
        case "FLOAT":
            return Parser.FLOAT;
    }
}
{BooleanValue} {
    Symbol symbol = new Symbol(tableIndex, yytext().toUpperCase(), "BOOL_LIT");
    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    yyparser.yyval = new ParserVal(Boolean.parseBoolean(yytext()));
    return Parser.BOOL_LIT;
}
{FloatNumber} {
    Symbol symbol = new Symbol(tableIndex, yytext(), "FLOAT_LIT");
    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    yyparser.yyval = new ParserVal(Float.parseFloat(yytext()));
    return Parser.FLOAT_LIT;
}
{IntegerNumber} {
    Symbol symbol = new Symbol(tableIndex, yytext(), "INT_LIT");
    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    yyparser.yyval = new ParserVal(Integer.parseInt(yytext()));
    return Parser.INT_LIT;
}
{Identifier} {
    Symbol symbol = new Symbol(tableIndex, yytext(), "IDENT");

    try{
        if (symbolTable.contains(symbol)){
            symbol = symbolTable.get(symbolTable.indexOf(symbol));
        }
        else{
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
            symbolTable.add(symbol);
            tableIndex++;
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    yyparser.yylval = new ParserVal(yytext());
    return Parser.IDENT;
}
{WhiteSpace} {}
{EndOfFile} {
    Symbol symbol = new Symbol(0, yytext(), "EOF");

    try {
        if (!symbolTable.contains(symbol)){
            symbolTable.add(symbol);
            symbolWriter.append(symbol.getName() + " " + symbol.getType() + " " + symbol.getId());
            symbolWriter.newLine();
            symbolWriter.flush();
        }
        writer.append("<" + symbol.getType() + ", " + symbol.getId() + ">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }

    return Parser.EOF;
}
{ErrorNum} {
    try{
        errorLog.append("Lexical error in line " + yyline + " and column " + yycolumn + ". Wrong number format: " + yytext());
        errorLog.newLine();
        errorLog.flush();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
{ErrorIdent} {
    try{
        errorLog.append("Lexical error in line " + yyline + " and column " + yycolumn + ". Identifier starts with a number: " + yytext());
        errorLog.newLine();
        errorLog.flush();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
.	{return (int) yycharat(0);}


