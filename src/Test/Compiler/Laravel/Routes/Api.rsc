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
    ]) == toCode(phpScript([phpExprstmt(phpStaticCall(
        phpName(phpName("Route")),
        phpName(phpName("resource")),
        [
          phpActualParameter(
            phpScalar(phpString("/users")),
            false),
          phpActualParameter(
            phpFetchClassConst(
              phpName(phpName("Test\\UserController")),
              "class"),
            false)
        ]))]));

test bool shouldCreateTwoLaravelApiRoutes() = 
    createRoutesApi([
        file(|temp:///|, \module(namespace("Test"), [], controller("UserController", jsonApi(), route([
            routePart("users")
        ]), []))),
        file(|temp:///|, \module(namespace("Test"), [], controller("ArticleController", jsonApi(), route([
            routePart("articles")
        ]), [])))
    ]) == toCode(phpScript([phpExprstmt(phpStaticCall(
        phpName(phpName("Route")),
        phpName(phpName("resource")),
        [
          phpActualParameter(
            phpScalar(phpString("/users")),
            false),
          phpActualParameter(
            phpFetchClassConst(
              phpName(phpName("Test\\UserController")),
              "class"),
            false)
        ])),
        phpExprstmt(phpStaticCall(
        phpName(phpName("Route")),
        phpName(phpName("resource")),
        [
          phpActualParameter(
            phpScalar(phpString("/articles")),
            false),
          phpActualParameter(
            phpFetchClassConst(
              phpName(phpName("Test\\ArticleController")),
              "class"),
            false)
        ]))]));
