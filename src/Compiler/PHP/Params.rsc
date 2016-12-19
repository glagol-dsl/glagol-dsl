module Compiler::PHP::Params

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;

public str toCode(phpParam(
	str paramName, 
	PhpOptionExpr paramDefault, 
	phpSomeName(phpName(str paramType)), 
	bool byRef, 
	bool isVariadic)) = "<paramType> <isVariadic ? "..." : ""><byRef ? "&" : "">$<paramName><defaultVal(paramDefault)>";

private str defaultVal(phpSomeExpr(PhpExpr expr)) = " = <toCode(expr)>";
private str defaultVal(phpNoExpr()) = "";
