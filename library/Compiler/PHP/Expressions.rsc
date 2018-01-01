module Compiler::PHP::Expressions

import Compiler::PHP::Code;
import Compiler::PHP::Operations;
import Compiler::PHP::ByRef;
import Utils::Glue;
import Compiler::PHP::CastType;
import Compiler::PHP::Statements;
import Compiler::PHP::Params;
import Utils::NewLine;
import Utils::Indentation;
import Compiler::PHP::IncludeType;
import Syntax::Abstract::PHP;
import List;

public Code toCode(p: phpScalar(phpClassConstant()), int i) = code("__CLASS__", p);
public Code toCode(p: phpScalar(phpDirConstant()), int i) = code("__DIR__", p);
public Code toCode(p: phpScalar(phpFileConstant()), int i) = code("__FILE__", p);
public Code toCode(p: phpScalar(phpFuncConstant()), int i) = code("__FUNCTION__", p);
public Code toCode(p: phpScalar(phpLineConstant()), int i) = code("__LINE__", p);
public Code toCode(p: phpScalar(phpMethodConstant()), int i) = code("__METHOD__", p);
public Code toCode(p: phpScalar(phpNamespaceConstant()), int i) = code("__NAMESPACE__", p);
public Code toCode(p: phpScalar(phpTraitConstant()), int i) = code("__TRAIT__", p);
public Code toCode(p: phpScalar(phpNull()), int i) = code("null", p);
public Code toCode(p: phpScalar(phpFloat(real realVal)), int i) = code("<realVal>", p);
public Code toCode(p: phpScalar(phpInteger(int intVal)), int i) = code("<intVal>", p);
public Code toCode(p: phpScalar(phpString(str strVal)), int i) = code("\"<strVal>\"", p);
public Code toCode(p: phpScalar(phpBoolean(true)), int i) = code("true", p);
public Code toCode(p: phpScalar(phpBoolean(false)), int i) = code("false", p);
public Code toCode(p: phpScalar(phpEncapsed(list[PhpExpr] exprs)), int i) = (code() | it + toCode(expr, i) | expr <- exprs);
public Code toCode(p: phpScalar(phpEncapsedStringPart(str strVal)), int i) = code(strVal, p);
public Code toCode(p: phpNoExpr(), int i) = code("", p);
public Code toCode(p: phpExpr(PhpExpr expr), int i) = toCode(expr, i);
public Code toCode(p: phpName(phpName(str name)), int i) = code(name, p);
public Code toCode(p: phpSomeExpr(PhpExpr expr), int i) = toCode(expr, i);
public Code toCode(p: phpArray(list[PhpArrayElement] items), int l) = code("[") + glue([toCode(item, 0) | item <- items], code(", ")) + code("]");
public Code toCode(p: phpVar(phpName(phpName(str name))), int i) = code("$<name>", p);
public Code toCode(p: phpVar(phpExpr(PhpExpr expr)), int i) = code("$", p) + toCode(expr, i);
public Code toCode(p: phpFetchArrayDim(PhpExpr var, phpNoExpr()), int i) = toCode(var, i) + code("[]", p);
public Code toCode(p: phpFetchArrayDim(PhpExpr var, phpSomeExpr(PhpExpr expr)), int i) = toCode(var, i) + code("[") + toCode(expr, i) + code("]");
public Code toCode(p: phpFetchClassConst(phpName(phpName(str class)), str constantName), int i) = code("<class>::<constantName>", p);
public Code toCode(p: phpFetchClassConst(phpExpr(PhpExpr expr), str constantName), int i) = toCode(expr, i) + code("::<constantName>", p);
public Code toCode(p: phpAssign(PhpExpr assignTo, PhpExpr assignExpr), int i) = toCode(assignTo, i) + code(" ") + code("=", p) + code(" ") + toCode(assignExpr, i);
public Code toCode(p: phpRefAssign(PhpExpr assignTo, PhpExpr assignExpr), int i) = toCode(assignTo, i) + code(" ") + code("=&", p) + code(" ") + toCode(assignExpr, i);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpPreInc()), int i) = code("++", p) + toCode(operand, i);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpPostInc()), int i) = toCode(operand, i) + code("++", p);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpPreDec()), int i) = code("--", p) + toCode(operand, i);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpPostDec()), int i) = toCode(operand, i) + code("--", p);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpUnaryPlus()), int i) = code("+", p) + toCode(operand, i);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpUnaryMinus()), int i) = code("-", p) + toCode(operand, i);
public Code toCode(phpUnaryOperation(PhpExpr operand, p: phpBooleanNot()), int i) = code("!", p) + toCode(operand, i);
public Code toCode(p: phpActualParameter(PhpExpr expr, bool byRef), int i) = code(ref(byRef), p) + toCode(expr, i);

