module Test::Compiler::PHP::Params

import Compiler::PHP::Params;
import Syntax::Abstract::PHP;

test bool shouldCompileToSimpleTypelessParam() = 
	toCode(phpParam("param", phpNoExpr(), phpNoName(), false, false)) == "$param";

test bool shouldCompileToTypedParam() = 
	toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), false, false)) == "int $param";
	
test bool shouldCompileToTypedParamByRef() = 
	toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), true, false)) == "int &$param";

test bool shouldCompileToTypedVariadicParam() = 
	toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), false, true)) == "int ...$param";

test bool shouldCompileToTypedParamWithDefaultValue() = 
	toCode(phpParam("param", phpSomeExpr(phpScalar(phpInteger(23))), phpSomeName(phpName("int")), false, false)) == 
	"int $param = 23";
	
test bool shouldCompileToTypedParamVariadicByRef() = 
	toCode(phpParam("param", phpNoExpr(), phpSomeName(phpName("int")), true, true)) == "int &...$param";
	
test bool shouldCompileToFullParam() = 
	toCode(phpParam("param", phpSomeExpr(phpScalar(phpString("blah"))), phpSomeName(phpName("string")), true, true)) == 
	"string &...$param = \"blah\"";
