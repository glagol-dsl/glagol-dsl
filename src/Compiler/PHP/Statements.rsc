module Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::Indentation;
import Compiler::PHP::Glue;
import Compiler::PHP::NewLine;
import Compiler::PHP::ByRef;
import Compiler::PHP::Params;
import List;

public str toCode(list[PhpStmt] statements, i) = ("" | it + toCode(stmt, i) + nl() | stmt <- statements);
public str toCode(phpExprstmt(PhpExpr expr), int i) = "<s(i)><toCode(expr, i)>;";
public str toCode(phpReturn(phpSomeExpr(PhpExpr expr)), int i) = "<nl()><s(i)>return <toCode(expr, i)>;";
public str toCode(phpReturn(phpNoExpr()), int i) = "<nl()><s(i)>return;";
public str toCode(phpBreak(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>break <toCode(expr, i)>;";
public str toCode(phpBreak(phpNoExpr()), int i) = "<s(i)>break;";
public str toCode(phpContinue(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>continue <toCode(expr, i)>;";
public str toCode(phpContinue(phpNoExpr()), int i) = "<s(i)>continue;";
public str toCode(phpConst(list[PhpConst] consts), int i) = "<s(i)>const <glue([toCode(c, i) | c <- consts], ",<nl()><s(i)>      ")>;";
public str toCode(phpConst(str name, PhpExpr val), int i) = "<name> = <toCode(val, i)>";
public str toCode(phpDeclaration(str key, PhpExpr val), int i) = "<key>=<toCode(val, i)>";
public str toCode(phpEcho(list[PhpExpr] exprs), int i) = "<s(i)>echo <glue([toCode(e, i) | e <- exprs], ", ")>;";

public str toCode(phpFor(list[PhpExpr] inits, list[PhpExpr] conds, list[PhpExpr] exprs, list[PhpStmt] body), int i) = 
	"<s(i)>for (<glue([toCode(e, i) | e <- inits], ", ")>; <glue([toCode(e, i) | e <- conds], ", ")>; <glue([toCode(e, i) | e <- exprs], ", ")>) {<nl()>" +
	"<toCode(body, i + 1)>" +
	"<s(i)>}";
	
public str toCode(phpForeach(PhpExpr arrayExpr, PhpOptionExpr keyvar, bool byRef, PhpExpr asVar, list[PhpStmt] body), int i) =
	"<s(i)>foreach (<toCode(arrayExpr, i)> as <key(keyvar, i)><ref(byRef)><toCode(asVar, i)>) {<nl()><toCode(body, i + 1)><s(i)>}";
	
public str toCode(phpFunction(str name, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName rType), int i) =
	"<s(i)>function <ref(byRef)><name>(<toCode(params)>)<returnType(rType)><nl()><s(i)>{<nl()><toCode(body, i + 1)><s(i)>}";

public str toCode(phpDo(PhpExpr cond, list[PhpStmt] body), int i) = 
	"<s(i)>do {<nl()><toCode(body, i + 1)><s(i)>} while (<toCode(cond, i)>);";

public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	"<s(i)>declare(<glue([toCode(d, i) | d <- decls], ", ")>);" when size(body) == 0;

public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	"<s(i)>declare(<glue([toCode(d, i) | d <- decls], ", ")>) {<nl()><toCode(body, i + 1)><s(i)>}" when size(body) > 0;

private str key(phpNoExpr(), _) = "";
private str key(phpSomeExpr(PhpExpr expr), int i) = "<toCode(expr, i)> =\> ";

public str returnType(phpNoName()) = "";
public str returnType(phpSomeName(phpName(str name))) = ": <name>";
