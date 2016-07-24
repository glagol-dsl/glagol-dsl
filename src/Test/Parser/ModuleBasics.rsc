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
    'import User;
    'import I18n::Language as LanguageEntity;
    'import News::Comment;
    'import News::Article as ArticleEntity;
    ";
    
    return parseModule(code) == \module("Testing", {
        \import("User", [], "User"),
        \import("Language", ["I18n"], "LanguageEntity"),
        \import("Article", ["News"], "ArticleEntity"),
        \import("Comment", ["News"], "Comment")
    });
}


