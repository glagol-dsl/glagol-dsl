module Compiler::Composer::Dependencies

import Compiler::Composer::Dependencies::Framework;
import Compiler::Composer::Dependencies::ORM;
import Compiler::Composer::Dependencies::Intersect;
import Compiler::Composer::Dependencies::Proxy;
import Config::Config;
import Config::Reader;
import Utils::JSON;
import lang::json::IO;
import lang::json::ast::JSON;

public JSON setDependencies(object(map[str, JSON] properties), Config config, list[Syntax::Abstract::Glagol::Declaration] ast) = object(merge(properties, (
    "require": object(
    	getFrameworkDependencies(getFramework(config))
      + getORMDependencies(getORM(config))
      + getIntersectDependencies(getFramework(config), getORM(config))
      + getProxyDependencies(ast)
    )))
);
