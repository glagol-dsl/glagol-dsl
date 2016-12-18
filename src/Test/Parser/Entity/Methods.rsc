module Test::Parser::Entity::Methods

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseMethodWithoutModifier()
{
    str code 
        = "namespace Example;
        'entity User {
        '    int example(int blabla = 5, string[] names = [\"a\", \"b\", \"c\"]) = (23 + 5)*8;
        '}";
    
    return parseModule(code) == 
      \module(namespace("Example"), [],
        entity("User", [ 
            method(\public(), integer(), "example", [
                    param(integer(), "blabla", integer(5)),
                    param(typedList(string()), "names", \list([string("a"), string("b"), string("c")]))
                ], [
                    \return(product(\bracket(addition(integer(23), integer(5))), integer(8)))
                ]
            )
          ]
        )
      );
}

test bool shouldParseMethodWithModifierAndWhenExpression()
{
    str code 
        = "namespace Example;
        'entity User {
        '    private int example(int argument) = (23 + 5)*8 when argument \> 5;
        '    @doc(\"This is a doc\")
        '    private int example(int argument) = (23 + 5)*8 when argument \> 5;
        '}";
        
    return parseModule(code) == 
      \module(namespace("Example"), [],
        entity("User", [
            method(\private(), integer(), "example", [
                    param(integer(), "argument")
                ], [
                    \return(product(\bracket(addition(integer(23), integer(5))), integer(8)))
                ], greaterThan(variable("argument"), integer(5))
            ),
            method(\private(), integer(), "example", [
                    param(integer(), "argument")
                ], [
                    \return(product(\bracket(addition(integer(23), integer(5))), integer(8)))
                ], greaterThan(variable("argument"), integer(5))
            )
          ]
        )
      ) &&
      parseModule(code).artifact.declarations[1]@annotations == [annotation("doc", [annotationVal("This is a doc")])];
}

test bool shouldParseMethodWithModifierBodyAndWhen()
{
    str code 
        = "namespace Example;
        'entity User {
        '  private void processEntry(int limit = 15) {
        '      return 1 + 5;
        '  } when limit == 15;
        '}";
        
    return parseModule(code) == 
      \module(namespace("Example"), [],
        entity("User", [ 
            method(\private(), voidValue(), "processEntry", [
                    param(integer(), "limit", integer(15))
                ], [
                    \return(addition(integer(1), integer(5)))
                ], equals(variable("limit"), integer(15))
            )
          ]
        )
      );
}
