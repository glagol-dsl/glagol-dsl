module Test::Compiler::Lumen::Config::App

import Compiler::Lumen::Config::App;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Compiler::PHP::Compiler;
import lang::json::ast::JSON;
import Config::Reader;

test bool shouldGenerateLumenAppConfig() =
    createAppConfig(newConfig(), []) == 
    toCode(phpScript([phpReturn(phpSomeExpr(phpArray([
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("providers"))),
              phpArray([
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("LaravelDoctrine\\ORM\\DoctrineServiceProvider")),
                      "class"),
                    false)
                ]),
              false)
          ])))]));

test bool shouldGenerateLumenAppConfigHavingRepositoryProviders() =
    createAppConfig(newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", [])))
    ]) == 
    toCode(phpScript([phpReturn(phpSomeExpr(phpArray([
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("providers"))),
              phpArray([
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("LaravelDoctrine\\ORM\\DoctrineServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("App\\Provider\\UserRepositoryProvider")),
                      "class"),
                    false)
                ]),
              false)
          ])))]));
          
