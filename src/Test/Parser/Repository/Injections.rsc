module Test::Parser::Repository::Injections

import Parser::ParseAST;
import Syntax::Abstract::AST;
import IO;

test bool shouldParseInjections() 
{    
    str code 
        = "module Example;
          '
          'import Glagol::ORM::EntityManager;
          '
          'repository for User {
          '     inject EntityManager as em;
          '}";
    
    return parseModule(code) == \module("Example", {
        \import("EntityManager", ["Glagol", "ORM"], "EntityManager")
    }, repository("User", {
        inject("EntityManager", "em")
    }));
}
