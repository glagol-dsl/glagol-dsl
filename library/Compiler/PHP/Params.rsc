module Compiler::PHP::Params

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::ByRef;
import Utils::Glue;

public Code toCode(p: phpParam(
		str paramName, 
		PhpOptionExpr paramDefault, 
		PhpOptionName \type, 
		bool byRef,
		bool isVariadic)) =
	paramType(\type) + code(ref(byRef), p) + 
	code("<isVariadic ? "..." : "">", p) + 
	code("$<paramName>", p) + 
	defaultVal(paramDefault);

public Code toCode(list[PhpParam] params) = glue([toCode(p) | p <- params], code(", "));

private Code paramType(p: phpSomeName(phpName(str paramType))) = code(paramType + " ", p);
private Code paramType(p: phpNoName()) = code("");

private Code defaultVal(p: phpSomeExpr(PhpExpr expr)) = code(" = ", p) + toCode(expr, 0);
private Code defaultVal(p: phpNoExpr()) = code("");
