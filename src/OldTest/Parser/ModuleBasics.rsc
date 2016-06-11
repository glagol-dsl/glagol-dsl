module Test::Parser::ModuleBasics

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseModule()
{
    str code = "module Example;";

    Declaration ast = parseModule(code);
    
    return ast == \module("Example", {}, emptyDeclaration());
}

test bool testShouldParseModuleWithUnderscoresInName()
{
    str code = "module my_example_module;";

    Declaration ast = parseModule(code);

    return ast == \module("my_example_module", {}, emptyDeclaration());
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

    return parseModule(code) == \module("Example", {\import("User", "entity", from("Auth"), noAlias())}, emptyDeclaration());
}

test bool testShouldParseModuleWithImportFromSameModule()
{
    str code = "module Example;
               'use User entity;";

    return parseModule(code) == \module("Example", {\import("User", "entity", localImport(), noAlias())}, emptyDeclaration());
}

test bool testShouldParseModuleWithImportFromSameModuleWithAlias()
{
    str code = "module Example;
               'use User entity as UserEntity;";

    return parseModule(code) == \module("Example", {\import("User", "entity", localImport(), \alias("UserEntity"))}, emptyDeclaration());
}

test bool testShouldParseModuleWithImportFromOtherModuleWithAlias()
{
    str code = "module Example;
               'use User entity from Auth as UserEntity;";

    return parseModule(code) == \module("Example", {\import("User", "entity", from("Auth"), \alias("UserEntity"))}, emptyDeclaration());
}

test bool testShouldParseModuleWithCompositeImports()
{
    str code = "module Example;
               'use User entity from Auth as UserEntity;
               'use Money value;
               'use Money collection as MoneySet;
               'use Language entity from I18n;";

   set[Declaration] expectedImports = {
        \import("User", "entity", from("Auth"), \alias("UserEntity")),
        \import("Money", "value", localImport(), noAlias()),
        \import("Money", "collection", localImport(), \alias("MoneySet")),
        \import("Language", "entity", from("I18n"), noAlias())
   };

   return parseModule(code) == \module("Example", expectedImports, emptyDeclaration());
}
