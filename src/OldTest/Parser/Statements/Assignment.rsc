module Test::Parser::Statements::Assignment

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shoudlParseAssignmentStmt()
{
    str code = "module Example;
               'entity User {
               '    void example(int a) {
               '        a = 5;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {parameter(integer(), "a", none())}, [
            assign({variable("a")}, defaultAssign(), expression(intLiteral(5)))
        ], none())
    }));
}

test bool shouldParseAssignmentStmtUsingArrays()
{
    str code = "module Example;
               'entity User {
               '    void example(int[] a, int[][] b) {
               '        a[0]    = 5;
               '        b[0][1] = 4;
               '    }
               '}";
    
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {
                parameter(typedArray(integer()), "a", none()), 
                parameter(typedArray(typedArray(integer())), "b", none())
            }, [
            assign({arrayAccess(variable("a"), intLiteral(0))}, defaultAssign(), expression(intLiteral(5))),
            assign({arrayAccess(arrayAccess(variable("b"), intLiteral(0)), intLiteral(1))}, defaultAssign(), expression(intLiteral(4)))
        ], none())
    }));
}

test bool shoudlParseAssignmentStmtUsingDiffAssignOperators()
{
    str code = "module Example;
               'entity User {
               '    void example(int a = 1) {
               '        a += 5;
               '        a *= 2;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {parameter(integer(), "a", defaultValue(intLiteral(1)))}, [
            assign({variable("a")}, additionAssign(), expression(intLiteral(5))),
            assign({variable("a")}, productAssign(), expression(intLiteral(2)))
        ], none())
    }));
}

test bool shouldParseMultiAssign()
{
    str code = "module Example;
               'entity User {
               '    void example(int a, int b) {
               '        a, b = 4;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {
                parameter(integer(), "a", none()),
                parameter(integer(), "b", none())
            }, [
            assign({variable("a"), variable("b")}, defaultAssign(), expression(intLiteral(4)))
        ], none())
    }));
}

test bool shouldParseNestedAssignments()
{
    str code = "module Example;
               'entity User {
               '    void example(int a, int b) {
               '        a = b = 4;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {
                parameter(integer(), "a", none()),
                parameter(integer(), "b", none())
            }, [
            assign({variable("a")}, defaultAssign(), assign({variable("b")}, defaultAssign(), expression(intLiteral(4))))
        ], none())
    }));
}
