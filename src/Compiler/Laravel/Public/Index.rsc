module Compiler::Laravel::Public::Index

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createIndexFile() = toCode(phpScript([
	phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../bootstrap/autoload.php")), phpConcat()), phpRequire())),
	phpExprstmt(phpAssign(phpVar("app"), phpInclude(
		phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../bootstrap/app.php")), phpConcat()), 
		phpRequireOnce()))
	),
	phpExprstmt(phpAssign(phpVar("kernel"), phpMethodCall(phpVar("app"), phpName(phpName("make")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("Illuminate\\Contracts\\Http\\Kernel")), "class"), false)
		]))
	),
	phpExprstmt(phpAssign(phpVar("response"), phpMethodCall(phpVar("kernel"), phpName(phpName("handle")), [
			phpActualParameter(phpAssign(phpVar("request"), 
				phpStaticCall(phpName(phpName("Illuminate\\Http\\Request")), phpName(phpName("capture")), [])
			), false)
		]))
	),
	phpExprstmt(phpMethodCall(phpVar("response"), phpName(phpName("send")), [])),
	phpExprstmt(phpMethodCall(phpVar("kernel"), phpName(phpName("terminate")), [
		phpActualParameter(phpVar("request"), false),
		phpActualParameter(phpVar("response"), false)
	]))
]));

