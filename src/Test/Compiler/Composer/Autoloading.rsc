module Test::Compiler::Composer::Autoloading

import Syntax::Abstract::Glagol;
import Compiler::Composer::Autoloading;
import lang::json::ast::JSON;
import Config::Config;

test bool testSetAutoloadingWithLaravelAndNoSourceFiles() = 
    setAutoloading(object(()), <object(("glagol": object(("framework": string("laravel"))))), |tmp:///|>, []) == object((
        "autoload": object((
            "psr-4": object((
                "App\\": string("app/")
            ))
        ))
    ));

test bool testSetAutoloadingWithLaravelAndOneSourceFileNamespace() = 
    setAutoloading(object(()), <object(("glagol": object(("framework": string("laravel"))))), |tmp:///|>, [
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
    setAutoloading(object(()), <object(("glagol": object(("framework": string("laravel"))))), |tmp:///|>, [
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
