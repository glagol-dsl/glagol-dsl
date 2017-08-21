module Test::Compiler::Laravel::Routes::Api

import Compiler::Laravel::Routes::Api;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol;

test bool shouldCreateLaravelApiRoutes() = 
    createRoutesApi([
        file(|temp:///|, \module(namespace("Test"), [], controller("UserController", jsonApi(), route([
            routePart("users")
        ]), [])))
    ]) == toCode(phpScript([]));

test bool shouldCreateTwoLaravelApiRoutes() = 
    createRoutesApi([
        file(|temp:///|, \module(namespace("Test"), [], controller("UserController", jsonApi(), route([
            routePart("users")
        ]), []))),
        file(|temp:///|, \module(namespace("Test"), [], controller("ArticleController", jsonApi(), route([
            routePart("articles")
        ]), [])))
    ]) == toCode(phpScript([]));
