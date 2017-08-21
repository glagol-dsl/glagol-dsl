module Compiler::Laravel::Public::Index

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createIndexFile() = toCode(phpScript([
	phpExprstmt(phpAssign(phpVar("app"), phpInclude(
		phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../bootstrap/app.php")), phpConcat()), 
		phpRequireOnce()))
	),
	phpExprstmt(phpMethodCall(phpVar("app"), phpName(phpName("run")), []))
]));

