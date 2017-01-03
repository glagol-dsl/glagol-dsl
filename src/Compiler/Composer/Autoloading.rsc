module Compiler::Composer::Autoloading

import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;
import Utils::JSON;
import lang::json::IO;
import lang::json::ast::JSON;

public JSON setAutoloading(object(map[str, JSON] properties), Config config, list[Declaration] ast) = object(merge(properties, (
    "autoload": object((
        "psr-4": object((
            "<n>\\": string("<getSourcesPath(config).file>/") |  n <- namespaces(ast)
        ))
    ))
)));


private set[str] namespaces(list[Declaration] ast) = 
	{f.\module.namespace.name | f <- ast};