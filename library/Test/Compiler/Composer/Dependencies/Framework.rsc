module Test::Compiler::Composer::Dependencies::Framework

import Compiler::Composer::Dependencies::Framework;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldGetFrameworkDependenciesForLumen() =
    getFrameworkDependencies(lumen()) == (
        "vlucas/phpdotenv": string("~2.2"),
        "laravel/lumen-framework": string("5.5.*"),
        "bulgaria-php/glagol-bridge-lumen": string("^0.1")
    );
