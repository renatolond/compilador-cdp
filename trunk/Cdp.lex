%{
	void zeraAtribs (atributos &at, string text)
	{
		at.codigo = at.tipo = "";
		at.valor = text;
		at.retorno = at.break_ = at.continue_ = false;
	}
%}
DELIM	[\t\r ]
NUMERO	[0-9]
LETRA	[A-Za-z_]
CNST_INTEIRO	{NUMERO}+
CNST_DOUBLE	{NUMERO}+("."{NUMERO}+)?
CNST_BOOL	("true"|"false")
INTEIRO		"int"
DOUBLE		"double"
BOOL		"bool"
STRING		("string"|"String")
CHAR		"char"
F_MAIN		"bigBang"
F_BREAK		"break"
F_CONTINUE	"continue"
F_RETURN	"return"
F_IF		"if"
F_ELSE		"else"
F_FOR		"for"
F_WHILE		"while"
F_DO		"do"
F_SWITCH	"switch"
F_CASE		"case"
F_DEFAULT	"default"
F_REC		"rec"
F_ECHO		"echo"
F_ECHOLN	"echoln"
F_VOID		"void"
F_DEFINE	"#define"
OP_MAIG		">="
OP_MEIG		"<="
OP_IGIG		"=="
OP_EXIG		"!="
OP_MAIS		"+"
OP_MENOS	"-"
OP_DIV		"/"
OP_MOD		"%"
OP_VEZES	"*"
OP_IG		"="
OP_MENOR	"<"
OP_MAIOR	">"
OP_OU		"||"
OP_E		"&&"
OP_INV		"!"
OP_MAMA		"++"
OP_MEME		"--"
ABRE_BLOCO      "{"
FECHA_BLOCO     "}"
ABRE_PARENTESES	"("
FECH_PARENTESES	")"
ABRE_COLCHETES	"["
FECHA_COLCHETES	"]"
CIFRAO "$"
VIRGULA ","
FIM_CMD		";"
E_COMERCIAL "&"
DOIS_PONTOS ":"
ID		{LETRA}({LETRA}|{NUMERO})*
CNST_STRING	\"([^\n"]|\\\")*\"
CNST_CHAR	\'([^']|\\\'|\\n)\'
NL		\n

%%

