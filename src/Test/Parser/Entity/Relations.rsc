module Test::Parser::Entity::Relations

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool testShouldParseEntityRelations()
{
    str code = "module Example;
               'entity User {
               '    relation one:one Language as userLanguage;
               '    relation one:many User as userFriends with {add, set, get, clear};
               '}";

   return parseModule(code) == \module(namespace("Example"), {}, entity("User", {
       relation(\one(), \one(), "Language", "userLanguage", {}),
       relation(\one(), many(), "User", "userFriends", {add(), \set(), read(), clear()})
   }));
}
