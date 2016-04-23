module Test::Parser::Entity::Methods

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shouldParseMethodWithoutModifier()
{
	str code = "module Example;
			 'entity User {
			 '    int example(int blabla = 5, string[] names = [\"a\", \"b\", \"c\"]) = (23 + 5)*8;
			 '}";

	return parseModule(code) ==
		\module("Example", {}, entity({}, "User", {
			method(
		        \public(),
		        integer(),
		        "example",
		        {
		          parameter(
		            integer(),
		            "blabla",
		            intLiteral(5)),
		          parameter(
		            typedArray(string()),
		            "names",
		            array({
		                stringLiteral("\"a\""),
		                stringLiteral("\"b\""),
		                stringLiteral("\"c\"")
		              })
		          )
		        },
		        product(
		          addition(literal(intLiteral(23)), literal(intLiteral(5))),
		          literal(intLiteral(8))
	            )
	        )
	  }));
}

test bool shouldParseMethodWithModifierAndWhenExpression()
{
    str code = "module Example;
             'entity User {
             '    private int example(int argument) = (23 + 5)*8 when argument \> 5;
             '}";

    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\private(), integer(), "example", {parameter(integer(), "argument")}, product(
              addition(literal(intLiteral(23)), literal(intLiteral(5))),
              literal(intLiteral(8))
        ), greaterThan(variable("argument"), literal(intLiteral(5))))
    }));
}

test bool shouldParseMethodWithModifierAndBody()
{
    str code = "module Example;
             'entity User {
             '  private void processEntry(int limit = 15) {
             '      1 + 1;
             '  }
             '}";
             
     return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\private(), voidValue(), "processEntry", {parameter(integer(), "limit", intLiteral(15))}, [
            expression(addition(literal(intLiteral(1)), literal(intLiteral(1))))
        ])
     }));
}

test bool shouldParseMethodWithModifierBodyAndWhen()
{
    str code = "module Example;
             'entity User {
             '  private void processEntry(int limit = 15) {
             '      1 + 1;
             '  } when limit == 15;
             '}";
             
     return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\private(), voidValue(), "processEntry", {parameter(integer(), "limit", intLiteral(15))}, [
            expression(addition(literal(intLiteral(1)), literal(intLiteral(1))))
        ], equals(variable("limit"), literal(intLiteral(15))))
     }));
}
