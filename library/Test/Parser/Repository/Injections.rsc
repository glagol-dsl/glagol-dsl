module Test::Parser::Repository::Injections

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import IO;

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
        property(artifact(external("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager")), "em",
        	get(artifact(external("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager")))),
		method(\public(), artifact(local("User")), "find", [
			param(integer(), "id", emptyExpr())
		], [\return(new(local("User"), []))], emptyExpr()),
		method(\public(), \list(artifact(local("User"))), "findAll", [], [\return(\list([]))], emptyExpr())
    ]));
}
