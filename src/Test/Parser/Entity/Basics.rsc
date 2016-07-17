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
               'use User entity from Auth as UserEntity;
               'use Money value;
               'use Money collection as MoneySet;
               'use Language entity from I18n;
               'entity User {}";

   set[Declaration] expectedImports = {
        use("User", "entity", externalUse("Auth"), "UserEntity"),
        use("Money", "value", internalUse(), "Money"),
        use("Money", "collection", internalUse(), "MoneySet"),
        use("Language", "entity", externalUse("I18n"), "Language")
   };

    return parseModule(code) == \module("Example", expectedImports, entity("User", {}));
}
