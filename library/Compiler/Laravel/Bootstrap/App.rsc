module Compiler::Laravel::Bootstrap::App

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createAppFile() = toCode(phpScript([
	phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../vendor/autoload.php")), phpConcat()), phpRequire())),
	phpExprstmt(phpAssign(phpVar("app"), phpNew(phpName(phpName("\\Laravel\\Lumen\\Application")), [
		phpActualParameter(phpCall(phpName(phpName("realpath")), [
			phpActualParameter(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../")), phpConcat()), false)
		]), false)
	]))),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("singleton")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\Illuminate\\Contracts\\Console\\Kernel")), "class"), false),
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\Laravel\\Lumen\\Console\\Kernel")), "class"), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("singleton")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\Illuminate\\Contracts\\Debug\\ExceptionHandler")), "class"), false),
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\Laravel\\Lumen\\Exceptions\\Handler")), "class"), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("configure")), [
			phpActualParameter(phpScalar(phpString("app")), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("configure")), [
			phpActualParameter(phpScalar(phpString("database")), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("configure")), [
			phpActualParameter(phpScalar(phpString("doctrine")), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("group")), [
			phpActualParameter(phpArray([]), false),
			phpActualParameter(phpClosure([
				phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../routes/api.php")), phpConcat()), phpRequire()))
			], [phpParam("app")], [], false, false), false)
		])
	),
	phpReturn(phpSomeExpr(phpVar("app")))
]));
