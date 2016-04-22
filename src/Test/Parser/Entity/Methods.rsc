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