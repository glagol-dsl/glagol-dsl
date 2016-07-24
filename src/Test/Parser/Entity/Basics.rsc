module Test::Parser::Entity::Basics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool entityDeclaration() {
    str code 
        = "module Testing;
        'entity User {}
        '";
        
    return parseModule(code) == \module("Testing", {}, entity("User", {}));
}

test bool testShouldParseEmptyEntityWithModuleImports()
{
    str code = "module Example;
               'import Auth::User as UserEntity;
               'import I18n::Money;
               'import I18n::Language;
               'entity User {}";

   set[Declaration] expectedImports = {
        \import("User", ["Auth"], "UserEntity"),
        \import("Money", ["I18n"], "Money"),
        \import("Language", ["I18n"], "Language")
   };

    return parseModule(code) == \module("Example", expectedImports, entity("User", {}));
}
