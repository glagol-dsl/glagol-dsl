module Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::Indentation;
import Compiler::PHP::Glue;
import Compiler::PHP::NewLine;
import Compiler::PHP::ByRef;
import Compiler::PHP::Params;
import Compiler::PHP::Properties;
import Compiler::PHP::Methods;
import Compiler::PHP::Modifiers;
import Compiler::PHP::Annotations;
import List;

public str toCode(phpClassDef(class: phpClass(
		str className, 
		set[PhpModifier] modifiers, 
		PhpOptionName extending, 
		list[PhpName] interfaces,
		list[PhpClassItem] members)), int i) = nl() +
	((class@phpAnnotations?) ? (toCode(class@phpAnnotations, i) + nl()) : "") +
	"<toCode(modifiers)>class <className> <extends(extending)><implements(interfaces)><nl()>{" + 
		("" | it + toCode(m, i + 1) | m <- members) +
	"}";
	
public str toCode(list[PhpStmt] statements, i) = ("" | it + toCode(stmt, i) + nl() | stmt <- statements);
public str toCode(phpExprstmt(PhpExpr expr), int i) = "<s(i)><toCode(expr, i)>;";
public str toCode(phpReturn(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>return <toCode(expr, i)>;";
public str toCode(phpReturn(phpNoExpr()), int i) = "<s(i)>return;";
public str toCode(phpBreak(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>break <toCode(expr, i)>;";
public str toCode(phpBreak(phpNoExpr()), int i) = "<s(i)>break;";
public str toCode(phpContinue(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>continue <toCode(expr, i)>;";
public str toCode(phpContinue(phpNoExpr()), int i) = "<s(i)>continue;";
public str toCode(phpConst(list[PhpConst] consts), int i) = "<s(i)>const <glue([toCode(c, i) | c <- consts], ",<nl()><s(i)>      ")>;";
public str toCode(phpConst(str name, PhpExpr val), int i) = "<name> = <toCode(val, i)>";
public str toCode(phpDeclaration(str key, PhpExpr val), int i) = "<key>=<toCode(val, i)>";
public str toCode(phpEcho(list[PhpExpr] exprs), int i) = "<s(i)>echo <glue([toCode(e, i) | e <- exprs], ", ")>;";
public str toCode(phpGlobal(list[PhpExpr] exprs), int i) = "<s(i)>global <glue([toCode(e, i) | e <- exprs], ", ")>;";
public str toCode(phpGoto(str label), int i) = "<s(i)>goto <label>;";
public str toCode(phpLabel(str label), int i) = "<s(i)><label>:";
public str toCode(phpHaltCompiler(str remainingText), int i) = "<s(i)>__halt_compiler();<remainingText>";

public str toCode(phpFor(list[PhpExpr] inits, list[PhpExpr] conds, list[PhpExpr] exprs, list[PhpStmt] body), int i) = 
	"<s(i)>for (<glue([toCode(e, i) | e <- inits], ", ")>; <glue([toCode(e, i) | e <- conds], ", ")>; <glue([toCode(e, i) | e <- exprs], ", ")>) {<nl()>" +
	"<toCode(body, i + 1)>" +
	"<s(i)>}";
	
public str toCode(phpForeach(PhpExpr arrayExpr, PhpOptionExpr keyvar, bool byRef, PhpExpr asVar, list[PhpStmt] body), int i) =
	"<s(i)>foreach (<toCode(arrayExpr, i)> as <key(keyvar, i)><ref(byRef)><toCode(asVar, i)>) {<nl()><toCode(body, i + 1)><s(i)>}";
	
public str toCode(phpFunction(str name, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName rType), int i) =
	"<s(i)>function <ref(byRef)><name>(<toCode(params)>)<returnType(rType)><nl()><s(i)>{<nl()><toCode(body, i + 1)><s(i)>}";

public str toCode(phpIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)], list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) =
	toCode(phpIf(cond, body, elseIfs, elseClause), i);

public str toCode(phpIf(PhpExpr cond, list[PhpStmt] body, list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) =
	"<s(i)>if (<toCode(cond, i)>) {<nl()>" +
	"<toCode(body, i + 1)>" + 
	"<s(i)>}<toElseIfs(elseIfs, i)><toElse(elseClause, i)>";

public str toCode(phpDo(PhpExpr cond, list[PhpStmt] body), int i) = 
	"<s(i)>do {<nl()><toCode(body, i + 1)><s(i)>} while (<toCode(cond, i)>);";

public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	"<s(i)>declare(<glue([toCode(d, i) | d <- decls], ", ")>);" when size(body) == 0;

public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	"<s(i)>declare(<glue([toCode(d, i) | d <- decls], ", ")>) {<nl()><toCode(body, i + 1)><s(i)>}" when size(body) > 0;

public str toCode(phpInterfaceDef(interface: phpInterface(str interfaceName, list[PhpName] extending, list[PhpClassItem] members)), int i)  = nl() +
	((interface@phpAnnotations?) ? (toCode(interface@phpAnnotations, i) + nl()) : "") + 
	"<s(i)>interface <interfaceName><extends(extending)><nl()>{" + 
		glue([toMethod(m, false, i + 1) | m <- members]) + 
	"}";

public str toCode(phpTraitDef(trait: phpTrait(str traitName, list[PhpClassItem] members)), int i) = nl() +
	((trait@phpAnnotations?) ? (toCode(trait@phpAnnotations, i) + nl()) : "") +
	"<s(i)>trait <traitName><nl()>{" + 
		glue([toCode(m, i + 1) | m <- members]) + 
	"}";

public str toCode(phpStatic(list[PhpStaticVar] vars), int i) =
	"<s(i)>static <glue([toCode(v, i) | v <- vars], ",<nl()><s(i)>       ")>;";

public str toCode(phpStaticVar(str name, PhpOptionExpr defValue), int i) = 
	"$<name><defaultVal(defValue)>";

public str toCode(phpSwitch(PhpExpr cond, list[PhpCase] cases), int i) =
	"<s(i)>switch (<toCode(cond, i)>) {<nl()>" +
		glue([toCode(c, i + 1) | c <- cases]) +
	"<s(i)>}";

public str toCode(phpCase(phpSomeExpr(PhpExpr expr), list[PhpStmt] body), int i) = 
	"<s(i)>case <toCode(expr, i)>:<nl()><toCode(body, i + 1)>";

public str toCode(phpCase(phpNoExpr(), list[PhpStmt] body), int i) = 
	"<s(i)>default:<nl()><toCode(body, i + 1)>";

public str toCode(phpThrow(PhpExpr expr), int i) = "<s(i)>throw <toCode(expr, i)>;";

public str toCode(phpTryCatch(list[PhpStmt] body, list[PhpCatch] catches), int i) =
	"<s(i)>try {<nl()><toCode(body, i + 1)><s(i)>}<glue([toCode(c, i) | c <- catches])>";

public str toCode(phpTryCatchFinally(list[PhpStmt] body, list[PhpCatch] catches, list[PhpStmt] final), int i) =
	"<s(i)>try {<nl()><toCode(body, i + 1)><s(i)>}<glue([toCode(c, i) | c <- catches])> finally {<nl()><toCode(final, i + 1)><s(i)>}";

public str toCode(phpCatch(phpName(str xtype), str varName, list[PhpStmt] body), int i) =
	"<s(i)> catch (<xtype> $<varName>) {<nl()><toCode(body, i + 1)><s(i)>}";

public str toCode(phpUnset(list[PhpExpr] unsetVars), int i) = "<s(i)>unset(<glue([toCode(v, i) | v <- unsetVars], ", ")>);";

public str toCode(phpWhile(PhpExpr cond, list[PhpStmt] body), int i) =
	"<s(i)>while (<toCode(cond, i)>) {<nl()><toCode(body, i + 1)><s(i)>}";

public str toCode(phpEmptyStmt(), int i) = "<s(i)>;";

public str toCode(phpBlock(list[PhpStmt] body), int i) = "<s(i)>{<nl()><toCode(body, i + 1)><s(i)>}";

public str toCode(phpNewLine(), int i) = "";

private str defaultVal(phpSomeExpr(PhpExpr expr)) = " = <toCode(expr, 0)>";
private str defaultVal(phpNoExpr()) = "";

private str extends(list[PhpName] extending) = "" when size(extending) == 0;
private str extends(list[PhpName] extending) = " extends <glue([e.name | e <- extending], ", ")>";
private str extends(phpNoName()) = "";
private str extends(phpSomeName(phpName(str name))) = "extends <name> ";

private str implements(list[PhpName] interfaces) = "" when size(interfaces) == 0;
private str implements(list[PhpName] interfaces) = "implements <interfaces[0].name> " when size(interfaces) == 1;
private default str implements(list[PhpName] interfaces) = 
	"implements <(glue([name | phpName(str name) <- interfaces], ", "))> ";

private str toElseIfs(list[PhpElseIf] elseIfs, int i) = glue([toElseIf(e, i) | e <- elseIfs]);

private str toElseIf(phpElseIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)]), int i) =
	toElseIf(phpElseIf(cond, body), i);

private str toElseIf(phpElseIf(PhpExpr cond, list[PhpStmt] body), int i) = 
	" elseif (<toCode(cond, i)>) {<nl()><toCode(body, i + 1)><s(i)>}";
	
private str toElse(phpNoElse(), int i) = "";
private str toElse(phpSomeElse(phpElse([phpBlock(list[PhpStmt] body)])), int i) = toElse(phpSomeElse(phpElse(body)), i);
private str toElse(phpSomeElse(phpElse(list[PhpStmt] body)), int i) = " else {<nl()><toCode(body, i + 1)><s(i)>}";

private str key(phpNoExpr(), _) = "";
private str key(phpSomeExpr(PhpExpr expr), int i) = "<toCode(expr, i)> =\> ";

private str returnType(phpNoName()) = "";
private str returnType(phpSomeName(phpName(str name))) = ": <name>";
