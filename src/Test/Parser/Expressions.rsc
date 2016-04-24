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
        method(\public(), voidValue(), "variableInBrackets", {parameter(integer(), "theVariable")}, [
            expression(variable("theVariable")),
            expression(addition(variable("theVariable"), literal(intLiteral(1))))
        ])
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
            expression(array([literal(stringLiteral("First thing")), literal(stringLiteral("Second thing"))])),
            expression(array([literal(intLiteral(1)), literal(intLiteral(2)), literal(intLiteral(3)), literal(intLiteral(4)), literal(intLiteral(5))])),
            expression(array([literal(floatLiteral(1.34)), literal(floatLiteral(2.35)), literal(floatLiteral(23.56))])),
            expression(array([array([literal(intLiteral(1)), literal(intLiteral(2)), literal(intLiteral(3))]), array([literal(intLiteral(3)), literal(intLiteral(4)), literal(intLiteral(5))])]))
        ])
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
            expression(negative(negative(negative(literal(intLiteral(23))))))
        ])
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
                      literal(intLiteral(3)),
                      literal(intLiteral(4))),
                    addition(
                      literal(intLiteral(23)),
                      literal(intLiteral(3)))
                  ),
                  division(
                    literal(intLiteral(4)),
                    literal(intLiteral(2))
                  )
                 ),
                 literal(intLiteral(32))
                ),
              literal(intLiteral(3)))
            ),
            expression(lessThan(literal(intLiteral(3)), literal(intLiteral(5)))),
            expression(greaterThanOrEq(literal(intLiteral(1)), literal(intLiteral(1)))),
            expression(equals(literal(intLiteral(2)), literal(intLiteral(2)))),
            expression(lessThanOrEq(literal(intLiteral(9)), literal(intLiteral(19)))),
            expression(or(or(and(literal(intLiteral(1)), literal(booleanLiteral("true"))), literal(booleanLiteral("false"))), literal(booleanLiteral("true")))),
            expression(ifThenElse(greaterThan(variable("argument"), literal(intLiteral(0))), literal(stringLiteral("argument is positive")), literal(stringLiteral("argument is negative"))))
          ])
    }));
}
