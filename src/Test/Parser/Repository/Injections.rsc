module Test::Parser::Repository::Injections

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import IO;

test bool shouldParseInjections() 
{    
    str code 
        = "namespace Example;
          '
          'import Glagol::ORM::EntityManager;
          '
          'repository for User {
          '     EntityManager em = get EntityManager;
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
        \import("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager")
    ], repository("User", [
        property(artifactType("EntityManager"), "em", {}, get(artifactType("EntityManager")))
    ]));
}
