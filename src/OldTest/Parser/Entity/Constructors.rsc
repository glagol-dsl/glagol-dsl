module Test::Parser::Entity::Constructors

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shouldParseConstructWithAndWithoutWhenExpr()
{
    str code 
        = "module Example;
          'entity User {
          '    constructor(int param) {
          '        \"some expression\";
          '        true;
          '    }
          '    when param == 1 
          '    throws MyException(\"Generic exception message\") if param == 2;
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        constructor({parameter(integer(), "param", none())}, methodBody([
                expression(stringLiteral("some expression")),
                expression(booleanLiteral("true"))
            ]), 
            equals(variable("param"), intLiteral(1)), 
            conditionalThrow("MyException", [stringLiteral("Generic exception message")], equals(variable("param"), intLiteral(2)))
        )
    }));
}
