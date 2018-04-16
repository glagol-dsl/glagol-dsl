module Compiler::Composer::Dependencies::Framework

import Config::Config;
import lang::json::IO;
import lang::json::ast::JSON;

public map[str, JSON] getFrameworkDependencies(lumen()) = (
	"vlucas/phpdotenv": string("~2.2"),
	"glagol-dsl/bridge-lumen": string("^0.2")
);
