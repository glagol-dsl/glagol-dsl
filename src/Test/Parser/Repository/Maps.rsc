module Test::Parser::Repository::Maps

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseMapDeclaration()
{
    str code 
        = "namespace Example
          'import Example::User;
          'repository for User {
          '     User[] findById(int id) {
          '         {string, int} query = {\"id\": id};
          '         return findOneBy(query);
          '     }
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [
    		\import("User", namespace("Example"), "User")
    	], repository("User", [
        method(\public(), \list(artifact("User")), "findById", [
            param(integer(), "id", emptyExpr())
        ], [
            declare(\map(string(), integer()), variable("query"), expression(\map((string("id"): variable("id"))))),
            \return(invoke("findOneBy", [variable("query")]))
        ])
    ]));
}
