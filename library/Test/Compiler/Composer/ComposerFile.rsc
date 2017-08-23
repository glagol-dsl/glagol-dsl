module Test::Compiler::Composer::ComposerFile

import Compiler::Composer::ComposerFile;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;
import Config::Reader;

test bool shouldCreateComposerFileUsingLumenAndDoctrine() =
    generateComposerFile(newConfig(), []) == 
    "{" + 
        "\"require\":{" + 
            "\"bulgaria-php/glagol-bridge-lumen\":\"^0.1\"," + 
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"laravel/lumen-framework\":\"5.4.*\"," + 
            "\"bulgaria-php/glagol-php-overriding\":\"^0.1\"," + 
            "\"php\":\"^7.1\"," + 
            "\"laravel-doctrine/orm\":\"^1.3\"," + 
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" + 
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"App\\\\\":\"app/\"" + 
            "}" + 
        "}" + 
    "}";

test bool shouldCreateComposerFileUsingLumenAndDoctrineWithNamespaceAutoload() =
    generateComposerFile(newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [], repository("User", [])))
    ]) == 
    "{" + 
        "\"require\":{" + 
            "\"bulgaria-php/glagol-bridge-lumen\":\"^0.1\"," +
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"laravel/lumen-framework\":\"5.4.*\"," + 
            "\"bulgaria-php/glagol-php-overriding\":\"^0.1\"," + 
            "\"php\":\"^7.1\"," + 
            "\"laravel-doctrine/orm\":\"^1.3\"," + 
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" + 
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"Test\\\\\":\"src/Test/\"," +
                "\"App\\\\\":\"app/\"" +  
            "}" + 
        "}" + 
    "}";
