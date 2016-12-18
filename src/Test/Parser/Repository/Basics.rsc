module Test::Parser::Repository::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseEmptyRepository()
{
    str code 
        = "namespace Example;
          '
          'import Glagol::ORM::EntityManager;
          '
          'repository for User {
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
        \import("EntityManager", namespace("Glagol", namespace("ORM")), "EntityManager")
    ], repository("User", []));
}

test bool shouldParseRepositoryWithMethodAndAMap()
{
    str code 
        = "namespace Example;
          'repository for User {
          '     User[] findById(int id) = findOneBy({\"id\": id});
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [], repository("User", [
        method(\public(), typedList(artifactType("User")), "findById", [
            param(integer(), "id")
        ], [\return(
            invoke("findOneBy", [\map((string("id"): variable("id")))])
        )])
    ]));
}
