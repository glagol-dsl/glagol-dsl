module Test::Parser::Entity::Methods

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shouldParseMethodWithoutModifier()
{
    str code 
        = "module Example;
        'entity User {
        '    int example(int blabla = 5, string[] names = [\"a\", \"b\", \"c\"]) = (23 + 5)*8;
        '}";
    
    return parseModule(code) == 
      \module("Example", {}, 
        entity("User", { 
            method(\public(), integer(), "example", [
                    param(integer(), "blabla", intLiteral(5)),
                    param(typedArray(string()), "names", array([strLiteral("a"), strLiteral("b"), strLiteral("c")]))
                ], [
                    \return(product(\bracket(addition(intLiteral(23), intLiteral(5))), intLiteral(8)))
                ]
            )
          }
        )
      );
}

test bool shouldParseMethodWithModifierAndWhenExpression()
{
    str code 
        = "module Example;
        'entity User {
        '    private int example(int argument) = (23 + 5)*8 when argument \> 5;
        '}";
        
    return parseModule(code) == 
      \module("Example", {}, 
        entity("User", { 
            method(\private(), integer(), "example", [
                    param(integer(), "argument")
                ], [
                    \return(product(\bracket(addition(intLiteral(23), intLiteral(5))), intLiteral(8)))
                ], greaterThan(variable("argument"), intLiteral(5))
            )
          }
        )
      );
}

test bool shouldParseMethodWithModifierBodyAndWhen()
{
    str code 
        = "module Example;
        'entity User {
        '  private void processEntry(int limit = 15) {
        '      return 1 + 5;
        '  } when limit == 15;
        '}";
        
    return parseModule(code) == 
      \module("Example", {}, 
        entity("User", { 
            method(\private(), voidValue(), "processEntry", [
                    param(integer(), "limit", intLiteral(15))
                ], [
                    \return(addition(intLiteral(1), intLiteral(5)))
                ], equals(variable("limit"), intLiteral(15))
            )
          }
        )
      );
}
