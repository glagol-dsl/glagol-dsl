module Test::Parser::Entity::Relations

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testShouldParseEntityRelations()
{
    str code = "namespace Example
               'entity User {
               '    relation one:one Language as userLanguage;
               '    relation one:many User as userFriends;
               '
               '    @doc=\"This is a relation\"
               '    relation one:one Language as userLanguage2;
               '}";

   return parseModule(code) == \module(namespace("Example"), [], entity("User", [
       relation(\one(), \one(), "Language", "userLanguage"),
       relation(\one(), many(), "User", "userFriends"),
       relation(\one(), \one(), "Language", "userLanguage2")
   ])) &&
   parseModule(code).artifact.declarations[2]@annotations == [annotation("doc", [annotationVal("This is a relation")])];
}
