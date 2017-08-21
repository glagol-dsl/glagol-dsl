module Test::Compiler::Composer::Dependencies::Framework

import Compiler::Composer::Dependencies::Framework;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldGetFrameworkDependenciesForLaravel() = 
    getFrameworkDependencies(laravel()) == (
        "vlucas/phpdotenv": string("~2.2"),
        "laravel/lumen-framework": string("5.4.*"),
        "bulgaria-php/glagol-bridge-laravel": string("^0.1")
    );
