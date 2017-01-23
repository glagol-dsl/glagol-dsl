module Test::Compiler::Composer::Dependencies::Framework

import Compiler::Composer::Dependencies::Framework;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldGetFrameworkDependenciesForLaravel() = 
    getFrameworkDependencies(laravel()) == (
        "laravel/framework": string("^5.3"),
        "bulgaria-php/glagol-bridge-laravel": string("^0.1")
    );
