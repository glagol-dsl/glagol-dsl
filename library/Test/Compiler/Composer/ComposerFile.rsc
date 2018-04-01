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
            "\"bulgaria-php/glagol-bridge-lumen\":\"^0.2\"," + 
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"bulgaria-php/glagol-php-overriding\":\"^0.2\"," + 
            "\"php\":\"^7.1\"," +  
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
            "\"bulgaria-php/glagol-bridge-lumen\":\"^0.2\"," +
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"bulgaria-php/glagol-php-overriding\":\"^0.2\"," + 
            "\"php\":\"^7.1\"," + 
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" + 
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"Test\\\\\":\"src/Test/\"," +
                "\"App\\\\\":\"app/\"" +  
            "}" + 
        "}" + 
    "}";
    
test bool shouldCreateComposerFileWithProxyRequirements() =
    generateComposerFile(newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [], util("User", [
        	require("demo/package", "0.1")
        ], proxyClass("\\Generic\\User"))))
    ]) == 
    "{" + 
        "\"require\":{" + 
            "\"bulgaria-php/glagol-bridge-lumen\":\"^0.2\"," +
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"bulgaria-php/glagol-php-overriding\":\"^0.2\"," + 
            "\"php\":\"^7.1\"," +  
            "\"demo/package\":\"0.1\"," +
            "\"bulgaria-php/glagol-php-ds\":\"^0.1\"" +
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"App\\\\\":\"app/\"" +  
            "}" + 
        "}" + 
    "}";
    