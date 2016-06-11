module Test::Parser::Expressions

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseVariableInBrackets()
{
    str code = "module Example;
               'entity User {
               '    void variableInBrackets(int theVariable) {
               '        ((theVariable));
               '        (theVariable) + 1;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\public(), voidValue(), "variableInBrackets", {parameter(integer(), "theVariable", none())}, [
            expression(variable("theVariable")),
            expression(addition(variable("theVariable"), intLiteral(1)))
        ], none())
    }));
}

test bool testShouldParseArray()
{
    str code = "module Example;
               'entity User {
               '    void arrayExpression() {
               '        [\"First thing\", \"Second thing\"];
               '        [1, 2, 3, 4, 5];
               '        [1.34, 2.35, 23.56];
               '        [[1, 2, 3], [3, 4, 5]];
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\public(), voidValue(), "arrayExpression", {}, [
            expression(array([stringLiteral("First thing"), stringLiteral("Second thing")])),
            expression(array([intLiteral(1), intLiteral(2), intLiteral(3), intLiteral(4), intLiteral(5)])),
            expression(array([floatLiteral(1.34), floatLiteral(2.35), floatLiteral(23.56)])),
            expression(array([array([intLiteral(1), intLiteral(2), intLiteral(3)]), array([intLiteral(3), intLiteral(4), intLiteral(5)])]))
        ], none())
    }));
}

test bool testShouldParseExpressionsWithNegativeLiterals()
{
    str code = "module Example;
               'entity User {
               '    void nestedNegative() {
               '        -(-(-(23)));
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\public(), voidValue(), "nestedNegative", {}, [
            expression(negative(negative(negative(intLiteral(23)))))
        ], none())
    }));
}

test bool testShouldParseMathExpressions()
{
    str code = "module Example;
               'entity User {
               '    void math() {
               '        3*4*(23+3)-4/2 mod 32 \> 3;
               '        3 \< 5;
               '        1 \>= 1;
               '        2 == 2;
               '        9 \<= 19;
               '        1 && true || false || true;
               '        argument \> 0 ? \"argument is positive\" : \"argument is negative\";
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\public(), voidValue(), "math", {}, [
            expression(greaterThan(
              modulo(
                subtraction(
                  product(
                    product(
                      intLiteral(3),
                      intLiteral(4)),
                    addition(
                      intLiteral(23),
                      intLiteral(3))
                  ),
                  division(
                    intLiteral(4),
                    intLiteral(2)
                  )
                 ),
                 intLiteral(32)
                ),
              intLiteral(3))
            ),
            expression(lessThan(intLiteral(3), intLiteral(5))),
            expression(greaterThanOrEq(intLiteral(1), intLiteral(1))),
            expression(equals(intLiteral(2), intLiteral(2))),
            expression(lessThanOrEq(intLiteral(9), intLiteral(19))),
            expression(or(or(and(intLiteral(1), booleanLiteral("true")), booleanLiteral("false")), booleanLiteral("true"))),
            expression(ifThenElse(greaterThan(variable("argument"), intLiteral(0)), stringLiteral("argument is positive"), stringLiteral("argument is negative")))
          ], none())
    }));
}

test bool shouldParseAllTypesOfLiterals()
{
    str code = "module Example;
               'entity User {
               '    void literals(int var) {
               '        \"simple string literal\";
               '        123;
               '        1.23;
               '        true;
               '        false;
               '        var;
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        method(\public(), voidValue(), "literals", {parameter(integer(), "var", none())}, [
            expression(stringLiteral("simple string literal")),
            expression(intLiteral(123)),
            expression(floatLiteral(1.23)),
            expression(booleanLiteral("true")),
            expression(booleanLiteral("false")),
            expression(variable("var"))
          ], none())
    }));
}
