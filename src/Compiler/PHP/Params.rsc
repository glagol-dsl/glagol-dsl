module Compiler::PHP::Params

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;

public str toCode(phpParam(
		str paramName, 
		PhpOptionExpr paramDefault, 
		PhpOptionName \type, 
		bool byRef,
		bool isVariadic)) =
	"<paramType(\type)><byRef ? "&" : "">" + 
	"<isVariadic ? "..." : "">" + 
	"$<paramName><defaultVal(paramDefault)>";

private str paramType(phpSomeName(phpName(str paramType))) = paramType + " ";
private str paramType(phpNoName()) = "";

private str defaultVal(phpSomeExpr(PhpExpr expr)) = " = <toCode(expr)>";
private str defaultVal(phpNoExpr()) = "";
