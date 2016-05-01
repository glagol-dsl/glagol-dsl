module Test::Parser::Entity::Basics

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseEmptyEntityWithName()
{
    str code = "module Example;
               'entity User {}";

    return parseModule(code) == \module("Example", {}, entity({}, "User", {}));
}

test bool testShouldParseEmptyEntityWithModuleImports()
{
    str code = "module Example;
               'use User entity from Auth as UserEntity;
               'use Money value;
               'use Money collection as MoneySet;
               'use Language entity from I18n;
               'entity User {}";

   set[Declaration] expectedImports = {
        \import("User", "entity", from("Auth"), \alias("UserEntity")),
        \import("Money", "value", localImport(), noAlias()),
        \import("Money", "collection", localImport(), \alias("MoneySet")),
        \import("Language", "entity", from("I18n"), noAlias())
   };

    return parseModule(code) == \module("Example", expectedImports, entity({}, "User", {}));
}
