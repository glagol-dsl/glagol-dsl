module Test::Parser::Repository::Basics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool shouldParseEmptyRepository()
{
    str code 
        = "module Example;
          '
          'import Glagol::ORM::EntityManager;
          '
          'repository for User {
          '}";
    
    return parseModule(code) == \module("Example", {
        \import("EntityManager", ["Glagol", "ORM"], "EntityManager")
    }, repository("User", {}));
}

test bool shouldParseRepositoryWithMethodAndAMap()
{
    str code 
        = "module Example;
          'repository for User {
          '     User[] findById(int id) = findOneBy({\"id\": id});
          '}";
    
    return parseModule(code) == \module("Example", {}, repository("User", {
        method(\public(), typedList(artifactType("User")), "findById", [
            param(integer(), "id")
        ], [\return(expression(
            invoke("findOneBy", [\map((strLiteral("id"): variable("id")))])
        ))])
    }));
}