{DELIM}		{ }
{NL}		{ lineNo++; }
{CNST_INTEIRO}	{ zeraAtribs(yylval, yytext); yylval.tipo = "I"; return TK_INT; }	
{CNST_DOUBLE}	{ zeraAtribs(yylval, yytext); yylval.tipo = "D"; return TK_DOUBLE; }	
{CNST_BOOL}	{ zeraAtribs(yylval, yytext); yylval.tipo = "B" ; return TK_BOOL; }
{INTEIRO}	{ zeraAtribs(yylval, yytext); yylval.tipo = "I" ; return T_INT; }
{DOUBLE}	{ zeraAtribs(yylval, yytext); yylval.tipo = "D" ; return T_DOUBLE; }
{BOOL}		{ zeraAtribs(yylval, yytext); yylval.tipo = "B" ; return T_BOOL; }
{STRING}	{ zeraAtribs(yylval, yytext); yylval.tipo = "S" ; return T_STRING; }
{CHAR}		{ zeraAtribs(yylval, yytext); yylval.tipo = "C" ; return T_CHAR; }
{F_VOID}	{ zeraAtribs(yylval, yytext); return F_VOID; }
{F_MAIN}	{ zeraAtribs(yylval, yytext); return F_MAIN; }
{F_BREAK}	{ zeraAtribs(yylval, yytext); return F_BREAK; }
{F_CONTINUE}	{ zeraAtribs(yylval, yytext); return F_CONTINUE; }
{F_RETURN}	{ zeraAtribs(yylval, yytext); return F_RETURN; }
{F_IF}		{ zeraAtribs(yylval, yytext); return F_IF; }
{F_ELSE}	{ zeraAtribs(yylval, yytext); return F_ELSE; }
{F_FOR}		{ zeraAtribs(yylval, yytext); return F_FOR; }
{F_WHILE}	{ zeraAtribs(yylval, yytext); return F_WHILE; }
{F_DO}		{ zeraAtribs(yylval, yytext); return F_DO; }
{F_SWITCH}	{ zeraAtribs(yylval, yytext); return F_SWITCH; }
{F_CASE}	{ zeraAtribs(yylval, yytext); return F_CASE; }
{F_DEFAULT}	{ zeraAtribs(yylval, yytext); return F_DEFAULT; }
{F_REC}		{ zeraAtribs(yylval, yytext); return F_REC; }
{F_ECHO}	{ zeraAtribs(yylval, yytext); return F_ECHO; }
{F_ECHOLN}	{ zeraAtribs(yylval, yytext); return F_ECHOLN; }
{F_DEFINE}	{ zeraAtribs(yylval, yytext); return F_DEFINE; }
{OP_MAIG}	{ zeraAtribs(yylval, yytext); return OP_MAIG; }
{OP_MEIG}	{ zeraAtribs(yylval, yytext); return OP_MEIG; }
{OP_IGIG}	{ zeraAtribs(yylval, yytext); return OP_IGIG; }
{OP_EXIG}	{ zeraAtribs(yylval, yytext); return OP_EXIG; }
{OP_MAIS}	{ zeraAtribs(yylval, yytext); return OP_MAIS; }
{OP_MENOS}	{ zeraAtribs(yylval, yytext); return OP_MENOS; }
{OP_VEZES}	{ zeraAtribs(yylval, yytext); return OP_VEZES; }
{OP_DIV}	{ zeraAtribs(yylval, yytext); return OP_DIV; }
{OP_MOD}	{ zeraAtribs(yylval, yytext); return OP_MOD; }
{OP_MENOR}	{ zeraAtribs(yylval, yytext); return OP_MENOR; }
{OP_MAIOR}	{ zeraAtribs(yylval, yytext); return OP_MAIOR; }
{OP_E}		{ zeraAtribs(yylval, yytext); return OP_E; }
{OP_OU}		{ zeraAtribs(yylval, yytext); return OP_OU; }
{OP_IG}		{ zeraAtribs(yylval, yytext); return OP_IG; }
{ID}		{ zeraAtribs(yylval, yytext); return TK_ID; }
{ABRE_BLOCO}	{ zeraAtribs(yylval, yytext); return TK_ABRE_BLOCO; }
{FECHA_BLOCO}	{ zeraAtribs(yylval, yytext); return TK_FECHA_BLOCO; }
{ABRE_PARENTESES}	{ zeraAtribs(yylval, yytext); return TK_ABRE_PAR; }
{FECH_PARENTESES}	{ zeraAtribs(yylval, yytext); return TK_FECHA_PAR; }
{ABRE_COLCHETES}	{ zeraAtribs(yylval, yytext); return TK_ABRE_COLCH; }
{FECHA_COLCHETES}	{ zeraAtribs(yylval, yytext); return TK_FECHA_COLCH; }
{CIFRAO} { zeraAtribs(yylval, yytext); return TK_CIFRAO; }
{VIRGULA} { zeraAtribs(yylval, yytext); return TK_VIRGULA; }
{E_COMERCIAL} { zeraAtribs(yylval, yytext); return TK_E_COM; }
{DOIS_PONTOS} { zeraAtribs(yylval, yytext); return TK_DP; }
{FIM_CMD}	{ zeraAtribs(yylval, yytext); return TK_FIM_CMD; }
{CNST_CHAR}	{ zeraAtribs(yylval, yytext); yylval.tipo = "C"; return TK_CHAR; }
{CNST_STRING}	{ zeraAtribs(yylval, yytext); yylval.tipo = "S"; return TK_STRING; }
.		{ return *yytext; }

%%

