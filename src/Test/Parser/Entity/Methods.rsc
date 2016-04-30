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
		            defaultValue(intLiteral(5))),
		          parameter(
		            typedArray(string()),
		            "names",
		            defaultValue(array([
	                  stringLiteral("a"),
	                  stringLiteral("b"),
	                  stringLiteral("c")
	                ]))
		          )
		        },
		        product(
		          addition(intLiteral(23), intLiteral(5)),
		          intLiteral(8)
	            ),
	            none()
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
        method(\private(), integer(), "example", {parameter(integer(), "argument", none())}, product(
              addition(intLiteral(23), intLiteral(5)),
              intLiteral(8)
        ), when(greaterThan(variable("argument"), intLiteral(5))))
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
        method(\private(), voidValue(), "processEntry", {parameter(integer(), "limit", defaultValue(intLiteral(15)))}, [
            expression(addition(intLiteral(1), intLiteral(1)))
        ], none())
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
        method(\private(), voidValue(), "processEntry", {parameter(integer(), "limit", defaultValue(intLiteral(15)))}, [
            expression(addition(intLiteral(1), intLiteral(1)))
        ], when(equals(variable("limit"), intLiteral(15))))
     }));
}
