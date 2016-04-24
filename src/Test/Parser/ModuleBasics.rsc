module Test::Parser::ModuleBasics

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseModule()
{
    str code = "module Example;";

    Declaration ast = parseModule(code);
    
    return ast == \module("Example", {});
}

test bool testShouldParseModuleWithUnderscoresInName()
{
    str code = "module my_example_module;";

    Declaration ast = parseModule(code);

    return ast == \module("my_example_module", {});
}

test bool testShouldNotParseTwoModuleDeclarations()
{
    str code = "module my_example_module;
               'module this_should_throw_error;";

    try parseModule(code);
    catch ParseError(x): return true;

    return false;
}

test bool testShouldParseModuleWithImportFromOtherModule()
{
    str code = "module Example;
               'use User entity from Auth;";

    return parseModule(code) == \module("Example", {importExternal("User", "entity", "Auth")});
}

test bool testShouldParseModuleWithImportFromSameModule()
{
    str code = "module Example;
               'use User entity;";

    return parseModule(code) == \module("Example", {importInternal("User", "entity")});
}

test bool testShouldParseModuleWithImportFromSameModuleWithAlias()
{
    str code = "module Example;
               'use User entity as UserEntity;";

    return parseModule(code) == \module("Example", {importInternal("User", "entity", "UserEntity")});
}

test bool testShouldParseModuleWithImportFromOtherModuleWithAlias()
{
    str code = "module Example;
               'use User entity from Auth as UserEntity;";

    return parseModule(code) == \module("Example", {importExternal("User", "entity", "Auth", "UserEntity")});
}

test bool testShouldParseModuleWithCompositeImports()
{
    str code = "module Example;
               'use User entity from Auth as UserEntity;
               'use Money value;
               'use Money collection as MoneySet;
               'use Language entity from I18n;";

   set[Declaration] expectedImports = {
        importExternal("User", "entity", "Auth", "UserEntity"),
        importInternal("Money", "value"),
        importInternal("Money", "collection", "MoneySet"),
        importExternal("Language", "entity", "I18n")
   };

   return parseModule(code) == \module("Example", expectedImports);
}
