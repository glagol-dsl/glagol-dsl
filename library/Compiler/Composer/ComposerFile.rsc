module Compiler::Composer::ComposerFile

import Compiler::Composer::Autoloading;
import Compiler::Composer::Dependencies;
import Syntax::Abstract::Glagol;
import Utils::Glue;
import Utils::JSON;
import lang::json::IO;
import lang::json::ast::JSON;
import Config::Config;
import Config::Reader;
import Map;
	
public str generateComposerFile(Config config, list[Declaration] ast) = 
    toJSON(removeGlagolProps(setAutoloading(setDependencies(object(()), config, ast), config, ast)));

private JSON removeGlagolProps(object(map[str, JSON] properties)) = object(delete(properties, "glagol"));