public Code toCode(p: phpActualParameter(PhpExpr expr, bool byRef, bool isVariadic), int i) = 
    code(ref(byRef), p) + 
    code("<isVariadic ? "..." : "">", p) + 
    toCode(expr, i);
    
public Code toCode(p: phpClone(PhpExpr expr), int i) = code("clone", p) + code(" ") + toCode(expr, i);
public Code toCode(p: phpFetchConst(phpName(str name)), int i) = code(name, p);
public Code toCode(p: phpEmpty(PhpExpr expr), int i) = code("empty(", p) + toCode(expr, i) + code(")");
public Code toCode(p: phpSuppress(PhpExpr expr), int i) = code("@", p) + toCode(expr, i);
public Code toCode(p: phpEval(PhpExpr expr), int i) = code("eval(", p) + toCode(expr, i) + code(")");
public Code toCode(p: phpExit(phpNoExpr()), int i) = code("exit", p);
public Code toCode(p: phpExit(phpSomeExpr(PhpExpr expr)), int i) = code("exit(", p) + toCode(expr, i) + code(")");
public Code toCode(p: phpPropertyFetch(PhpExpr target, PhpNameOrExpr propertyName), int i) = toCode(target, i) + codeEnd("-\>", target) + toCode(propertyName, i);
public Code toCode(p: phpInclude(PhpExpr expr, PhpIncludeType includeType), int i) = toCode(includeType) + code(" ") + toCode(expr, i);
public Code toCode(p: phpInstanceOf(PhpExpr expr, PhpNameOrExpr toCompare), int i) = toCode(expr, i) + code(" ") + code("instanceof", p) + code(" ") + toCode(toCompare, i);
public Code toCode(p: phpIsSet(list[PhpExpr] exprs), int i) = code("isset(", p) + glue([toCode(expr, i) | expr <- exprs], code(", ")) + code(")");
public Code toCode(p: phpPrint(PhpExpr expr), int i) = code("print", p) + code(" ") + toCode(expr, i);
public Code toCode(pr: phpShellExec(list[PhpExpr] parts), int i) = code("`", pr) + glue([toCode(p, i)| p <- parts]) + codeEnd("`");
public Code toCode(p: phpTernary(PhpExpr cond, phpSomeExpr(PhpExpr ifBranch), PhpExpr elseBranch), int i) = 
	toCode(cond, i) + code(" ") + code("?", p) + code(" ") + toCode(ifBranch, i) + code(" ") + code(":", p) + code(" ") + toCode(elseBranch, i);
public Code toCode(p: phpTernary(PhpExpr cond, phpNoExpr(), PhpExpr elseBranch), int i) = toCode(cond, i) + code(" ") + code("?:") + code(" ") + toCode(elseBranch, i);
public Code toCode(p: phpStaticPropertyFetch(PhpNameOrExpr className, PhpNameOrExpr propertyName), int i) = 
	toCode(className, i) + code("::$", p) + toCode(propertyName, i);
public Code toCode(p: phpYield(phpNoExpr(), phpSomeExpr(PhpExpr val)), int i) = code("yield", p) + code(" ") + toCode(val, i);
public Code toCode(p: phpYield(phpSomeExpr(PhpExpr key), phpSomeExpr(PhpExpr val)), int i) = code("yield", p) + code(" ") + toCode(key, i) + code(" =\> ", p) + toCode(val, i);
public Code toCode(p: phpYield(phpNoExpr(), phpNoExpr()), int i) = code("yield", p);
public Code toCode(p: phpListExpr(list[PhpOptionExpr] listExprs), int i) = code("[") + glue([toCode(e, i) | e <- listExprs], code(", ")) + code("]");
public Code toCode(p: phpBracket(PhpOptionExpr bracketExpr), int i) = code("(") + toCode(bracketExpr, i) + codeEnd(")");

