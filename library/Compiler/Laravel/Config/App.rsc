module Compiler::Laravel::Config::App

import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;
import Config::Config;
import Config::Reader;

public str createAppConfig(Config config, list[Declaration] ast) = 
    toCode(createAppConfigAST(config, ast));

private PhpScript createAppConfigAST(Config config, list[Declaration] ast) =
    phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "providers": array(getORMProviders(getORM(config), ast))
    )))))]);

private list[Conf] getORMProviders(doctrine(), list[Declaration] ast) = [
    class("LaravelDoctrine\\ORM\\DoctrineServiceProvider")
] + [class("App\\Provider\\<name>RepositoryProvider") | file(_, \module(_, _, repository(str name, _))) <- ast];
