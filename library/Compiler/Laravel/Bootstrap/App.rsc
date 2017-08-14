module Compiler::Laravel::Bootstrap::App

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createAppFile() = toCode(phpScript([
	phpExprstmt(phpAssign(phpVar("app"), phpNew(phpName(phpName("Illuminate\\Foundation\\Application")), [
		phpActualParameter(phpCall(phpName(phpName("realpath")), [
			phpActualParameter(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../")), phpConcat()), false)
		]), false)
	]))),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("singleton")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("Illuminate\\Contracts\\Http\\Kernel")), "class"), false),
			phpActualParameter(phpFetchClassConst(phpName(phpName("Glagol\\Bridge\\Laravel\\Http\\Kernel")), "class"), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("singleton")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("Illuminate\\Contracts\\Console\\Kernel")), "class"), false),
			phpActualParameter(phpFetchClassConst(phpName(phpName("Glagol\\Bridge\\Laravel\\Console\\Kernel")), "class"), false)
		])
	),
	phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("singleton")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("Illuminate\\Contracts\\Debug\\ExceptionHandler")), "class"), false),
			phpActualParameter(phpFetchClassConst(phpName(phpName("Glagol\\Bridge\\Laravel\\Exceptions\\Handler")), "class"), false)
		])
	),
	phpReturn(phpSomeExpr(phpVar("app")))
]));
