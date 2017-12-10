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
	code("class <className> <extends(extending)><implements(interfaces)>", d) + code(nl()) + code("{") + 
		glue([toCode(m, i + 1) | m <- members]) +
	code("}");
	
public Code toCode(list[PhpStmt] statements, i) = (code() | it + toCode(stmt, i) + code(nl()) | stmt <- statements);
public Code toCode(p: phpExprstmt(PhpExpr expr), int i) = code(s(i)) + toCode(expr, i) + codeEnd(";", expr);
public Code toCode(p: phpReturn(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("return", p) + code(" ") + toCode(expr, i) + codeEnd(";", expr);
public Code toCode(p: phpReturn(phpNoExpr()), int i) = code(s(i)) + code("return;", p);
public Code toCode(p: phpBreak(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("break", p) + code(" ") + toCode(expr, i) + codeEnd(";", expr);
public Code toCode(p: phpBreak(phpNoExpr()), int i) = code(s(i)) + code("break;", p);
public Code toCode(p: phpContinue(phpSomeExpr(PhpExpr expr)), int i) = code(s(i)) + code("continue", p) + code(" ") + toCode(expr, i) + codeEnd(";", expr);
public Code toCode(p: phpContinue(phpNoExpr()), int i) = code(s(i)) + code("continue;", p);
public Code toCode(p: phpConst(list[PhpConst] consts), int i) = 
	code(s(i)) + code("const", p) + code(" ") + glue([toCode(c, i) | c <- consts], code(",") + code(nl()) + code("<s(i)>      ")) + codeEnd(";", p);
public Code toCode(p: phpConst(str name, PhpExpr val), int i) = code(name, p) + code(" ") + code("=") + code(" ") + toCode(val, i);
public Code toCode(p: phpDeclaration(str key, PhpExpr val), int i) = code(key, p) + code("=", p) + toCode(val, i);
public Code toCode(p: phpEcho(list[PhpExpr] exprs), int i) = 
	code(s(i)) + code("echo", p) + code(" ") + toCode(exprs[0], i) + codeEnd(";", exprs[0]) when size(exprs) == 1;
public Code toCode(p: phpEcho(list[PhpExpr] exprs), int i) = 
	code(s(i)) + code("echo(", p) + glue([toCode(e, i) | e <- exprs], code(", ")) + codeEnd(");", last(exprs));
public Code toCode(p: phpGlobal(list[PhpExpr] exprs), int i) = 
	code(s(i)) + code("global", p) + code(" ") + glue([toCode(e, i) | e <- exprs], code(", ")) + codeEnd(";", last(exprs));
public Code toCode(p: phpGoto(str label), int i) = code(s(i)) + code("goto <label>;", p);
public Code toCode(p: phpLabel(str label), int i) = code(s(i)) + code("<label>:", p);
public Code toCode(p: phpHaltCompiler(str remainingText), int i) = code("<s(i)>__halt_compiler();<remainingText>", p);

public Code toCode(p: phpFor(list[PhpExpr] inits, list[PhpExpr] conds, list[PhpExpr] exprs, list[PhpStmt] body), int i) = 
	code(s(i)) + code("for", p) + code(" ") + code("(") + glue([toCode(e, i) | e <- inits], code(", ")) + 
	codeEnd(";", p) + code(" ") + glue([toCode(e, i) | e <- conds], code(", ")) + codeEnd(";", p) + code(" ") + 
	glue([toCode(e, i) | e <- exprs], code(", ", p)) + code(")") + code(" ") + code("{") + code(nl()) +
	toCode(body, i + 1) +
	code(s(i)) + 
	code("}");
	
public Code toCode(p: phpForeach(PhpExpr arrayExpr, PhpOptionExpr keyvar, bool byRef, PhpExpr asVar, list[PhpStmt] body), int i) =
	code(s(i)) + code("foreach", p) + code(" ") + code("(") + toCode(arrayExpr, i) + code(" ") + code("as", p) + code(" ") + key(keyvar, i) + code(ref(byRef), p) + toCode(asVar, i) + 
	code(")") + code(" ") + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}");
	
public Code toCode(p: phpFunction(str name, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName rType), int i) =
	code(s(i)) + code("function <ref(byRef)><name>(", p) + toCode(params) + code(")") + returnType(rType) + code(nl()) + code(s(i)) + 
	code("{") + code(nl()) + 
	toCode(body, i + 1) + code(s(i)) + 
	code("}");

public Code toCode(p: phpIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)], list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) =
	toCode(phpIf(cond, body, elseIfs, elseClause), p, i);
	
public Code toCode(p: phpIf(PhpExpr cond, list[PhpStmt] body, list[PhpElseIf] elseIfs, PhpOptionElse elseClause), int i) = toCode(p, p, i);

public Code toCode(p: phpIf(PhpExpr cond, list[PhpStmt] body, list[PhpElseIf] elseIfs, PhpOptionElse elseClause), PhpStmt sOrigin, int i) =
	code(s(i)) + code("if", sOrigin) + code(" ") + code("(") + toCode(cond, i) + code(")") + code(" ") + 
	code("{") + code(nl()) +
	toCode(body, i + 1) + 
	code(s(i)) +
	code("}") + 
	toElseIfs(elseIfs, i) +
	toElse(elseClause, i);

public Code toCode(p: phpDo(PhpExpr cond, list[PhpStmt] body), int i) = 
	code(s(i)) + code("do", p) + code(" ") + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + codeEnd("}") + code(" ") + code("while (", p) + toCode(cond, i) + codeEnd(");", p);

public Code toCode(p: phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	code(s(i)) + code("declare(", p) + glue([toCode(d, i) | d <- decls], code(", ")) + codeEnd(")") + codeEnd(";") + code(nl()) 
	when size(body) == 0;

public Code toCode(p: phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = 
	code(s(i)) + code("declare(", p) + glue([toCode(d, i) | d <- decls], code(", ")) + codeEnd(")", body[0]) + code(" ") + 
	code("{", body[0]) + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}") when size(body) > 0;

public Code toCode(p: phpInterfaceDef(interface: phpInterface(str interfaceName, list[PhpName] extending, list[PhpClassItem] members)), int i)  = code(nl()) +
	((interface@phpAnnotations?) ? (toCode(interface@phpAnnotations, i) + code(nl())) : code("")) + 
	code("<s(i)>interface <interfaceName><extends(extending)>", p) + code(nl()) + code("{") + 
		glue([toMethod(m, false, i + 1) | m <- members]) + 
	code("}");

public Code toCode(p: phpTraitDef(trait: phpTrait(str traitName, list[PhpClassItem] members)), int i) = code(nl()) +
	((trait@phpAnnotations?) ? (toCode(trait@phpAnnotations, i) + code(nl())) : code("")) +
	code(s(i)) + code("trait <traitName>", p) + code(nl()) + code("{") + 
		glue([toCode(m, i + 1) | m <- members]) + 
	code("}");

public Code toCode(p: phpStatic(list[PhpStaticVar] vars), int i) =
	code(s(i)) + code("static", p) + code(" ") + glue([toCode(v, i) | v <- vars], code(",") + code(nl()) + code("<s(i)>       ")) + codeEnd(";", p);

public Code toCode(p: phpStaticVar(str name, PhpOptionExpr defValue), int i) = 
	code("$<name>", p) + defaultVal(defValue);

public Code toCode(p: phpSwitch(PhpExpr cond, list[PhpCase] cases), int i) =
	code(s(i)) +
	code("switch (", p) + toCode(cond, i) + code(")") + code(" ") + code("{") + code(nl()) +
		glue([toCode(c, i + 1) | c <- cases]) +
	code(s(i)) + 
	code("}");

public Code toCode(p: phpCase(phpSomeExpr(PhpExpr expr), list[PhpStmt] body), int i) = 
	code(s(i)) + code("case", p) + code(" ") + toCode(expr, i) + codeEnd(":", expr) + code(nl()) + toCode(body, i + 1);

public Code toCode(p: phpCase(phpNoExpr(), list[PhpStmt] body), int i) = 
	code(s(i)) + code("default:", p) + code(nl()) + toCode(body, i + 1);

public Code toCode(p: phpThrow(PhpExpr expr), int i) = code(s(i)) + code("throw", p) + code(" ") + toCode(expr, i) + codeEnd(";", p);

public Code toCode(p: phpTryCatch(list[PhpStmt] body, list[PhpCatch] catches), int i) =
	code(s(i)) + code("try", p) + code(" ") + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}") + glue([toCode(c, i) | c <- catches]);

public Code toCode(p: phpTryCatchFinally(list[PhpStmt] body, list[PhpCatch] catches, list[PhpStmt] final), int i) =
	code(s(i)) + code("try", p) + code(" ") + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}") + 
		glue([toCode(c, i) | c <- catches]) + code(" ") + code("finally") + code(" ") + code("{") + code(nl()) + toCode(final, i + 1) + code(s(i)) + code("}");

