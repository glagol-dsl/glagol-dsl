module Test::Parser::Statements

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testDeclarationsWithPrimitiveTypes() {
    str code
        = "namespace Example
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
            declare(float(), variable("myVariable"), expression(float(5.4))),
            declare(integer(), variable("yourVariable"), expression(integer(23))),
            declare(string(), variable("myString"), expression(string("hello world"))),
            declare(boolean(), variable("withExpr"), expression(greaterThan(variable("myVariable"), variable("yourVariable"))))
        ])
    ]));
}

test bool testDeclarationsWithoutDefaultValue() {
    str code
        = "namespace Example
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
            assign(variable("yourVariable"), defaultAssign(), expression(addition(variable("yourVariable"), integer(5))))
        ])
    ]));
}

test bool testDeclarationsWithCustomTypes() {
    str code
        = "namespace Example
        'entity User {
        '   User() {
        '       DateTime myDate;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(artifact("DateTime"), variable("myDate"))
        ])
    ]));
}

test bool testDeclarationsWithNestedAssignment() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       int myNumber = a = 5;
        '   }
        '}";
        
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            declare(integer(), variable("myNumber"), assign(variable("a"), defaultAssign(), expression(integer(5))))
        ])
    ]));
}

test bool testIfStatement() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThen(equals(variable("a"), integer(5)), \return(integer(5)))
        ])
    ]));
}

test bool testIfStatementWithBlock() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       if (a == 5) {return 5;}
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThen(equals(variable("a"), integer(5)), block([\return(integer(5))]))
        ])
    ]));
}

test bool testIfElseStatement() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else return 6;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), integer(5)), \return(integer(5)), \return(integer(6)))
        ])
    ]));
}

test bool testIfElseIfStatement() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else if (a == 6) return 6;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), integer(5)), \return(integer(5)), 
                ifThen(equals(variable("a"), integer(6)), \return(integer(6)))    
            )
        ])
    ]));
}

test bool testIfElseIfEndingWithElseStatement() {
    str code
        = "namespace Example
        'entity User {
        '   User(int a) {
        '       if (a == 5) return 5;
        '       else if (a == 6) return 6;
        '       else return 0;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "a")], [
            ifThenElse(equals(variable("a"), integer(5)), \return(integer(5)), 
                ifThenElse(equals(variable("a"), integer(6)), \return(integer(6)), \return(integer(0)))
            )
        ])
    ]));
}

test bool testForeachStatementWithEmptyStmt() {
    str code
        = "namespace Example
        'entity User {
        '   User(int[] a) {
        '       for (a as b);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(\list(integer()), "a")], [
            foreach(variable("a"), variable("b"), emptyStmt())
        ])
    ]));
}

test bool testForeachStatementWithEmptyStmtAndDirectList() {
    str code
        = "namespace Example
        'entity User {
        '   User() {
        '       for ([1, 2, 3, 4, 5] as b);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            foreach(\list([integer(1), integer(2), integer(3), integer(4), integer(5)]), 
                variable("b"), emptyStmt())
        ])
    ]));
}

test bool testForeachStatementWithIncrementStmtAndDirectList() {
    str code
        = "namespace Example
        'entity User {
        '   User() {
        '       int i;
        '       for ([1, 2, 3, 4, 5] as b) i += 1;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [
            declare(integer(), variable("i")),
            foreach(\list([integer(1), integer(2), integer(3), integer(4), integer(5)]), 
                variable("b"), assign(variable("i"), additionAssign(), expression(integer(1))))
        ])
    ]));
}

test bool testForeachStatementWithBreak() {
    str code
        = "namespace Example
        'entity User {
        '   User(int[] a) {
        '       for (a as b) {
        '           if (a \> 2) break;
        '       }
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(\list(integer()), "a")], [
            foreach(variable("a"), variable("b"), block([
                ifThen(greaterThan(variable("a"), integer(2)), \break())
            ]))
        ])
    ]));
}

test bool testForeachStatementWithLevelledBreak() {
    str code
        = "namespace Example
        'entity User {
        '   User(int[] a) {
        '       for (a as b) 
        '           for (c as d)
        '               if (c \> 2) break 2;
        '       
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(\list(integer()), "a")], [
            foreach(variable("a"), variable("b"), 
                foreach(variable("c"), variable("d"), 
                    ifThen(greaterThan(variable("c"), integer(2)), \break(2))
                )
            )
        ])
    ]));
}

test bool testForeachStatementWithCondition() {
    str code
        = "namespace Example
        'entity User {
        '   User(DateTime[] a, DateTime now) {
        '       for (a as b, a \< now);
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(\list(artifact("DateTime")), "a"), param(artifact("DateTime"), "now")], [
            foreach(variable("a"), variable("b"), emptyStmt(), [lessThan(variable("a"), variable("now"))])
        ])
    ]));
}

test bool testForeachStatementWithContinue() {
    str code
        = "namespace Example
        'entity User {
        '   User(DateTime[] a, DateTime now) {
        '       for (a as b)
        '           if (a \< now) continue;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(\list(artifact("DateTime")), "a"), param(artifact("DateTime"), "now")], [
            foreach(variable("a"), variable("b"), ifThen(
                lessThan(variable("a"), variable("now")), \continue()
            ))
        ])
    ]));
}

test bool testPersistStatementOnRepository() {
    str code
        = "namespace Example
        'import Example::User;
        'repository for User {
        '   public void blah() {
        '       persist a;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [\import("User", namespace("Example"), "User")], 
        repository("User", [
            method(\public(), voidValue(), "blah", [], [
                persist(variable("a"))
            ])
    ]));
}

test bool testFlushStatementOnRepository() {
    str code
        = "namespace Example
        'import Example::User;
        'repository for User {
        '   public void blah() {
        '       persist a;
        '       flush a;
        '       flush;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [\import("User", namespace("Example"), "User")], 
        repository("User", [
            method(\public(), voidValue(), "blah", [], [
                persist(variable("a")),
                flush(variable("a")),
                flush(emptyExpr())
            ])
    ]));
}

test bool testRemoveStatementOnRepository() {
    str code
        = "namespace Example
        'import Example::User;
        'repository for User {
        '   public void blah() {
        '       remove a;
        '   }
        '}";

    return parseModule(code) == \module(namespace("Example"), [\import("User", namespace("Example"), "User")], 
        repository("User", [
            method(\public(), voidValue(), "blah", [], [
                remove(variable("a"))
            ])
    ]));
}
