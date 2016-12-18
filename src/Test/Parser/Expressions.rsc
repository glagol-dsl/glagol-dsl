module Test::Parser::Expressions

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import IO;

test bool testShouldParseVariableInBrackets()
{
    str code = "namespace Example;
               'entity User {
               '    void variableInBrackets(int theVariable) {
               '        ((theVariable));
               '        (theVariable) + 1;
               '        anotherVar;
               '    }
               '}"; 
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "variableInBrackets", [param(integer(), "theVariable")], [
            expression(\bracket(\bracket(variable("theVariable")))),
            expression(addition(\bracket(variable("theVariable")), integer(1))),
            expression(variable("anotherVar"))
        ])
    ]));
}

test bool testShouldParseList()
{
    str code = "namespace Example;
               'entity User {
               '    void arrayExpression() {
               '        [\"First thing\", \"Second thing\"];
               '        [1, 2, 3, 4, 5];
               '        [1.34, 2.35, 23.56];
               '        [[1, 2, 3], [3, 4, 5]];
               '    }
               '}";
               
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "arrayExpression", [], [
            expression(\list([string("First thing"), string("Second thing")])),
            expression(\list([integer(1), integer(2), integer(3), integer(4), integer(5)])),
            expression(\list([float(1.34), float(2.35), float(23.56)])),
            expression(\list([\list([integer(1), integer(2), integer(3)]), \list([integer(3), integer(4), integer(5)])]))
        ])
    ]));
}

test bool testShouldParseExpressionsWithNegativeLiterals()
{
    str code = "namespace Example;
               'entity User {
               '    void nestedNegative() {
               '        -(-(-(23)));
               '    }
               '}";
               
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "nestedNegative", [], [
            expression(negative(\bracket(negative(\bracket(negative(\bracket(integer(23))))))))
        ])
    ]));
}

test bool testShouldParseExpressionsWithPositiveLiterals()
{
    str code = "namespace Example;
               'entity User {
               '    void nestedNegative() {
               '        +(+(+(23)));
               '    }
               '}";
               
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "nestedNegative", [], [
            expression(positive(\bracket(positive(\bracket(positive(\bracket(integer(23))))))))
        ])
    ]));
}

test bool testShouldParseMathExpressions()
{
    str code = "namespace Example;
               'entity User {
               '    void math() {
               '        3*4*(23+3)-4/2;
               '        3 \< 5;
               '        3 % 5;
               '        1 \>= 1;
               '        2 == 2;
               '        9 \<= 19;
               '        1 && true || false || true;
               '        argument \> 0 ? \"argument is positive\" : \"argument is negative\";
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "math", [], [
            expression(subtraction(
                  product(
                    product(
                      integer(3),
                      integer(4)),
                    \bracket(addition(
                      integer(23),
                      integer(3)))
                  ),
                  division(
                    integer(4),
                    integer(2)
                  )
                 )),
            expression(lessThan(integer(3), integer(5))),
            expression(remainder(integer(3), integer(5))),
            expression(greaterThanOrEq(integer(1), integer(1))),
            expression(equals(integer(2), integer(2))),
            expression(lessThanOrEq(integer(9), integer(19))),
            expression(or(or(and(integer(1), boolean(true)), boolean(false)), boolean(true))),
            expression(ifThenElse(greaterThan(variable("argument"), integer(0)), string("argument is positive"), string("argument is negative")))
          ])
    ]));
}

test bool shouldParseAllTypesOfLiterals()
{
    str code = "namespace Example;
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
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "literals", [param(integer(), "var")], [
            expression(string("simple string literal")),
            expression(integer(123)),
            expression(float(1.23)),
            expression(boolean(true)),
            expression(boolean(false)),
            expression(variable("var"))
          ])
    ]));
}

test bool testNewInstance()
{
    str code = "namespace Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime;
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", []))
          ])
    ]));
}

test bool testNewInstanceWithArg()
{
    str code = "namespace Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime(\"now\");
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", [string("now")]))
          ])
    ]));
}

test bool testNewInstanceWithArgs()
{
    str code = "namespace Example;
               'entity User {
               '    void newInstance() {
               '        new DateTime(\"now\", new Money(2300, \"USD\"));
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "newInstance", [], [
            expression(new("DateTime", [string("now"), new("Money", [
                integer(2300), string("USD")
            ])]))
          ])
    ]));
}

test bool testMethodInvoke()
{
    str code = "namespace Example;
               'entity User {
               '    void methodInvoke() {
               '        methodInvoke();
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "methodInvoke", [], [
            expression(invoke("methodInvoke", []))
          ])
    ]));
}

test bool testMethodInvokeChainedToAVariable()
{
    str code = "namespace Example;
               'entity User {
               '    void methodInvoke() {
               '        SomeEntity eee = new SomeEntity();
               '        eee.methodInvoke();
               '        eee.nested([\"string\"]).methodInvoke();
               '        eee.blah.blah2.methodInvoke();
               '        new MyClass().methodInvoke();
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "methodInvoke", [], [
            declare(artifactType("SomeEntity"), variable("eee"), expression(
                new("SomeEntity", [])
            )),
            expression(invoke(variable("eee"), "methodInvoke", [])),
            expression(invoke(invoke(variable("eee"), "nested", [\list([string("string")])]), "methodInvoke", [])),
            expression(invoke(fieldAccess(fieldAccess(variable("eee"), "blah"), "blah2"), "methodInvoke", [])),
            expression(invoke(new("MyClass", []), "methodInvoke", []))
          ])
    ]));
}

test bool testMethodInvokeUsingThis()
{
    str code = "namespace Example;
               'entity User {
               '    void methodInvoke() {
               '        this.field.nested.invoke();
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "methodInvoke", [], [
            expression(invoke(fieldAccess(fieldAccess(this(), "field"), "nested"), "invoke", []))
          ])
    ]));
}

test bool shouldFailWhenUsingWrongExpressionsForChainedAccess()
{
    str code = "namespace Example;
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

test bool testFieldAccessWithAssign()
{
    str code = "namespace Example;
               'entity User {
               '    void methodInvoke() {
               '        this.field = \"adsdsasad\";
               '        this.invoke().field2 += 33;
               '        this.var = that.var2;
               '    }
               '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        method(\public(), voidValue(), "methodInvoke", [], [
            assign(fieldAccess(this(), "field"), defaultAssign(), expression(string("adsdsasad"))),
            assign(fieldAccess(invoke(this(), "invoke", []), "field2"), additionAssign(), expression(integer(33))),
            assign(fieldAccess(this(), "var"), defaultAssign(), expression(fieldAccess(variable("that"), "var2")))
          ])
    ]));
}
