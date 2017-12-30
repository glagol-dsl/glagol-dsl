module Test::Parser::Repository::Injections

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseInjections() 
{    
    str code 
        = "namespace Example
          '
          'import Glagol::ORM::EntityManager;
          'import Example::User;
          '
          'repository for User {
          '     EntityManager em = get EntityManager;
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
        \import("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager"),
        \import("User", namespace("Example"), "User")
    ], repository("User", [
        property(artifact(fullName("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager")), "em",
        	get(artifact(fullName("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager"))))
    ]));
}
