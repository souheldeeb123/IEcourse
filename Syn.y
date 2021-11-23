%{
    import java.io.*;
    import java.util.*;
%}

%token LE
%token GE
%token EQ
%token NE
%token OR
%token AND
%token IF
%token ELSE
%token WHILE
%token FOR
%token RETURN
%token BREAK
%token NEW
%token SIZE
%token VOID
%token BOOL
%token INT
%token FLOAT
%token BOOL_LIT
%token FLOAT_LIT
%token INT_LIT
%token IDENT
%token EOF

%left '='
%left LE GE EQ NE '<' '>'
%left OR AND
%left '-' '+'
%left '*' '/' '%'
%right UNIMUS
%nonassoc NO_ELSE
%nonassoc ELSE

%%

program: decl_list;

decl_list: decl decl_list | decl;

decl: var_decl | func_decl;

var_decl: type_spec IDENT ';' | type_spec IDENT '[' ']' ;

type_spec: VOID | BOOL | INT | FLOAT;

func_decl: type_spec IDENT '(' params ')' comp_stmt;

params: param_list | VOID;

param_list: param_list ',' param | param;

param: type_spec IDENT | stype_spec IDENT '[' ']';

comp_stmt: '{' local_decls stmt_list '}';

local_decls: local_decls local_decl | ;

local_decl: type_spec IDENT ';' | type_spec IDENT '[' ']' ';';

stmt_list: stmt_list stmt | ;

stmt: expr_stmt | comp_stmt | if_stmt | for_stmt | while_stmt
    | return_stmt | break_stmt ;

expr_stmt: expr ';' | ';';

while_stmt: WHILE '(' expr ')' stmt;

if_stmt: IF '(' expr ')' stmt %prec NO_ELSE | IF '(' expr ')' stmt ELSE stmt;

for_stmt: FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt;

opt_expr: expr | ;

return_stmt: RETURN ';' | RETURN expr ';';

expr: IDENT '=' expr | IDENT '[' expr ']' '=' expr
    | expr OR expr
    | expr AND expr
    | expr EQ expr | expr NE expr
    | expr LE expr | expr GE expr | expr '<' expr | expr '>' expr
    | expr '+' expr | expr '-' expr
    | expr '*' expr | expr '/' expr | expr '%' expr
    | '!' expr %prec UNIMUS | '-' expr %prec UNIMUS | '+' expr %prec UNIMUS
    | '(' expr ')'
    | IDENT | IDENT '[' expr ']' | IDENT '(' args ')' | IDENT '.' SIZE
    | BOOL_LIT | INT_LIT | FLOAT_LIT | NEW type_spec '[' expr ']';

args: arg_list | ;

arg_list: arg_list ',' expr | expr;

break_stmt: BREAK ;

%%

private MyC lexer;

/* A simple symbol table */
private HashMap symbol_table = new HashMap();
static BufferedWriter errorLog;

/* interface to the lexer */
private int yylex() {
	int retVal = -1;
	try {
		retVal = lexer.yylex();
                       // System.out.println(retVal);
	} catch (IOException e) {
		System.err.println("IO Error:" + e);
	}
	return retVal;
}

/* error reporting */
public void yyerror (String error) {
    try{
        errorLog.append("Syntax error in line " + lexer.getLine() + " and column " + lexer.getColumn() + ". " + error + ": " + lexer.yytext());
        errorLog.newLine();
        errorLog.flush();
    } catch(IOException e){
        e.printStackTrace();
    }
}

/* constructor taking in File Input */
public Parser (Reader r) {
	lexer = new MyC (r, this);
}

/* this method stores an id on the symbol table with its associated value */
public void assign (String id, int value) {
	symbol_table.put (id, new Integer(value));
}

public void assign (String id, int index, int value) {
    if (symbol_table.containsKey(id)) {
        ArrayList list = (ArrayList)symbol_table.get(id);
        list.add (index, value);
    } else {
        ArrayList list = new ArrayList<>();
        list.add (index, value);
        symbol_table.put (id, list);
    }
}

public int lookup (String id) {
	return ((Integer)symbol_table.get(id)).intValue();
}

public int lookup (String id, int index) {
	return ((Integer)symbol_table.get(id)).intValue();
}

public static void main (String [] args) throws IOException {
	Parser yyparser = new Parser(new FileReader(args[0]));
    try{
        errorLog = new BufferedWriter(new FileWriter("ErrorLog.txt", true));
    } catch(IOException e) {
        e.printStackTrace();
    }

	yyparser.yyparse();

	try{
	errorLog.close();
    } catch(IOException e){
        e.printStackTrace();
    }
}

