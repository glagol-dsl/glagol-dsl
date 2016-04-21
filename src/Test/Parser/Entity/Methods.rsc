module Test::Parser::Entity::Methods

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseMethod1()
{
    str code = "module Example;
               'entity User {
               '    public int;
               '}";

    return parseModule(code) == \module("Example", {}, entity({annoTable("users")}, "User", {
        method(\public(), \int(), "example", numberLiteral(33))
    }));
}
