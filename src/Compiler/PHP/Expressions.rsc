module Compiler::PHP::Expressions

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

public str toCode(phpScalar(phpClassConstant()), int i) = "__CLASS__";
public str toCode(phpScalar(phpDirConstant()), int i) = "__DIR__";
public str toCode(phpScalar(phpFileConstant()), int i) = "__FILE__";
public str toCode(phpScalar(phpFuncConstant()), int i) = "__FUNCTION__";
public str toCode(phpScalar(phpLineConstant()), int i) = "__LINE__";
public str toCode(phpScalar(phpMethodConstant()), int i) = "__METHOD__";
public str toCode(phpScalar(phpNamespaceConstant()), int i) = "__NAMESPACE__";
public str toCode(phpScalar(phpTraitConstant()), int i) = "__TRAIT__";
public str toCode(phpScalar(phpNull()), int i) = "null";
public str toCode(phpScalar(phpFloat(real realVal)), int i) = "<realVal>";
public str toCode(phpScalar(phpInteger(int intVal)), int i) = "<intVal>";
public str toCode(phpScalar(phpString(str strVal)), int i) = "\"<strVal>\"";
public str toCode(phpScalar(phpBoolean(true)), int i) = "true";
public str toCode(phpScalar(phpBoolean(false)), int i) = "false";
public str toCode(phpScalar(phpEncapsed(list[PhpExpr] exprs)), int i) = glue([toCode(expr, i) | expr <- exprs]);
public str toCode(phpScalar(phpEncapsedStringPart(str strVal)), int i) = strVal;
public str toCode(phpNoExpr(), int i) = "";
public str toCode(phpExpr(PhpExpr expr), int i) = toCode(expr, i);
public str toCode(phpName(phpName(str name)), int i) = name;
public str toCode(phpSomeExpr(PhpExpr expr), int i) = toCode(expr, i);
public str toCode(phpArray(list[PhpArrayElement] items), int l) = "[<glue([toCode(i, l) | i <- items], ", ")>]";
public str toCode(phpVar(phpName(phpName(str name))), int i) = "$<name>";
public str toCode(phpVar(phpExpr(PhpExpr expr)), int i) = "$<toCode(expr, i)>";
public str toCode(phpFetchArrayDim(PhpExpr var, phpNoExpr()), int i) = "<toCode(var, i)>[]";
public str toCode(phpFetchArrayDim(PhpExpr var, phpSomeExpr(PhpExpr expr)), int i) = "<toCode(var, i)>[<toCode(expr, i)>]";
public str toCode(phpFetchClassConst(phpName(phpName(str class)), str constantName), int i) = "<class>::<constantName>";
public str toCode(phpFetchClassConst(phpExpr(PhpExpr expr), str constantName), int i) = "<toCode(expr, i)>::<constantName>";
public str toCode(phpAssign(PhpExpr assignTo, PhpExpr assignExpr), int i) = "<toCode(assignTo, i)> = <toCode(assignExpr, i)>";
public str toCode(phpRefAssign(PhpExpr assignTo, PhpExpr assignExpr), int i) = "<toCode(assignTo, i)> =& <toCode(assignExpr, i)>";
public str toCode(phpUnaryOperation(PhpExpr operand, phpPreInc()), int i) = "++<toCode(operand, i)>";
public str toCode(phpUnaryOperation(PhpExpr operand, phpPostInc()), int i) = "<toCode(operand, i)>++";
public str toCode(phpUnaryOperation(PhpExpr operand, phpPreDec()), int i) = "--<toCode(operand, i)>";
public str toCode(phpUnaryOperation(PhpExpr operand, phpPostDec()), int i) = "<toCode(operand, i)>--";
public str toCode(phpUnaryOperation(PhpExpr operand, phpUnaryPlus()), int i) = "+<toCode(operand, i)>";
public str toCode(phpUnaryOperation(PhpExpr operand, phpUnaryMinus()), int i) = "-<toCode(operand, i)>";
public str toCode(phpActualParameter(PhpExpr expr, bool byRef), int i) = "<ref(byRef)><toCode(expr, i)>";

public str toCode(phpActualParameter(PhpExpr expr, bool byRef, bool isVariadic), int i) = 
    "<ref(byRef)>" + 
    "<isVariadic ? "..." : "">" + 
    "<toCode(expr, i)>";
    