public Code toCode(pr: phpMethodCall(PhpExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters), int i) =
	toCode(target, i) + code(nl()) + code(s(i + 1)) + codeEnd("-\>", target) + toCode(methodName, i) + codeEnd("()", methodName)
	when size(parameters) == 0;

public Code toCode(pr: phpMethodCall(PhpExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters), int i) =
	toCode(target, i) + code(nl()) + code(s(i + 1)) + codeEnd("-\>", target) + toCode(methodName, i) + codeEnd("(", methodName) + glue([toCode(p, i + 1) | p <- parameters], code(", ")) + 
	codeEnd(")", last(parameters))
	when size(parameters) > 0;

public Code toCode(pr: phpStaticCall(PhpNameOrExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters), int i) = 
    toCode(target, i) + codeEnd("::", target) + toCode(methodName, i + 1) + codeEnd("(", methodName) + glue([toCode(p, i) | p <- parameters], code(", ")) + codeEnd(")");
	
public Code toCode(pr: phpCall(PhpNameOrExpr funName, list[PhpActualParameter] parameters), int i) = 
	toCode(funName, i) + code("(") + glue([toCode(p, i) | p <- parameters], code(", ")) + codeEnd(")");

public Code toCode(pr: phpClosure(
			list[PhpStmt] statements, 
			list[PhpParam] params, 
			list[PhpClosureUse] uses, 
			bool byRef, 
			bool static), int i) = 
	code("<static ? "static " : ""><ref(byRef)>function (", pr) + 
	glue([toCode(p) | p <- params], code(", ")) + 
	code(")") +
	closureUses(uses) +
	code(" ") + code("{") + code(nl()) + 
	toCode(statements, i + 1) + 
	code(s(i)) + 
	code("}");

public Code toCode(pr: phpNew(PhpNameOrExpr className, list[PhpActualParameter] parameters), int i) = 
	code("new", pr) + code(" ") + toCode(className, i) + code("(") + glue([toCode(p, i) | p <- parameters], code(", ")) + codeEnd(")");
	
public Code toCode(p: phpCast(PhpCastType castType, PhpExpr expr), int i) = code("(") + toCode(castType) + codeEnd(")") + code(" ") + toCode(expr, i);

public Code toCode(p: phpBinaryOperation(PhpExpr left, PhpExpr right, PhpOp operation), int i) = 
	toCode(left, i) + code(" ") + toCode(operation) + code(" ") + toCode(right, i);

public Code toCode(pr: phpListAssign(list[PhpOptionExpr] assignsTo, PhpExpr assignExpr), int i) = 
	code("list(", pr) + glue([toCode(p, i) | p <- assignsTo], code(", ")) + code(")") + code(" ") + code("=", pr) + code(" ") + toCode(assignExpr, i);
	
public Code toCode(p: phpAssignWOp(PhpExpr assignTo, PhpExpr assignExpr, PhpOp operation), int i) = 
	toCode(assignTo, i) + code(" ") + toCode(operation) + code("=", operation) + code(" ") + toCode(assignExpr, i);

public Code toCode(p: phpArrayElement(PhpOptionExpr key, PhpExpr val, bool byRef), int i) = 
	arrayKey(key, i) + code(ref(byRef), p) + toCode(val, i);

public Code toCode(p: phpClosureUse(PhpExpr varName, bool byRef)) = code(ref(byRef), p) + toCode(varName, 0);

private Code closureUses(list[PhpClosureUse] uses) = code("") when size(uses) == 0;
private Code closureUses(list[PhpClosureUse] uses) = code(" ") + code("use", uses[0]) + code(" ") + code("(") + glue([toCode(u) | u <- uses], code(", ")) + codeEnd(")") when size(uses) > 0;

private Code arrayKey(p: phpSomeExpr(PhpExpr expr), int i) = toCode(expr, i) + code(" ") + code("=\>", p) + code(" ");
private Code arrayKey(phpNoExpr(), int i) = code("");
