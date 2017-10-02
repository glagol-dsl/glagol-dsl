module Compiler::PHP::Statements

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Utils::Indentation;
import Utils::Glue;
import Utils::NewLine;
import Compiler::PHP::ByRef;
import Compiler::PHP::Params;
import Compiler::PHP::Properties;
import Compiler::PHP::Consts;
import Compiler::PHP::Methods;
import Compiler::PHP::Traits;
import Compiler::PHP::Modifiers;
import Compiler::PHP::Annotations;
import List;

public Code toCode(d: phpClassDef(class: phpClass(
		str className, 
		set[PhpModifier] modifiers, 
		PhpOptionName extending, 
		list[PhpName] interfaces,
		list[PhpClassItem] members)), int i) = 
	code(nl()) +
	((class@phpAnnotations?) ? (toCode(class@phpAnnotations, i) + code(nl())) : code("")) +
	toCode(modifiers) +
	code("class <className> <extends(extending)><implements(interfaces)>", d) + code(nl()) + code("{", d) + 
		glue([toCode(m, i + 1) | m <- members]) +
	code("}");
	
public Code toCode(list[PhpStmt] statements, i) = (code() | it + toCode(stmt, i) + code(nl()) | stmt <- statements);
public Code toCode(p: phpExprstmt(PhpExpr expr), int i) = code(s(i)) + toCode(expr, i) + code(";");
public Code toCode(p: phpReturn(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("return ", p) + toCode(expr, i) + code(";");
public Code toCode(p: phpReturn(phpNoExpr()), int i) = code(s(i)) + code("return;", p);
public Code toCode(p: phpBreak(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("break ", p) + toCode(expr, i) + code(";");
public Code toCode(p: phpBreak(phpNoExpr()), int i) = code(s(i)) + code("break;", p);
public Code toCode(p: phpContinue(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("continue ", p) + toCode(expr, i) + code(";");
public Code toCode(p: phpContinue(phpNoExpr()), int i) = code(s(i)) + code("continue;", p);
public Code toCode(p: phpConst(list[PhpConst] consts), int i) = 
	code(s(i)) + code("const ", p) + glue([toCode(c, i) | c <- consts], code(",") + code(nl()) + code("<s(i)>      ")) + code(";");
public Code toCode(p: phpConst(str name, PhpExpr val), int i) = code(name, p) + code(" = ", p) + toCode(val, i);
public Code toCode(p: phpDeclaration(str key, PhpExpr val), int i) = code(key, p) + code("=", p) + toCode(val, i);
public Code toCode(p: phpEcho(list[PhpExpr] exprs), int i) = code(s(i)) + code("echo ", p) + toCode(exprs[0], i) + code(";", p) when size(exprs) == 1;
public Code toCode(p: phpEcho(list[PhpExpr] exprs), int i) = code(s(i)) + code("echo (", p) + glue([toCode(e, i) | e <- exprs], code(", ")) + code(");", p);
public Code toCode(p: phpGlobal(list[PhpExpr] exprs), int i) = code(s(i)) + code("global ", p) + glue([toCode(e, i) | e <- exprs], code(", ", p)) + code(";");
public Code toCode(p: phpGoto(str label), int i) = code(s(i)) + code("goto <label>;", p);
public Code toCode(p: phpLabel(str label), int i) = code(s(i)) + code("<label>:", p);
public Code toCode(p: phpHaltCompiler(str remainingText), int i) = code("<s(i)>__halt_compiler();<remainingText>", p);

public Code toCode(p: phpFor(list[PhpExpr] inits, list[PhpExpr] conds, list[PhpExpr] exprs, list[PhpStmt] body), int i) = 
	code(s(i)) + code("for (", p) + glue([toCode(e, i) | e <- inits], code(", ", p)) + 
	code("; ", p) + glue([toCode(e, i) | e <- conds], code(", ", p)) + code("; ", p) + 
	glue([toCode(e, i) | e <- exprs], code(", ", p)) + code(") {") + code(nl()) +
	toCode(body, i + 1) +
	code("<s(i)>}", p);
	
public Code toCode(p: phpForeach(PhpExpr arrayExpr, PhpOptionExpr keyvar, bool byRef, PhpExpr asVar, list[PhpStmt] body), int i) =
	code("<s(i)>foreach (", p) + toCode(arrayExpr, i) + code(" as ", p) + key(keyvar, i) + code(ref(byRef), p) + toCode(asVar, i) + 
	code(") {", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);
	
public Code toCode(p: phpFunction(str name, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName rType), int i) =
	code("<s(i)>function <ref(byRef)><name>(") + toCode(params) + code(")") + returnType(rType) + code(nl()) + code(s(i)) + code("{") + code(nl()) + 
	toCode(body, i + 1) + code("<s(i)>}");

public Code toCode(p: phpIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)], list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) =
	toCode(phpIf(cond, body, elseIfs, elseClause), i);

public Code toCode(p: phpIf(PhpExpr cond, list[PhpStmt] body, list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) =
	code(s(i)) + code("if (", p) + toCode(cond, i) + code(") {") + code(nl()) +
	toCode(body, i + 1) + 
	code(s(i)) +
	code("}") + 
	toElseIfs(elseIfs, i) +
	toElse(elseClause, i);

public Code toCode(p: phpDo(PhpExpr cond, list[PhpStmt] body), int i) = 
	code(s(i)) + code("do {") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("} while (", p) + toCode(cond, i) + code(");", p);

public Code toCode(p: phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	code(s(i)) + code("declare(", p) + glue([toCode(d, i) | d <- decls], code(", ")) + code(");", p) + code(nl()) when size(body) == 0;

public Code toCode(p: phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	code(s(i)) + code("declare(", p) + glue([toCode(d, i) | d <- decls], code(", ")) + code(") {") + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p) when size(body) > 0;

public Code toCode(p: phpInterfaceDef(interface: phpInterface(str interfaceName, list[PhpName] extending, list[PhpClassItem] members)), int i)  = code(nl()) +
	((interface@phpAnnotations?) ? (toCode(interface@phpAnnotations, i) + code(nl())) : code("")) + 
	code("<s(i)>interface <interfaceName><extends(extending)>", p) + code(nl()) + code("{", p) + 
		glue([toMethod(m, false, i + 1) | m <- members]) + 
	code("}", p);

public Code toCode(p: phpTraitDef(trait: phpTrait(str traitName, list[PhpClassItem] members)), int i) = code(nl()) +
	((trait@phpAnnotations?) ? (toCode(trait@phpAnnotations, i) + code(nl())) : code("")) +
	code("<s(i)>trait <traitName>", p) + code(nl()) + code("{", p) + 
		glue([toCode(m, i + 1) | m <- members]) + 
	code("}", p);

public Code toCode(p: phpStatic(list[PhpStaticVar] vars), int i) =
	code("<s(i)>static ", p) + glue([toCode(v, i) | v <- vars], code(",") + code(nl()) + code("<s(i)>       ")) + code(";");

public Code toCode(p: phpStaticVar(str name, PhpOptionExpr defValue), int i) = 
	code("$<name>", p) + defaultVal(defValue);

public Code toCode(p: phpSwitch(PhpExpr cond, list[PhpCase] cases), int i) =
	code("<s(i)>switch (", p) + toCode(cond, i) + code(") {") + code(nl()) +
		glue([toCode(c, i + 1) | c <- cases]) +
	code("<s(i)>}");

public Code toCode(p: phpCase(phpSomeExpr(PhpExpr expr), list[PhpStmt] body), int i) = 
	code("<s(i)>case ", p) + toCode(expr, i) + code(":", p) + code(nl()) + toCode(body, i + 1);

public Code toCode(p: phpCase(phpNoExpr(), list[PhpStmt] body), int i) = 
	code("<s(i)>default:", p) + code(nl()) + toCode(body, i + 1);

public Code toCode(p: phpThrow(PhpExpr expr), int i) = code(s(i)) + code("throw ", p) + toCode(expr, i) + code(";", p);

public Code toCode(p: phpTryCatch(list[PhpStmt] body, list[PhpCatch] catches), int i) =
	code("<s(i)>try {", p) + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}", p) + glue([toCode(c, i) | c <- catches]);

public Code toCode(p: phpTryCatchFinally(list[PhpStmt] body, list[PhpCatch] catches, list[PhpStmt] final), int i) =
	code("<s(i)>try {") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}", p) + 
		glue([toCode(c, i) | c <- catches]) + code(" finally {", p) + code(nl()) + toCode(final, i + 1) + code("<s(i)>}", p);

public Code toCode(p: phpCatch(phpName(str xtype), str varName, list[PhpStmt] body), int i) =
	code("<s(i)> catch (<xtype> $<varName>) {", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);

public Code toCode(p: phpUnset(list[PhpExpr] unsetVars), int i) = 
	code("<s(i)>unset(", p) + glue([toCode(v, i) | v <- unsetVars], code(", ")) + code(");", p);

public Code toCode(p: phpWhile(PhpExpr cond, list[PhpStmt] body), int i) =
	code("<s(i)>while (", p) + toCode(cond, i) + code(") {", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);

public Code toCode(p: phpEmptyStmt(), int i) = code("<s(i)>;", p);

public Code toCode(p: phpBlock(list[PhpStmt] body), int i) = code(s(i)) + code("{", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);

public Code toCode(p: phpNewLine(), int i) = code("", p);

private Code defaultVal(p: phpSomeExpr(PhpExpr expr)) = code(" = ", p) + toCode(expr, 0);
private Code defaultVal(phpNoExpr()) = code("");

private str extends(list[PhpName] extending) = "" when size(extending) == 0;
private str extends(list[PhpName] extending) = " extends <glue([e.name | e <- extending], ", ")>";
private str extends(phpNoName()) = "";
private str extends(phpSomeName(phpName(str name))) = "extends <name> ";

private str implements(list[PhpName] interfaces) = "" when size(interfaces) == 0;
private str implements(list[PhpName] interfaces) = "implements <interfaces[0].name> " when size(interfaces) == 1;
private default str implements(list[PhpName] interfaces) = 
	"implements <(glue([name | phpName(str name) <- interfaces], ", "))> ";

private Code toElseIfs(list[PhpElseIf] elseIfs, int i) = glue([toElseIf(e, i) | e <- elseIfs]);

private Code toElseIf(phpElseIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)]), int i) =
	toElseIf(phpElseIf(cond, body), i);

private Code toElseIf(p: phpElseIf(PhpExpr cond, list[PhpStmt] body), int i) = 
	code(" elseif (", p) + toCode(cond, i) + code(") {", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);
	
private Code toElse(phpNoElse(), int i) = code("");
private Code toElse(phpSomeElse(phpElse([phpBlock(list[PhpStmt] body)])), int i) = toElse(phpSomeElse(phpElse(body)), i);
private Code toElse(p: phpSomeElse(phpElse(list[PhpStmt] body)), int i) = code(" else {", p) + code(nl()) + toCode(body, i + 1) + code("<s(i)>}", p);

private Code key(phpNoExpr(), _) = code("");
private Code key(p: phpSomeExpr(PhpExpr expr), int i) = toCode(expr, i) + code(" =\> ", p);

private Code returnType(phpNoName()) = code("");
private Code returnType(p: phpSomeName(phpName(str name))) = code(": <name>", p);
