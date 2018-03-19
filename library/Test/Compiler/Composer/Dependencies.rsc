module Test::Compiler::Composer::Dependencies

import Compiler::Composer::Dependencies;
import lang::json::ast::JSON;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;

test bool shouldCreateComposerDependenciesUsingLumenAndDoctrine() =
    setDependencies(object(()), newConfig(), []) == 
    object(("require":object((
        "vlucas/phpdotenv": string("~2.2"),
        "bulgaria-php/glagol-bridge-lumen":string("^0.2"),
        "bulgaria-php/glagol-php-overriding":string("^0.2"),
        "php":string("^7.1"),
        "bulgaria-php/glagol-php-ds":string("^0.1")
      ))));

test bool shouldCreateComposerDependenciesUsingLumenAndDoctrineAndProxyRequirement() =
    setDependencies(object(()), newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [], util("User", [
        	require("demo/package", "0.1")
        ], proxyClass("\\Generic\\User"))))
    ]) == 
    object(("require":object((
        "vlucas/phpdotenv": string("~2.2"),
        "bulgaria-php/glagol-bridge-lumen":string("^0.2"),
        "bulgaria-php/glagol-php-overriding":string("^0.2"),
        "php":string("^7.1"),
        "bulgaria-php/glagol-php-ds":string("^0.1"),
        "demo/package": string("0.1")
      ))));