public Code toCode(p: phpCatch(phpName(str xtype), str varName, list[PhpStmt] body), int i) =
	code(s(i) + " ") + code("catch (<xtype> $<varName>) {", p) + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}");

public Code toCode(p: phpUnset(list[PhpExpr] unsetVars), int i) = 
	code(s(i)) + code("unset(", p) + glue([toCode(v, i) | v <- unsetVars], code(", ")) + codeEnd(");", p);

public Code toCode(p: phpWhile(PhpExpr cond, list[PhpStmt] body), int i) =
	code(s(i)) + 
	code("while (", p) + toCode(cond, i) + code(")") + code(" ") + 
	code("{") + code(nl()) + 
	toCode(body, i + 1) + code(s(i)) + 
	code("}");

public Code toCode(p: phpEmptyStmt(), int i) = code(s(i)) + code(";", p);

public Code toCode(p: phpBlock(list[PhpStmt] body), int i) = code(s(i)) + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + code("}");

public Code toCode(p: phpNewLine(), int i) = code("", p);

private Code defaultVal(p: phpSomeExpr(PhpExpr expr)) = code(" ") + code("=", p) + code(" ") + toCode(expr, 0);
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

private Code toElseIf(p: phpElseIf(PhpExpr cond, [phpBlock(list[PhpStmt] body)]), int i) = toElseIf(phpElseIf(cond, body), p, i);
private Code toElseIf(p: phpElseIf(PhpExpr cond, list[PhpStmt] body), int i) = toElseIf(p, p, i);

