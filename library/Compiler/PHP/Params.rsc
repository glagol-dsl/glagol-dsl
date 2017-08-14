module Compiler::PHP::Params

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::ByRef;
import Utils::Glue;

public str toCode(phpParam(
		str paramName, 
		PhpOptionExpr paramDefault, 
		PhpOptionName \type, 
		bool byRef,
		bool isVariadic)) =
	"<paramType(\type)><ref(byRef)>" + 
	"<isVariadic ? "..." : "">" + 
	"$<paramName><defaultVal(paramDefault)>";

public str toCode(list[PhpParam] params) = glue([toCode(p) | p <- params], ", ");

private str paramType(phpSomeName(phpName(str paramType))) = paramType + " ";
private str paramType(phpNoName()) = "";

private str defaultVal(phpSomeExpr(PhpExpr expr)) = " = <toCode(expr, 0)>";
private str defaultVal(phpNoExpr()) = "";
