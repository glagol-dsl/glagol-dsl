module Test::Parser::Statements::Ifs

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shoudlParseIfThenStmt()
{
    str code = "module Example;
               'entity User {
               '    void example() {
               '        if (a \> b) true;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {}, [
            ifThen(greaterThan(variable("a"), variable("b")), expression(booleanLiteral("true")))
        ], none())
    }));
}

test bool shouldParseIfThenElseStmt()
{
    str code = "module Example;
               'entity User {
               '    void example() {
               '        if (a \> b) true; 
               '        else        false;
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {}, [
            ifThenElse(greaterThan(variable("a"), variable("b")), expression(booleanLiteral("true")), expression(booleanLiteral("false")))
        ], none())
    }));
}


test bool shoudlParseIfThenStmtWithBlock()
{
    str code = "module Example;
               'entity User {
               '    void example() {
               '        if (a \> b) {
               '            true;
               '        }
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {}, [
            ifThen(greaterThan(variable("a"), variable("b")), block([expression(booleanLiteral("true"))]))
        ], none())
    }));
}

test bool shouldParseIfThenElseStmtWithBlocks()
{
    str code = "module Example;
               'entity User {
               '    void example() {
               '        if (a \> b) {
               '            true; 
               '        } else {
               '            false;
               '        }
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {}, [
            ifThenElse(greaterThan(variable("a"), variable("b")), 
                block([expression(booleanLiteral("true"))]), 
                block([expression(booleanLiteral("false"))])
            )
        ], none())
    }));
}

test bool shouldParseIfThenElseIfStmt()
{
    str code = "module Example;
               'entity User {
               '    void example() {
               '        if (a \> b) {
               '            true; 
               '        } else if (a == b) {
               '            false;
               '        }
               '    }
               '}";
               
    return parseModule(code) == \module("Example", {}, entity({}, "User", {
        \method(\public(), voidValue(), "example", {}, [
            ifThenElse(greaterThan(variable("a"), variable("b")), 
                block([expression(booleanLiteral("true"))]), 
                ifThen(equals(variable("a"), variable("b")), block([expression(booleanLiteral("false"))]))
            )
        ], none())
    }));
}