private Code toElseIf(p: phpElseIf(PhpExpr cond, list[PhpStmt] body), PhpElseIf eOrigin, int i) = 
	code(" ") + code("elseif", eOrigin) + code(" ") + code("(", cond) + toCode(cond, i) + codeEnd(")", cond) + code(" ") + 
	code("{") + code(nl()) + toCode(body, i + 1) + 
	code(s(i)) + 
	codeEnd("}", eOrigin);
	
private Code toElse(phpNoElse(), int i) = code("");
private Code toElse(p: phpSomeElse(phpElse([phpBlock(list[PhpStmt] body)])), int i) = toElse(phpSomeElse(phpElse(body)), p, i);
private Code toElse(p: phpSomeElse(phpElse(list[PhpStmt] body)), int i) = toElse(p, p, i);
private Code toElse(phpSomeElse(p: phpElse(list[PhpStmt] body)), PhpOptionElse eOrigin, int i) = 
	code(" ") +
	code("else", eOrigin) + code(" ") + 
	code("{") + code(nl()) + toCode(body, i + 1) + 
	code(s(i)) +
	codeEnd("}", eOrigin);

private Code key(phpNoExpr(), _) = code("");
private Code key(p: phpSomeExpr(PhpExpr expr), int i) = toCode(expr, i) + code(" ") + code("=\>", p) + code(" ");

private Code returnType(phpNoName()) = code("");
private Code returnType(p: phpSomeName(phpName(str name))) = code(":", p) + code(" ") + code(name, p);
