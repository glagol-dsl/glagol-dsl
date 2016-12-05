module Test::Parser::Statements

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testDeclarationsWithPrimitiveTypes() {
    str code
        = "namespace Example;
        'entity User {
        '   User() {
        '       float myVariable = 5.4;
        '       int yourVariable = 23;
        '       string myString = \"hello world\";
        '       boolean withExpr = myVariable \> yourVariable;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(float(), variable("myVariable"), expression(floatLiteral(5.4))),
            declare(integer(), variable("yourVariable"), expression(intLiteral(23))),
            declare(string(), variable("myString"), expression(strLiteral("hello world"))),
            declare(boolean(), variable("withExpr"), expression(greaterThan(variable("myVariable"), variable("yourVariable"))))
        ])
    ]));
}

test bool testDeclarationsWithoutDefaultValue() {
    str code
        = "namespace Example;
        'entity User {
        '   User() {
        '       float myVariable;
        '       int yourVariable;
        '       
        '       yourVariable = yourVariable + 5;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(float(), variable("myVariable")),
            declare(integer(), variable("yourVariable")),
            assign(variable("yourVariable"), defaultAssign(), expression(addition(variable("yourVariable"), intLiteral(5))))
        ])
    ]));
}

test bool testDeclarationsWithCustomTypes() {
    str code
        = "namespace Example;
        'entity User {
        '   User() {
        '       DateTime myDate;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(artifactType("DateTime"), variable("myDate"))
        ])
    ]));
}

test bool testDeclarationsWithNestedAssignment() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       int myNumber = a = 5;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            declare(integer(), variable("myNumber"), assign(variable("a"), defaultAssign(), expression(intLiteral(5))))
        ])
    ]));
}

test bool testIfStatement() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThen(equals(variable("a"), intLiteral(5)), \return(intLiteral(5)))
        ])
    ]));
}

test bool testIfStatementWithBlock() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       if (a == 5) {return 5;}
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThen(equals(variable("a"), intLiteral(5)), block([\return(intLiteral(5))]))
        ])
    ]));
}

test bool testIfElseStatement() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else return 6;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), intLiteral(5)), \return(intLiteral(5)), \return(intLiteral(6)))
        ])
    ]));
}

test bool testIfElseIfStatement() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else if (a == 6) return 6;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), intLiteral(5)), \return(intLiteral(5)), 
                ifThen(equals(variable("a"), intLiteral(6)), \return(intLiteral(6)))    
            )
        ])
    ]));
}

test bool testIfElseIfEndingWithElseStatement() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else if (a == 6) return 6;
        '       else return 0;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), intLiteral(5)), \return(intLiteral(5)), 
                ifThenElse(equals(variable("a"), intLiteral(6)), \return(intLiteral(6)), \return(intLiteral(0)))
            )
        ])
    ]));
}

test bool testForeachStatementWithEmptyStmt() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int[] a) {
        '       for (a as b);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(typedList(integer()), "a")], [
            foreach(variable("a"), variable("b"), emptyStmt())
        ])
    ]));
}

test bool testForeachStatementWithEmptyStmtAndDirectList() {
    str code
        = "namespace Example;
        'entity User {
        '   User() {
        '       for ([1, 2, 3, 4, 5] as b);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            foreach(\list([intLiteral(1), intLiteral(2), intLiteral(3), intLiteral(4), intLiteral(5)]), 
                variable("b"), emptyStmt())
        ])
    ]));
}

test bool testForeachStatementWithIncrementStmtAndDirectList() {
    str code
        = "namespace Example;
        'entity User {
        '   User() {
        '       int i;
        '       for ([1, 2, 3, 4, 5] as b) i += 1;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(integer(), variable("i")),
            foreach(\list([intLiteral(1), intLiteral(2), intLiteral(3), intLiteral(4), intLiteral(5)]), 
                variable("b"), assign(variable("i"), additionAssign(), expression(intLiteral(1))))
        ])
    ]));
}

test bool testForeachStatementWithBreak() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int[] a) {
        '       for (a as b) {
        '           if (a \> 2) break;
        '       }
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(typedList(integer()), "a")], [
            foreach(variable("a"), variable("b"), block([
                ifThen(greaterThan(variable("a"), intLiteral(2)), \break())
            ]))
        ])
    ]));
}

test bool testForeachStatementWithLevelledBreak() {
    str code
        = "namespace Example;
        'entity User {
        '   User(int[] a) {
        '       for (a as b) 
        '           for (c as d)
        '               if (c \> 2) break 2;
        '       
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(typedList(integer()), "a")], [
            foreach(variable("a"), variable("b"), 
                foreach(variable("c"), variable("d"), 
                    ifThen(greaterThan(variable("c"), intLiteral(2)), \break(2))
                )
            )
        ])
    ]));
}

test bool testForeachStatementWithCondition() {
    str code
        = "namespace Example;
        'entity User {
        '   User(DateTime[] a, DateTime now) {
        '       for (a as b, a \< now);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(typedList(artifactType("DateTime")), "a"), param(artifactType("DateTime"), "now")], [
            foreach(variable("a"), variable("b"), emptyStmt(), [lessThan(variable("a"), variable("now"))])
        ])
    ]));
}

test bool testForeachStatementWithContinue() {
    str code
        = "namespace Example;
        'entity User {
        '   User(DateTime[] a, DateTime now) {
        '       for (a as b)
        '           if (a \< now) continue;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(typedList(artifactType("DateTime")), "a"), param(artifactType("DateTime"), "now")], [
            foreach(variable("a"), variable("b"), ifThen(
                lessThan(variable("a"), variable("now")), \continue()
            ))
        ])
    ]));
}
