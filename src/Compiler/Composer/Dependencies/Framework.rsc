module Compiler::Composer::Dependencies::Framework

import Config::Config;
import lang::json::IO;
import lang::json::ast::JSON;

public map[str, JSON] getFrameworkDependencies(laravel()) = ("laravel/framework": string("^5.3"));
