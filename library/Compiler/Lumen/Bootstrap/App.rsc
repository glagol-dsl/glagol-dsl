module Compiler::Lumen::Bootstrap::App

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;
import Compiler::PHP::Code;
import Config::Config;

public str createAppFile(ORM orm, list[Declaration] ast) = implode(toCode(phpScript([
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
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\Glagol\\Bridge\\Lumen\\Exceptions\\Handler")), "class"), false)
		])
	)] + 
	getORMProviders(orm, ast) +
	[
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
		phpMethodCall(phpPropertyFetch(phpVar("app"), phpName(phpName("router"))), phpName(phpName("group")), [
			phpActualParameter(phpArray([]), false),
			phpActualParameter(phpClosure([
				phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/../routes/api.php")), phpConcat()), phpRequire()))
			], [phpParam("app")], [], false, false), false)
		])
	),
	phpReturn(phpSomeExpr(phpVar("app")))
])));

private list[PhpStmt] getORMProviders(doctrine(), list[Declaration] ast) = [
    phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("register")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\LaravelDoctrine\\ORM\\DoctrineServiceProvider")), "class"), false)
		])
	)
] + [phpExprstmt(
		phpMethodCall(phpVar("app"), phpName(phpName("register")), [
			phpActualParameter(phpFetchClassConst(phpName(phpName("\\App\\Provider\\<namespaceToString(ns,  "\\")>\\<name>RepositoryProvider")), "class"), false)
		])
	) | file(_, \module(ns, _, repository(str name, _))) <- ast];
