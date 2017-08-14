module Test::Compiler::Composer::ComposerFile

import Compiler::Composer::ComposerFile;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldCreateComposerFileUsingLaravelAndDoctrine() = 
    generateComposerFile(<object(("glagol": object(("framework": string("laravel"), "orm": string("doctrine"))))), |temp:///|>, []) == 
    "{" + 
        "\"require\":{" + 
            "\"laravel/framework\":\"^5.3\"," + 
            "\"bulgaria-php/glagol-bridge-laravel\":\"^0.1\"," + 
            "\"bulgaria-php/glagol-php-overriding\":\"^0.1\"," + 
            "\"php\":\"^7.1\"," + 
            "\"laravel-doctrine/orm\":\"1.2.*\"," + 
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" + 
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"App\\\\\":\"app/\"" + 
            "}" + 
        "}" + 
    "}";

test bool shouldCreateComposerFileUsingLaravelAndDoctrineWithNamespaceAutoload() = 
    generateComposerFile(<object(("glagol": object(("framework": string("laravel"), "orm": string("doctrine"))))), |temp:///|>, [
        file(|temp:///|, \module(namespace("Test"), [], repository("User", [])))
    ]) == 
    "{" + 
        "\"require\":{" + 
            "\"laravel/framework\":\"^5.3\"," + 
            "\"bulgaria-php/glagol-bridge-laravel\":\"^0.1\"," + 
            "\"bulgaria-php/glagol-php-overriding\":\"^0.1\"," + 
            "\"php\":\"^7.1\"," + 
            "\"laravel-doctrine/orm\":\"1.2.*\"," + 
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" + 
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"Test\\\\\":\"src/Test/\"," +
                "\"App\\\\\":\"app/\"" +  
            "}" + 
        "}" + 
    "}";
