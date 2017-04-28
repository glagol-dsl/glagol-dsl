module Compiler::Laravel::Bootstrap::Autoload

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createAutoloadFile() = toCode(phpScript([
	phpExprstmt(phpCall(phpName(phpName("define")), [
		phpActualParameter(phpScalar(phpString("LARAVEL_START")), false),
		phpActualParameter(phpCall(phpName(phpName("microtime")), [
			phpActualParameter(phpScalar(phpBoolean(true)), false)
		]), false)
	])),
	phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../vendor/autoload.php")), phpConcat()), phpRequire())),
	phpExprstmt(phpAssign(phpVar("compiledPath"), phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/cache/compiled.php")), phpConcat()))),
	phpIf(
		phpCall(phpName(phpName("file_exists")), [phpActualParameter(phpVar("compiledPath"), false)]), 
		[phpExprstmt(
			phpInclude(phpVar("compiledPath"), phpRequire())
		)],
		[], 
		phpNoElse()
	)
]));
