module Test::Compiler::PHP::Methods

import Compiler::PHP::Code;
import Compiler::PHP::Methods;
import Syntax::Abstract::PHP;

test bool shouldCompileSimpleMethod() = 
	implode(toCode(phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName()), 0)) ==
	"\npublic function __construct()\n{\n}\n";

test bool shouldCompileSimpleMethodByReference() = 
	implode(toCode(phpMethod("test", {phpPublic()}, true, [], [], phpNoName()), 0)) ==
	"\npublic function &test()\n{\n}\n";

test bool shouldCompileSimpleMethodWithArguments() = 
	implode(toCode(phpMethod("__construct", {phpPublic()}, false, [
		phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], phpNoName()), 0)) ==
	"\npublic function __construct(int $param1)\n{\n}\n";

test bool shouldCompileSimpleMethodWithoutArgumentsAndSimpleExprStmt() = 
	implode(toCode(phpMethod("__construct", {phpPublic()}, false, [], [
		phpExprstmt(phpScalar(phpBoolean(true)))
	], phpNoName()), 0)) ==
	"\npublic function __construct()\n{\n    true;\n}\n";


test bool shouldCompileSimpleMethodWithReturnType() = 
	implode(toCode(phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("DateTime"))), 0)) ==
	"\npublic function test(): DateTime\n{\n}\n";
	
// TODO add tests for annotated methods
