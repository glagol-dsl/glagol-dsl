module Test::Parser::ModuleBasics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool moduleDeclaration() {
    str code = "module Testing;";
    
    return parseModule(code) == \module("Testing", {});
}

test bool moduleDeclarationWithWhitespace() {
    str code = "module Testing;
    '
    '
    ";
    
    return parseModule(code) == \module("Testing", {});
}

test bool moduleDeclarationWithImports() {
    str code = "module Testing;
    'use User entity;
    'use Language entity as LanguageEntity;
    'use Comment entity from News;
    'use Article entity from News as ArticleEntity;
    ";
    
    return parseModule(code) == \module("Testing", {
        use("User", "entity", internalUse(), "User"),
        use("Language", "entity", internalUse(), "LanguageEntity"),
        use("Article", "entity", externalUse("News"), "ArticleEntity"),
        use("Comment", "entity", externalUse("News"), "Comment")
    });
}


