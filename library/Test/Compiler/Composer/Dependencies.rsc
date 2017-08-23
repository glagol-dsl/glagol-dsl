module Test::Compiler::Composer::Dependencies

import Compiler::Composer::Dependencies;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;
import Config::Reader;

test bool shouldCreateComposerDependenciesUsingLumenAndDoctrine() =
    setDependencies(object(()), newConfig()) == 
    object(("require":object((
        "laravel/lumen-framework":string("5.4.*"),
        "vlucas/phpdotenv": string("~2.2"),
        "bulgaria-php/glagol-bridge-lumen":string("^0.1"),
        "bulgaria-php/glagol-php-overriding":string("^0.1"),
        "php":string("^7.1"),
        "laravel-doctrine/orm":string("^1.3"),
        "bulgaria-php/glagol-php-ds":string("^0.1")
      ))));

