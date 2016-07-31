module Test::Parser::ModuleBasics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool moduleDeclaration() {
    str code = "module Testing;";
    
    return parseModule(code) == \module(namespace("Testing"), {});
}

test bool moduleDeclarationWithWhitespace() {
    str code = "module Testing;
    '
    '
    ";
    
    return parseModule(code) == \module(namespace("Testing"), {});
}

test bool moduleDeclarationWithImports() {
    str code = "module Testing;
    'import Example::User;
    'import I18n::Language as LanguageEntity;
    'import News::Comment;
    'import News::Article as ArticleEntity;
    ";
    
    return parseModule(code) == \module(namespace("Testing"), {
        \import("User", namespace("Example"), "User"),
        \import("Language", namespace("I18n"), "LanguageEntity"),
        \import("Article", namespace("News"), "ArticleEntity"),
        \import("Comment", namespace("News"), "Comment")
    });
}

test bool moduleDeclarationWithSubModule() {
    str code = "module Testing::SubName;
    '
    '
    ";
    
    return parseModule(code) == \module(namespace("Testing", namespace("SubName")), {});
}
