module Test::Parser::Entity::Basics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool entityDeclaration() 
{
    str code 
        = "module Testing;
        'entity User {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), {}, entity("User", {}));
}

test bool testShouldParseEmptyEntityWithModuleImports()
{
    str code = "module Example;
               'import Auth::User as UserEntity;
               'import I18n::Money;
               'import I18n::Language;
               'entity User {}";

   set[Declaration] expectedImports = {
        \import("User", namespace("Auth"), "UserEntity"),
        \import("Money", namespace("I18n"), "Money"),
        \import("Language", namespace("I18n"), "Language")
   };

    return parseModule(code) == \module(namespace("Example"), expectedImports, entity("User", {}));
}
