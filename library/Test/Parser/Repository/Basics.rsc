module Test::Parser::Repository::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import IO;

test bool shouldThrowExceptionWhenEntityNotImported()
{
    str code 
        = "namespace Example
          '
          'import Glagol::ORM::EntityManager;
          '
          'repository for User {
          '}";
    
    try parseModule(code);
    catch EntityNotImported("Repository cannot attach to entity \'User\': entity not imported", _): return true;
    
    return false;
}

test bool shouldParseEmptyRepository()
{
    str code 
        = "namespace Example
          '
          'import Glagol::ORM::EntityManager;
          'import Example::User;
          '
          'repository for User {
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
        \import("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager"),
        \import("User", namespace("Example"), "User")
    ], repository("User", []));
}

test bool shouldNotAllowRepositoryConstructor()
{
    str code 
        = "namespace Example
          '
          'import Example::User;
          '
          'repository for User {
          '    User() {}
          '}";
    
    try parseModule(code);
    catch ConstructorNotAllowed("Constructor not allowed for repository artifacts", loc at): return true;
    
    return false;
}

test bool shouldParseRepositoryWithMethodAndAMap()
{
    str code 
        = "namespace Example
          'import Example::User;
          'repository for User {
          '     User[] findById(int id) = findOneBy({\"id\": id});
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
        	\import("User", namespace("Example"), "User")
    	], repository("User", [
        method(\public(), \list(artifact("User")), "findById", [
            param(integer(), "id", emptyExpr())
        ], [\return(
            invoke("findOneBy", [\map((string("id"): variable("id")))])
        )], emptyExpr())
    ]));
}
