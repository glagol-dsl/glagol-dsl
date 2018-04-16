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
            "\"glagol-dsl/bridge-lumen\":\"^0.2\"," + 
        	"\"vlucas/phpdotenv\":\"~2.2\"" +
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
            "\"glagol-dsl/bridge-lumen\":\"^0.2\"," +
        	"\"vlucas/phpdotenv\":\"~2.2\"" +
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
            "\"glagol-dsl/bridge-lumen\":\"^0.2\"," +
        	"\"vlucas/phpdotenv\":\"~2.2\"," +
            "\"demo/package\":\"0.1\"" +
        "}," + 
        "\"autoload\":{" + 
            "\"psr-4\":{" + 
                "\"App\\\\\":\"app/\"" +  
            "}" + 
        "}" + 
    "}";
    