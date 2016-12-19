module Test::Compiler::PHP::Methods

import Compiler::PHP::Methods;
import Syntax::Abstract::PHP;

test bool shouldCompileSimpleMethod() = 
	toCode(phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName()), 0) ==
	"\npublic function __construct()\n{\n}";

test bool shouldCompileSimpleMethodByReference() = 
	toCode(phpMethod("test", {phpPublic()}, true, [], [], phpNoName()), 0) ==
	"\npublic function &test()\n{\n}";

test bool shouldCompileSimpleMethodWithArguments() = 
	toCode(phpMethod("__construct", {phpPublic()}, false, [
		phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], phpNoName()), 0) ==
	"\npublic function __construct(int $param1)\n{\n}";

test bool shouldCompileSimpleMethodWithArguments() = 
	toCode(phpMethod("__construct", {phpPublic()}, false, [], [
		phpExprstmt(phpScalar(phpBoolean(true)))
	], phpNoName()), 0) ==
	"\npublic function __construct()\n{\n    true;\n}";


test bool shouldCompileSimpleMethodWithReturnType() = 
	toCode(phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("DateTime"))), 0) ==
	"\npublic function test(): DateTime\n{\n}";
	
