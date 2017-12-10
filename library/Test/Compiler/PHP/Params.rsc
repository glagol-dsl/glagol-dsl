module Test::Compiler::PHP::Params

import Compiler::PHP::Code;
import Compiler::PHP::Params;
import Syntax::Abstract::PHP;

test bool shouldCompileToSimpleTypelessParam() = 
	implode(toCode(phpParam("param", phpNoExpr(), phpNoName(), false, false))) == "$param";

test bool shouldCompileToTypedParam() = 
	implode(toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), false, false))) == "int $param";
	
test bool shouldCompileToTypedParamByRef() = 
	implode(toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), true, false))) == "int &$param";

test bool shouldCompileToTypedVariadicParam() = 
	implode(toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), false, true))) == "int ...$param";

test bool shouldCompileToTypedParamWithDefaultValue() = 
	implode(toCode(phpParam("param", phpSomeExpr(phpScalar(phpInteger(23))), phpSomeName(phpName("int")), false, false))) == 
	"int $param = 23";
	
test bool shouldCompileToTypedParamVariadicByRef() = 
	implode(toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), true, true))) == "int &...$param";
	
test bool shouldCompileToFullParam() = 
	implode(toCode(phpParam("param", phpSomeExpr(phpScalar(phpString("blah"))), phpSomeName(phpName("string")), true, true))) == 
	"string &...$param = \"blah\"";
