%{
#include <string>
#include <iostream>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <vector>

using namespace std;

#define YYSTYPE atributos

typedef struct _atributos
{
	string valor, codigo, tipo, temp;
	bool retorno, break_, continue_;
	vector<string> retTipo;
} atributos;

#define N_OPERACAO 102
#define MAX_VAR 512
int lineNo = 1;

struct vartemp{
	int i, d, s, c, b;
} nvartemp;

struct TSItem {
	string nome, tipo;
	bool param;
	int nVet;
} TS[MAX_VAR];

string sourc, dest;

#define MAX_FUNC 512
#define MAX_MV 666

struct TSFunc {
	string nome, retorno, tipoParams;
	int n_param;
	bool cabecalho;
} TSF[MAX_FUNC];

struct TMatVet {
	string nome;
	int nDimens;
	int nFunc;
	vector<int> tam;
	vector<int> desloc;
	string tipo;
} TMV[MAX_MV];

int n_vet = 0;
int n_func = 0;
int n_var = 0;
int ts_marca = 0;
int nlabel = 1;
int ncondlabel = 1;

struct operacao
{
	string op1, op2, opr, res;
} tab_operacao[N_OPERACAO] = {
	{"I","I","+","I"}, {"I","D","+","D"}, {"D","I","+","D"}, {"D","D","+","D"},
	{"S","S","+","S"}, {"S","C","+","S"}, {"C","S","+","S"}, {"C","C","+","S"},
	{"I","I","-","I"}, {"I","D","-","D"}, {"D","I","-","D"}, {"D","D","-","D"},
	{"I","I","*","I"}, {"I","D","*","D"}, {"D","I","*","D"}, {"D","D","*","D"},
	{"I","I","/","I"}, {"I","D","/","D"}, {"D","I","/","D"}, {"D","D","/","D"},
	{"I","I","%","I"},
	{"I","I","=","I"}, {"I","C","=","I"}, {"I","D","=","I"}, {"D","I","=","D"},
	{"D","D","=","D"}, {"S","S","=","S"}, {"S","C","=","S"}, {"C","C","=","C"},
	{"C","I","=","C"}, {"B","B","=","B"},
	
	{"I","I",">","B"}, {"I","D",">","B"}, {"D","I",">","B"}, {"D","D",">","B"},
	{"S","S",">","B"}, {"S","C",">","B"}, {"C","S",">","B"}, {"C","C",">","B"},
	{"B","B",">","B"},
	{"I","I","<","B"}, {"I","D","<","B"}, {"D","I","<","B"}, {"D","D","<","B"},
	{"S","S","<","B"}, {"S","C","<","B"}, {"C","S","<","B"}, {"C","C","<","B"},
	{"B","B","<","B"},
	{"I","I",">=","B"}, {"I","D",">=","B"}, {"D","I",">=","B"}, {"D","D",">=","B"},
	{"S","S",">=","B"}, {"S","C",">=","B"}, {"C","S",">=","B"}, {"C","C",">=","B"},
	{"B","B",">=","B"},
	{"I","I","<=","B"}, {"I","D","<=","B"}, {"D","I","<=","B"}, {"D","D","<=","B"},
	{"S","S","<=","B"}, {"S","C","<=","B"}, {"C","S","<=","B"}, {"C","C","<=","B"},
	{"B","B","<=","B"},
	{"I","I","==","B"}, {"I","D","==","B"}, {"D","I","==","B"}, {"D","D","==","B"},
	{"S","S","==","B"}, {"S","C","==","B"}, {"C","S","==","B"}, {"C","C","==","B"},
	{"B","B","==","B"},
	{"I","I","!=","B"}, {"I","D","!=","B"}, {"D","I","!=","B"}, {"D","D","!=","B"},
	{"S","S","!=","B"}, {"S","C","!=","B"}, {"C","S","!=","B"}, {"C","C","!=","B"},
	{"B","B","!=","B"},
	
	{"I","I","||","B"}, {"I","B","||","B"}, {"B","I","||","B"}, {"B","B","||","B"},
	{"I","I","&&","B"}, {"I","B","&&","B"}, {"B","I","&&","B"}, {"B","B","&&","B"},
};

int yylex();
void yyerror( const char* st );
string rev_str ( string s );
string intToStr ( int numero );
int strToInt ( string str );
string geraTemp(string tipo);
void insereFunc(atributos s1, atributos s2, atributos s3, bool cabecalho);
void insereVetorGlobal ( string nome, string &tipo, int tam , int desloc);
void insereMatrizLocal ( string nome, string &tipo, int tam, int desloc, int tam2, int desloc2, bool param, bool isRef);
void insereVetorLocal ( string nome, string &tipo, int tam , int desloc, bool param, bool isRef);
int insereVarLocal ( string nome , string tipo , bool param, bool isRef);
int insereVarGlobal ( string nome, string tipo );
void geraCodigoOperador ( atributos &ss, atributos s1, atributos s2, atributos s3 );
void geraCodigoOperadorComp ( atributos &ss, atributos s1, atributos s2, atributos s3 );
string geraLabel (string comentario);
void incLabel ();
void erro ( string st );
int buscaIndiceVar ( string nome );
void atributosVar ( atributos &ss , atributos s1 );
void atributosVetor ( atributos &ss, atributos s1, atributos s2 );
void atributosMatriz ( atributos &ss, atributos s1, atributos s2, atributos s3 );
bool buscaFunc(string &retorno, string nome, string params, int nParams, bool &cabecalho, int &aux_nfunc);
string declaraVarTemp ();
bool verificaTipo ( string op1, string op2, string opr, string &res );
string declaraVarsLocais ( );
string declaraVarsGlobais ( );
void incCondLabel();
string geraCondLabel(string lab);
string realTipo ( string tipo );
void insereMatrizGlobal ( string nome, string &tipo, int tam, int desloc, int tam2, int desloc2);

%}

%token TK_ID TK_INT TK_DOUBLE TK_STRING TK_BOOL TK_CHAR 
%token T_INT T_DOUBLE T_STRING T_BOOL T_CHAR
%token F_MAIN F_BREAK F_CONTINUE F_RETURN F_IF F_ELSE F_FOR F_WHILE F_DO F_SWITCH F_CASE F_DEFAULT F_REC F_ECHO F_ECHOLN F_VOID F_DEFINE
%token OP_MAIG OP_MEIG OP_IGIG OP_EXIG OP_MAIS
%token TK_ABRE_BLOCO TK_FECHA_BLOCO TK_FIM_CMD TK_ABRE_PAR TK_FECHA_PAR TK_ABRE_COLCH TK_FECHA_COLCH TK_CIFRAO TK_VIRGULA TK_E_COM TK_DP
%right OP_IG
%nonassoc OP_OU OP_E
%nonassoc OP_IGIG OP_EXIG OP_MAIOR OP_MENOR OP_MAIG OP_MEIG
%left OP_MENOS OP_MAIS
%left OP_VEZES OP_DIV OP_MOD


%%

A : S { $$.codigo = "#include <cstdio>\n#include <cstring>\n#include <cstdlib>\n#include <iostream>\nusing namespace std;\n\n" + declaraVarsGlobais() + $$.codigo;
	fstream f;
	f.open(dest.c_str(), ios::out );
	f << $$.codigo << endl; 
	f.close(); }
  ;

S : D S { $$.valor = "";
	  $$.codigo = $1.codigo + $2.codigo; $$.retorno = $$.break_ = $$.continue_ = false; }
  | MAIN_ 
  ;

MAIN_ : T_INT F_MAIN TK_ABRE_PAR F_VOID TK_FECHA_PAR CORPO {	$$.valor = "";
						$$.codigo = "int main (void)\n{\n" +
							declaraVarTemp() + "\n" + $6.codigo +
							"\n" +
							"return 0; }\n";
					if ( !$6.retorno ) 
					   	cout << "Função " + $2.valor + " deveria retornar algo." << endl;
					for ( unsigned int i = 0 ; i < $6.retTipo.size() ; i++ )
						if ( $6.retTipo.at(i) != "I" )
						{
							if ( $6.retTipo.at(i) == "" )
								erro("Retorno vazio em função de retorno " + $1.valor);
							cout << "Um ou mais retornos da função " + $2.valor + " são diferentes do esperado." << endl << "Esperado: " << $1.valor << " Retornado: " << realTipo($6.retTipo.at(i)) << endl;
							break;
						}
					
					if ( $6.break_ )
						erro("break não esperado na função " + $2.valor);
					if ( $6.continue_ )
						erro("continue não esperado na função " + $2.valor);
					}
      ;

