module Test::Compiler::Composer::Autoloading

import Compiler::Composer::Autoloading;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;
import Config::Reader;

test bool testSetAutoloadingWithLaravelAndNoSourceFiles() = 
    setAutoloading(object(()), newConfig(), []) == object((
        "autoload": object((
            "psr-4": object((
                "App\\": string("app/")
            ))
        ))
    ));

test bool testSetAutoloadingWithLaravelAndOneSourceFileNamespace() = 
    setAutoloading(object(()), newConfig(), [
        file(|tmp:///src/Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", [])))
    ]) == object((
        "autoload": object((
            "psr-4": object((
                "Test\\": string("src/Test/"),
                "App\\": string("app/")
            ))
        ))
    ));


test bool testSetAutoloadingWithLaravelAndTwoSourceFileNamespaces() = 
    setAutoloading(object(()), newConfig(), [
        file(|tmp:///src/Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///src/Test/Entity/User.g|, \module(namespace("Test2", namespace("Entity")), [], entity("User", [])))
    ]) == object((
        "autoload": object((
            "psr-4": object((
                "Test\\": string("src/Test/"),
                "Test2\\": string("src/Test2/"),
                "App\\": string("app/")
            ))
        ))
    ));
