module Test::Parser::Expressions

import Parser::ParseAST;
import Syntax::Abstract::AST;
import IO;

test bool testShouldParseVariableInBrackets()
{
    str code = "module Example;
               'entity User {
               '    void variableInBrackets(int theVariable) {
               '        ((theVariable));
               '        (theVariable) + 1;
               '    }
               '}"; 
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "variableInBrackets", [param(integer(), "theVariable")], [
            expression(\bracket(\bracket(variable("theVariable")))),
            expression(addition(\bracket(variable("theVariable")), intLiteral(1)))
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
               
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "arrayExpression", [], [
            expression(array([strLiteral("First thing"), strLiteral("Second thing")])),
            expression(array([intLiteral(1), intLiteral(2), intLiteral(3), intLiteral(4), intLiteral(5)])),
            expression(array([floatLiteral(1.34), floatLiteral(2.35), floatLiteral(23.56)])),
            expression(array([array([intLiteral(1), intLiteral(2), intLiteral(3)]), array([intLiteral(3), intLiteral(4), intLiteral(5)])]))
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
               
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "nestedNegative", [], [
            expression(negative(\bracket(negative(\bracket(negative(\bracket(intLiteral(23))))))))
        ])
    }));
}

test bool testShouldParseMathExpressions()
{
    str code = "module Example;
               'entity User {
               '    void math() {
               '        3*4*(23+3)-4/2;
               '        3 \< 5;
               '        1 \>= 1;
               '        2 == 2;
               '        9 \<= 19;
               '        1 && true || false || true;
               '        argument \> 0 ? \"argument is positive\" : \"argument is negative\";
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "math", [], [
            expression(subtraction(
                  product(
                    product(
                      intLiteral(3),
                      intLiteral(4)),
                    \bracket(addition(
                      intLiteral(23),
                      intLiteral(3)))
                  ),
                  division(
                    intLiteral(4),
                    intLiteral(2)
                  )
                 )),
            expression(lessThan(intLiteral(3), intLiteral(5))),
            expression(greaterThanOrEq(intLiteral(1), intLiteral(1))),
            expression(equals(intLiteral(2), intLiteral(2))),
            expression(lessThanOrEq(intLiteral(9), intLiteral(19))),
            expression(or(or(and(intLiteral(1), boolLiteral(true)), boolLiteral(false)), boolLiteral(true))),
            expression(ifThenElse(greaterThan(variable("argument"), intLiteral(0)), strLiteral("argument is positive"), strLiteral("argument is negative")))
          ])
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
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "literals", [param(integer(), "var")], [
            expression(strLiteral("simple string literal")),
            expression(intLiteral(123)),
            expression(floatLiteral(1.23)),
            expression(boolLiteral(true)),
            expression(boolLiteral(false)),
            expression(variable("var"))
          ])
    }));
}

test bool testNewInstance()
{
    str code = "module Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime;
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", []))
          ])
    }));
}

test bool testNewInstanceWithArg()
{
    str code = "module Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime(\"now\");
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", [strLiteral("now")]))
          ])
    }));
}

test bool testNewInstanceWithArgs()
{
    str code = "module Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime(\"now\", new Money(2300, \"USD\"));
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", [strLiteral("now"), new("Money", [
                intLiteral(2300), strLiteral("USD")
            ])]))
          ])
    }));
}

test bool testMethodInvoke()
{
    str code = "module Example;
               'entity User {
               '    void methodInvoke() {
               '        methodInvoke();
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "methodInvoke", [], [
            expression(invoke("methodInvoke", []))
          ])
    }));
}

test bool testMethodInvokeChainedToAVariable()
{
    str code = "module Example;
               'entity User {
               '    void methodInvoke() {
               '        SomeEntity eee = new SomeEntity();
               '        eee.methodInvoke();
               '        eee.nested([\"string\"]).methodInvoke();
               '        eee.blah.blah2.methodInvoke();
               '        new MyClass().methodInvoke();
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        method(\public(), voidValue(), "methodInvoke", [], [
            declare(artifactType("SomeEntity"), variable("eee"), expression(
                new("SomeEntity", [])
            )),
            expression(invoke(variable("eee"), "methodInvoke", [])),
            expression(invoke(invoke(variable("eee"), "nested", [array([strLiteral("string")])]), "methodInvoke", [])),
            expression(invoke(fieldAccess(fieldAccess(variable("eee"), "blah"), "blah2"), "methodInvoke", [])),
            expression(invoke(new("MyClass", []), "methodInvoke", []))
          ])
    }));
}

test bool shouldFailWhenUsingWrongExpressionsForChainedAccess()
{
    str code = "module Example;
               'entity User {
               '    void methodInvoke() {
               '        SomeEntity eee = new SomeEntity();
               '        (1+2).methodInvoke();
               '    }
               '}";
               
    try parseModule(code);
    catch IllegalObjectOperator(str msg): return true;
    
    return false;
}