D : CABECALHO_F 
  | FUNCAO 
  | VARIAVEL_GLOBAL TK_FIM_CMD 
  | CONSTANTE 
  ;

CONSTANTE : F_DEFINE TK_ID NUM { $$.codigo = "#define " + $2.valor + " " + $3.valor + "\n" ; $$.valor = ""; }
          ;

NUM : TK_INT { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n";  }
    | TK_DOUBLE { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n";  }
    ;

VARIAVEL_GLOBAL : TIPO OP_MOD TK_ID V { 	int temp1, temp2, temp3; 
					stringstream($4.temp) >> temp1 >> temp2 >> temp3;
					/* 	temp1 é quantas dimensões
						temp2 é o início da primeira dimensão
						temp3 é o início da segunda dimensão
						$4.temp é onde os temps estão armazenados
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp1)
					{
						case 0:
							insereVarGlobal ( $3.valor , $1.tipo );
							$$.tipo = $1.tipo;
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorGlobal ( $3.valor, $1.tipo, strToInt($4.valor), temp2);
							$$.tipo = $1.tipo;
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizGlobal ( $3.valor, $1.tipo, strToInt($4.valor), temp2, strToInt($4.codigo), temp3);
							$$.tipo = $1.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
				     $$.codigo = "";
				     $$.valor = "";
				   }
		| VARIAVEL_GLOBAL TK_VIRGULA OP_MOD TK_ID V { int temp1, temp2, temp3; 
					stringstream($5.temp) >> temp1 >> temp2 >> temp3;
					/* 	temp1 é quantas dimensões
						temp2 é o início da primeira dimensão
						temp3 é o início da segunda dimensão
						$5.temp é onde os temps estão armazenados
						$5.valor é o tamamnho da primeira dimensão
						$5.codigo é o tamanho da segunda dimensão */
					switch(temp1)
					{
						case 0:
							insereVarGlobal ( $4.valor , $1.tipo );
							$$.tipo = $1.tipo;
							break;
						case 1:
							if ( strToInt($5.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $4.valor);
							insereVetorGlobal ( $4.valor, $1.tipo, strToInt($5.valor), temp2);
							$$.tipo = $1.tipo;
							break;
						case 2:
							if ( strToInt($5.valor) <= 0 || strToInt($5.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $4.valor);
							insereMatrizGlobal ( $4.valor, $1.tipo, strToInt($5.valor), temp2, strToInt($5.codigo), temp3);
							$$.tipo = $1.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
				     $$.codigo = "";
				     $$.valor = ""; }
		;

TIPO : T_CHAR { $$.valor = ""; $$.codigo = "char"; }
     | T_BOOL { $$.valor = ""; $$.codigo = "bool"; }
     | T_INT { $$.valor = ""; $$.codigo = "int"; }
     | T_STRING { $$.valor = ""; $$.codigo = "char *"; }
     | T_DOUBLE { $$.valor = ""; $$.codigo = "double"; }
     ;

V : TK_ABRE_COLCH TK_INT TK_FECHA_COLCH { $$.temp = "1 0 0"; $$.valor = $2.valor; }
  | TK_ABRE_COLCH TK_INT OP_MENOS TK_INT TK_FECHA_COLCH { 	$$.temp = "1 " + $2.valor + " 0"; 
					$$.valor = intToStr(strToInt($4.valor) - strToInt($2.valor) + 1); } 
  | TK_ABRE_COLCH TK_INT OP_MENOS TK_INT TK_FECHA_COLCH TK_ABRE_COLCH TK_INT TK_FECHA_COLCH {	$$.temp = "2 " + $2.valor + " 0"; 
							$$.valor = intToStr(strToInt($4.valor) - strToInt($2.valor) + 1);
							$$.codigo = $7.valor; }
  | TK_ABRE_COLCH TK_INT TK_FECHA_COLCH TK_ABRE_COLCH TK_INT TK_FECHA_COLCH { 	$$.temp = "2 0 0";
					$$.valor = $2.valor;
					$$.codigo = $5.valor; }
  | TK_ABRE_COLCH TK_INT TK_FECHA_COLCH TK_ABRE_COLCH TK_INT OP_MENOS TK_INT TK_FECHA_COLCH {	$$.temp = "2 0 " + $5.valor;
							$$.valor = $2.valor;
							$$.codigo = intToStr(strToInt($7.valor) - strToInt($5.valor) + 1);}
  | TK_ABRE_COLCH TK_INT OP_MENOS TK_INT TK_FECHA_COLCH TK_ABRE_COLCH TK_INT OP_MENOS TK_INT TK_FECHA_COLCH {	$$.temp = "2 " + $2.valor + " " + $7.valor;
									$$.valor = intToStr(strToInt($4.valor) - strToInt($2.valor) + 1);
									$$.codigo = intToStr(strToInt($9.valor) - strToInt($7.valor) + 1);}
  | { $$.temp = "0 0 0"; } 
  ;

CABECALHO_F : TIPO TK_ID TK_ABRE_PAR LPARAM TK_FECHA_PAR TK_FIM_CMD { $$.valor = "";
					  $$.codigo = $1.codigo + " " + $2.valor + "(" + $4.codigo + ");\n";
					  insereFunc($1, $2, $4, true); 
					  declaraVarsLocais(); }
	    | TK_ID TK_ABRE_PAR LPARAM TK_FECHA_PAR TK_FIM_CMD { $$.valor = "";
				     $$.codigo = "void " + $1.valor + "(" + $3.codigo + ");\n";
				     atributos temp;
				     temp.tipo = temp.valor = temp.codigo = "";
				     insereFunc(temp, $1, $3, true); 
				     declaraVarsLocais(); }
	    ;

FUNCAO : TIPO TK_ID TK_ABRE_PAR LPARAM TK_FECHA_PAR CORPO { $$.valor = "";
					   $$.codigo = $1.codigo + " " + $2.valor + "(" + $4.codigo + ")\n{\n" +
					   declaraVarTemp() + "\n" + $6.codigo + "}\n\n";
					if ( !$6.retorno ) 
					   	cout << "Função " + $2.valor + " deveria retornar algo." << endl;
					for ( unsigned int i = 0 ; i < $6.retTipo.size() ; i++ )
						if ( $6.retTipo.at(i) != "I" )
						{
							cout << "Um ou mais retornos da função " + $2.valor + " são diferentes do esperado." << endl << "Esperado: " << $1.valor << " Retornado: " << realTipo($6.retTipo.at(i)) << endl;
							break;
						}
					 
					   insereFunc($1, $2, $4, false);
					   }
       | TK_ID TK_ABRE_PAR LPARAM TK_FECHA_PAR CORPO { $$.valor = "";
				      $$.codigo = "void " + $1.valor + "(" + $3.codigo + ")\n{\n" +
				      declaraVarTemp() + "\n" + $5.codigo + "}\n\n";
				      if ( $5.retorno )
						for ( unsigned int i = 0 ; i < $5.retTipo.size() ; i++ )
							if ( $5.retTipo.at(i) != "" )
							{
								cout << "Atenção: Função retornando um valor, quando não deveria." << endl;
							}
				      atributos temp;
				      temp.tipo = temp.valor = temp.codigo = "";
				      insereFunc(temp,$1,$3,false); }
       ;

LPARAM : TIPO OP_MOD TK_ID VF TK_VIRGULA LPARAM {	int temp; 
					stringstream($4.temp) >> temp;
					/* 	temp é quantas dimensões
						$4.temp é onde temp está armazenado
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp)
					{
						case 0:
							$$.codigo = $1.codigo + " " + $3.valor + "," + $6.codigo;
							$$.tipo = $1.tipo + "," + $6.tipo;
							insereVarLocal ($3.valor , $1.tipo, true, false);
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, true, false);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + $4.valor + "]" + "," + $6.codigo;
							$$.tipo = $1.tipo + "[]," + $6.tipo;
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, strToInt($4.codigo), 0, true, false);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + intToStr(strToInt($4.valor) * strToInt($4.codigo)) + "]" + "," + $6.codigo;
							$$.tipo = $1.tipo + "[][]," + $6.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
					$$.valor = intToStr(strToInt($6.valor) + 1); 
}
       | TIPO OP_MOD TK_ID VF { 		int temp; 
					stringstream($4.temp) >> temp;
					/* 	temp é quantas dimensões
						$4.temp é onde temp está armazenado
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp)
					{
						case 0:
							$$.codigo = $1.codigo + " " + $3.valor;
							$$.tipo = $1.tipo;
							insereVarLocal ($3.valor , $1.tipo, true, false);
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, true, false);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + $4.valor + "]";
							$$.tipo = $1.tipo + "[]";
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, strToInt($4.codigo), 0, true, false);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + intToStr(strToInt($4.valor) * strToInt($4.codigo)) + "]";
							$$.tipo = $1.tipo + "[][]";
							break;
						default:
							erro("Dimensão máxima é 2");
					}
					$$.valor = "1"; 
}
       | TIPO TK_E_COM OP_MOD TK_ID VF TK_VIRGULA LPARAM {	int temp; 
					stringstream($4.temp) >> temp;
					/* 	temp é quantas dimensões
						$4.temp é onde temp está armazenado
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp)
					{
						case 0:
							$$.codigo = $1.codigo + " &" + $3.valor + "," + $6.codigo;
							$$.tipo = $1.tipo + "," + $6.tipo;
							insereVarLocal ($3.valor , $1.tipo, true, true);
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, true, true);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + $4.valor + "]" + "," + $6.codigo;
							$$.tipo = $1.tipo + "[]," + $6.tipo;
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, strToInt($4.codigo), 0, true, true);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + intToStr(strToInt($4.valor) * strToInt($4.codigo)) + "]" + "," + $6.codigo;
							$$.tipo = $1.tipo + "[][]," + $6.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
					$$.valor = intToStr(strToInt($6.valor) + 1); 
}
       | TIPO TK_E_COM OP_MOD TK_ID VF { 		int temp; 
					stringstream($4.temp) >> temp;
					/* 	temp é quantas dimensões
						$4.temp é onde temp está armazenado
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp)
					{
						case 0:
							$$.codigo = $1.codigo + " " + $3.valor;
							$$.tipo = $1.tipo;
							insereVarLocal ($3.valor , $1.tipo, true, true);
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, true, true);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + $4.valor + "]";
							$$.tipo = $1.tipo + "[]";
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizLocal ( $3.valor, $1.tipo, strToInt($4.valor), 0, strToInt($4.codigo), 0, true, true);
							$$.codigo = $1.codigo + " " + $3.valor + "[" + intToStr(strToInt($4.valor) * strToInt($4.codigo)) + "]";
							$$.tipo = $1.tipo + "[][]";
							break;
						default:
							erro("Dimensão máxima é 2");
					}
					$$.valor = "1"; 
}
 
       ;

VF : TK_ABRE_COLCH TK_INT TK_FECHA_COLCH { $$.temp = "1"; $$.valor = $2.valor; }
  | TK_ABRE_COLCH TK_INT TK_FECHA_COLCH TK_ABRE_COLCH TK_INT TK_FECHA_COLCH { 	$$.temp = "2";
					$$.valor = $2.valor;
					$$.codigo = $5.valor; }
  | { $$.temp = "0"; } 
  ;

CORPO : TK_ABRE_BLOCO VARIAVEIS_LOCAIS CMDS TK_FECHA_BLOCO { $$ = $3; $$.valor = "";
     		    $$.codigo = declaraVarsLocais() + $3.codigo; $$.retorno = $3.retorno; $$.retTipo = $3.retTipo;
				      }
      | TK_ABRE_BLOCO VARIAVEIS_LOCAIS TK_FECHA_BLOCO { $$.valor = ""; $$.codigo = declaraVarsLocais(); }
      | TK_ABRE_BLOCO CMDS TK_FECHA_BLOCO { $$ = $2; }
      | TK_ABRE_BLOCO TK_FECHA_BLOCO
      ;
      
      
VARIAVEIS_LOCAIS : VARIAVEL_LOCAL TK_FIM_CMD 
	  | VARIAVEL_LOCAL TK_FIM_CMD VARIAVEIS_LOCAIS 
          ;

VARIAVEL_LOCAL : TIPO OP_MOD TK_ID V {  	
					int temp1, temp2, temp3; 
					stringstream($4.temp) >> temp1 >> temp2 >> temp3;
					/* 	temp1 é quantas dimensões
						temp2 é o início da primeira dimensão
						temp3 é o início da segunda dimensão
						$4.temp é onde os temps estão armazenados
						$4.valor é o tamamnho da primeira dimensão
						$4.codigo é o tamanho da segunda dimensão */
					switch(temp1)
					{
						case 0:
							insereVarLocal ( $3.valor , $1.tipo, false, false); /* false porque não é parâmetro */
							$$.tipo = $1.tipo;
							break;
						case 1:
							if ( strToInt($4.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $3.valor);
							insereVetorLocal ( $3.valor, $1.tipo, strToInt($4.valor), temp2, false, false);
							$$.tipo = $1.tipo;
							break;
						case 2:
							if ( strToInt($4.valor) <= 0 || strToInt($4.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $3.valor);
							insereMatrizLocal ( $3.valor, $1.tipo, strToInt($4.valor), temp2, strToInt($4.codigo), temp3, false, false);
							$$.tipo = $1.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
				     $$.codigo = "";
				     $$.valor = "";
				}
		| VARIAVEL_LOCAL TK_VIRGULA OP_MOD TK_ID V { 
					int temp1, temp2, temp3; 
					stringstream($5.temp) >> temp1 >> temp2 >> temp3;
					/* 	temp1 é quantas dimensões
						temp2 é o início da primeira dimensão
						temp3 é o início da segunda dimensão
						$5.temp é onde os temps estão armazenados
						$5.valor é o tamamnho da primeira dimensão
						$5.codigo é o tamanho da segunda dimensão */
					switch(temp1)
					{
						case 0:
							insereVarLocal ( $4.valor , $1.tipo, false, false); /* false porque não é parâmetro */
							$$.tipo = $1.tipo;
							break;
						case 1:
							if ( strToInt($5.valor) <= 0 )
								erro("Tamanho inválido para o vetor " + $4.valor);
							insereVetorLocal ( $4.valor, $1.tipo, strToInt($5.valor), temp2, false, false);
							$$.tipo = $1.tipo;
							break;
						case 2:
							if ( strToInt($5.valor) <= 0 || strToInt($5.codigo) <= 0 )
								erro("Tamanho inválido para a matriz " + $4.valor);
							insereMatrizLocal ( $4.valor, $1.tipo, strToInt($5.valor), temp2, strToInt($5.codigo), temp3, false, false);
							$$.tipo = $1.tipo;
							break;
						default:
							erro("Dimensão máxima é 2");
					}
				     $$.codigo = "";
				     $$.valor = "";

				}
		;

BLOCO : TK_ABRE_BLOCO CMDS TK_FECHA_BLOCO { $$ = $2;  }
      | TK_ABRE_BLOCO TK_FECHA_BLOCO { $$.valor = $$.tipo = $$.codigo = ""; $$.retTipo = vector<string>(); $$.retorno = $$.continue_ = $$.break_ = false;  }
      ;

CMDS : CMD CMDS   { $$.valor = ""; $$.tipo = "";
     		    $$.codigo = $1.codigo + $2.codigo; $$.retorno = $1.retorno|$2.retorno; 
		    $$.break_ = $1.break_|$2.break_; $$.continue_ = $1.continue_|$2.continue_; 
		    $$.retTipo = $1.retTipo; $$.retTipo.insert($$.retTipo.end(), $2.retTipo.begin(), $2.retTipo.end());}
     | CMD { $$ = $1; }
     | BLOCO CMDS { $$.valor = ""; $$.tipo = "";
     		    $$.codigo = $1.codigo + $2.codigo; $$.retorno = $1.retorno|$2.retorno; 
		    $$.break_ = $1.break_|$2.break_; $$.continue_ = $1.continue_|$2.continue_;
		    $$.retTipo = $1.retTipo; $$.retTipo.insert($$.retTipo.end(), $2.retTipo.begin(), $2.retTipo.end());}
     | BLOCO { $$ = $1; }
     ;

CMD : CMD_IF 
    | CMD_FOR 
    | CMD_WHILE 
    | CMD_DWHILE 
    | CMD_SWITCH 
    | F_BREAK TK_FIM_CMD { $$ = $1; $$.codigo = "goto " + geraLabel("fim_") + "; /* break */\n\n" ; $$.break_ = true; }
    | F_CONTINUE TK_FIM_CMD { $$ = $1; $$.codigo = "goto " + geraLabel("cont_") + "; /* continue */\n\n" ; $$.continue_ = true; }
    | F_RETURN TK_FIM_CMD { $$ = $1; $$.codigo = "return;\n\n" ; $$.retorno = true; $$.retTipo.push_back(""); }
    | F_RETURN E TK_FIM_CMD { $$.codigo = $2.codigo + "return " + $2.valor + ";\n\n"; $$.retorno = true; $$.retTipo.push_back($2.tipo); }
    | ATRIBUICAO TK_FIM_CMD { $$ = $1; }
    | CHAMA_FUNC 
    | CMD_ECHO 
    | CMD_REC 
    ;


B_OU_C : TK_FIM_CMD
       | CMD { $$ = $1; }
       | BLOCO
       ;

CMD_IF : F_IF TK_ABRE_PAR E TK_FECHA_PAR B_OU_C	{	$$.break_ = $5.break_;
					$$.continue_ = $5.continue_;
					$$.retorno = $5.retorno;
					$$.retTipo = $5.retTipo;
					$$.valor = "";
					string fim = geraCondLabel("fim_If_");
					$$.codigo = $3.codigo + $3.valor + " = !" + $3.valor + ";\n" +
					"/* Inicio If " + geraCondLabel("") + " */\n" +
					"if (" + $3.valor + " ) goto " + fim + ";\n\n" +
					$5.codigo + fim + ": /* Fim If " + geraCondLabel("") + " */\n\n";
					incCondLabel();
				}
       | F_IF TK_ABRE_PAR E TK_FECHA_PAR B_OU_C F_ELSE B_OU_C {	$$.break_ = $5.break_|$7.break_;
						$$.continue_ = $5.continue_|$7.break_;
						$$.retorno = $5.retorno|$7.retorno;
						$$.retTipo = $5.retTipo; $$.retTipo.insert($$.retTipo.end(), $7.retTipo.begin(), $7.retTipo.end());
						$$.valor = "";
						string L1 = geraCondLabel("then_"), fim = geraCondLabel("fim_If_");
						$$.codigo = $3.codigo + $3.valor + " = !" + $3.valor + ";\n" +
						"/* Inicio if " + geraCondLabel("") + " */\n"+
						"if ( " + $3.valor + " ) goto " + L1 + ";\n\n" +
						$5.codigo + "goto " + fim + ";\n" +
						L1 + ":\n\n" + $7.codigo + fim + ": /* Fim If " + geraCondLabel("") + " */\n\n";
						incCondLabel(); }
       ;


CMD_FOR : F_FOR TK_ABRE_PAR E TK_FIM_CMD E TK_FIM_CMD E TK_FECHA_PAR B_OU_C { $$ = $9; $$.break_ = $$.continue_ = false;
						$$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $3.codigo + $5.codigo + $5.valor + " = !" + $5.valor + ";\n" +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( " + $5.valor + " ) goto " + fim + ";\n\n" +
						$9.codigo + cpoint + ":\n" + $7.codigo + $5.codigo + $5.valor + " = !" + $5.valor + ";\n" + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR E TK_FIM_CMD TK_FIM_CMD TK_FECHA_PAR B_OU_C { $$=$7; $$.break_ = $$.continue_ = false;$$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $3.codigo +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( ) goto " + fim + ";\n\n" +
						$7.codigo + cpoint + ":\n" +
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR E TK_FIM_CMD E TK_FIM_CMD TK_FECHA_PAR B_OU_C { $$=$8;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $3.codigo + $5.codigo + $5.valor + " = !" + $5.valor + ";\n" +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( " + $5.valor + " ) goto " + fim + ";\n\n" +
						$8.codigo + cpoint + ":\n" + $5.codigo + $5.valor + " = !" + $5.valor + ";\n" + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR E TK_FIM_CMD TK_FIM_CMD E TK_FECHA_PAR B_OU_C { $$=$8;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $3.codigo +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( ) goto " + fim + ";\n\n" +
						$8.codigo + cpoint + ":\n" + $6.codigo + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR TK_FIM_CMD E TK_FIM_CMD  TK_FECHA_PAR B_OU_C 	{ $$=$7;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $4.codigo + $4.valor + " = !" + $4.valor + ";\n" +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( " + $4.valor + " ) goto " + fim + ";\n\n" +
						$7.codigo + cpoint + ":\n" + $4.codigo + $4.valor + " = !" + $4.valor + ";\n" + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR TK_FIM_CMD E TK_FIM_CMD E TK_FECHA_PAR B_OU_C { $$=$8;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = $4.codigo + $4.valor + " = !" + $4.valor + ";\n" +
						L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( " + $4.valor + " ) goto " + fim + ";\n\n" +
						$8.codigo + cpoint + ":\n" + $6.codigo + $4.codigo + $4.valor + " = !" + $4.valor + ";\n" + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR TK_FIM_CMD TK_FIM_CMD E TK_FECHA_PAR B_OU_C { $$=$7;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( 0 ) goto " + fim + ";\n\n" +
						$7.codigo + cpoint + ":\n" + $5.codigo + 
						"goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
	| F_FOR TK_ABRE_PAR TK_FIM_CMD TK_FIM_CMD TK_FECHA_PAR B_OU_C { $$=$6;$$.break_ = $$.continue_ = false; $$.valor = "";
						string L1 = geraLabel("inicio_"), fim=geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = L1 + ": /* Inicio do for " + geraLabel("") + " */\nif ( 0 ) goto " + fim + ";\n\n" +
						$6.codigo + cpoint + ":\n" + "goto " + L1 + ";\n" +
						fim + ": /* Fim do for " + geraLabel("") + " */\n\n"; 
						incLabel(); }
        ;
CMD_WHILE : F_WHILE TK_ABRE_PAR E TK_FECHA_PAR B_OU_C { $$=$5;$$.break_ = $$.continue_ = false; $$.valor = "";
					string L1 = geraLabel("inicio_"), fim = geraLabel("fim_"), cpoint = geraLabel("cont_");
					$$.codigo = $3.codigo + $3.valor + " = !" + $3.valor + ";\n" + 
					L1 + ": /* Inicio do while " + geraLabel("") + " */\nif ( " + $3.valor + " ) goto " + fim + ";\n\n" +
					$5.codigo + cpoint + ":\n" + $3.codigo + $3.valor + " = !" + $3.valor + ";\n" + 
					"goto " + L1 + ";\n" +
					fim + ": /* Fim do while " + geraLabel("") + " */\n\n";
					incLabel(); }
          ;
CMD_DWHILE : F_DO B_OU_C F_WHILE TK_ABRE_PAR E TK_FECHA_PAR TK_FIM_CMD { $$=$2;$$.break_ = $$.continue_ = false; $$.valor = "";
	   					string L1 = geraLabel("inicio_"), fim = geraLabel("fim_"), cpoint = geraLabel("cont_");
						$$.codigo = L1 + ": /* Inicio do do-while " + geraLabel("") + " */\n\n" + $2.codigo + 
						cpoint + ":\n" + $5.codigo + "if ( " + $5.valor + " ) goto " + L1 + ";\n" +
						fim + ": /* Fim do do-while " + geraLabel("") + " */\n\n"; 
						incLabel(); }
           ;
CMD_SWITCH : F_SWITCH TK_ABRE_PAR E TK_FECHA_PAR TK_ABRE_BLOCO LCASE TK_FECHA_BLOCO { $$=$6;$$.break_ = false;
	   					string fim = geraLabel("fim_");
	   					$$.valor = ""; $$.codigo = $3.codigo + "switch ( " + $3.valor + " )\n{\n" +
						$6.valor + $6.codigo + "}\n" + fim + ":\n"; 
						incLabel();  }
           ;
LCASE : F_CASE CONST TK_DP CMDS LCASE { 	$$=$4;
					$$.retorno = $4.retorno|$5.retorno;
					$$.break_ = $4.break_|$5.break_;
					$$.continue_ = $4.continue_|$5.continue_;
					$$.retTipo = $4.retTipo; $$.retTipo.insert($$.retTipo.end(), $5.retTipo.begin(), $5.retTipo.end());
					$$.valor = $2.codigo + $5.valor ; 
					$$.codigo = "case " + $2.valor + ":\n" + $4.codigo + $5.codigo;}
      | F_CASE CONST TK_DP LCASE { $$=$4; $$.valor = $2.codigo + $4.valor ; $$.codigo = "case " + $2.valor + ":\n" + $4.codigo; }
      | F_DEFAULT TK_DP CMDS { $$=$3; $$.valor = ""; $$.codigo = "default:\n" + $3.codigo; }
      | F_DEFAULT TK_DP { $$.valor = "" ; $$.codigo = "default:\n"; }
      |
      ;

CONST : TK_INT { $$ = $1; }
      | TK_CHAR { $$ = $1;}
      ;

LV : OP_MOD TK_ID { atributosVar($$,$2); }
   | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH { atributosVetor($$,$2,$4); }
   | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH TK_ABRE_COLCH E TK_FECHA_COLCH { atributosMatriz($$,$2,$4,$7); }
   ;
ATRIBUICAO : LV OP_IG E  {	$$.valor = $1.valor; 
				if ( !verificaTipo($1.tipo, $3.tipo, $2.valor, $$.tipo) )
				{
					erro("Não é possível fazer essa atribuição: "+ $1.valor + "(" + $1.tipo + ") " + $2.valor + " " + $3.valor + "(" + $3.tipo + ")"); 
				}
				if ( $1.tipo != "S" )
				{
					$$.codigo = $1.codigo + $3.codigo + 
					$1.valor + " = " + $3.valor + ";\n\n"; 
				}
				else
				{
					$$.codigo = $1.codigo + $3.codigo +
					"strncpy(&" + $1.valor + ", &" + $3.valor + ",255);\n\n"; 
				}
				}
           ;
CHAMA_FUNC : TK_CIFRAO TK_ID TK_ABRE_PAR LARGS TK_FECHA_PAR TK_FIM_CMD {	bool temp; int tempi; 
				if ( !buscaFunc($$.tipo, $2.valor, $4.tipo, strToInt($4.temp), temp, tempi) )
				{
					erro("Funcão não declarada: " + $2.valor);
				}
				$$.valor = geraTemp($$.tipo);
				$$.codigo = $4.codigo + $$.valor + " = " + $2.valor + "(" +
				$4.valor + ");\n\n";}
           | TK_CIFRAO TK_ID TK_FIM_CMD { bool temp; int tempi; 
			if ( !buscaFunc($$.tipo, $2.valor, "", 0, temp, tempi) )
			{
				erro("Função não declarada: " + $2.valor);
			}
			$$.valor = geraTemp($$.tipo);
			$$.codigo = $$.valor + " = " + $2.valor + "();\n\n";	
			}
           ;
LARGS : E TK_VIRGULA LARGS { $$.temp = intToStr(strToInt($3.temp) + 1); $$.tipo = $1.tipo + "," + $3.tipo; 
			$$.codigo = $1.codigo + $3.codigo; $$.valor = $1.valor + ", " + $3.valor; }
      | E { $$.temp = "1" ; $$.codigo = $1.codigo; $$.tipo = $1.tipo; $$.valor = $1.valor; }
      ;
CMD_REC : F_REC TK_ABRE_PAR RLV TK_FECHA_PAR TK_FIM_CMD { $$.valor = $$.tipo = ""; $$.codigo = $3.codigo + "cin >> " + $3.valor + ";\n\n"; }
        ;
RLV : LVC TK_VIRGULA RLV { $$ = $1; $$.codigo = $1.codigo + $3.codigo; $$.valor = $1.valor + " >> " + $3.valor; }
    | LVC
    ;
CMD_ECHO : F_ECHO TK_ABRE_PAR ELV TK_FECHA_PAR TK_FIM_CMD { $$.valor = $$.tipo = ""; $$.codigo = $3.codigo + "cout << " + $3.valor + ";\n\n"; }
         | F_ECHOLN TK_ABRE_PAR ELV TK_FECHA_PAR TK_FIM_CMD { $$.valor = $$.tipo = ""; $$.codigo = $3.codigo + "cout << " + $3.valor + " << endl;\n\n"; }
         ;
ELV : LVC TK_VIRGULA ELV { $$ = $1; $$.codigo = $1.codigo + $3.codigo; $$.valor = $1.valor + " << " + $3.valor; }
    | LVC
    ;
LVC : OP_MOD TK_ID { atributosVar($$,$2); }
   | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH { atributosVetor($$,$2,$4); }
   | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH TK_ABRE_COLCH E TK_FECHA_COLCH { atributosMatriz($$,$2,$4,$7); }
   | TK_INT { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n"; }
   | TK_CHAR { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n";  }
   | TK_DOUBLE { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n"; }
   | TK_BOOL { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n";  }
   | TK_STRING { $$  = $1; $$.valor = geraTemp($1.tipo); $$.codigo = "strncpy(" + $$.valor + ", " + $1.valor + ",255);\n";  }
   ;

E : E OP_OU E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_E E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_MENOR E { geraCodigoOperadorComp($$,$1,$2,$3); }
  | E OP_MAIOR E { geraCodigoOperadorComp($$,$1,$2,$3); }
  | E OP_MEIG E { geraCodigoOperadorComp($$,$1,$2,$3); } 
  | E OP_MAIG E { geraCodigoOperadorComp($$,$1,$2,$3); } 
  | E OP_IGIG E { geraCodigoOperadorComp($$,$1,$2,$3); }
  | E OP_EXIG E { geraCodigoOperadorComp($$,$1,$2,$3); }
  | E OP_MAIS E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_MENOS E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_VEZES E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_DIV E { geraCodigoOperador($$,$1,$2,$3); }
  | E OP_MOD E { geraCodigoOperador($$,$1,$2,$3); }
  | F
  ;
F : ATRIBUICAO
  | OP_MAIS F { 	if ( $2.tipo == "C" || $2.tipo == "S" )
				erro("Operador não suportado para este tipo: Unário +");
			$$ = $2; } 
  | OP_MENOS F { 	if ( $2.tipo == "C" || $2.tipo == "S" )
				erro("Operador não suportado para este tipo: Unário -");
			$$.valor = geraTemp($2.tipo); $$.codigo = $2.codigo + $$.valor + " = - " + $2.valor + ";\n";
			$$.tipo = $2.tipo;}
  | TK_ABRE_PAR E TK_FECHA_PAR { $$ = $2; }
  | OP_MOD TK_ID	{ 
			atributosVar($$,$2); string temp = geraTemp($$.tipo); 
			if ( $$.tipo != "S" )
			{
				$$.codigo = temp + " = " + $2.valor + ";\n"; $$.valor = temp; 
			}
			else
			{
				$$.codigo = "strncpy(" + temp + ", " + $2.valor + ",255);\n"; $$.valor = temp;
			}
		}
  | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH { atributosVetor($$,$2,$4); }
  | OP_MOD TK_ID TK_ABRE_COLCH E TK_FECHA_COLCH TK_ABRE_COLCH E TK_FECHA_COLCH { atributosMatriz($$,$2,$4,$7); }
  | TK_CIFRAO TK_ID TK_ABRE_PAR LARGS TK_FECHA_PAR {	bool temp; int tempi; 
				if ( !buscaFunc($$.tipo, $2.valor, $4.tipo, strToInt($4.temp), temp, tempi) )
				{
					erro("Funcão não declarada: " + $2.valor);
				}
				$$.valor = geraTemp($$.tipo);
				$$.codigo = $4.codigo + $$.valor + " = " + $2.valor + "(" +
				$4.valor + ");\n";}
  | TK_CIFRAO TK_ID TK_ABRE_PAR TK_FECHA_PAR { bool temp; int tempi; 
			if ( !buscaFunc($$.tipo, $2.valor, "", 0, temp, tempi) )
			{
				erro("Função não declarada: " + $2.valor);
			}
			$$ = $2; }
  | TK_INT { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n"; }
  | TK_CHAR { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n"; }
  | TK_DOUBLE { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n";}
  | TK_BOOL { $$ = $1; $$.valor = geraTemp($1.tipo); $$.codigo = $$.valor + " = " + $1.valor + ";\n"; }
  | TK_STRING { $$  = $1; $$.valor = geraTemp($1.tipo) + "[0]"; $$.codigo = "strcpy(&" + $$.valor + ", " + $1.valor + ");\n"; }
  ;

%%
#include "lex.yy.c"

int yyparse();

/*void yyerror( const char* st )
{
  puts( st );

}*/

void erro ( string st )
{
	cout << "Em " << sourc << ", na linha " << lineNo << ":\n" << st << endl;
	exit(1);
}

string rev_str ( string s )
{
	if ( !s.empty() )
	{
		s = rev_str(s.substr(1)) + s.substr(0,1);
		return s;
	}

	return "";
}

string intToStr ( int numero )
{
	string temp = string();
	stringstream ss;
	ss << numero;
	ss >> temp;
	return temp;
}

int strToInt ( string str )
{
	int temp;
	stringstream(str) >> temp;
	return temp;
}

string geraTemp(string tipo)
{
	if ( tipo == "I" )
	{
		return "T_int_" + intToStr(++nvartemp.i);
	}
	else if ( tipo == "D" )
	{
		return "T_double_" + intToStr(++nvartemp.d);
	}
	else if ( tipo == "B" )
	{
		return "T_bool_" + intToStr(++nvartemp.b);
	}
	else if ( tipo == "C" )
	{
		return "T_char_" + intToStr(++nvartemp.c);
	}
	else if ( tipo == "S" )
	{
		return "T_string_" + intToStr(++nvartemp.s);
	}
	else
		erro("tipo inválido" + tipo);
	
	return "ERRO";
}

string geraLabel (string comentario)
{
	return comentario + intToStr(nlabel);
}

void incLabel ()
{
	nlabel++;
}

string declaraVarTemp ()
{
	string VARS = "";
	for ( int i = 1 ; i <= nvartemp.i ; i++ )
		VARS += "int T_int_" + intToStr(i) + ";\n";
	for ( int i = 1 ; i <= nvartemp.c ; i++ )
		VARS += "char T_char_" + intToStr(i) + ";\n";
	for ( int i = 1 ; i <= nvartemp.d ; i++ )
		VARS += "double T_double_" + intToStr(i) + ";\n";
	for ( int i = 1 ; i <= nvartemp.b ; i++ )
		VARS += "int T_bool_" + intToStr(i) + ";\n";
	for ( int i = 1 ; i <= nvartemp.s ; i++ )
		VARS += "char T_string_" + intToStr(i) + "[256];\n";
	
	nvartemp.i = nvartemp.c = nvartemp.d = nvartemp.b = nvartemp.s = 0;
	
	return VARS;
}

bool verificaTipo ( string op1, string op2, string opr, string &res )
{
	for (int i = 0;i<N_OPERACAO;i++)
	{
		if ( 	tab_operacao[i].op1 == op1 &&
			tab_operacao[i].op2 == op2 &&
			tab_operacao[i].opr == opr )
		{
			res = tab_operacao[i].res;
			return true;
		}
	}
	res = "";
	return false;
}

void geraCodigoOperador ( atributos &ss, atributos s1, atributos s2, atributos s3 )
{
	if ( verificaTipo(s1.tipo, s3.tipo, s2.valor, ss.tipo ) )
	{
		ss.valor = geraTemp(ss.tipo);
		if ( s1.tipo == "I" || s1.tipo == "D" || s1.tipo == "B")
		{
			ss.codigo =	s1.codigo + s3.codigo + 
					ss.valor + " = " + s1.valor + " " + s2.valor + " " + s3.valor + ";\n";
		}
		else if ( s1.tipo == "S" || s1.tipo == "C" )
		{
			if ( s2.valor == "+" )
			{
				if ( s1.tipo == "S" && s3.tipo == "S" )
				{
					ss.codigo = s1.codigo + s3.codigo + "strncpy(" + ss.valor + ",&" + s1.valor + ",255);\n";
					ss.codigo += "strncat(" + ss.valor + ",&" + s3.valor + ",255);\n";
					ss.valor += "[0]";
				}
				else if ( s1.tipo == "S" && s3.tipo == "C" )
				{
					ss.codigo = s1.codigo + s3.codigo + "strncpy(" + ss.valor + ",&" + s1.valor + ",255);\n";
					ss.codigo += "if ( strlen(" + ss.valor + ") < 255 )\n{\n";
					ss.codigo += ss.valor + "[strlen(" + ss.valor + ")+1] = '\\0';\n";
					ss.codigo += ss.valor + "[strlen(" + ss.valor + ")] = " + s3.valor + ";\n}\n";
					ss.valor += "[0]";
				}
				else if ( s1.tipo == "C" && s3.tipo == "S" )
				{
					ss.codigo = s1.codigo + s3.codigo + ss.valor + "[0] = " + s1.valor + ";\n";
					ss.codigo += ss.valor + "[1] = '\\0';\n";
					ss.codigo += "strncat(" + ss.valor + ",&" + s3.valor + ",255);\n";
					ss.valor += "[0]";
				}
				else if ( s1.tipo == "C" && s3.tipo == "C" )
				{
					ss.codigo = s1.codigo + s3.codigo + ss.valor + "[0] = " + s1.valor + ";\n";
					ss.codigo += ss.valor + "[1] = " + s3.valor + ";\n";
					ss.codigo += ss.valor + "[2] = '\\0';\n";
					ss.valor += "[0]";
				}
				else
				{
					erro("Tipos desconhecidos em: " + s1.tipo + s2.valor + s3.tipo);
				}
			}
		}
	}
	else
	{
		erro("Operador com tipos inválidos: " + s1.tipo + s2.valor + s3.tipo);
	}
}

void geraCodigoOperadorComp ( atributos &ss, atributos s1, atributos s2, atributos s3 )
{
	if ( verificaTipo(s1.tipo, s3.tipo, s2.valor, ss.tipo ) )
	{
		ss.valor = geraTemp(ss.tipo);
		if ( s1.tipo == "I" || s1.tipo == "D" || s1.tipo == "B" || ( s1.tipo == "C" && s3.tipo == "C" ) )
		{
			ss.codigo =	s1.codigo + s3.codigo + 
					ss.valor + " = " + s1.valor + " " + s2.valor + " " + s3.valor + ";\n";
		}
		else if ( s1.tipo == "S" || s1.tipo == "C" )
		{
			if ( s2.valor == "==" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") == 0;\n";
			}
			else if ( s2.valor == "!=" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") != 0;\n";
			}
			else if ( s2.valor == ">" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") > 0;\n";
			}
			else if ( s2.valor == "<" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") < 0;\n";
			}
			else if ( s2.valor == ">=" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") >= 0;\n";
			}
			else if ( s2.valor == "<=" )
			{
				ss.codigo = s1.codigo + s3.codigo +
					ss.valor + " = strcmp(" + s1.valor + "," + s3.valor + ") <= 0;\n";
			}
		}
	}
	else
	{
		erro("Operador com tipos inválidos: " + s1.tipo + s2.valor + s3.tipo);
	}
}

bool busca_var_global ( string nome, string &tipo )
{
	for ( int i = ts_marca-1 ; i > 0 ; i-- )
	{
		if ( nome == TS[i-1].nome )
		{
			tipo = TS[i-1].tipo;
			return true;
		}
	}
	tipo = "";
	return false;
}

bool busca_var_local ( string nome, string &tipo )
{
	for ( int i = n_var ; i > ts_marca ; i-- )
	{
		if ( nome == TS[i-1].nome )
		{
			tipo = TS[i-1].tipo;
			return true;
		}
	}
	tipo = "";
	return false;
}

int insereVarLocal ( string nome , string tipo , bool param, bool isRef)
{
	string tipo_aux;
	if ( busca_var_local(nome, tipo_aux) )
	{
		if ( param )
		{
			erro("Parâmetro já declarado: "+nome);
		}
		erro("Variável local já declarada: " + nome);
	}
	TS[n_var].nome = nome;
	TS[n_var].tipo = tipo;
	TS[n_var].param = param;
	TS[n_var].nVet = -1;
	n_var++;
	return n_var-1;
}

int insereVarGlobal ( string nome, string tipo )
{
	string tipo_aux;
	if ( busca_var_global(nome, tipo_aux) )
		erro("Variável global já declarada: " + nome);
	if ( ts_marca != n_var )
		erro("Não é possível declarar variáveis globais dentro de funções");
	
	TS[n_var].nome = nome;
	TS[n_var].tipo = tipo;
	TS[n_var].nVet = -1;
	
	n_var++;
	ts_marca++;
	return n_var-1;
}

string declaraVarsLocais ( )
{
	string temp = "";
	for ( ; n_var > ts_marca ; n_var--)
	{
		if ( !TS[n_var-1].param )
		{
			if (TS[n_var-1].tipo == "I")
			{
				temp+= "int " + TS[n_var-1].nome + ";\n";
			}
			else if (TS[n_var-1].tipo == "I[]")
			{
				temp+= "int " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
			}
			else if (TS[n_var-1].tipo == "I[][]")
			{
				temp+= "int " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
			}
			else if ( TS[n_var-1].tipo == "C" )
			{
				temp+= "char " + TS[n_var-1].nome + ";\n";	
			}
			else if (TS[n_var-1].tipo == "C[]")
			{
				temp+= "char " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
			}
			else if (TS[n_var-1].tipo == "C[][]")
			{
				temp+= "char " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
			}

			else if ( TS[n_var-1].tipo == "S" )
			{
				temp+= "char " + TS[n_var-1].nome + "[256];\n";	
			}
			else if (TS[n_var-1].tipo == "S[]")
			{
				temp+= "char " + TS[n_var-1].nome + "[" + intToStr(256*TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
			}
			else if (TS[n_var-1].tipo == "S[][]")
			{
				temp+= "char " + TS[n_var-1].nome + "[" + intToStr(256*TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
			}
			else if ( TS[n_var-1].tipo == "D" )
			{
				temp+= "double " + TS[n_var-1].nome + ";\n";
			}
			else if (TS[n_var-1].tipo == "D[]")
			{
				temp+= "double " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
			}
			else if (TS[n_var-1].tipo == "D[][]")
			{
				temp+= "double " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
			}

			else if ( TS[n_var-1].tipo == "B" )
			{
				temp+= "bool " + TS[n_var-1].nome + ";\n";
			}
			else if (TS[n_var-1].tipo == "B[]")
			{
				temp+= "bool " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
			}
			else if (TS[n_var-1].tipo == "B[][]")
			{
				temp+= "bool " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
			}
			else
			{
				temp+= "ERRO!";
			}
		}
	}
	temp += "\n";
	return temp;
}

string declaraVarsGlobais ( )
{
	string temp = "";
	for ( int n_var = ts_marca ; n_var > 0 ; n_var--)
	{
		if (TS[n_var-1].tipo == "I")
		{
			temp+= "int " + TS[n_var-1].nome + ";\n";
		}
		else if (TS[n_var-1].tipo == "I[]")
		{
			temp+= "int " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
		}
		else if (TS[n_var-1].tipo == "I[][]")
		{
			temp+= "int " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
		}
		else if ( TS[n_var-1].tipo == "C" )
		{
			temp+= "char " + TS[n_var-1].nome + ";\n";	
		}
		else if (TS[n_var-1].tipo == "C[]")
		{
			temp+= "char " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
		}
		else if (TS[n_var-1].tipo == "C[][]")
		{
			temp+= "char " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
		}
		else if ( TS[n_var-1].tipo == "S" )
		{
			temp+= "char " + TS[n_var-1].nome + "[256];\n";	
		}
		else if (TS[n_var-1].tipo == "S[]")
		{
			temp+= "char " + TS[n_var-1].nome + "[" + intToStr(256*TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
		}
		else if (TS[n_var-1].tipo == "S[][]")
		{
				temp+= "char " + TS[n_var-1].nome + "[" + intToStr(256*TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
		}
		else if ( TS[n_var-1].tipo == "D" )
		{
			temp+= "double " + TS[n_var-1].nome + ";\n";
		}
		else if (TS[n_var-1].tipo == "D[]")
		{
			temp+= "double " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
		}
		else if (TS[n_var-1].tipo == "D[][]")
		{
			temp+= "double " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
		}

		else if ( TS[n_var-1].tipo == "B" )
		{
			temp+= "bool " + TS[n_var-1].nome + ";\n";
		}
		else if (TS[n_var-1].tipo == "B[]")
		{
			temp+= "bool " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)) + "];\n";
		}
		else if (TS[n_var-1].tipo == "B[][]")
		{
			temp+= "bool " + TS[n_var-1].nome + "[" + intToStr(TMV[TS[n_var-1].nVet].tam.at(0)*TMV[TS[n_var-1].nVet].tam.at(1)) + "];\n";
		}
		else
		{
			temp+= "ERRO!";
		}
	}
	temp += "\n";
	return temp;
}

bool buscaFunc(string &retorno, string nome, string params, int nParams, bool &cabecalho, int &aux_nfunc)
{
	for ( int i = 0 ; i < n_func ; i++ )
	{
		if ( TSF[i].nome == nome )
		{
			if ( TSF[i].n_param == nParams )
			{
				if ( TSF[i].tipoParams == params )
				{
					if ( TSF[i].cabecalho && !cabecalho )
						cabecalho = true;
					retorno = TSF[i].retorno;
					aux_nfunc = i;
					return true;
				}
			}
		}
	}

	return false;
}

void insereFunc(atributos s1, atributos s2, atributos s3, bool cabecalho)
{
	string retorno_aux;
	bool cabecalho_aux;
	int aux_nfunc;

	cabecalho_aux = cabecalho;
	/* s1 tipo, s2 id, s4 parâmetros */
	if ( buscaFunc(retorno_aux, s2.valor, s3.tipo, strToInt(s3.valor), cabecalho_aux, aux_nfunc) )
	{
		if ( cabecalho_aux && !cabecalho )
		{
			TSF[aux_nfunc].cabecalho = false;
			return;
		}
		
		if ( cabecalho )
		{
			return;
		}

		if ( retorno_aux == s1.tipo )
		{
			erro("Funcão " + s2.valor + " já declarada");
		}
	}	
	TSF[n_func].nome = s2.valor;
	TSF[n_func].n_param = strToInt(s3.valor);
	TSF[n_func].tipoParams = s3.tipo;
	TSF[n_func].retorno = s1.tipo;
	TSF[n_func].cabecalho = cabecalho;
	n_func++;
}

void insereVetorGlobal ( string nome, string &tipo, int tam , int desloc)
{
	int nfunc;
	nfunc = insereVarGlobal(nome, tipo + "[]");
	
	TMV[n_vet].nome = nome;
	TMV[n_vet].nDimens = 1;
	TMV[n_vet].nFunc = nfunc;
	TMV[n_vet].tipo = tipo + "[]";
	TMV[n_vet].tam.push_back(tam);
	TMV[n_vet].desloc.push_back(desloc);
	TS[TMV[n_vet].nFunc].nVet = n_vet;
	if ( TMV[n_vet].tam.size() <= 0 || TMV[n_vet].desloc.size() <= 0 )
		erro("Erro ao guardar tamanhos.");
	n_vet++;
}

void insereMatrizGlobal ( string nome, string &tipo, int tam, int desloc, int tam2, int desloc2)
{
	int nfunc;
	nfunc = insereVarGlobal(nome, tipo + "[][]");
	
	TMV[n_vet].nome = nome;
	TMV[n_vet].nDimens = 2;
	TMV[n_vet].nFunc = nfunc;
	TMV[n_vet].tipo = tipo + "[][]";
	TMV[n_vet].tam.push_back(tam); TMV[n_vet].tam.push_back(tam2);
	TMV[n_vet].desloc.push_back(desloc); TMV[n_vet].desloc.push_back(desloc2);
	TS[TMV[n_vet].nFunc].nVet = n_vet;
	if ( TMV[n_vet].tam.size() <= 0 || TMV[n_vet].desloc.size() <= 0 )
		erro("Erro ao guardar tamanhos.");
	n_vet++;
}

void insereVetorLocal ( string nome, string &tipo, int tam , int desloc, bool param, bool isRef)
{
	int nfunc;
	nfunc = insereVarLocal(nome, tipo + "[]", param, isRef);
	
	TMV[n_vet].nome = nome;
	TMV[n_vet].nDimens = 1;
	TMV[n_vet].nFunc = nfunc;
	TMV[n_vet].tipo = tipo + "[]";
	TMV[n_vet].tam.push_back(tam);
	TMV[n_vet].desloc.push_back(desloc);
	TS[TMV[n_vet].nFunc].nVet = n_vet;
	if ( TMV[n_vet].tam.size() <= 0 || TMV[n_vet].desloc.size() <= 0 )
		erro("Erro ao guardar tamanhos.");
	n_vet++;
}

void insereMatrizLocal ( string nome, string &tipo, int tam, int desloc, int tam2, int desloc2, bool param, bool isRef)
{
	int nfunc;
	nfunc = insereVarLocal(nome, tipo + "[][]", param, isRef);
	
	TMV[n_vet].nome = nome;
	TMV[n_vet].nDimens = 2;
	TMV[n_vet].nFunc = nfunc;
	TMV[n_vet].tipo = tipo + "[][]";
	TMV[n_vet].tam.push_back(tam); TMV[n_vet].tam.push_back(tam2);
	TMV[n_vet].desloc.push_back(desloc); TMV[n_vet].desloc.push_back(desloc2);
	TS[TMV[n_vet].nFunc].nVet = n_vet;
	if ( TMV[n_vet].tam.size() <= 0 || TMV[n_vet].desloc.size() <= 0 )
		erro("Erro ao guardar tamanhos.");
	n_vet++;
}

int buscaIndiceVar ( string nome )
{
	for ( int nVar = n_var ; nVar > 0 ; nVar--)
	{
		if ( nome == TS[nVar-1].nome )
		{
			return nVar-1;
		}
	}
	erro("Variável não existente!");
	return 0;
}

void atributosVar ( atributos &ss , atributos s1 )
{
	ss.valor = s1.valor; ss.codigo = "";
	if ( !busca_var_local(ss.valor, ss.tipo) && !busca_var_global(ss.valor, ss.tipo) )
	  		erro("Variável não declarada: " + ss.valor);
}

void atributosVetor ( atributos &ss, atributos s1, atributos s2 )
{

	ss.valor = s1.valor; ss.codigo = "";
	if ( !busca_var_local(ss.valor, ss.tipo) && !busca_var_global(ss.valor, ss.tipo) )
		erro("Variável não declarada: " + ss.valor);
	int indice = buscaIndiceVar(ss.valor);
	if ( TS[indice].nVet != -1 && TMV[TS[indice].nVet].nDimens != 1 )
		erro("Variável " + s1.valor + " não é um vetor!");
	if ( s2.tipo != "I" )
		erro("Índice do vetor " + s1.valor + "não é inteiro."); 
	/* Então, é um vetor válido, com indice válido */
	if ( ss.tipo != "S[]" )
	{
		string inicio, fim;
		inicio = geraTemp(s2.tipo); fim = geraTemp(s2.tipo);
		ss.codigo = s2.codigo + inicio + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.codigo += fim + " = " + intToStr(TMV[TS[indice].nVet].tam.at(0) + TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.codigo += "if ( " + s2.valor + " < " + inicio + " || " + s2.valor +" > " + fim +" )\n{\n";
		ss.codigo += "puts(\"Índice do vetor " + s1.valor + " além dos limites!\");\n";
		ss.codigo += "exit(1);\n}\n";
		ss.codigo += s2.valor + " = " + s2.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.valor = s1.valor + "[" + s2.valor + "]";
		ss.tipo = ss.tipo[0];
	}
	else
	{
		string inicio, fim, indice_s;
		inicio = geraTemp(s2.tipo); fim = geraTemp(s2.tipo);
		indice_s = geraTemp("I");
		ss.codigo = s2.codigo +"\n";
		ss.codigo += inicio + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.codigo += fim + " = " + intToStr(TMV[TS[indice].nVet].tam.at(0) + TMV[TS[indice].nVet].desloc.at(0) - 1) + ";\n";
		ss.codigo += "if (" + s2.valor + " < " + inicio + " || " + s2.valor +" > " + fim +")\n{\n";
		ss.codigo += "puts(\"Indice do vetor "+ s1.valor +" além dos limites!\");\n";
		ss.codigo += "exit(1);\n}\n";
		ss.codigo += indice_s + " = ( " + s2.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + " ) * 256;\n";
		ss.valor = s1.valor + "[ " + indice_s + " ]";
		ss.tipo = ss.tipo[0];
	}
}


void atributosMatriz ( atributos &ss, atributos s1, atributos s2, atributos s3 )
{
	ss.valor = s1.valor; ss.codigo = "";
	if ( !busca_var_local(ss.valor, ss.tipo) && !busca_var_global(ss.valor, ss.tipo) )
		erro("Variável não declarada: " + ss.valor);
	int indice = buscaIndiceVar(ss.valor);
	if ( TS[indice].nVet == -1 || TMV[TS[indice].nVet].nDimens != 2 )
		erro("Variável " + s1.valor + " não é uma matriz!");
	if ( s2.tipo != "I" || s3.tipo != "I" )
		erro("Um dos Índices da matriz " + s1.valor + "não é inteiro."); 
	/* Então, é uma matriz válida, com indice válido */
	
	if ( ss.tipo != "S[][]" )
	{
		string inicio, fim, inicio2, fim2, indice_s;
		inicio = geraTemp(s2.tipo); fim = geraTemp(s2.tipo);
		inicio2 = geraTemp(s3.tipo); fim2 = geraTemp(s3.tipo);
		indice_s = geraTemp("I");
		ss.codigo = s2.codigo + s3.codigo + "\n";
		ss.codigo += inicio + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.codigo += fim + " = " + intToStr(TMV[TS[indice].nVet].tam.at(0) + TMV[TS[indice].nVet].desloc.at(0) - 1) + ";\n";
		ss.codigo += inicio2 + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(1)) + ";\n";
		ss.codigo += fim2 + " = " + intToStr(TMV[TS[indice].nVet].tam.at(1) + TMV[TS[indice].nVet].desloc.at(1) - 1) + ";\n";
		ss.codigo += "if ( (" + s2.valor + " < " + inicio + " || " + s2.valor +" > " + fim +") || (" + s3.valor + " < " + inicio2 + " || " + s3.valor +" > " + fim2 +")  )\n{\n";
		ss.codigo += "puts(\"Indice da matriz "+ s1.valor +" além dos limites!\");\n";
		ss.codigo += "exit(1);\n}\n";
		ss.codigo += indice_s + " = ( ( " + s2.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + " ) * " + intToStr(TMV[TS[indice].nVet].tam.at(1)) + " ) + ( " + s3.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(1)) + " );\n";
		ss.valor = s1.valor + "[ " + indice_s + " ]";
		ss.tipo = ss.tipo[0];
	}
	else
	{
		string inicio, fim, inicio2, fim2, indice_s;
		inicio = geraTemp(s2.tipo); fim = geraTemp(s2.tipo);
		inicio2 = geraTemp(s3.tipo); fim2 = geraTemp(s3.tipo);
		indice_s = geraTemp("I");
		ss.codigo = s2.codigo + s3.codigo + "\n";
		ss.codigo += inicio + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + ";\n";
		ss.codigo += fim + " = " + intToStr(TMV[TS[indice].nVet].tam.at(0) + TMV[TS[indice].nVet].desloc.at(0) - 1) + ";\n";
		ss.codigo += inicio2 + " = " + intToStr(TMV[TS[indice].nVet].desloc.at(1)) + ";\n";
		ss.codigo += fim2 + " = " + intToStr(TMV[TS[indice].nVet].tam.at(1) + TMV[TS[indice].nVet].desloc.at(1) - 1) + ";\n";
		ss.codigo += "if ( (" + s2.valor + " < " + inicio + " || " + s2.valor +" > " + fim +") || (" + s3.valor + " < " + inicio2 + " || " + s3.valor +" > " + fim2 +")  )\n{\n";
		ss.codigo += "puts(\"Indice da matriz "+ s1.valor +" além dos limites!\");\n";
		ss.codigo += "exit(1);\n}\n";
		ss.codigo += indice_s + " = ( ( ( " + s2.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(0)) + " ) * " + intToStr(TMV[TS[indice].nVet].tam.at(1)) + " ) + ( " + s3.valor + " - " + intToStr(TMV[TS[indice].nVet].desloc.at(1)) + " ) ) * 256;\n";
		ss.valor = s1.valor + "[ " + indice_s + " ]";
		ss.tipo = ss.tipo[0];

	}
}

string geraCondLabel(string lab)
{
	return lab + intToStr(ncondlabel);
}
void incCondLabel()
{
	ncondlabel++;
}

string realTipo ( string tipo )
{
	if (tipo == "I")
	{
		return "int";
	}
	else if (tipo == "I[]")
	{
		return "int[]";
	}
	else if (tipo == "I[][]")
	{
		return "int[][]";
	}
	else if (tipo == "C" )
	{
		return "char";
	}
	else if (tipo == "C[]")
	{
		return "char[]";
	}
	else if (tipo == "C[][]")
	{
		return "char[][]";
	}
	else if (tipo == "S" )
	{
		return "string";
	}
	else if (tipo == "S[]")
	{
		return "string[]";
	}
	else if (tipo == "S[][]")
	{
		return "string[][]";
	}
	else if (tipo == "D" )
	{
		return "double";
	}
	else if (tipo == "D[]")
	{
		return "double[]";
	}
	else if (tipo == "D[][]")
	{
		return "double[][]";
	}

	else if (tipo == "B" )
	{
		return "bool";
	}
	else if (tipo == "B[]")
	{
		return "bool[]";
	}
	else if (tipo == "B[][]")
	{
		return "bool[][]";
	}
	else if (tipo == "")
	{
		return "vazio";
	}
	else
	{
		return "erro";
	}
}

void yyerror( const char* st )
{
	if ( (string)st == "syntax error")
		cout << "Erro de sintaxe em " + sourc + ": na linha " + intToStr(lineNo) + " próximo de " + yytext << endl;
	else
		cout << "Erro em " + sourc + ": na linha " + intToStr(lineNo) + " próximo de " + yytext << endl << st << endl;
}

int main( int argc, char* argv[] )
{
	yyin = NULL;
	dest = sourc = "";
	for ( int i = 0 ; i < argc ; i++ )
	{
		string temp = argv[i];
		if ( temp == "-s" )
		{
			sourc = argv[i+1];
			yyin = fopen(sourc.c_str(), "r");
			i++;
		}
		if ( temp == "-d" )
		{
			dest = argv[i+1];
			i++;
		}	
	}
	if ( sourc == "" || dest == "" )
	{
		erro("Ops!\nSintaxe: cdp -s origem.cd -d destino.c");
	}

	yyparse();
}