public str toCode(phpClone(PhpExpr expr), int i) = "clone <toCode(expr, i)>";
public str toCode(phpFetchConst(phpName(str name)), int i) = "<name>";
public str toCode(phpEmpty(PhpExpr expr), int i) = "empty(<toCode(expr, i)>)";
public str toCode(phpSuppress(PhpExpr expr), int i) = "@<toCode(expr, i)>";
public str toCode(phpEval(PhpExpr expr), int i) = "eval(<toCode(expr, i)>)";
public str toCode(phpExit(phpNoExpr()), int i) = "exit";
public str toCode(phpExit(phpSomeExpr(PhpExpr expr)), int i) = "exit(<toCode(expr, i)>)";
public str toCode(phpPropertyFetch(PhpExpr target, PhpNameOrExpr propertyName), int i) = "<toCode(target, i)>-\><toCode(propertyName, i)>";
public str toCode(phpInclude(PhpExpr expr, PhpIncludeType includeType), int i) = "<toCode(includeType)> <toCode(expr, i)>";
public str toCode(phpInstanceOf(PhpExpr expr, PhpNameOrExpr toCompare), int i) = "<toCode(expr, i)> instanceof <toCode(toCompare, i)>";
public str toCode(phpIsSet(list[PhpExpr] exprs), int i) = "isset(<glue([toCode(expr, i) | expr <- exprs], ", ")>)";
public str toCode(phpPrint(PhpExpr expr), int i) = "print <toCode(expr, i)>";
public str toCode(phpShellExec(list[PhpExpr] parts), int i) = "`<glue([toCode(p, i) | p <- parts])>`";
public str toCode(phpTernary(PhpExpr cond, phpSomeExpr(PhpExpr ifBranch), PhpExpr elseBranch), int i) = "<toCode(cond, i)> ? <toCode(ifBranch, i)> : <toCode(elseBranch, i)>";
public str toCode(phpTernary(PhpExpr cond, phpNoExpr(), PhpExpr elseBranch), int i) = "<toCode(cond, i)> ?: <toCode(elseBranch, i)>";
public str toCode(phpStaticPropertyFetch(PhpNameOrExpr className, PhpNameOrExpr propertyName), int i) = "<toCode(className, i)>::$<toCode(propertyName, i)>";
public str toCode(phpYield(phpNoExpr(), phpSomeExpr(PhpExpr val)), int i) = "yield <toCode(val, i)>";
public str toCode(phpYield(phpSomeExpr(PhpExpr key), phpSomeExpr(PhpExpr val)), int i) = "yield <toCode(key, i)> =\> <toCode(val, i)>";
public str toCode(phpYield(phpNoExpr(), phpNoExpr()), int i) = "yield";
public str toCode(phpListExpr(list[PhpOptionExpr] listExprs), int i) = "[<glue([toCode(e, i) | e <- listExprs], ", ")>]";
public str toCode(phpBracket(PhpOptionExpr bracketExpr), int i) = "(<toCode(bracketExpr, i)>)";

public str toCode(phpMethodCall(PhpExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters), int i) =
	"<toCode(target, i)>-\><toCode(methodName, i)>(<glue([toCode(p, i) | p <- parameters], ", ")>)";
	
public str toCode(phpStaticCall(PhpNameOrExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters), int i) = 
    "<toCode(target, i)>::<toCode(methodName, i)>(<glue([toCode(p, i) | p <- parameters], ", ")>)";
	
public str toCode(phpCall(PhpNameOrExpr funName, list[PhpActualParameter] parameters), int i) = 
	"<toCode(funName, i)>(<glue([toCode(p, i) | p <- parameters], ", ")>)";

public str toCode(phpClosure(
			list[PhpStmt] statements, 
			list[PhpParam] params, 
			list[PhpClosureUse] uses, 
			bool byRef, 
			bool static), int i) = 
	"<static ? "static " : ""><ref(byRef)>function (<glue([toCode(p) | p <- params], ", ")>)" + 
	"<closureUses(uses)> {<nl()><toCode(statements, i + 1)><s(i)>}";

public str toCode(phpNew(PhpNameOrExpr className, list[PhpActualParameter] parameters), int i) = 
	"new <toCode(className, i)>(<glue([toCode(p, i) | p <- parameters], ", ")>)";
	
public str toCode(phpCast(PhpCastType castType, PhpExpr expr), int i) = "(<toCode(castType)>) <toCode(expr, i)>";

public str toCode(phpBinaryOperation(PhpExpr left, PhpExpr right, PhpOp operation), int i) = 
	"<toCode(left, i)> <toCode(operation)> <toCode(right, i)>";

public str toCode(phpListAssign(list[PhpOptionExpr] assignsTo, PhpExpr assignExpr), int l) = 
	"list(<glue([toCode(i, l) | i <- assignsTo], ", ")>) = <toCode(assignExpr, l)>";
	
public str toCode(phpAssignWOp(PhpExpr assignTo, PhpExpr assignExpr, PhpOp operation), int i) = 
	"<toCode(assignTo, i)> <toCode(operation)>= <toCode(assignExpr, i)>";

public str toCode(phpArrayElement(PhpOptionExpr key, PhpExpr val, bool byRef), int i) = 
	"<arrayKey(key, i)><ref(byRef)><toCode(val, i)>";

public str toCode(phpClosureUse(PhpExpr varName, bool byRef)) = "<ref(byRef)><toCode(varName, 0)>";

private str closureUses(list[PhpClosureUse] uses) = "" when size(uses) == 0;
private str closureUses(list[PhpClosureUse] uses) = " use (<glue([toCode(u) | u <- uses], ", ")>)" when size(uses) > 0;

private str arrayKey(phpSomeExpr(PhpExpr expr), int i) = "<toCode(expr, i)> =\> ";
private str arrayKey(phpNoExpr(), int i) = "";
