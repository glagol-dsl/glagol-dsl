module Test::Compiler::Lumen::Routes::Api

import Compiler::Lumen::Routes::Api;
import Compiler::PHP::Compiler;
import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol;

test bool shouldCreateLumenApiRoutes() =
    createRoutesApi([
        file(|temp:///|, \module(namespace("Test"), [], controller("UserController", jsonApi(), route([
            routePart("users")
        ]), [])))
    ]) == implode(toCode(phpScript([])));

test bool shouldCreateTwoLumenApiRoutes() =
    createRoutesApi([
        file(|temp:///|, \module(namespace("Test"), [], controller("UserController", jsonApi(), route([
            routePart("users")
        ]), []))),
        file(|temp:///|, \module(namespace("Test"), [], controller("ArticleController", jsonApi(), route([
            routePart("articles")
        ]), [])))
    ]) == implode(toCode(phpScript([])));
